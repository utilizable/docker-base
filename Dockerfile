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
ARG TZ=UTC
ARG USER_NAME=fakeroot
ARG USER_PASSWORD=mypasswd

# Set environment variables for locales and timezone
ENV LANG="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    TZ=${TZ}

# Install required packages
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
      fakeroot \
      locales \
      ssl-cert \
      sudo \
      udev \
      tzdata && \

    # Clean up unnecessary files and set locale and timezone
    locale-gen en_US.UTF-8 && \
    ln -snf "/usr/share/zoneinfo/$TZ" /etc/localtime && \
    echo "$TZ" > /etc/timezone && \

    # Move sudo to sudo-root to restrict its use
    mv -f /usr/bin/sudo /usr/bin/sudo-root && \
    ln -snf /usr/bin/fakeroot /usr/bin/sudo  && \ 

    # Create a non-root user with sudo privileges
    groupadd -g 1001 ${USER_NAME} || \
      echo "Failed to add ${USER_NAME} group" && \

    useradd -ms /bin/bash ${USER_NAME} -u 1001 -g 1001 || \
      echo "Failed to add ${USER_NAME} user" && \

    # Add fakeroot user to groups 
    usermod -aG adm,audio,cdrom,dialout,dip,fax,floppy,games,input,lp,plugdev,render,ssl-cert,sudo,tape,tty,video,voice ${USER_NAME} && \

    echo "${USER_NAME} ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    echo "${USER_NAME}:${USER_PASSWORD}" | chpasswd && \

    # Clean up unnecessary files
    apt-get clean && \ 
    rm -rf /var/lib/apt/lists/* /var/cache/debconf/* /var/log/* /tmp/* /var/tmp/* && \

    chown -R -f --no-preserve-root ${USER_NAME}:${USER_NAME} / || \
      echo "Failed to set filesystem ownership in some paths to ${USER_NAME} user"

# Switch to non-root user and set the default shell to use fakeroot
USER 1001
SHELL ["/usr/bin/fakeroot", "--", "/bin/sh", "-o", "pipefail", "-c"]
