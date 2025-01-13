#!/bin/bash

# Determine the currently logged-in user
CURRENT_USER=$(whoami)

# Set the Router IP address
ROUTER_IP="192.168.9.1"

# Check if the ROUTER_IP is set to the default value
if [ "$ROUTER_IP" == "192.168.9.1" ]; then
    read -p "192.168.9.1 the correct Router IP? (Y/n): " correct_ip

    if [[ ! $correct_ip =~ ^[Yy]$ ]]; then
        echo "Please update the script with the correct Router_IP variable and run it again."
        exit 1
    fi
fi


# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed."
    exit 1
fi


# Clone the repository
git clone https://github.com/ficapy/Openwrt-Monitoring.git
# Cleaning up files that are not needed on the docker server
rm -r ./Openwrt-Monitoring/Python
rm -r ./Openwrt-Monitoring/Router
rm -r ./Openwrt-Monitoring/screenshots
rm ./Openwrt-Monitoring/serverSetup.sh
rm ./Openwrt-Monitoring/routersetup.sh
rm ./Openwrt-Monitoring/README.md

cd ./Openwrt-Monitoring/Docker
# Replace the Router IP in prometheus.yml
sed -i "s/10.0.5.1/$ROUTER_IP/g" prometheus.yml

# Replace the Router IP in netify-log.sh
sed -i "s/10.0.5.1/$ROUTER_IP/g" netify-log.sh

# Make netify-log.sh executable
sudo chmod +x netify-log.sh

# Create a Crontab entry as root
sudo bash -c "echo '*/1 * * * * /home/$CURRENT_USER/Openwrt-Monitoring/Docker/netify-log.sh >> /var/log/crontab.netify.txt 2>&1' > /etc/cron.d/netify-log-cronjob"


# Do you want to start the Docker containers
read -p "Do you want to start the Docker containers? (Y/n): " start_docker

if [[ $start_docker =~ ^[Yy]$ ]]; then
    # Do you want to install AdGuard Home
    read -p "Do you want to install AdGuard Home? (Y/n): " install_adguard

    if [[ $install_adguard =~ ^[Yy]$ ]]; then
        # Start AdGuard Home using a different Docker Compose file (docker-compose-extras.yml)
        sudo docker-compose -f docker-compose-extras.yml up -d
    else
        # Start the Docker containers using the default Compose file
        sudo docker-compose up -d
    fi
else
    echo "Docker containers not started."
fi

echo "Script Completed"
