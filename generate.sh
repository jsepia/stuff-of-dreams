#!/bin/bash
DPI=$1


#
# SETTINGS
#

CWD=`pwd`
IN_DIR=$CWD/src
RES_DIR=$CWD/resources
TMP_DIR=$CWD/tmp
OUT_DIR=$CWD/dist/${DPI}dpi
FILES=$CWD/src/*
TEMPLATE_FILENAME=template-tarot.svg
#STYLE_FILENAME=style-dark.css
STYLE_FILENAME=style-light.css
TYPE=Grayscale
# TYPE=Undefined

FULL_BLEED_W=3
FULL_BLEED_H=5

ILLUSTRATION_AREA_W=2.51
ILLUSTRATION_AREA_H=4.51


#
# PROGRAM
#

# support filenames with spaces
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")

# GM/IM abstraction layer
CONVERT=convert

FULL_BLEED_DEFAULT_W_PX="`echo "$FULL_BLEED_W * 72" | bc`"
FULL_BLEED_DEFAULT_H_PX="`echo "$FULL_BLEED_H * 72" | bc`"

FULL_BLEED_W_PX=`echo "$FULL_BLEED_W * $DPI" | bc`
FULL_BLEED_H_PX=`echo "$FULL_BLEED_H * $DPI" | bc`
ILLUSTRATION_AREA_W_PX=`echo "$ILLUSTRATION_AREA_W * $DPI" | bc`
ILLUSTRATION_AREA_H_PX=`echo "$ILLUSTRATION_AREA_H * $DPI" | bc`

FULL_BLEED_SIZE=${FULL_BLEED_W_PX}x${FULL_BLEED_H_PX}
ILLUSTRATION_AREA_SIZE=${ILLUSTRATION_AREA_W_PX}x${ILLUSTRATION_AREA_H_PX}

TEMPLATE_SRC=$RES_DIR/$TEMPLATE_FILENAME
TEMPLATE_TMP=$TMP_DIR/$TEMPLATE_FILENAME
COVER_FILENAME="$OUT_DIR"/stuff-of-dreams-tarot-"$DPI"dpi-cover.png
BUNDLE_FILENAME=stuff-of-dreams-tarot-"$DPI"dpi.zip
BUNDLE_TMP_FILENAME="$TMP_DIR"/"$BUNDLE_FILENAME"
BUNDLE_OUT_FILENAME="$OUT_DIR"/"$BUNDLE_FILENAME"

echo "Cleaning tmp and output"
rm -rf "$OUT_DIR" "$TMP_DIR"

echo "Creating directories..."
mkdir -p "$TMP_DIR"
mkdir -p "$OUT_DIR"

echo "Copying resources..."
cp -r "$RES_DIR"/* "$TMP_DIR/"

echo "Rendering at ${DPI}dpi (${FULL_BLEED_W_PX}x${FULL_BLEED_H_PX})..."
echo ""

for INPUT_FILENAME in $FILES
do
  # establish the base filename and metadata
  FILENAME=`basename $INPUT_FILENAME`
  BASE_FILENAME=`echo "$FILENAME" | sed -e 's/\..*$//g'`
  NUMBER=`bin/getcardnumber $FILENAME`
  NAME=`bin/getcardname $FILENAME`

  # aux copy
  TMP_FILENAME="$TMP_DIR/$FILENAME"

  # output filename
  OUTPUT_FILENAME="$OUT_DIR/$FILENAME"

  echo "Processing $FILENAME..."
  echo "Base filename: $BASE_FILENAME"
  echo "Number: $NUMBER"
  echo "Name: $NAME"

  # resize and crop the source image
  echo "$INPUT_FILENAME -> $TMP_FILENAME"
  $CONVERT "$INPUT_FILENAME" \
    -type $TYPE \
    -filter box \
    -resize "$ILLUSTRATION_AREA_SIZE" \
    -gravity Center \
    -crop "$ILLUSTRATION_AREA_SIZE" "$TMP_FILENAME"

  # render the SVG
  SVG_FILENAME="$BASE_FILENAME.svg"
  bin/generatecardsvg \
    --template "$RES_DIR/$TEMPLATE_FILENAME" \
    --style "$RES_DIR/$STYLE_FILENAME" \
    --cardnumber "$NUMBER" \
    --cardname "$NAME" \
    --cardimage "$FILENAME" \
    --output "$TMP_DIR/$SVG_FILENAME"
  
  # convert it to PNG
  echo "Converting $TMP_DIR/$SVG_FILENAME to $OUTPUT_FILENAME"
  INPUT_SIZE="$FULL_BLEED_DEFAULT_W_PX":"$FULL_BLEED_DEFAULT_H_PX"
  OUTPUT_SIZE="$FULL_BLEED_W_PX":"$FULL_BLEED_H_PX"
  svg2png \
    "$TMP_DIR/$SVG_FILENAME" \
    --output "$OUTPUT_FILENAME" \
    --width="$FULL_BLEED_W_PX" \
    --height="$FULL_BLEED_H_PX"
  
  # done
  echo "Generated $OUTPUT_FILENAME"
  echo ""
done

# Generate a montage
montage "$OUT_DIR/*.png" -tile 6x -geometry "$FULL_BLEED_W_PX"x"$FULL_BLEED_H_PX" -background black "$COVER_FILENAME"
echo "Generated $COVER_FILENAME"

# Generate a bundle
cd "$OUT_DIR"
bestzip "$BUNDLE_TMP_FILENAME" ./
cd "$CWD"
mv "$BUNDLE_TMP_FILENAME" "$BUNDLE_OUT_FILENAME"
echo "Generated $BUNDLE_FILENAME"

# restore $IFS
IFS=$SAVEIFS
