# /bin/bash
# 工程名  YHB_Prj  StudentLoan
APP_NAME="YHB_Prj"
#scheme
SCHEME="YHB_Prj"
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
#provision file name       nonoAppDis,schoolLoanEnterDis
PROVISIONING_PROFILE_SPECIFIER="NonobankDis"
#BundleID
bundleID="com.nuonuobank.shanghai.nuonuo"
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
IPANAME="${APP_NAME}"

sed -i '' "s/Automatic/Manual/g"  "${PROJECT_PATH}/${APP_NAME}.xcodeproj/project.pbxproj"


#是否开启 
Nagagin=YES
if [ ${Nagagin} =  YES ];then
oldGcc='GCC_VERSION = "";'

newGcc='GCC_VERSION = com.apple.compilers.llvm.nagain.3.9.0.1_4_beta;'

oldModule='CLANG_ENABLE_MODULES = YES';

newModule='CLANG_ENABLE_MODULES = NO';

pbxprojPath="${PROJECT_PATH}/${APP_NAME}.xcodeproj/project.pbxproj"

sed -i '' "s/${oldGcc}/${newGcc}/g"  "${PROJECT_PATH}/${APP_NAME}.xcodeproj/project.pbxproj"

sed -i '' "s/${oldModule}/${newModule}/g"  "${PROJECT_PATH}/${APP_NAME}.xcodeproj/project.pbxproj"

hexdump -ve '1/1 "%.2x"'  "${pbxprojPath}" |sed  "s/4f544845525f43464c414753203d2022223b/4f544845525f43464c414753203d20280a0909090909222d6d6c6c766d222c0a0909090909222d72656f726465722d6262222c0a0909090909222d6d6c6c766d222c0a0909090909222d73706c6974222c0a0909090909222d6d6c6c766d222c0a0909090909222d73706c69742d6e756d3d33222c0a0909090909222d6d6c6c766d222c0a0909090909222d666c617474656e222c0a0909090909222d6d6c6c766d222c0a0909090909222d7a6c6f67222c0a09090909293b/g"  | xxd -r -p >  project3.pbxproj

rm "${pbxprojPath}"

mv project3.pbxproj "${pbxprojPath}"
fi


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
    xcodebuild -workspace "${PROJECT_PATH}/${APP_NAME}.${APP_TYPE}" -scheme "${SCHEME}" -configuration "Release" clean \
    archive -archivePath "${PROJECT_PATH}/${APP_NAME}" \
    DEVELOPMENT_TEAM=${DevelopmentTeam}  DEVELOPMENT_TEAM="${DevelopmentTeam}" \
    CODE_SIGN_IDENTITY="${CODE_SIGN_DISTRIBUTION}" \
    PROVISIONING_PROFILE_SPECIFIER="${PROVISIONING_PROFILE_SPECIFIER}" ProvisioningStyle="Manual" \
    PRODUCT_BUNDLE_IDENTIFIER="${bundleID}"
elif [ ${APP_TYPE} = "xcodeproj" ]; then
   xcodebuild -project "${PROJECT_PATH}/${APP_NAME}.${APP_TYPE}" -scheme "${SCHEME}" -configuration "Release" clean \
    archive -archivePath "${PROJECT_PATH}/${APP_NAME}" \
    DEVELOPMENT_TEAM=${DevelopmentTeam}  DEVELOPMENT_TEAM="${DevelopmentTeam}" \
    CODE_SIGN_IDENTITY="${CODE_SIGN_DISTRIBUTION}" \
    PROVISIONING_PROFILE_SPECIFIER="${PROVISIONING_PROFILE_SPECIFIER}" ProvisioningStyle="Manual" \
    PRODUCT_BUNDLE_IDENTIFIER="${bundleID}"
fi        

echo "${BundlePath}"

echo "${BundlePath}"

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

xcodebuild -exportArchive -archivePath "${PROJECT_PATH}/${APP_NAME}.xcarchive" -exportPath "${PROJECT_PATH}/ipa" -exportOptionsPlist "${PROJECT_PATH}/exportOptions.plist"


#    ipa
echo "${PROJECT_PATH}/ipa/${APP_NAME}"


#蒲公英上的User Key
uKey="c0aa355c5353d6d43f10f4b37f0291c6"
#蒲公英上的API Key
apiKey="013b6f5891f79e10dc0256beaa5caf40"
#要上传的ipa文件路径
IPA_PATH="${PROJECT_PATH}/ipa/${IPANAME}.ipa"

#执行上传至蒲公英的命令
#echo "++++++++++++++upload+++++++++++++"
curl -F "file=@${IPA_PATH}" -F "uKey=${uKey}" -F "_api_key=${apiKey}" https://www.pgyer.com/apiv1/app/upload

##上传至平台目录
#sshpass -p '123456' scp "${PROJECT_PATH}/ipa/${IPANAME}" localadmin@192.168.1.50:/home/localadmin/apps/nono/ipa/

rm -r "${PROJECT_PATH}/${APP_NAME}.xcarchive"
rm -r "${PROJECT_PATH}/exportOptions.plist"
rm -r  "${PROJECT_PATH}/Release-iphoneos/"
#rm -r "${PROJECT_PATH}/ipa"

