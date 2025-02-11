#
# handy Makefile to build and manage up
# 
default: public/index.html

public/index.html: content/* sass/* templates/* static/* index.html *.css
	zola build

test:
	zola serve

clean:
	rm -fR public/

