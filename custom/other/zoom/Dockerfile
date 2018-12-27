FROM fedora:29
RUN \
    dnf update --assumeyes && \
    dnf install --assumeyes wget && \
    dnf groupinstall --assumeyes "Fedora Workstation" && \
    cd /tmp && \
    wget https://zoom.us/client/latest/zoom_x86_64.rpm && \
    dnf install --assumeyes /tmp/zoom_x86_64.rpm && \
    rm --force /tmp/zoom_x86_64.rpm && \
    adduser user && \
    dnf clean all && \
    true
USER user
WORKDIR /home/user
ENTRYPOINT [ "bash" ]
CMD []