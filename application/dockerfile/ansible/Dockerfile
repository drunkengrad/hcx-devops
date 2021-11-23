FROM quay.io/ansible/ansible-runner:stable-2.10-devel
RUN cd /tmp && \
    curl -O https://get.helm.sh/helm-v3.7.1-linux-amd64.tar.gz && \
    tar -xf helm-v3.7.1-linux-amd64.tar.gz && \
    mv linux-amd64/helm /usr/local/bin/helm && \
    chmod +x /usr/local/bin/helm
