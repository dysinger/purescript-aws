default: test

node_modules: package.json
	npm install

bower_components: node_modules bower.json
	node_modules/.bin/bower --allow-root install

build: node_modules bower_components
	node_modules/.bin/grunt build

test: node_modules bower_components
	node_modules/.bin/grunt test

watch: node_modules bower_components
	node_modules/.bin/grunt watch

clean:
	if [ -f node_modules/.bin/grunt ]; then node_modules/.bin/grunt clean ; fi

distclean: clean
	rm -rf node_modules bower_components

.PHONY: build clean default distclean test watch
