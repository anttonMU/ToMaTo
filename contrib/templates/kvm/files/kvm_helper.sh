#!/bin/ash
#no bash in busybox

set -e

DISTRO=""
ISSUE=$(cat /target/etc/issue)
case "$ISSUE" in
  Debian*5.0*)
    DISTRO="debian_5"
    ;;
  Debian*6.0*)
    DISTRO="debian_6"
    ;;
  Debian*7*)
    DISTRO="debian_7"
    ;;
  Debian*8*)
    DISTRO="debian_8"
    ;;
  Ubuntu*10.04*)
    DISTRO="ubuntu_1004"
    ;;
  Ubuntu*10.10*)
    DISTRO="ubuntu_1010"
    ;;
  Ubuntu*11.04*)
    DISTRO="ubuntu_1104"
    ;;
  Ubuntu*11.10*)
    DISTRO="ubuntu_1110"
    ;;
  Ubuntu*12.04*)
    DISTRO="ubuntu_1204"
    ;;
  Ubuntu*12.10*)
    DISTRO="ubuntu_1210"
    ;;
  Ubuntu*13.04*)
    DISTRO="ubuntu_1304"
    ;;
  Ubuntu*13.10*)
    DISTRO="ubuntu_1310"
    ;;
  Ubuntu*14.04*)
    DISTRO="ubuntu_1404"
    ;;
  Ubuntu*14.10*)
    DISTRO="ubuntu_1410"
    ;;
  Ubuntu*15.04*)
    DISTRO="ubuntu_1504"
    ;;
  Ubuntu*15.10*)
    DISTRO="ubuntu_1510"
    ;;
  Ubuntu*16.04*)
    DISTRO="ubuntu_1604"
    ;;
  Ubuntu*16.10*)
    DISTRO="ubuntu_1610"
    ;;
esac

cp /prepare_vm.sh /target

# Registering prepare_vm.sh for start upon next boot
case $DISTRO in
  ubuntu*)
    mv /target/etc/rc.local /target/etc/rc.local.orig
    cat <<EOF >/target/etc/rc.local
#!/bin/bash
sleep 5
/prepare_vm.sh >/var/log/prepare_vm.log 2>&1
rm -f /prepare_vm.sh
rm -f \$0
mv /etc/rc.local.orig /etc/rc.local
if [ -f /etc/init.d/grub-common ]; then
  # fix for ubuntu waiting forever at boot due to fail state
  /etc/init.d/grub-common start
fi
shutdown -h now
EOF
    chmod a+x /target/etc/rc.local
    ;;
  debian_5)
    cat <<EOF >/target/etc/rc2.d/S15prepare_vm
#!/bin/bash
sleep 5
/prepare_vm.sh >/var/log/prepare_vm.log 2>&1
rm -f /prepare_vm.sh
rm -f \$0
if [ -f /etc/init.d/grub-common ]; then
  # fix for ubuntu waiting forever at boot due to fail state
  /etc/init.d/grub-common start
fi
shutdown -h now
EOF
    chmod a+x /target/etc/rc2.d/S15prepare_vm
    ;;
  debian_*)
    cat <<EOF >/target/etc/init.d/prepare_vm
#!/bin/sh
### BEGIN INIT INFO
# Provides:          Preparing VM
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:
# Short-Description: Preparing VM
# Description:       Preparing VM
### END INIT INFO
sleep 5
/prepare_vm.sh
insserv -r /etc/init.d/prepare_vm
rm -f /prepare_vm.sh
rm -f \$0
shutdown -h now
EOF
    chmod a+x /target/etc/init.d/prepare_vm
    chroot /target insserv /etc/init.d/prepare_vm
    ;;
esac
