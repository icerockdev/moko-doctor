# !bin/bash

# # Path to save .plist file
file_path=~/Library/LaunchAgents/setenv.MPP_ENV.plist

# # Name for launchctl
launch_name=setenv.MPP_ENV

# 1 arg - filepath
# 2 arg - new java path
# 3 arg - new sdk path
# 4 arg - new gradle path
# 5 arg - new konan path
function replace_paths {
  echo "JAVA_HOME ---> $2"
  echo "ANDROID_SDK_ROOT ---> $3"
  echo "GRADLE_USER_HOME ---> $4"
  echo "KONAN_DATA_DIR ---> $5"
  cat >$1 <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>$launch_name</string>
  <key>ProgramArguments</key>
  <array>
    <string>/bin/launchctl</string>
    <string>setenv</string>
    <string>JAVA_HOME</string>
    <string>$2</string>
    <string>;/bin/launchctl</string>
    <string>setenv</string>
    <string>ANDROID_SDK_ROOT</string>
    <string>$3</string>
    <string>;/bin/launchctl</string>
    <string>setenv</string>
    <string>GRADLE_USER_HOME</string>
    <string>$4</string>
    <string>;/bin/launchctl</string>
    <string>setenv</string>
    <string>KONAN_DATA_DIR</string>
    <string>$5</string>
  </array>
  <key>RunAtLoad</key>
  <true/>
  <key>ServiceIPC</key>
  <false/>
</dict>
</plist>
EOF
  echo "To make the changes take effect, reboot the system!"
}

out=$(launchctl list | grep $launch_name)
if [ -f $file_path ]; then
  echo "[+] LaunchAgent is installed:"
  echo $out
  current_java=$( (cat $file_path | grep 'jdk' | sed 's/<string>*//' | sed 's/ *<\/string>/ /' | sed 's/\t//' | sed 's/\t//' | sed 's/ *$//'))
  echo " - JAVA_HOME: $current_java"
  current_sdk=$( (cat $file_path | grep 'sdk' | sed 's/<string>*//' | sed 's/ *<\/string>/ /' | sed 's/\t//' | sed 's/\t//' | sed 's/ *$//'))
  echo " - ANDROID_SDK_ROOT: $current_sdk"
  current_gradle=$( (cat $file_path | grep 'gradle' | sed 's/<string>*//' | sed 's/ *<\/string>/ /' | sed 's/\t//' | sed 's/\t//' | sed 's/ *$//'))
  echo " - GRADLE_USER_HOME: $current_gradle"
  current_gradle=$( (cat $file_path | grep 'konan' | sed 's/<string>*//' | sed 's/ *<\/string>/ /' | sed 's/\t//' | sed 's/\t//' | sed 's/ *$//'))
  echo " - KONAN_DATA_DIR: $current_konan"

  if [[ "$JAVA_HOME" != "$current_java" ]] || [[ "$ANDROID_SDK_ROOT" != "$current_sdk" ]] || [[ "$GRADLE_USER_HOME" != "$current_gradle" ]] || [[ "$KONAN_DATA_DIR" != "$current_konan" ]]; then
    if [ -d "$JAVA_HOME" ] && [ -d "$ANDROID_SDK_ROOT" ] && [ -d "$GRADLE_USER_HOME" ] && [ -d "$KONAN_DATA_DIR" ]; then
      while true; do
        read -p "New paths found, replace? [y/N] : " yn
        case $yn in
        [Yy]*)
          (replace_paths $file_path $JAVA_HOME $ANDROID_SDK_ROOT $GRADLE_USER_HOME $KONAN_DATA_DIR)
          exit
          ;;
        [Nn]*) exit ;;
        *) echo "Please answer y/n." ;;
        esac
      done
    else
      if ! [ -d "$JAVA_HOME" ]; then
        printf "\nThe directory specified in the JAVA_HOME variable does not exist!\n"
      fi
      if ! [ -d "$ANDROID_SDK_ROOT" ]; then
        printf "\nThe directory specified in the ANDROID_SDK_ROOT variable does not exist!\n"
      fi
      if ! [ -d "$GRADLE_USER_HOME" ]; then
        printf "\nThe directory specified in the GRADLE_USER_HOME variable does not exist!\n"
      fi
      if ! [ -d "$KONAN_DATA_DIR" ]; then
        printf "\nThe directory specified in the KONAN_DATA_DIR variable does not exist!\n"
      fi
    fi
  fi

else
  echo "[-] LaunchAgent is not installed:"
  java_path=""
  android_sdk_path=""
  gradle_user_home=""
  konan_data_dir=""
  if [ $JAVA_HOME ] && [ -d "$JAVA_HOME" ]; then
    java_path=$JAVA_HOME
  else
    echo "Enter JAVA_HOME path: "
    read java_path
  fi

  if [ $ANDROID_SDK_ROOT ] && [ -d "$ANDROID_SDK_ROOT"]; then
    android_sdk_path=$ANDROID_SDK_ROOT
  else
    echo "Enter ANDROID_SDK_ROOT path: "
    read android_sdk_path
  fi

  if [ $GRADLE_USER_HOME ] && [ -d "$GRADLE_USER_HOME"]; then
    gradle_user_home=$GRADLE_USER_HOME
  else
    echo "Enter GRADLE_USER_HOME path: "
    read gradle_user_home
  fi

  if [ $KONAN_DATA_DIR ] && [ -d "$KONAN_DATA_DIR"]; then
    konan_data_dir=$KONAN_DATA_DIR
  else
    echo "Enter KONAN_DATA_DIR path: "
    read konan_data_dir
  fi


  replace_paths $file_path $java_path $android_sdk_path $gradle_user_home $konan_data_dir
fi
