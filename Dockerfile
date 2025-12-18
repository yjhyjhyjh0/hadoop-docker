FROM apache/hadoop:3.4.0

USER root

# ----------------------------------------------------
# Fix CentOS 7 EOL yum repositories (REQUIRED)
# Otherwise default repo result in 404
# ----------------------------------------------------
RUN sed -i \
    -e 's|^mirrorlist=|#mirrorlist=|g' \
    -e 's|^#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' \
    /etc/yum.repos.d/CentOS-Base.repo


# -------------------------
# Install SSH (required by start-dfs.sh)
# -------------------------
RUN yum install -y openssh-server openssh-clients \
 && ssh-keygen -A 

# -------------------------
# Install jdk for hadoop cluster
# -------------------------
RUN yum install -y java-1.8.0-openjdk-devel.x86_64


# -------------------------
# Setup user home directories
# -------------------------
RUN mkdir /home/hadoop
RUN usermod -d /home/hadoop hadoop
RUN chown -R hadoop:users /home/hadoop

USER hadoop

# -------------------------
# Setup ssh
# -------------------------
RUN mkdir -p /home/hadoop/.ssh \
 && chmod 700 /home/hadoop/.ssh \
 && ssh-keygen -t rsa -P "" -f /home/hadoop/.ssh/id_rsa \
 && cat /home/hadoop/.ssh/id_rsa.pub >> /home/hadoop/.ssh/authorized_keys \
 && chmod 600 /home/hadoop/.ssh/authorized_keys


# -------------------------
# Hadoop data directories
# -------------------------
RUN mkdir -p /opt/hadoop/data/namenode \
             /opt/hadoop/data/datanode

# -------------------------
# Hadoop configuration
# -------------------------
COPY --chown=hadoop conf/core-site.xml /opt/hadoop/etc/hadoop/core-site.xml
COPY --chown=hadoop conf/hdfs-site.xml /opt/hadoop/etc/hadoop/hdfs-site.xml
COPY --chown=hadoop conf/hadoop-env.sh /opt/hadoop/etc/hadoop/hadoop-env.sh

# -------------------------
# Environment
# -------------------------
ENV HADOOP_HOME=/opt/hadoop
WORKDIR /opt/hadoop

# -------------------------
# Expose NameNode UI & HDFS
# -------------------------
EXPOSE 9870 9000

# Keep container alive when running interactively
CMD ["/bin/bash"]
