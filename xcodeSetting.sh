git reset --hard HEAD^

# /bin/bash
# 工程名  YHB_Prj  StudentLoan
APP_NAME="StudentLoan"
#scheme
SCHEME="StudentLoan"
# app 类型   xcodeproj,xcworkspace
APP_TYPE="xcworkspace"
# Debug Release
PackageMode="Release"
#method  development, app-store, ad-hoc, enterprise
method="enterprise"
#DevelopmentTeam
DevelopmentTeam="YXY7V48A96"
# 证书
CODE_SIGN_DISTRIBUTION="iPhone Distribution: Shanghai Nonobank financial information service Co. Ltd."
#provision file name       mxd,schoolLoanEnterDis
#PROVISIONING_PROFILE_SPECIFIER="BailingDis"
PROVISIONING_PROFILE_SPECIFIER="schoolLoanEnterDis2"
#BundleID
#bundleID="bailing.nono.maizi"
bundleID="com.nonobank.schoolLoan"

#project path
PROJECT_PATH="${PWD}"

cd  "${PROJECT_PATH}"
# info.plist路径
project_infoplist_path="${PROJECT_PATH}/${APP_NAME}/InfoPlistFiles/Info.plist"

/usr/libexec/PlistBuddy -c "Set:CFBundleIdentifier ${bundleID}"   ${project_infoplist_path}
#取版本号
bundleShortVersion=$(/usr/libexec/PlistBuddy -c "print CFBundleShortVersionString" "${project_infoplist_path}")
#取build值
bundleVersion=$(/usr/libexec/PlistBuddy -c "print CFBundleVersion" "${project_infoplist_path}")
DATE="$(date +%Y%m%d%H%M)"
IPANAME="${APP_NAME}_V${bundleShortVersion}_${DATE}.ipa"

sed -i '' "s/Automatic/Manual/g"  "${PROJECT_PATH}/${APP_NAME}.xcodeproj/project.pbxproj"




BundlePath="NULL"

if [ ${PackageMode} =  "Release" ];then
	BundlePath="Release-iphoneos"
	if [ ! -d "Release-iphoneos" ]; then 
	mkdir "Release-iphoneos" 
	fi 
else 
	BundlePath="Debug-iphoneos"
	if [ ! -d "Debug-iphoneos" ]; then 
	mkdir "Debug-iphoneos" 
	fi
fi


if [ ! -d "ipa" ]; then 
mkdir "ipa" 
fi 

if [ ${APP_TYPE} = "xcworkspace" ]; then
 	xcodebuild -workspace  "${PROJECT_PATH}/${APP_NAME}.xcworkspace" -scheme "${SCHEME}" -sdk iphoneos  PRODUCT_BUNDLE_IDENTIFIER="${bundleID}" DevelopmentTeam="${DevelopmentTeam}" \
 	DEVELOPMENT_TEAM="${DevelopmentTeam}" CODE_SIGN_IDENTITY="${CODE_SIGN_DISTRIBUTION}" \
  	PROVISIONING_PROFILE_SPECIFIER="${PROVISIONING_PROFILE_SPECIFIER}"  SYMROOT="$(PWD)" -configuration "${PackageMode}" OTHER_CFLAGS="$(inherited) -mllvm -reorder-bb -mllvm -split -mllvm -split-num=3 -mllvm -flatten -mllvm -zlog" OTHER_CPLUSPLUSFLAGS="$(inherited) -mllvm -reorder-bb -mllvm -split -mllvm -split-num=3 -mllvm -flatten -mllvm -zlog" GCC_VERSION="com.apple.compilers.llvm.nagain.3.9.0.1_4_beta" GCC_VERSION_IDENTIFIER="com_apple_compilers_llvm_nagain_3_9_0_1_4_beta"
elif [ ${APP_TYPE} = "xcodeproj" ]; then
    xcodebuild -target "${APP_NAME}" PRODUCT_BUNDLE_IDENTIFIER="${bundleID}" DevelopmentTeam="${DevelopmentTeam}" \
    DEVELOPMENT_TEAM="${DevelopmentTeam}" CODE_SIGN_IDENTITY="${CODE_SIGN_DISTRIBUTION}"  -configuration "${PackageMode}"\
    PROVISIONING_PROFILE_SPECIFIER="${PROVISIONING_PROFILE_SPECIFIER}"  SYMROOT="$(PWD)"
fi	     

echo "${BundlePath}"

xcrun -sdk iphoneos PackageApplication "./${BundlePath}/${APP_NAME}.app" -o "${PROJECT_PATH}/${IPANAME}"

#    ipa
echo "${PROJECT_PATH}/ipa/${APP_NAME}"


mv "${PROJECT_PATH}/${IPANAME}" "${PROJECT_PATH}/ipa/${IPANAME}"

#蒲公英上的User Key
uKey="534826e37a7c599598aaf265a6f6896a"
#蒲公英上的API Key
apiKey="756a4dad43e9e138bceb26d322240cd4"
#要上传的ipa文件路径
IPA_PATH="${PROJECT_PATH}/ipa/${IPANAME}"
rm -rf text.txt
#执行上传至蒲公英的命令
echo "++++++++++++++upload+++++++++++++"
curl -F "file=@${IPA_PATH}" -F "uKey=${uKey}" -F "_api_key=${apiKey}" https://qiniu-storage.pgyer.com/apiv1/app/upload


##上传至平台目录
#sshpass -p '123456' scp "${PROJECT_PATH}/ipa/${IPANAME}" localadmin@192.168.1.50:/home/localadmin/apps/mxd/ipa/

rm -r "${PROJECT_PATH}/ipa"
rm -r "${PROJECT_PATH}/Release-iphoneos"