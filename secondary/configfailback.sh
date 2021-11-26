cp secondary.repl.properties.tf secondary.repl.properties
dsrutil secondary -C terminate server
sleep 15
dsrutil secondary -C restart server
sleep 15

