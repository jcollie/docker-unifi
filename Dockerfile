FROM registry.fedoraproject.org/fedora:26

ENV LANG C.UTF-8

RUN mkdir /data /logs /opt/UniFi
RUN ln -s /data /opt/UniFi/data
RUN ln -s /logs /opt/UniFi/logs

RUN dnf -y update && \
    dnf -y install java-1.8.0-openjdk-headless mongodb-server unzip && \
    rm -rf /var/cache/dnf

ADD https://www.ubnt.com/downloads/unifi/5.6.7-63ab9a7965/UniFi.unix.zip /tmp/UniFi.unix.zip
ADD https://www.ubnt.com/downloads/unifi/5.6.7-63ab9a7965/unifi_sh_api /usr/local/bin/unifi_sh_api

RUN chmod a+x /usr/local/bin/unifi_sh_api

RUN unzip /tmp/UniFi.unix.zip -d /opt

RUN rm -rf /tmp/*

VOLUME /data
VOLUME /logs

EXPOSE 6789/tcp
EXPOSE 8080/tcp
EXPOSE 8443/tcp
EXPOSE 8880/tcp
EXPOSE 8843/tcp
EXPOSE 3478/udp
EXPOSE 10001/udp

WORKDIR /opt/UniFi

CMD ["java", "-jar", "lib/ace.jar", "start"]

# Local Variables:
# indent-tabs-mode: nil
# End:
