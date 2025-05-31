#!/bin/bash

# Setting env variables for proxy
export APT_PROXY="http://squid_proxy:3128"
export http_proxy="$APT_PROXY"
export https_proxy="$APT_PROXY"

# Setup of proxy APT (file 01proxy)
echo "Acquire::http::Proxy \"$APT_PROXY\";" > /etc/apt/apt.conf.d/01proxy
echo "Acquire::https::Proxy \"$APT_PROXY\";" >> /etc/apt/apt.conf.d/01proxy

echo "Proxy settings configured:"
cat /etc/apt/apt.conf.d/01proxy

# Waiting for Squid to be ready
echo "Waiting for Squid proxy (squid_proxy:3128) to be ready..."
for i in $(seq 1 20); do
    if nc -z -w 1 squid_proxy 3128; then
        echo "Squid proxy is ready."
        break
    else
        echo "Squid not ready yet, retrying in 3 seconds..."
        sleep 3
    fi
    if [ "$i" -eq 20 ]; then
        echo "Error: Squid proxy did not become ready. Exiting."
        exit 1
    fi
done


echo "Running apt update to ensure lists are fresh via proxy..."
apt-get update -o Acquire::http::Proxy="$http_proxy" -o Acquire::https::Proxy="$https_proxy"

echo "Packages are already installed in Dockerfile. Starting SSHD..."

# Executing of main container command (SSHD)
exec /usr/sbin/sshd -D