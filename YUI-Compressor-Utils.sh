#/bin/sh

VERSION=1.0.0

MAIN_PACKAGE=yuicompressorutils.main
MAIN_CLASS=MainYUICompressorUtils

CP=.
CP=${CP}:classes

clear

clean() {
	cleanBin
	cleanClasses
	cleanOut
}

cleanBin() {
	rm -rf bin/*
}

cleanClasses() {
	rm -rf classes/*
}

cleanOut() {
	rm -rf out/*
}

runIt() {
	NAMES=files.txt
	find . -not -iwholename '*src.deploy*' -not -path '*/\.*' -iwholename '*.js' -type f > ${NAMES}
	find . -not -iwholename '*src.deploy*' -not -path '*/\.*' -iwholename '*.css' -type f >> ${NAMES}
	for line in $(cat $NAMES) ; do
		DESTINY=src.deploy/${line}
		DESTINY_PARENT=$(dirname ${DESTINY})
		[ -d $DESTINY_PARENT ] || mkdir $DESTINY_PARENT
		java -cp ${CP} -jar lib/yuicompressor-2.4.8.jar -v -o ${DESTINY} ${line}
	done
	rm -f ${NAMES}
}

compileIt() {
	find src | grep .java > files.txt
	javac -cp ${CP} -d classes @files.txt
	rm files.txt
}

AppleShowAllFiles() {
	defaults write com.apple.finder AppleShowAllFiles YES
	sudo killall Finder
}

AppleHideAllFiles() {
	defaults write com.apple.finder AppleShowAllFiles NO
	sudo killall Finder
}

if [ -z "$1" ] ; then
	echo
	echo "Error!"
	echo "Usage: ./YUI-Compressor-Utils.sh (compileIt | clean[Bin|Classes|Out] | runIt | Apple(Show|Hide)AllFiles)"
	echo
else
	$1
fi
