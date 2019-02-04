#!/bin/bash
function gdal_pixel_count() {
    if [ -z "$1" ]; then
        echo "Missing arguments. Syntax:"
        echo "  gdal_extent <input_raster>"
        return
    fi
    EXTENT=$(gdalinfo $1 |\
        grep "Size is" |\
        sed "s/Size is //g;s/,//;s/\n//")
    echo -n "$EXTENT"
}

TARGET_SIZE="3601 3601"
for i in *.bil; do
    SOURCE_NAME=`echo $i | cut -d _ -f 1,2 | sed 's/_//' | tr '[:lower:]' '[:upper:]'`
    DEST_FILE=$SOURCE_NAME.hgt
    echo $url $DEST_FILE
    if [ -e $DEST_FILE ]; then
        echo $DEST_FILE exists, skipping
        continue
    fi

    PIXEL_COUNT=`gdal_pixel_count $i`
    if [ "$PIXEL_COUNT" != "$TARGET_SIZE" ]; then
        echo bad size $PIXEL_COUNT 
    fi
    gdal_translate -outsize $TARGET_SIZE -of SRTMHGT $i $DEST_FILE

    if [ -e $DEST_FILE.aux.xml ]
    then
        rm $DEST_FILE.aux.xml
    fi
done