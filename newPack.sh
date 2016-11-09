# /bin/bash
# 工程名
APP_NAME="YHB_Prj"
# app 类型   xcodeproj,xcworkspace
APP_TYPE="xcworkspace"
#scheme
SCHEME="YHB_Prj"
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
PROJECT_PATH="${PWD}/NuoNuoBank_App_git"

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

#echo "${IPA_PATH}">> text.txt
echo "=================clean================="
#xcodebuild -target "${APP_NAME}"  -configuration 'Release' clean
echo "+++++++++++++++++build+++++++++++++++++"
#xcodebuild -list
 # xcodebuild -target "${APP_NAME}" PRODUCT_BUNDLE_IDENTIFIER="${bundleID}" DevelopmentTeam="${DevelopmentTeam}" \
 # DEVELOPMENT_TEAM="${DevelopmentTeam}" CODE_SIGN_IDENTITY="${CODE_SIGN_DISTRIBUTION}" \
 #  PROVISIONING_PROFILE_SPECIFIER="${PROVISIONING_PROFILE_SPECIFIER}"  SYMROOT="$(PWD)"

# make archieve

sed -i '' "s/Automatic/Manual/g"  "${PROJECT_PATH}/${APP_NAME}.xcodeproj/project.pbxproj"


# xcodebuild -workspace "${PROJECT_PATH}/${APP_NAME}.${APP_TYPE}" -scheme "${SCHEME}" -configuration "Release" clean \
# archive -archivePath "${PROJECT_PATH}/${APP_NAME}" \
# DEVELOPMENT_TEAM=${DevelopmentTeam}  DEVELOPMENT_TEAM="${DevelopmentTeam}" \
#  CODE_SIGN_IDENTITY="${CODE_SIGN_DISTRIBUTION}" \
#  PROVISIONING_PROFILE_SPECIFIER="${PROVISIONING_PROFILE_SPECIFIER}" ProvisioningStyle="Manual" \
#  PRODUCT_BUNDLE_IDENTIFIER="${bundleID}"

if [${APP_TYPE} = "xcworkspace"];
	then
	xcodebuild -workspace "${PROJECT_PATH}/${APP_NAME}.${APP_TYPE}" -scheme "${SCHEME}" -configuration "Release" clean \
    archive -archivePath "${PROJECT_PATH}/${APP_NAME}" \
    DEVELOPMENT_TEAM=${DevelopmentTeam}  DEVELOPMENT_TEAM="${DevelopmentTeam}" \
     CODE_SIGN_IDENTITY="${CODE_SIGN_DISTRIBUTION}" \
     PROVISIONING_PROFILE_SPECIFIER="${PROVISIONING_PROFILE_SPECIFIER}" ProvisioningStyle="Manual" \
     PRODUCT_BUNDLE_IDENTIFIER="${bundleID}"
elif [${APP_TYPE} = "xcodeproj"]; 
	then
	xcodebuild -project "${PROJECT_PATH}/${APP_NAME}.${APP_TYPE}" -scheme "${SCHEME}" -configuration "Release" clean \
    archive -archivePath "${PROJECT_PATH}/${APP_NAME}" \
    DEVELOPMENT_TEAM=${DevelopmentTeam}  DEVELOPMENT_TEAM="${DevelopmentTeam}" \
     CODE_SIGN_IDENTITY="${CODE_SIGN_DISTRIBUTION}" \
     PROVISIONING_PROFILE_SPECIFIER="${PROVISIONING_PROFILE_SPECIFIER}" ProvisioningStyle="Manual" \
     PRODUCT_BUNDLE_IDENTIFIER="${bundleID}"
fi	     


echo "<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>development</string>
    <key>teamID</key>
    <string> A1B2C3D4E5 </string>
</dict>
</plist>" >> exportOptions.plist

/usr/libexec/PlistBuddy -c "Set:method ${method}" "${PROJECT_PATH}/exportOptions.plist"

/usr/libexec/PlistBuddy -c "Set:teamID ${DevelopmentTeam}" "${PROJECT_PATH}/exportOptions.plist"

 #要上传的ipa文件路径
echo "${PROJECT_PATH}/${IPANAME}.xcarchive"
#mkdir ipa

if [ ! -d "ipa"]; then 
mkdir "$myPath" 
fi 
#xcrun -sdk iphoneos PackageApplication "./Release-iphoneos/${APP_NAME}.app" -o "${PROJECT_PATH}/ipa/${IPANAME}"

#    ipa
echo "${PROJECT_PATH}/${APP_NAME}"
xcodebuild -exportArchive  -archivePath  "${PROJECT_PATH}/${APP_NAME}.xcarchive" -exportPath  "${PROJECT_PATH}/ipa"  -exportOptionsPlist "${PROJECT_PATH}/exportOptions.plist"

mv "${PROJECT_PATH}/ipa/${APP_NAME}.ipa" "${PROJECT_PATH}/ipa/${IPANAME}"