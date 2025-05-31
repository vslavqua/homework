
FROM --platform=linux/amd64 debian:bullseye

RUN apt-get update && \
    apt-get install -y --no-install-recommends openssh-server sudo iproute2 iputils-ping vim curl netcat python3 ca-certificates gnupg software-properties-common lsb-release && \
    mkdir -p /var/run/sshd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    echo "root:root" | chpasswd && \
    rm -rf /var/lib/apt/lists/*

# To copy script to entrypoint
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 22
CMD ["/usr/local/bin/entrypoint.sh"]