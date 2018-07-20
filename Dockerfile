FROM ubuntu:16.04

MAINTAINER Leo Unbekandt <leo@scalingo.com>

RUN adduser --system --home /var/lib/munin --shell /bin/false --uid 1103 --group munin

RUN apt-get update -qq && RUNLEVEL=1 DEBIAN_FRONTEND=noninteractive \
    apt-get install -y -qq cron munin munin-node nginx apache2-utils wget heirloom-mailx patch telnet
RUN rm /etc/nginx/sites-enabled/default && mkdir -p /var/cache/munin/www && chown munin:munin /var/cache/munin/www && mkdir -p /var/run/munin && chown -R munin:munin /var/run/munin

VOLUME /var/lib/munin
VOLUME /var/log/munin

ADD ./conf/munin.conf /etc/munin/munin.conf
ADD ./conf/nginx-munin /etc/nginx/sites-enabled/munin
ADD ./conf/start-munin.sh /munin
ADD ./conf/munin-graph-logging.patch /usr/share/munin
ADD ./conf/munin-update-logging.patch /usr/share/munin

RUN cd /usr/share/munin && patch munin-graph < munin-graph-logging.patch && patch munin-update < munin-update-logging.patch

EXPOSE 8080
CMD ["/etc/init.d/munin-node", "start"]
CMD ["bash", "/munin"]
