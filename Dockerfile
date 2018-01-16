# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# docker run -it --privileged=true -m 8192m -h bootcamp1.docker centos:7 /bin/bash
FROM centos:7

ENV container docker

RUN curl http://www.apache.org/dist/bigtop/bigtop-1.1.0/repos/centos7/bigtop.repo -o /etc/yum.repos.d/bigtop.repo

RUN yum update -y ; \
    yum install openssh* wget bzip2 unzip gzip git gcc-c++ lsof \
    java-1.8.0-openjdk java-1.8.0-openjdk-devel \
    epel-release \ 
    sudo hostname -y ; \
    yum clean all; rm -rf /var/cache/yum

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
    rm -f /lib/systemd/system/multi-user.target.wants/*;\
    rm -f /etc/systemd/system/*.wants/*;\
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*;\
    rm -f /lib/systemd/system/anaconda.target.wants/*;

VOLUME [ "/sys/fs/cgroup" ]
# CMD ["/usr/sbin/init"]

# SSH service start
RUN ssh-keygen -A
RUN mkdir /var/run/sshd

# use password 'mypassword123' here
RUN echo 'root:youjumpijump' | chpasswd
# RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# SSH service end

# External Resources Start
# ADD bootcamp /bootcamp
RUN git clone https://bitbucket.org/realsunlab/bigdata-bootcamp.git /bootcamp
RUN git clone https://github.com/yuikns/bigbox-scripts.git /scripts

# External Resources End

# Python Section Start

# add miniconda
RUN wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh && chmod +x miniconda.sh && ./miniconda.sh -b -p /usr/local/conda3 && rm -rf miniconda.sh
ENV PATH /usr/local/conda3/bin:$PATH
RUN echo 'export PATH=/usr/local/conda3/bin:$PATH' >> /etc/profile.d/bigbox.sh
RUN conda install --yes numpy ipython

# Python Section End

# JAVA environment start
#ENV NOTVISIBLE "in users profile"
#RUN echo "export VISIBLE=now" >> /etc/profile.d/bigbox.sh
RUN echo "export JAVA_HOME=/usr/lib/jvm/java" >> /etc/profile.d/bigbox.sh

# JAVA environment end

# hadoop init start
RUN yum install zookeeper-server hadoop-yarn-proxyserver hadoop-hdfs-namenode hadoop-hdfs-datanode \
    hadoop-yarn-resourcemanager hadoop-mapreduce-historyserver \
    hadoop-yarn-nodemanager \
    spark-worker spark-master \
    hbase-regionserver hbase-master hbase-thrift \
    hive-metastore pig -y ; \
    yum clean all; rm -rf /var/cache/yum

# Configure Hadoop Start

ADD data/hadoop/conf /etc/hadoop/conf.docker
ADD data/hbase/conf /etc/hbase/conf.docker

RUN /scripts/hadoop.env.init.sh

# hadoop init end

# ADD scripts/config.sh /scripts/
#
# ADD scripts/env.init.sh /scripts/
#
# RUN /scripts/env.init.sh
#
# # post configure for zeppelin
# ADD data/zeppelin/conf/ /usr/local/zeppelin/conf/
#
# RUN if [ -d /usr/local/zeppelin-0.7.1-bin-netinst ]; then \
#  chown -R zeppelin:zeppelin /usr/local/zeppelin ; \
#  chown -R zeppelin:zeppelin /usr/local/zeppelin-0.7.1-bin-netinst ; fi
#
# # ENV PATH /usr/local/zeppelin/bin:$PATH
# RUN echo 'export PATH=/usr/local/zeppelin/bin:$PATH' >> /etc/profile.d/bigbox.sh

EXPOSE 9530

# /usr/bin/sudo -i -u zeppelin /usr/local/zeppelin/bin/zeppelin-daemon.sh start
# /usr/bin/sudo -i -u zeppelin /usr/local/zeppelin/bin/zeppelin-daemon.sh stop
# ADD scripts/zeppelin_serve.sh  /scripts/

# zeppelin end


# Add Tini
ENV TINI_VERSION v0.16.1
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--"]

# expose 22, and start sshd in default
EXPOSE 22
# CMD ["/usr/sbin/sshd", "-D"]
CMD ["/bin/bash"]


