FROM registry.fedoraproject.org/fedora:28

ENV LANG C.UTF-8

RUN dnf -y update && rm -rf /usr/share/doc /usr/share/man /var/cache/dnf
RUN dnf -y install java-1.8.0-openjdk-headless unzip && rm -rf /usr/share/doc /usr/share/man /var/cache/dnf

RUN mkdir /data /logs /opt/UniFi /opt/UniFi/bin && ln -s /data /opt/UniFi/data && ln -s /logs /opt/UniFi/logs

ADD https://dl.ubnt.com/unifi/5.8.24/UniFi.unix.zip /tmp/UniFi.unix.zip
ADD https://dl.ubnt.com/unifi/5.8.24/unifi_sh_api /usr/local/bin/unifi_sh_api
ADD entrypoint.sh /opt/UniFi/bin/entrypoint.sh

RUN chmod a+x /usr/local/bin/unifi_sh_api /opt/UniFi/bin/entrypoint.sh

RUN unzip /tmp/UniFi.unix.zip -d /opt

RUN rm -rf /tmp/*

VOLUME /data
VOLUME /logs

EXPOSE 1900/udp
EXPOSE 3478/udp
EXPOSE 5353/udp
EXPOSE 6789/tcp
EXPOSE 8080/tcp
EXPOSE 8443/tcp
EXPOSE 8843/tcp
EXPOSE 8880/tcp
EXPOSE 10001/udp

WORKDIR /opt/UniFi

CMD ["/opt/UniFi/bin/entrypoint.sh"]

# Local Variables:
# indent-tabs-mode: nil
# End:
