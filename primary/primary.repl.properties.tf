 
[server]
  control-agents=agent1,agent2
  database=primary
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
  critical=1
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
  recovery-backup-arguments=backup-primary-recovery.bck
  restart-after-transition=1
  normal-startup-arguments=-pf generic.pf -S 20000
  source-startup-arguments=-pf generic.pf -S 20000 -DBService replserv
  target-startup-arguments=-pf generic.pf -S 20000 -DBService replagent
  start-secondary-broker=0
 
[agent]
  name=agent0
  database=primary
  listener-minport=34100
  listener-maxport=34200
