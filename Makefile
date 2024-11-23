
.PHONY: test
test:
	@ruby -I./src/main/ -I./src/test/ src/test/all.rb

.PHONY: run
run:
	@ruby -I./src/main/ src/main/main.rb

