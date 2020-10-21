FROM centos:7.8.2003
MAINTAINER Toshiaki Baba<toshiaki@netmark.jp>

RUN echo 'ZONE="Asia/Tokyo"' > /etc/sysconfig/clock \
      && echo 'UTC=false' >> /etc/sysconfig/clock \
      && yum clean all && yum -y install tzdata && yum clean all \
      && yes | cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
RUN localedef -i ja_JP -c -f UTF-8 -A /usr/share/locale/locale.alias ja_JP.UTF-8
ENV LC_ALL ja_JP.UTF-8
ENV LANG ja_JP.UTF-8

RUN yum -y install \
        epel-release \
        https://centos7.iuscommunity.org/ius-release.rpm \
        && yum clean all
RUN yum -y install \
        python3 \
        python3-pip \
        git \
        zip \
        which \
        google-noto-sans-japanese-fonts \
        && yum clean all

RUN /usr/bin/pip3.6 install --upgrade wheel setuptools
RUN /usr/bin/pip3.6 install --upgrade pipenv

ENV PIPENV_VENV_IN_PROJECT true
COPY Pipfile      /root/Pipfile
COPY Pipfile.lock /root/Pipfile.lock
RUN cd /root && pipenv --python=/usr/bin/python3.6 sync

RUN curl -sL https://rpm.nodesource.com/setup_12.x | bash - && yum -y install nodejs && yum clean all
RUN yum -y install chromium-headless gtk3 alsa-lib cups libXScrnSaver && yum -y remove chromium-headless && yum clean all
RUN mkdir -p /root/pptrhtmltopdf && cd /root/pptrhtmltopdf \
    && npm install pptrhtmltopdf \
    && ln -s /root/pptrhtmltopdf/node_modules/.bin/pptrhtmltopdf /usr/local/bin/pptrhtmltopdf

ENV PATH "/root/.venv/bin:/usr/local/bin:/usr/bin:$PATH"

COPY build.sh /root/build.sh

EXPOSE 8000

WORKDIR /mnt
CMD ["/root/build.sh"]
