#!/bin/bash

Err="/tmp/Err2sh.log"

:> $Err

if [ $# \< 3 ]
then
	echo "$(basename $0): Too few arguments" 2>> $Err
	exit 1
fi

A=$( find $(readlink -f $1) -size +$2c -size -$3c -type f -printf '%p"' 2>> $Err)
B=$( find $(readlink -f $1) -size +$2c -size -$3c -type f -printf '%p"' 2>> $Err)

STDIFS=$IFS
IFS='"'
for file in $A
do
	for file2 in $B
	do
		if ( cmp -s "$file" "$file2" 2>> $Err )  && [ "$file" != "$file2" ]
			then
				echo "$file = $file2"
		fi
	done
done
IFS=$STDIFS

sed -r "s/[^:]*:([^:]*:)?/$(basename $0):\1/g" $Err >&2
rm $Err
