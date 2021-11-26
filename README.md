# **Replication Demo Notes**

9/18/2017

# Contents

[Prerequisites](#Prerequisites)

[Setup to do complete Demo](#Setup-to-do-complete-Demo)

[Demonstrate Replication](#Demonstrate-Replication)

[Transition failover](#Transition-failover)

[Transition fail back](#Transition-fail-back)

[Primary failure and manual failover](#Primary-failure-and-manual-failover)

[Reseed and restore primary](#Reseed-and-restore-primary)

[Fail back](#Fail-back)

# Prerequisites

- Supported Linux distro (see [Progress Availability Guides](https://knowledgebase.progress.com/articles/Article/P7519): [https://knowledgebase.progress.com/articles/Article/P7519](https://knowledgebase.progress.com/articles/Article/P7519))
- Minimum of OpenEdge 11.7.x installed (preferably \&gt; OE12.2x)
  - Using the Replication Set functionality
- Git installed

# Setup to do complete Demo

1. Move to your working directory
2. **git clone https://github.com/rwdroge/oereplication\_demo.git**

1. Open four PuTTY sessions to your Linux instance
  1. From prompt, do &quot;sudo su&quot; to become super user (if you aren&#39;t already)

1. Change directory, background and foreground in three windows

- First window &quot;cd /usr/wrk/primary&quot; – background teal, foreground black
- Second window &quot;cd /usr/wrk/secondary&quot; – background yellow, foreground black
- Third window &quot;cd /usr/wrk/tertiary&quot; – background white, foreground black
- Fourth window &quot;cd /usr/wrk/primary&quot; – do not change colors

1. In each window, execute the commands:

export DLC=\&lt;your\_dlc\&gt;

export PATH=$PATH:$DLC/bin

1. In black window
  1. &quot;cd /usr/wrk/primary&quot;
  2. &quot;./reset.sh&quot;


2. This will have setup the environment (and started replication between primary, secondary and tertiary databases)

![](RackMultipart20211126-4-6isldw_html_813922be8fe3f38e.png)

# Demonstrate Replication

1. In teal, yellow and white screens, execute &quot;./tl.sh&quot;

1. In black window in /usr/wrk/primary, execute &quot;./updatecust.sh&quot;

1. Watch teal for &quot;Sending&quot; and yellow and white for &quot;Processing messages

![](RackMultipart20211126-4-6isldw_html_6a7e8a6d2f231887.png)

![](RackMultipart20211126-4-6isldw_html_73dc6a0c9768a97e.png)

![](RackMultipart20211126-4-6isldw_html_251de6f68c8c2185.png)

1. Replication is working correctly from primary to secondary and tertiary

# Transition failover

1. In /usr/wrk/primary, execute &quot;dsrutil primary -C transition failover&quot;

![](RackMultipart20211126-4-6isldw_html_688704ccc5705e80.png)

1. In teal and yellow do ctrl-c and execute ./tl2.sh after failover is done
2. &quot;cd /usr/wrk/secondary&quot; , execute ./updatecust.sh
3. In yellow, confirm &quot;Sending&quot;

![](RackMultipart20211126-4-6isldw_html_fd230f6e0eb3a08d.png)

1. In teal, confirm &quot;processing&quot;

![](RackMultipart20211126-4-6isldw_html_7662549a0fae6700.png)

1. Primary and secondary have reversed roles

# Transition fail Back

1. From /usr/wrk/secondary, execute &quot;dsrutil secondary -C transition failover&quot;

![](RackMultipart20211126-4-6isldw_html_1886c08c61c8bc37.png)

1. In teal and yellow, ctrl-c and ./tl.sh after failback is done
2. In /usr/wrk/primary, execute ./updatecust.sh
3. In teal, confirm &quot;Sending&quot;

![](RackMultipart20211126-4-6isldw_html_c22b41cdd23423ee.png)

1. In yellow, confirm &quot;processing&quot;

![](RackMultipart20211126-4-6isldw_html_263814520d6b6da9.png)

1. System has reversed roles again

# Primary failure and manual failover

1. In primary, execute ./transetup.sh
  1. In secondary, cp secondary.repl.properties.t to secondary.repl.properties
  2. dsrutil secondary -C terminate agent
  3. dsrutil secondary -C restart agent
  4. in primary – dsrutil primary -C restart server

1. Execute ./tl.sh in all three windows

1. In Primary, execute ./updatecust.sh to verify that replication is still working as shown in screens from last exercise

1. ps -ef |grep rpserv

![](RackMultipart20211126-4-6isldw_html_6f436e6db5abcad2.png)

1. Kill process

![](RackMultipart20211126-4-6isldw_html_69b4f887f7d7236d.png)

1. yellow and white logs will say &quot;Pre-transition&quot;

![](RackMultipart20211126-4-6isldw_html_7502a69586c7a991.png)

![](RackMultipart20211126-4-6isldw_html_b926210c59a8e708.png)

1. Ctrl-C in teal window

1. In Black window, cd ../secondary

1. dsrutil secondary -C transition

![](RackMultipart20211126-4-6isldw_html_3e976b239674843a.png)

1. After transition completes, stop yellow and execute ./tl2.sh

1. In /usr/wrk/db/secondary, execute ./updatecust.sh

1. Yellow is sending and white is processing

![](RackMultipart20211126-4-6isldw_html_8a0cd5c78cbd9d6e.png)

![](RackMultipart20211126-4-6isldw_html_7496742945b9179c.png)

1. Yellow is now primary and white continues to be a target to new server

# Reseed and restore primary

1. probkup online secondary secondary.bak
2. cp secondary.bak ../primary

![](RackMultipart20211126-4-6isldw_html_7f43a838bd47df03.png)

1. Cd ../primary
2. ./restoreprimary.sh
  1. Proshut primary -by
  2. Prodel primary
  3. Prorest primary secondary.bak
  4. rfutil primary -C mark backedup
  5. proutil primary -C aimage begin
  6. proutil primary -C aiarchiver enable
  7. proutil handy -C enablesitereplication target
  8. ./pri-server2.sh

![](RackMultipart20211126-4-6isldw_html_4a7cf0b8def20de0.png)

1. Cd ../secondary

1. ./restartreplserv.sh
  1. cp secondary.repl.properties.2 secondary.repl.properties
  2. dsrutil secondary -C terminate server
  3. dsrutil secondary -C restart server
  4. cd ../primary
  5. dsrutil primary -C restart agent

![](RackMultipart20211126-4-6isldw_html_57c680522e9047da.png)

1. in teal, execute ./tl2.sh

1. ./updatecust.sh

1. Yellow is sending and teal and white are processing so primary is now a target

# Fail back

1. In secondary, ./configfailback.sh
  1. cp secondary.repl.properties.tf secondary.repl.properties
  2. dsrutil secondary -C terminate server
  3. dsrutil secondary -C restart server

1. restart ./tl.sh in yellow and teal

1. dsrutil secondary -C transition failover

![](RackMultipart20211126-4-6isldw_html_998139e7c3278801.png)

1. cd ../primary

1. ./updatecust.sh
