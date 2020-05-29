#/usr/bin/bash

for file in *.ttf
do
	woff2_compress $file
done
