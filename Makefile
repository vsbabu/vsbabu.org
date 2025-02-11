#
# handy Makefile to build and manage up
# 
default: docs/index.html

docs/index.html: content/* templates/* static/*
	git submodule update --init --recursive
	zola build 
	rm -f /tmp/docs.tar
	tar -cvf /tmp/docs.tar docs/

test:
	zola serve 

clean:
	rm -fR docs/

