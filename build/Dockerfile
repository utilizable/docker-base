############################################################
# Copyright (c) 2024 Utilizable 
# Released under the MIT license
############################################################
#
# ├─utilizable/ubuntu-fakeroot

ARG DISTRIBUTION=24.04
FROM ubuntu:${DISTRIBUTION}

# Define build-time arguments
ARG DEBIAN_FRONTEND=noninteractive
ARG DEBCONF_NOWARNINGS=yes
ARG TZ=UTC

# User argumnets
ARG USER_NAME=docker
ARG USER_UID=1001
ARG USER_PASSWORD=docker

# Group arguments
ARG GROUP_NAME=${USER_NAME}
ARG GROUP_UID=${USER_UID}

# Set environment variables for locales and timezone
ENV TZ=${TZ} \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    LANGUAGE=en_US.UTF-8

# Install required packages
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
      ssl-cert \
      sudo \
      udev \
      locales \
      apt-utils \
      tzdata && \

    # Clean up unnecessary files and set locale and timezone
    locale-gen ${LANGUAGE} && \ 
    ln -snf "/usr/share/zoneinfo/${TZ}" /etc/localtime && \
    echo "${TZ}" > /etc/timezone && \

    # Create a non-root user with sudo privileges
    groupadd -g ${GROUP_UID} ${GROUP_NAME} || \
      echo "Failed to add ${GROUP_NAME} group" && \

    useradd -m -l -s /bin/bash ${USER_NAME} -u ${USER_UID} -g ${GROUP_UID} || \
      echo "Failed to add ${USER_NAME} user" && \

    # Add fakeroot user to groups 
    usermod -aG adm,audio,cdrom,dialout,dip,fax,floppy,games,input,lp,plugdev,render,ssl-cert,sudo,tape,tty,video,voice ${USER_NAME} && \

    echo "${USER_NAME} ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    echo "${USER_NAME}:${USER_PASSWORD}" | chpasswd && \

    # Clean up unnecessary files
    apt-get clean && \ 
    rm -rf /var/lib/apt/lists/* /var/cache/debconf/* /var/log/* /tmp/* /var/tmp/* && \

USER ${USER_UID}
