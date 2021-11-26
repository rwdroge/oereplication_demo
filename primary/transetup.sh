cd ../secondary
cp secondary.repl.properties.t secondary.repl.properties
dsrutil secondary -C terminate agent
sleep 15
dsrutil secondary -C restart agent
sleep 15
cd ../primary
dsrutil primary -C restart server

