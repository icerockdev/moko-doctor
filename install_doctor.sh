# !bin/bash
mkdir -p ~/.moko-doctor/sh && \
cd ~/.moko-doctor/sh && \
curl -L -O "https://raw.githubusercontent.com/icerockdev/moko-doctor/main/doctor.sh" && \
curl -L -O "https://raw.githubusercontent.com/icerockdev/moko-doctor/main/setup_xcode_environment.sh" && \
chmod u+x doctor.sh && \
chmod u+x setup_xcode_environment.sh && \
echo 'To complete setup add into your environments: export PATH=~/.moko-doctor/sh:$PATH'
