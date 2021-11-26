cp secondary.repl.properties.t secondary.repl.properties
dsrutil secondary -C terminate agent
sleep 5
dsrutil secondary -C restart agent

