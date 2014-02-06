.PHONY : all test clean lint

all: node_modules lint build/sequence-diagram-min.js

node_modules: package.json
	#
	# NPM Update needed.
	#
	npm update

clean:
	rm build/*

lint:
	node_modules/jshint/bin/jshint src/*.js
	node_modules/jshint/bin/jshint test/grammar-tests.js

build/grammar.js: src/grammar.jison
	node_modules/jison/lib/cli.js $< -o $@

build/diagram-grammar.js: src/diagram.js build/grammar.js
	#
	# Compiling grammar
	#
	jspp $< > $@

build/sequence-diagram-min.js build/sequence-diagram-min.js.map: src/copyright.js build/diagram-grammar.js src/jquery-plugin.js fonts/daniel/daniel_700.font.js src/sequence-diagram.js
	#
	# Please ignore the warnings below (these are in combined js code)
	#
	node_modules/uglify-js/bin/uglifyjs \
		src/copyright.js \
		build/diagram-grammar.js src/jquery-plugin.js fonts/daniel/daniel_700.font.js \
		src/sequence-diagram.js \
		-o build/sequence-diagram-min.js \
		-c --comments \
		--source-map build/sequence-diagram-min.js.map
	#
	# Copy minified file to site
	#
	cp build/sequence-diagram-min.js* _site/
