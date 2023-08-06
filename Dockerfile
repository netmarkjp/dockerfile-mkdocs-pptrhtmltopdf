FROM ghcr.io/netmarkjp/pptrhtmltopdf:latest
LABEL author="Toshiaki Baba<toshiaki@netmark.jp>"

USER root
RUN apt-get -y -qq update \
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
        sudo \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*
RUN chmod 777 /mnt

# # $(id -nu 1000) == "node"
# RUN groupadd --gid 1000 myuser
# RUN useradd --create-home --uid 1000 --gid 1000 myuser
RUN echo "node ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers.d/user1000
RUN install -d -o $(id -nu 1000) -g $(id -ng 1000) -m 0775 /opt/mkdocs-pptrhtmltopdf

USER node
WORKDIR /opt/mkdocs-pptrhtmltopdf
ENV PIPENV_VENV_IN_PROJECT true

COPY Pipfile      Pipfile
COPY Pipfile.lock Pipfile.lock
RUN pipenv --python=/usr/bin/python3 sync

ENV PATH "/opt/mkdocs-pptrhtmltopdf/.venv/bin:/usr/local/bin:/usr/bin:$PATH"

COPY build.sh build.sh

EXPOSE 8000

WORKDIR /mnt
ENTRYPOINT ["/opt/mkdocs-pptrhtmltopdf/build.sh"]
