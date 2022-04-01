FROM jupyter/minimal-notebook as base

USER root

# Provide password-less sudo to NB_USER
RUN sed -i /etc/sudoers -re 's/^%sudo.*/%sudo ALL=(ALL:ALL) NOPASSWD: ALL/g' && \
    sed -i /etc/sudoers -re 's/^root.*/root ALL=(ALL:ALL) NOPASSWD: ALL/g' && \
    sed -i /etc/sudoers -re 's/^#includedir.*/## **Removed the include directive** ##"/g' && \
    echo "${NB_USER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    chmod g+w /etc/passwd

RUN apt-get update && \
    apt-get install -y gcc

ARG GOLANG_VERSION=1.18
RUN wget https://go.dev/dl/go${GOLANG_VERSION}.linux-amd64.tar.gz && \
    rm -rf /usr/local/go && tar -C /usr/local -xzf go${GOLANG_VERSION}.linux-amd64.tar.gz && \
    rm go${GOLANG_VERSION}.linux-amd64.tar.gz

USER $NB_UID
ENV PATH $PATH:/usr/local/go/bin
ARG GOPHERNOTES_VERSION=0.7.4
RUN go install github.com/gopherdata/gophernotes@v${GOPHERNOTES_VERSION} && \
    mkdir -p ~/.local/share/jupyter/kernels/gophernotes && \
    cp -r ~/go/pkg/mod/github.com/gopherdata/gophernotes@v${GOPHERNOTES_VERSION}/kernel/* ~/.local/share/jupyter/kernels/gophernotes && \
    sudo cp ~/go/bin/gophernotes /usr/local/bin

EXPOSE 8888
CMD [ "jupyter", "notebook" ]