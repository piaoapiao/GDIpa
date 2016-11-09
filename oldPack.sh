# /bin/bash
# 工程名
APP_NAME="StudentLoan"
# app 类型   xcodeproj,xcworkspace
APP_TYPE="xcodeproj"
#scheme
SCHEME="StudentLoan"
#method  development, app-store, ad-hoc, enterprise
method="enterprise"
#DevelopmentTeam
DevelopmentTeam="YXY7V48A96"
# 证书
CODE_SIGN_DISTRIBUTION="iPhone Distribution: Shanghai Nonobank financial information service Co. Ltd."
#provision file name
PROVISIONING_PROFILE_SPECIFIER="schoolLoanEnterDis"
#BundleID
bundleID="com.nonobank.schoolLoan"
#project path
PROJECT_PATH="${PWD}"

cd  "${PROJECT_PATH}"
# info.plist路径
project_infoplist_path="${PROJECT_PATH}/${APP_NAME}/Info.plist"

/usr/libexec/PlistBuddy -c "Set:CFBundleIdentifier ${bundleID}"   ${project_infoplist_path}
#取版本号
bundleShortVersion=$(/usr/libexec/PlistBuddy -c "print CFBundleShortVersionString" "${project_infoplist_path}")
#取build值
bundleVersion=$(/usr/libexec/PlistBuddy -c "print CFBundleVersion" "${project_infoplist_path}")
DATE="$(date +%Y%m%d%H%M)"
IPANAME="${APP_NAME}_V${bundleShortVersion}_${DATE}.ipa"

sed -i '' "s/Automatic/Manual/g"  "${PROJECT_PATH}/${APP_NAME}.xcodeproj/project.pbxproj"

if [ ! -d "Release-iphoneos" ]; then 
mkdir "Release-iphoneos" 
fi 


if [ ! -d "ipa" ]; then 
mkdir "ipa" 
fi 

if [ ${APP_TYPE} = "xcworkspace" ]; then
 	xcodebuild -workspace  "${PROJECT_PATH}/${APP_NAME}.xcworkspace" -scheme "${SCHEME}" -sdk iphoneos  PRODUCT_BUNDLE_IDENTIFIER="${bundleID}" DevelopmentTeam="${DevelopmentTeam}" \
 	DEVELOPMENT_TEAM="${DevelopmentTeam}" CODE_SIGN_IDENTITY="${CODE_SIGN_DISTRIBUTION}" \
  	PROVISIONING_PROFILE_SPECIFIER="${PROVISIONING_PROFILE_SPECIFIER}"  SYMROOT="$(PWD)" CONFIGURATION_BUILD_DIR="${PROJECT_PATH}/Release-iphoneos"
elif [ ${APP_TYPE} = "xcodeproj" ]; then
    xcodebuild -target "${APP_NAME}" PRODUCT_BUNDLE_IDENTIFIER="${bundleID}" DevelopmentTeam="${DevelopmentTeam}" \
    DEVELOPMENT_TEAM="${DevelopmentTeam}" CODE_SIGN_IDENTITY="${CODE_SIGN_DISTRIBUTION}" \
    PROVISIONING_PROFILE_SPECIFIER="${PROVISIONING_PROFILE_SPECIFIER}"  SYMROOT="$(PWD)"
fi	     


xcrun -sdk iphoneos PackageApplication "./Release-iphoneos/${APP_NAME}.app" -o "${PROJECT_PATH}/${IPANAME}"

#    ipa
echo "${PROJECT_PATH}/ipa/${APP_NAME}"


mv "${PROJECT_PATH}/${IPANAME}" "${PROJECT_PATH}/ipa/${IPANAME}"