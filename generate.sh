#!/bin/bash
DPI=$1


#
# SETTINGS
#

IN_DIR=./src
RES_DIR=./resources
TMP_DIR=./tmp
OUT_DIR=./dist/${DPI}dpi
FILES=./src/*
TEMPLATE_FILENAME=template-tarot.svg
STYLE_FILENAME=style-dark.css

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

FULL_BLEED_W_PX=`echo "$FULL_BLEED_W * $DPI" | bc`
FULL_BLEED_H_PX=`echo "$FULL_BLEED_H * $DPI" | bc`
ILLUSTRATION_AREA_W_PX=`echo "$ILLUSTRATION_AREA_W * $DPI" | bc`
ILLUSTRATION_AREA_H_PX=`echo "$ILLUSTRATION_AREA_H * $DPI" | bc`

FULL_BLEED_SIZE=${FULL_BLEED_W_PX}x${FULL_BLEED_H_PX}
ILLUSTRATION_AREA_SIZE=${ILLUSTRATION_AREA_W_PX}x${ILLUSTRATION_AREA_H_PX}

TEMPLATE_SRC=$RES_DIR/$TEMPLATE_FILENAME
TEMPLATE_TMP=$TMP_DIR/$TEMPLATE_FILENAME

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
  convert "$INPUT_FILENAME" -resize "$ILLUSTRATION_AREA_SIZE" -gravity Center -crop "$ILLUSTRATION_AREA_SIZE" "$TMP_FILENAME"

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
  svg2png "$TMP_DIR/$SVG_FILENAME" --output="$OUTPUT_FILENAME" --width $FULL_BLEED_W_PX --height $FULL_BLEED_H_PX
  
  # done
  echo "Generated $OUTPUT_FILENAME"
  echo ""
done

# restore $IFS
IFS=$SAVEIFS
