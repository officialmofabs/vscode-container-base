FROM ubuntu:22.10
#FROM debian:12

LABEL org.opencontainers.image.source https://github.com/officialmofabs/vscode-container-base
ARG USERNAME=mosgarage
ARG USER_UID=1000
ARG USER_GID=1000
ARG LANG=en_US.UTF-8
ARG LANGUAGE=en_US.UTF-8
ARG LC_ALL=en_US.UTF-8

# Enable systemd
ENV container docker
STOPSIGNAL SIGRTMIN+3

# Install systemd and other dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    systemd systemd-sysv && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Prevent some systemd units from starting (optional)
RUN systemctl mask \
    dev-hugepages.mount \
    dev-mqueue.mount \
    sys-fs-fuse-connections.mount \
    systemd-remount-fs.service \
    sys-kernel-config.mount \
    sys-kernel-debug.mount \
    systemd-logind.service \
    systemd-journald.service \
    systemd-udevd.service \
    systemd-udevd-control.socket \
    systemd-udevd-kernel.socket

# Cleanup unnecessary files (optional)
RUN rm -f /lib/systemd/system/multi-user.target.wants/* && \
    rm -f /lib/systemd/system/sockets.target.wants/*udev* && \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl* && \
    rm -f /lib/systemd/system/basic.target.wants/* && \
    rm -f /lib/systemd/system/anaconda.target.wants/*

# Set the default command for the container
CMD ["/lib/systemd/systemd"]