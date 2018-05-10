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
    && ln -s /usr/local/fido/etc/config /usr/local/etc/fido/config

COPY ./samples/binkd/binkd.conf /usr/local/etc/binkd.conf
ADD ./wfido/deploy.sh /root/devel/deploy.sh
    
CMD ["/usr/local/sbin/binkd", "/usr/local/etc/binkd.conf", "-C" ]

EXPOSE 24554
