echo Restore database....
prorest secondary db.bak
echo Add ai extents....
prostrct add secondary ai.st
echo List new structure....
prostrct list secondary
echo Enable AI....
proutil secondary -C aimage begin
echo Enable aiarchiver....
proutil secondary -C aiarchiver enable
echo Enable for target replication...
proutil secondary -C enablesitereplication target
echo FINISHED!
