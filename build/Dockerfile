############################################################
# Copyright (c) 2024 Utilizable 
# Released under the MIT license
############################################################
#
# ├─utilizable/ubuntu-base

ARG DISTRIBUTION=24.04
FROM ubuntu:${DISTRIBUTION}

# Define build-time arguments
ARG DEBIAN_FRONTEND=noninteractive \
    TZ=UTC \
    USER_NAME=ubuntu \
    USER_PASSWORD=mypasswd \
    USER_UID=1000

# Set environment variables for locales and timezone
ENV LANG="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    TZ=${TZ}

# Use root to install dependencies
USER 0

RUN \
    echo "**** Update & Dependencies ****" \
        && apt-get update \
        && apt-get install --no-install-recommends -y \
           apt-utils \
           locales \
           ssl-cert \
           sudo \
           udev \
           tzdata \
    && \
    echo "**** Set locale and timezone ****" \ 
        && locale-gen en_US.UTF-8 \
        && ln -snf "/usr/share/zoneinfo/$TZ" /etc/localtime \
        && echo "$TZ" > /etc/timezone \
    && \
    echo "**** Create a non-root user with sudo privileges ****" \     
        && groupadd -g ${USER_UID} ${USER_NAME} \
        && useradd -m -l -s /bin/bash -u ${USER_UID} -g ${USER_UID} ${USER_NAME} \
        && usermod -aG sudo ${USER_NAME} \
        && echo "${USER_NAME} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
        && echo "${USER_NAME}:${USER_PASSWORD}" | chpasswd \
    && \
    echo "**** C# Clean up unnecessary files ****" \   
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/* \
                  /var/cache/debconf/* \
                  /var/log/* \
                  /tmp/* \
                  /var/tmp/*

# Switch to non-root user
USER ${USER_NAME}

# Set bash shell as default
SHELL ["/usr/bin/sudo", "--", "/bin/bash", "-c"]
