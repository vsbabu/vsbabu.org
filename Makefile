#
# handy Makefile to build and manage up
# 
default: public/index.html

public/index.html: content/* templates/* static/*
	git submodule update --init --recursive
	zola build

test:
	zola serve

clean:
	rm -fR public/

