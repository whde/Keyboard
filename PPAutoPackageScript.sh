cd "$(dirname "$0")"
# ===============================项目自定义部分(自定义好下列参数后再执行该脚本)============================= #
# 计时
SECONDS=0
# 指定项目的scheme名称
# (注意: 因为shell定义变量时,=号两边不能留空格,若scheme_name与info_plist_name有空格,脚本运行会失败,暂时还没有解决方法,知道的还请指教!)
scheme_name="Keyboard"
# 工程中Target对应的配置plist文件名称, Xcode默认的配置文件为Info.plist
info_plist_name="Info"
# 指定要打包编译的方式 : Release,Debug...
build_configuration="Release"


# ===============================自动打包部分(无特殊情况不用修改)============================= #

# 导出ipa所需要的plist文件路径
ExportOptionsPlistPath="DevelopmentExportOptionsPlist.plist"

# 获取项目名称
project_name=`find . -name *.xcodeproj | awk -F "[/.]" '{print $(NF-1)}'`
# 获取版本号,内部版本号,bundleID
info_plist_path="$project_name/$info_plist_name.plist"
buildNumber=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "$info_plist_path")
buildNumber=$(($buildNumber + 1))
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $buildNumber" "$info_plist_path"
bundle_version=`/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" $info_plist_path`
bundle_build_version=`/usr/libexec/PlistBuddy -c "Print CFBundleVersion" $info_plist_path`
bundle_identifier=`/usr/libexec/PlistBuddy -c "Print CFBundleIdentifier" $info_plist_path`


export_path=./Build
ipa_name="$scheme_name""_V$bundle_version($bundle_build_version)"
export_archive_path="$export_path/$ipa_name"".xcarchive"
export_ipa_path=$export_path
web_path=""
echo "$export_archive_path"
echo "$ipa_name"

echo "\033[32m*************************  开始构建项目  *************************  \033[0m"
# 指定输出文件目录不存在则创建
if [ -d "$export_path" ] ; then
echo $export_path
else
mkdir -pv $export_path
fi

xcodebuild clean -project ${project_name}.xcodeproj \
-scheme ${scheme_name} \
-configuration ${build_configuration}

xcodebuild archive -project ${project_name}.xcodeproj \
-scheme ${scheme_name} \
-configuration ${build_configuration} \
-archivePath ${export_archive_path}

#  检查是否构建成功
#  xcarchive 实际是一个文件夹不是一个文件所以使用 -d 判断
if [ -d "$export_archive_path" ] ; then
echo "\033[32;1m项目构建成功 🚀 🚀 🚀  \033[0m"
else
echo "\033[31;1m项目构建失败 😢 😢 😢  \033[0m"
exit 1
fi

echo "\033[32m*************************  开始导出ipa文件  *************************  \033[0m"
xcodebuild  -exportArchive \
            -archivePath ${export_archive_path} \
            -exportPath ${export_ipa_path} \
            -exportOptionsPlist ${ExportOptionsPlistPath}

# 检查文件是否存在
if [ -f "$export_ipa_path/$scheme_name.ipa" ] ; then
echo "\033[32;1m导出 ${scheme_name}.ipa 包成功 🎉  🎉  🎉   \033[0m"
# open $export_path
else
echo "\033[31;1m导出 ${scheme_name}.ipa 包失败 😢 😢 😢     \033[0m"
# 相关的解决方法
exit 1
fi
# 输出打包总用时
echo "\033[36;1m使用PPAutoPackageScript打包总用时: ${SECONDS}s \033[0m"
