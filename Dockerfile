FROM ghcr.io/netmarkjp/pptrhtmltopdf:latest
LABEL author="Toshiaki Baba<toshiaki@netmark.jp>"

RUN apt-get -y  -qq update \
        && apt-get -y install locales tzdata curl \
        && apt-get -y clean \
        && rm -rf /var/lib/apt/lists/*
RUN localedef -i ja_JP -c -f UTF-8 -A /usr/share/locale/locale.alias ja_JP.UTF-8
ENV LANG ja_JP.UTF-8
RUN cp -f /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

RUN apt-get update && apt-get install -y \
        python3-pip \
        pipenv \
        zip \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*

ENV PIPENV_VENV_IN_PROJECT true
COPY Pipfile      /root/Pipfile
COPY Pipfile.lock /root/Pipfile.lock
RUN cd /root && pipenv --python=/usr/bin/python3 sync

ENV PATH "/root/.venv/bin:/usr/local/bin:/usr/bin:$PATH"

COPY build.sh /root/build.sh

EXPOSE 8000

WORKDIR /mnt
ENTRYPOINT ["/root/build.sh"]
