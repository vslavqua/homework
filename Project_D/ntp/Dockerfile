
FROM --platform=linux/amd64 debian:bullseye
ARG DC_NAME

RUN apt-get update && \
    apt-get install -y chrony python3 && \
    apt-get clean

COPY chrony-${DC_NAME}.conf /etc/chrony/chrony.conf

CMD ["chronyd", "-d"]