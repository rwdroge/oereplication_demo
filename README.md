# **OpenEdge Replication Demo Script**

This demo script walks through several OE replication scenario's using the sports database.
In the demo all of the databases are located on the same machine, obviously property files would need adjusting for real-world multi-machine replication.

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

- Supported Linux distro (see [Progress Availability Guides](https://knowledgebase.progress.com/articles/Article/P7519)) 
- Minimum of OpenEdge 11.7.x installed (preferably OE12.2x or higher)
  - Using the Replication Set functionality
- Git installed

# Setup to do complete Demo

1. Move to your working directory (from now on called $WRK)
2. Execute the following command:  
  ```git clone https://github.com/rwdroge/oereplication\_demo.git```
3. Open four PuTTY sessions to your Linux instance
    * From prompt make sure to become super user (if you aren\'t already):  
    ```sudo su```
4. Change directory, background and foreground in three windows

    - First window – background teal, foreground black  
    ```cd $WRK/primary```
    - Second window – background yellow, foreground black  
    ```cd $WRK/secondary```
    - Third window – background white, foreground black  
    ```cd $WRK/tertiary```
    - Fourth window – do not change colors
    ```cd $WRK/primary```

5. In each window, execute the commands:
```
export DLC=<your_dlc>;
export PATH=$PATH:$DLC/bin
```
6. In black window  
```./reset.sh```

7. This will have setup the environment (and started replication between primary, secondary and tertiary databases)

# Demonstrate Replication

1. In teal, yellow and white screens, execute:  
```./tl.sh```

2. In black window in $WRK/primary, execute:  
```./updatecust.sh``` 

3. Watch teal for &quot;Sending&quot; and yellow and white for &quot;Processing messages&quot;

4. Replication is working correctly from primary to secondary and tertiary

# Transition failover

1. In $WRK/primary, execute:  
```dsrutil primary -C transition failover```

2. In teal and yellow do ctrl-c and once failover is done execute:  
```./tl2.sh```
3. In the black window execute:  
```cd /usr/wrk/secondary```  
```./updatecust.sh```
4. In yellow, confirm &quot;Sending&quot;

5. In teal, confirm &quot;process&quot;

6. Primary and secondary databases have reversed roles

# Transition fail Back

1. From $WRK/secondary, execute:  
```dsrutil secondary -C transition failover```

2. In teal and yellow, ctrl-c and after failback is done execute:  
```./tl.sh```
3. In $WRK/primary, execute:  
```./updatecust.sh```
4. In teal, confirm &quot;Sending&quot;

5. In yellow, confirm &quot;process&quot;

6. System has reversed roles again

# Primary failure and manual failover

1. In primary, execute:  
```./transetup.sh```
    * In secondary:  
    ```cp secondary.repl.properties.t secondary.repl.properties``` 
    * ```dsrutil secondary -C terminate agent```
    * ```dsrutil secondary -C restart agent```
    * In primary:  
    ```dsrutil primary -C restart server```

2. In all three windows execute:  
```./tl.sh```

3. In Primary, to verify that replication is still working as shown in screens from last exercise execute:  
```./updatecust.sh``` 

4. In the black window execute and note the PID (process id):  
```ps -ef |grep rpserv```

5. Kill process by executing:  
```kill -9 <PID>``` 

6. Yellow and White screens' logs will say &quot;Pre-transition&quot;

7. Press Ctrl-C in teal window

8. In Black window execute:  
```cd $WRK/secondary```  
```dsrutil secondary -C transition```

9. After transition completes, stop yellow (CTRL+C) and execute:  
```./tl2.sh```

10. In $WRK/secondary, execute:  
```./updatecust.sh```

11. Yellow screen is now showing &quot;Sending&quot; and white shows &quot;process&quot;

12. Secondary database is now the source database and tertiary continues to be a target to the new source

# Reseed and restore primary

1. In the black screen execute:  
```cd $WRK/secondary```  
```probkup online secondary secondary.bak```  
```cp secondary.bak ../primary```  
```cd ../primary```   
```./restoreprimary.sh```  

> **restoreprimary.sh:**  
> ```proshut primary -by    
> prodel primary    
> prorest primary secondary.bak    
> rfutil primary -C mark backedup  
> proutil primary -C aimage begin  
> proutil primary -C aiarchiver enable  
> proutil handy -C enablesitereplication target  
> ./pri-server2.sh```

2. Execute:  
```cd ../secondary```

3. Execute:  
```./restartreplserv.sh```  

> **restartreplserv.sh:**  
> ```cp secondary.repl.properties.2 secondary.repl.properties    
> dsrutil secondary -C terminate server    
> dsrutil secondary -C restart server    
> cd ../primary  
> dsrutil primary -C restart agent

4. In teal window, execute:  
```./tl2.sh```

5. In black window execute:  
```./updatecust.sh```

6. Yellow window is now showing &quot;Sending&quot; and teal and white are processing so primary database is now a target database

# Fail back

1. In black window execute:  
```cd $WRK/secondary```    
```./configfailback.sh```

> **configfailback.sh**  
> ```cp secondary.repl.properties.tf secondary.repl.properties```    
> ```dsrutil secondary -C terminate server```  
> ```dsrutil secondary -C restart server```  

2. Restart ./tl.sh in yellow and teal windows 

3. In black window execute:  
```dsrutil secondary -C transition failover```  
```cd ../primary```  
```./updatecust.sh```
