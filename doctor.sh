# !bin/bash
#######
## CHECK INSTRUMENTS:
########
printf "Checking installed programs: \n"

git_found=$(type git | grep "not found")
if [ -z "$git_found" ];
then
    printf "\t[+] Git is installed.\n"
else 
    printf "\t[-] Git is not installed!\n"
fi

xcode_found=$(type xcode-select | grep "not found")
if [ -z "$git_found" ];
then
    printf "\t[+] Xcode is installed.\n"
else 
    printf "\t[-] Xcode is not installed!\n"
fi

xcode_found=$(type xcodebuild | grep "not found")
if [ -z "$git_found" ];
then
    printf "\t[+] Xcode Comand Line is installed.\n"
else
    printf "\t[-] Xcode Comand Line is not installed!\n"
fi

as_found=$(mdfind "Android Studio.app" "kind:app")
if [ -z "$as_found" ];
then
    printf "\t[-] Android Studio is not installed!\n"
else
    printf "\t[+] Android Studio is installed.\n"
fi
#######
## CHECK ENVIRONMENT:
########
printf "\nChecking environment variables: \n"
if [ $JAVA_HOME ]; then
    printf "\t[+] "JAVA_HOME" variable is set.\n"
else
    printf "\t[-] "JAVA_HOME" variable is not set.\n"
fi

if [ $ANDROID_SDK_ROOT ]; then
    printf "\t[+] "ANDROID_SDK_ROOT" variable is set.\n"
else
    printf "\t[-] "ANDROID_SDK_ROOT" variable is not set.\n"
fi

#######
## CHECK PLUG-INS:
########
printf "\nChecking plugins: \n"
as_kmm_plugin=$(mdfind "com.jetbrains.kmm" | grep "pluginAdvertiser")
if [ -z "$as_kmm_plugin" ]; then
    printf "\t[-] KMM plugin for Android Studio is not installed.\n"
else
    printf "\t[+] KMM plugin for Android Studio is installed.\n"
fi

xcode_kotlin_plugin_path=~/Library/Developer/Xcode/Plug-ins/Kotlin.ideplugin
if [ -e $xcode_kotlin_plugin_path ]; then 
    printf "\t[+] Xcode Kotlin plugin is installed.\n"
else
    printf "\t[-] Xcode Kotlin plugin is not installed.\n"
fi

#######
## CHECK AndroidStudio CONFIGURATION:
########

printf "\nChecking Android Studio Configuration: \n"

prefs=$(mdfind "extensions" kind:folder | grep "Android" | sed 's/ *\/extensions//')
count_pref=$(echo $prefs | wc -l | sed 's/^[[:blank:]]*//g')
if [ "$count_pref" -ge 2 ]; then
    printf "\nYou have several ($count_pref) Android Studio settings: \n"
    echo $prefs
    printf "\n[!] To work correctly, leave one!\n"
fi

gradle_skip_task_list=$(mdfind "SKIP_GRADLE_TASKS_LIST" | grep "options")
if [ -z "$gradle_skip_task_list" ]; then
    printf "\t[-] Android Studio: \`Do not build gradle task list during Gradle sync\` is enable!\n"
else
    printf "\t[+] Android Studio: \`Do not build gradle task list during Gradle sync\` is disable!\n"
fi

jdk_tables=$(mdfind "jdk" | grep "table" | grep "Android")
jdk_count=$(mdfind "jdk" | grep "table" | grep "Android" | wc -l | sed 's/^[[:blank:]]*//g')
studio_jdk_set=0
for (( i = 1; i <= jdk_count; i++))
do
    file=$(``mdfind "jdk" | grep "table" | grep "Android" | sed -n "${i}p" )
    # echo "$i => $file"
    jdk_out=$(grep $JAVA_HOME "$file")
    if [ "$jdk_out" ];
    then
        studio_jdk_set=1
    fi
    # echo "sjs : $studio_jdk_set"

done
if [ $studio_jdk_set -eq 1 ];
then
    printf "\t[+] Android Studio JDK is set.\n"
else
    printf "\t[-] Android Studio JDK is not set!\n"
fi

#######
## CHECK COCOA PODS:
########

printf "Checking COCOA: \n"
pod_found=$(type pod | grep "not found")
if [ -z "$pod_found" ];
then
    printf "\t[+] Cocoa Pods is installed.\n"
else 
    printf "\t[-] Cocoa Pods is not installed!\n"
fi





