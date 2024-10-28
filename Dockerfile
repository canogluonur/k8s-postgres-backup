FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y \
        python3 \
        python3-pip \
        curl \
        openssh-server \
        gnupg2 \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/run/sshd \
    && echo 'root:password' | chpasswd \
    && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && apt-get update \
    && apt-get install -y unzip \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm -rf awscliv2.zip aws \
    && rm -rf /var/lib/apt/lists/* \
    && echo 'complete -C /usr/local/bin/aws_completer aws' >> ~/.bashrc

RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt focal-pgdg main" > /etc/apt/sources.list.d/pgdg.list' \
    && curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
    && apt-get update \
    && apt-get install -y postgresql-14 \
    && rm -rf /var/lib/apt/lists/*

COPY . /home/root/

EXPOSE 22 5432

RUN echo '#!/bin/bash\nservice postgresql start\n/usr/sbin/sshd -D' > /start.sh \
    && chmod +x /start.sh

CMD ["/start.sh"]
