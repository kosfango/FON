FROM centos:latest

MAINTAINER Sergey Anokhin 2:5034/10.1

RUN cd /tmp && rpm -Uvh http://dl.fedoraproject.org/pub/epel/7/x86_64/Packages/e/epel-release-7-11.noarch.rpm \
    && rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm \
    && rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm \
    && yum upgrade -y \
    && yum groupinstall "Development Tools" -y \
    && yum install perl-ExtUtils-Embed.noarch -y

RUN mkdir -p /root/devel/husky \
    && cd /root/devel/husky \
    && git clone https://github.com/huskyproject/smapi.git \
    && git clone https://github.com/huskyproject/hpt.git \
    && git clone https://github.com/huskyproject/huskylib.git \
    && git clone https://github.com/huskyproject/huskybse.git \
    && git clone https://github.com/huskyproject/htick.git \
    && git clone https://github.com/huskyproject/fidoconf.git \
    && git clone https://github.com/huskyproject/areafix.git \
    && cp huskybse/huskymak.cfg ./huskymak.cfg \
    && sed -i 's/PERL=0/PERL=1/g' ./huskymak.cfg \
    && cd  ./huskylib && gmake && gmake install && gmake install-man \
    && cd ../smapi/ && gmake && gmake install \
    && cd ../fidoconf && gmake && gmake install && gmake install-man \
    && cd ../areafix && gmake && gmake install \
    && cd ../hpt && gmake && gmake install \
    && cd ../htick && gmake && gmake install && cd ./doc && make install \
    && echo "/usr/local/lib" > /etc/ld.so.conf.d/fido.conf && ldconfig \
    && cd /root/devel && git clone https://github.com/pgul/binkd.git \
    && cd ./binkd && cp mkfls/unix/* . && sh ./configure && make && make install \
    && mkdir -p /usr/local/fido/etc && mkdir /usr/local/etc/fido \
    && ln -s /usr/local/fido/etc/config /usr/local/etc/fido/config \

# Start WFIDO deployment
########################################################################################
    && cd /root/devel \
    && git clone https://github.com/kosfango/wfido.git \
    ###dirty
    && mkdir -p /usr/local/fido/lib/ \
    ###
    && echo $'[mariadb] \n\
name = MariaDB \n\
baseurl = http://yum.mariadb.org/10.2/centos7-amd64 \n\
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB \n\
gpgcheck=1' > /etc/yum.repos.d/mariadb.repo \
    && yum update -y && yum install MariaDB-client perl-Digest-MD5 perl-DBD-MySQL perl-Test-Simple.noarch -y \
    && cd /root/devel/wfido/dependencies \
    && tar -xvzf /root/devel/wfido/dependencies/FTN-Pkt-1.02.tar.gz \
    && cd /root/devel/wfido/dependencies/FTN-Pkt-1.02 \
    && perl Makefile.PL && make && make test && make install \
    && sed -i 's/require Exporter;/use Exporter;/g' /usr/local/share/perl5/FTN/Pkt.pm \
    && mkdir -p /usr/local/fido/var/xml/archive \
    && mkdir -p /var/www/vhosts/wfido && useradd nginx \
    ###dirty
    && mkdir -p /usr/local/fido/log/ \
    && mkdir -p /usr/local/fido/outbound \
    && mkdir -p /usr/local/fido/inbound \
    && mkdir -p /usr/local/fido/insecure \
    && mkdir -p /usr/local/fido/tmp/in 
    ###
# End WFIDO deployment
#########################################################################################

COPY ./samples/binkd/binkd.conf /usr/local/etc/binkd.conf
CMD ["/usr/local/sbin/binkd", "/usr/local/etc/binkd.conf", "-C" ]

EXPOSE 24554
