#
# handy Makefile to build and manage up
# 
default: docs/index.html

docs/index.html: content/* templates/* static/*
	git submodule update --init --recursive
	zola build --force --output-dir docs/

test:
	zola serve --output-dir docs/

clean:
	rm -fR docs/

