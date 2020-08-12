all: strip.js index.js

%.js: %.coffee
	coffee -c $<
