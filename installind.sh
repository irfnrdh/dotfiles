#!/bin/bash
# disesuaikan oleh irfnrdh dari https://gitlab.com/vay3t/hax0rpi & https://raw.githubusercontent.com/vay3t/hax0rpi/master/ubuntu-installer.sh
# Later https://github.com/thehackingsage/hackpi

export DEBIAN_FRONTEND=noninteractive

# secret directory
secret=rts
cd
mkdir $secret
cd $secret
echo -e "\n${YELLOW}[+] folder 'bukan rahasia' sudah dibuat ya${NC}"

# update system
echo -e "\n${YELLOW}[!] Kita update &d upgrade system dulu yak${NC}"
sudo apt-get update
sudo apt-get dist-upgrade -y

# install from apt-get
echo -e "\n${YELLOW}\n[!] Kita install dulu yak dengan apt-get${NC}"
sudo apt-get install -yq \
        adb \
        apache2 \
        arp-scan \
        baobab \
        curl \
        default-jdk \
        default-jre \
        dhex \
        dnsmasq \
        ettercap-text-only \
        evince \
        fastboot \
        filezilla \
        flameshot \
        git \
        hashcat \
        hexedit \
        hexyl \
        hostapd \
        hping3 \
        htop \
        iperf3 \
        iw \
        jq \
        libimage-exiftool-perl \
        libreoffice \
        libreoffice-l10n-es \
        locate \
        macchanger \
        mariadb-client \
        mariadb-server \
        mycli \
        nbtscan \
        netcat \
        netdiscover \
        neofetch \
        nmap \
        openvpn \
        php php-common php-cli php-curl php-gd php-mbstring php-xml php-zip php-mysql libapache2-mod-php \
        prips \
        proxychains4 \
        python3-dev \
        python3-pip \
        ruby-full \
        s3fs \
        screen \
        simplescreenrecorder \
        smbclient \
        snapd \
        tcpdump \
        terminator \
        tmux \
        tor \
        torsocks \
        traceroute \
        tree \
        trickle \
        p7zip-full\
        unrar-free \
        unzip \
        neovim \
        wipe \
        wireless-tools \
        wireshark-qt \
        whois \
        xclip \
        zeal;

# Install Composer 
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer

# cargo install rustcat # modern Port listener and Reverse shell
