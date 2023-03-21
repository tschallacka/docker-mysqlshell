FROM bitnami/minideb:latest
ARG UID=1000
ARG GID=1000
RUN groupadd -g $GID -o mysqlsh && useradd -m -u $UID -g $GID -o -s /bin/bash mysqlsh
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
COPY build/mysql-shell-8.0.32-linux-glibc2.12-x86-64bit.tar.gz /tmp/msyqlshell.tar.gz
RUN tar -xzf /tmp/msyqlshell.tar.gz -C /tmp/ && cp -R /tmp/mysql-shell-8.0.32-linux-glibc2.12-x86-64bit/* /usr/local/
COPY build/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN apt-get update && apt-get install -y \
    locales \
    && rm -rf /var/lib/apt/lists/*
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && locale-gen
RUN chmod +x /usr/local/bin/entrypoint.sh \
    && chmod +x /usr/local/bin/mysqlsh \
    && rm -rf /tmp/msyqlshell.tar.gz \
    && mkdir -p /root/.mysqlsh \
    && rm -rf /tmp/mysql-shell-8.0.32-linux-glibc2.12-x86-64bit
# create user mysqlsh and home directory /home/mysqlsh \
RUN mkdir -p /data \
    && chown -R mysqlsh:mysqlsh /data
USER mysqlsh
WORKDIR /home/mysqlsh
RUN mkdir -p /home/mysqlsh/.mysqlsh

VOLUME /data
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["--help"]
