#
# handy Makefile to build and manage up
# 
default: public/index.html

public/index.html: content/* sass/* templates/* static/* index.html *.css
	zola build

publish: public/index.html
	rsync --recursive --verbose public/ vsbabu.org:~/www/twenties/
	rsync --verbose `ls avatar.jpg index.html *.css` vsbabu.org:www/

test:
	zola serve

clean:
	rm -fR public/

