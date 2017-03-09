#!/bin/bash

COMPRESS=1                # Compress if ImageOptim is intalled. 0 = disabled; 1 = enabled
iOSSubdir="/Media.xcassets/AppIcon.appiconset"          # make this an empty string to save in same dir
androidSubdir="/Android"  # make this an empty string to save in same dir

help() {
	echo ""
	echo "Usage: ./$(basename "$0") <your_1024x1024.png>"
	echo "       --------------------------------------------------------------------------------------"
	echo "       If you don't pass a parameter, it will look for a iTunesArtwork@2x.png in the current"
	echo "       directory. The file needs to be 1024x1024 for the rest of the files to be resized"
	echo "       correctly."
	echo ""
	echo "       If you want to automatically compress the icons, install ImageOptim."
	echo "       More info here: http://imageoptim.com/"
	exit
}

FILEPATH=$1
if [[ ! -f $FILEPATH ]]; then
	SHELLDIR=$(cd $(dirname "$0"); pwd)
	FILEPATH="${SHELLDIR}/Icon.png"
#	FILEPATH="./iTunesArtwork@2x.png"
	
fi
if [[ ! -f $FILEPATH ]]; then
	echo "ERROR: Could not find icon file"
	help
fi
FILE=$(basename "$FILEPATH")

# the root directory is where the icon passed as a parameter lives
DIR=$(cd $(dirname "$FILEPATH"); pwd)

# make subdirs
if [[ $iOSSubdir != "" && ! -d ${DIR}/$iOSSubdir ]]; then mkdir ${DIR}/${iOSSubdir}; fi
#if [[ $androidSubdir != "" && ! -d ${DIR}/$androidSubdir ]]; then mkdir ${DIR}/${androidSubdir}; fi

# iOS App Store Icons
#if [[ $FILE != "./Icon.png" || $iOSSubdir != "" ]]; then sips --resampleWidth 1024 "${DIR}/${FILE}" --out "${DIR}${iOSSubdir}/iTunesArtwork@2x.png" > /dev/null 2>&1; fi
#sips --resampleWidth 512 "${DIR}/${FILE}" --out "${DIR}${iOSSubdir}/iTunesArtwork.png" > /dev/null 2>&1

# iOS App Icons
sips --resampleWidth 40 "${DIR}/${FILE}" --out "${DIR}${iOSSubdir}/Icon-40.png" > /dev/null 2>&1
sips --resampleWidth 80 "${DIR}/${FILE}" --out "${DIR}${iOSSubdir}/Icon-40@2x.png" > /dev/null 2>&1
sips --resampleWidth 120 "${DIR}/${FILE}" --out "${DIR}${iOSSubdir}/Icon-40@3x.png" > /dev/null 2>&1
sips --resampleWidth 120 "${DIR}/${FILE}" --out "${DIR}${iOSSubdir}/Icon-60@2x.png" > /dev/null 2>&1
sips --resampleWidth 180 "${DIR}/${FILE}" --out "${DIR}${iOSSubdir}/Icon-60@3x.png" > /dev/null 2>&1
sips --resampleWidth 72 "${DIR}/${FILE}" --out "${DIR}${iOSSubdir}/Icon-72.png" > /dev/null 2>&1
sips --resampleWidth 144 "${DIR}/${FILE}" --out "${DIR}${iOSSubdir}/Icon-72@2x.png" > /dev/null 2>&1
sips --resampleWidth 76 "${DIR}/${FILE}" --out "${DIR}${iOSSubdir}/Icon-76.png" > /dev/null 2>&1
sips --resampleWidth 152 "${DIR}/${FILE}" --out "${DIR}${iOSSubdir}/Icon-76@2x.png" > /dev/null 2>&1
sips --resampleWidth 167 "${DIR}/${FILE}" --out "${DIR}${iOSSubdir}/Icon-83.5@2x.png" > /dev/null 2>&1
sips --resampleWidth 50 "${DIR}/${FILE}" --out "${DIR}${iOSSubdir}/Icon-Small-50.png" > /dev/null 2>&1
sips --resampleWidth 100 "${DIR}/${FILE}" --out "${DIR}${iOSSubdir}/Icon-Small-50@2x.png" > /dev/null 2>&1
sips --resampleWidth 29 "${DIR}/${FILE}" --out "${DIR}${iOSSubdir}/Icon-Small.png" > /dev/null 2>&1
sips --resampleWidth 58 "${DIR}/${FILE}" --out "${DIR}${iOSSubdir}/Icon-Small@2x.png" > /dev/null 2>&1
sips --resampleWidth 87 "${DIR}/${FILE}" --out "${DIR}${iOSSubdir}/Icon-Small@3x.png" > /dev/null 2>&1
sips --resampleWidth 57 "${DIR}/${FILE}" --out "${DIR}${iOSSubdir}/Icon.png" > /dev/null 2>&1
sips --resampleWidth 114 "${DIR}/${FILE}" --out "${DIR}${iOSSubdir}/Icon@2x.png" > /dev/null 2>&1
sips --resampleWidth 40 "${DIR}/${FILE}" --out "${DIR}${iOSSubdir}/NotificationIcon@2x.png" > /dev/null 2>&1
sips --resampleWidth 60 "${DIR}/${FILE}" --out "${DIR}${iOSSubdir}/NotificationIcon@3x.png" > /dev/null 2>&1
sips --resampleWidth 20 "${DIR}/${FILE}" --out "${DIR}${iOSSubdir}/NotificationIcon~ipad.png" > /dev/null 2>&1
sips --resampleWidth 40 "${DIR}/${FILE}" --out "${DIR}${iOSSubdir}/NotificationIcon~ipad@2x.png" > /dev/null 2>&1


## iOS App Icons
#sips --resampleWidth 57 "${DIR}/${FILE}" --out "${DIR}${iOSSubdir}/Icon.png" > /dev/null 2>&1
#sips --resampleWidth 114 "${DIR}/${FILE}" --out "${DIR}${iOSSubdir}/Icon@2x.png" > /dev/null 2>&1
#sips --resampleWidth 60 "${DIR}/${FILE}" --out "${DIR}${iOSSubdir}/Icon-60.png" > /dev/null 2>&1
#sips --resampleWidth 120 "${DIR}/${FILE}" --out "${DIR}${iOSSubdir}/Icon-60@2x.png" > /dev/null 2>&1
#sips --resampleWidth 72 "${DIR}/${FILE}" --out "${DIR}${iOSSubdir}/Icon-72.png" > /dev/null 2>&1
#sips --resampleWidth 144 "${DIR}/${FILE}" --out "${DIR}${iOSSubdir}/Icon-72@2x.png" > /dev/null 2>&1
#sips --resampleWidth 76 "${DIR}/${FILE}" --out "${DIR}${iOSSubdir}/Icon-76.png" > /dev/null 2>&1
#sips --resampleWidth 152 "${DIR}/${FILE}" --out "${DIR}${iOSSubdir}/Icon-76@2x.png" > /dev/null 2>&1
#
## iOS Search/Settings
#sips --resampleWidth 29 "${DIR}/${FILE}" --out "${DIR}${iOSSubdir}/Icon-Small.png" > /dev/null 2>&1
#sips --resampleWidth 58 "${DIR}/${FILE}" --out "${DIR}${iOSSubdir}/Icon-Small@2x.png" > /dev/null 2>&1
#sips --resampleWidth 40 "${DIR}/${FILE}" --out "${DIR}${iOSSubdir}/Icon-Small-40.png" > /dev/null 2>&1
#sips --resampleWidth 80 "${DIR}/${FILE}" --out "${DIR}${iOSSubdir}/Icon-Small-40@2x.png" > /dev/null 2>&1
#sips --resampleWidth 50 "${DIR}/${FILE}" --out "${DIR}${iOSSubdir}/Icon-Small-50.png" > /dev/null 2>&1
#sips --resampleWidth 100 "${DIR}/${FILE}" --out "${DIR}${iOSSubdir}/Icon-Small-50@2x.png" > /dev/null 2>&1
#
## Android icons
#sips --resampleWidth 144 "${DIR}/${FILE}" --out "${DIR}${androidSubdir}/Icon-xxhdpi.png.png" > /dev/null 2>&1
#sips --resampleWidth 96 "${DIR}/${FILE}" --out "${DIR}${androidSubdir}/Icon-xhdpi.png.png" > /dev/null 2>&1
#sips --resampleWidth 72 "${DIR}/${FILE}" --out "${DIR}${androidSubdir}/Icon-hdpi.png.png" > /dev/null 2>&1
#sips --resampleWidth 48 "${DIR}/${FILE}" --out "${DIR}${androidSubdir}/Icon-mdpi.png.png" > /dev/null 2>&1
#sips --resampleWidth 36 "${DIR}/${FILE}" --out "${DIR}${androidSubdir}/Icon-ldpi.png.png" > /dev/null 2>&1

echo "Your icons have been created!"

# optimize PNGs, if ImageOptim is installed
ImageOptim="/Applications/ImageOptim.app/Contents/MacOS/ImageOptim"
if [[ $COMPRESS -eq 1 ]]; then
	if [[ -f $ImageOptim ]]; then
		echo "Optimizing iOS icons... This is going to take a while..."
		$($ImageOptim ${DIR}${iOSSubdir}/*)
		echo "Optimizing Android icons... This is going to take a while..."
#		$($ImageOptim ${DIR}${androidSubdir}/*)
		echo ""
		echo "Finished compressing the icon files!"
	else
		echo "Skipped compression. To compress the PNGs, install ImageOptim. More info here: http://imageoptim.com/"
	fi
fi

