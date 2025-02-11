#
# handy Makefile to build and manage up
# 
default: public/index.html

public/index.html: content/* templates/* static/*
	git submodule update --init --recursive
	zola build --output-dir docs/

test:
	zola serve --output-dir docs/

clean:
	rm -fR docs/

