echo Delete database....
prodel primary
echo Remove st file....
rm -f primary.st
echo Remove log files....
rm -f *.lg
rm -f *.log
rm -f *.recovery
rm -f *.stdout
rm -f *.bck
echo Remove old backup....
rm -f *.bak
echo Remove aibak files....
rm -f aibak/*
echo FINISHED!
