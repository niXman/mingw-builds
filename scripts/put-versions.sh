#!/bin/bash

VERSION_FILE=$PREFIX/versions.txt
echo "" > $VERSION_FILE

PROCESSEDV=()

for sub in ${SUBTARGETS[@]}; do
	[[ $sub == "put-versions" ]] && continue
	
	pack_type=$( grep 'TYPE=' $TOP_DIR/scripts/${sub}.sh )
	pack_url=$( grep 'URL=' $TOP_DIR/scripts/${sub}.sh | sed 's|URL=||' )
	[[ -n $pack_type ]] && {
		pack_type=$( echo "$pack_type" | sed 's|TYPE=||g' )
		pack_name=$( grep 'SRC_DIR_NAME=' $TOP_DIR/scripts/${sub}.sh | sed 's|SRC_DIR_NAME=||' )
		
		[[ -n $( echo "${PROCESSEDV[@]}" | grep $pack_name ) ]] && continue
		PROCESSEDV=( ${PROCESSEDV[@]} $pack_name )
		
		revision=""
		echo "name: $pack_name" >> $VERSION_FILE
		echo "url: $pack_url" >> $VERSION_FILE
		
		case $pack_type in
			cvs|svn|hg|git)
				cd $SRCS_DIR/$pack_name
				[[ $? != 0 ]] && { echo "error in $SRCS_DIR/$pack_name"; exit 1; }
				echo "revision: $( svn info | grep 'Revision: ' | sed 's|Revision: ||' )" >> $VERSION_FILE
			;;
			*)
				echo "version: $( echo $pack_name | sed 's/[^0-9.]*\([0-9.]*\).*/\1/' )" >> $VERSION_FILE
			;;
		esac
		echo "" >> $VERSION_FILE
	}
done
