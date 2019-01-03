#=========Dockerfile begin=========
FROM ubuntu:14.04

# 签名
MAINTAINER docker <docker@163.com>
ENV REFRESHED_AT 2017-2-25
RUN apt-get -yqq update
RUN apt-get -y install mysql-server

RUN /etc/init.d/mysql start \
    && mysql -uroot -e "grant all privileges on *.* to 'root@%' identified by 'root123';"

RUN sed -Ei 's/^(bind-address|log)/#&/' /etc/mysql/my.cnf \
    && echo 'skip-host-cache\nskip-name-resolve' | awk '{ print } $1 == "[mysqld]" && c == 0 { c = 1; system("cat") }' /etc/mysql/my.cnf > /tmp/my.cnf \
    && mv /tmp/my.cnf /etc/mysql/my.cnf

# 容器开放3306端口
EXPOSE 3306
# 将数据data路径映射给宿主主机
VOLUME ["/var/lib/mysql/"]
# 设置启动容器时启动mysql
ENTRYPOINT ["/usr/bin/mysqld_safe"]
#=========Dockerfile end=========
