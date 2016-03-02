#/bin/sh

VERSION=1.0.0

NAME="YUI Compressor Utils"

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
	if [ -d ${SRC_DEPLOY} ] ; then
		NAMES=files.txt
		find src.deploy -not -path '*/\.*' -name '*.css' -o -name '*.js' -type f > ${NAMES}
		for line in $(cat $NAMES) ; do
			DESTINY=${SRC_DEPLOY}/${line}
			rm ${line}
		done
		rm -f ${NAMES}
	else
		msg "Error!" "Directory src.deploy not found!"
	fi
}

runIt() {
	YUI_COMPRESSOR_JAR=yuicompressor-2.4.8.jar
	SRC_DEPLOY=src.deploy
	if [ -d ${SRC_DEPLOY} ] ; then
		NAMES=files.txt
		find . -not -iwholename '*src.deploy*' -not -path '*/\.*' -name '*.css' -type f > ${NAMES}
		find . -not -iwholename '*src.deploy*' -not -path '*/\.*' -name '*.js' -type f >> ${NAMES}
		for line in $(cat $NAMES) ; do
			DESTINY=${SRC_DEPLOY}/${line}
			DESTINY_PARENT=$(dirname ${DESTINY})
			[ -d $DESTINY_PARENT ] || mkdir $DESTINY_PARENT
			msg_ "=> File: ${DESTINY}"
			java -cp ${CP} -jar lib/${YUI_COMPRESSOR_JAR} -v -o ${DESTINY} ${line}
			checkError "Error!" "java not found!"
			msg__ "________________________________________________________________________________"
		done
		rm -f ${NAMES}
	else
		msg "Error!" "Directory src.deploy not found!"
	fi
}

compileIt() {
	find src | grep .java > files.txt
	javac -cp ${CP} -d classes @files.txt
	checkError "Error!" "javac not found!"
	rm files.txt
}

ShowHiddenFiles() {
	defaults write com.apple.finder AppleShowAllFiles YES
	sudo killall Finder
}

DontShowHiddenFiles() {
	defaults write com.apple.finder AppleShowAllFiles NO
	sudo killall Finder
}

checkError() {
	if [ $? -ne 0 ] ; then
		msg ${1} ${2}
	fi
}

msg() {
	echo
	echo "  ${1}"
	echo "  ${2}"
	echo
}

msg_() {
	echo "${1}"
	echo
}

msg__() {
	echo
	echo "${1}"
	echo
	echo
	echo
}

if [ -z "$1" ] ; then
	echo
	echo "${NAME} - ${VERSION}"
	echo "============================"
	msg "Error!" "Usage: ./YUI-Compressor-Utils.sh [commands...]"
	echo "  Available commands:"
	echo "         ./YUI-Compressor-Utils.sh [compileIt | clean[Bin|Classes|Out] | runIt | [Dont]ShowHiddenFiles]"
	echo
	echo "  ps: commands starting with uppercase letter are OS specific."
	echo
	echo
else
	while test ${#} -gt 0 ; do
		$1 ; shift
	done
fi
