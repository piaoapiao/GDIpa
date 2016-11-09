# /bin/bash
echo "test"
APP_TYPE="xcworkspace"
INPUT_SUFFIX="xcodeproj"  # xcworkspace  xcodeproj
PRJ_PATH="${PWD}"


IPA_PATH="${PRJ_PATH}/ipa"

echo "${IPA_PATH}"

if [ ! -d "ipa" ]; then 
	echo "create ipa"
	mkdir "ipa"
fi 

if [ ${INPUT_SUFFIX} = "xcodeproj" ];
	then
	#mkdir "${PRJ_PATH}/ipa"
	echo "111"
elif [ "${INPUT_SUFFIX}" = "xcworkspace" ]; 
	then
	echo "2222"
fi




