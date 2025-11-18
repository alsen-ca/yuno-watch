from almalinux:9.6

RUN dnf -y update \
    && dnf -y install \
        ca-certificates \
        gnupg2 \
        curl \
        dnf-plugins-core && \
    dnf clean all

RUN dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo && \
    dnf remove podman buildah && \
    dnf -y install docker-ce docker-ce-cli docker-compose-plugin && \
    dnf clean all

ARG USERNAME=debrian
ARG UID=1000
ARG GID=1000
RUN groupadd -g ${GID} ${USERNAME} && useradd -m -u ${UID} -g ${GID} -s /bin/bash ${USERNAME}
USER ${USERNAME}

WORKDIR /debrian

CMD ["slee", "infinity"]
