cp secondary.repl.properties.2 secondary.repl.properties
dsrutil secondary -C terminate server
sleep 15
dsrutil secondary -C restart server
sleep 15
cd ../primary
dsrutil primary -C restart agent

