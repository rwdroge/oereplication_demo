 
[server]
  control-agents=agent2
  database=secondary
  agent-shutdown-action=recovery
  defer-agent-startup=5
  transition=manual
  transition-timeout=30
 
[control-agent.agent0]
  name=agent0
  database=primary
  host=localhost
  port=20000
  replication-method=async
  critical=0
  connect-timeout=60
 
[control-agent.agent1]
  name=agent1
  database=secondary
  host=localhost
  port=20001
  replication-method=async
  critical=0
  connect-timeout=60
 
[control-agent.agent2]
  name=agent2
  database=tertiary
  host=localhost
  port=20002
  replication-method=async
  critical=0
  connect-timeout=60
 
[transition]
  replication-set=1
  database-role=reverse
  transition-to-agents=agent1,agent2
  auto-begin-ai=1
  auto-add-ai-areas=0
  ai-structure-file=addAI.st
  backup-method=mark
  recovery-backup-arguments=backup-secondary-recovery.bck
  restart-after-transition=1
  normal-startup-arguments=-pf generic.pf -S 20001
  source-startup-arguments=-pf generic.pf -S 20001 -DBService replserv
  target-startup-arguments=-pf generic.pf -S 20001 -DBService replagent
  start-secondary-broker=0
 
[agent]
  name=agent1
  database=secondary
  listener-minport=34300
  listener-maxport=34400
