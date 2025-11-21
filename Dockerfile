FROM almalinux:9.6

RUN dnf -y update \
    && dnf -y install \
        sudo \
        shadow-utils \
        dnf-plugins-core \
        which \
        git && \
    dnf clean all && \
    rm -rf /var/cache/dnf

ARG USERNAME=debrian
ARG UID=1000
ARG GID=1000


RUN groupadd -g ${GID} ${USERNAME} && \
    useradd -m -u ${UID} -g ${GID} -s /bin/bash ${USERNAME} && \
    usermod -aG wheel ${USERNAME} && \
    mkdir -p /etc/sudoers.d && \
    echo "%wheel ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/wheel && \
    chmod 0440 /etc/sudoers.d/wheel


WORKDIR /home/debrian/Downloads
RUN git clone https://github.com/bats-core/bats-core.git

WORKDIR /home/debrian
COPY entrypoint.sh /home/debrian/entrypoint.sh
RUN chmod +x /home/debrian/entrypoint.sh

USER ${USERNAME}
ENTRYPOINT ["/home/debrian/entrypoint.sh"]
