# Creates distributed hadoop 2.6.0

FROM buildpack-deps:wheezy
MAINTAINER kusimari


# JDK 7 http://www.webupd8.org/2012/06/how-to-install-oracle-java-7-in-debian.html ####
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu precise main" | tee /etc/apt/sources.list.d/webupd8team-java.list \
    && echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu precise main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list \
    && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886 \
    && apt-get update \
    && echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections \
    && apt-get install -y oracle-java7-installer

ENV JAVA_HOME /usr/lib/jvm/java-7-oracle/
ENV PATH $JAVA_HOME/bin:$PATH


# passwordless ssh #####################################################################
RUN ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key
RUN ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN ssh-keygen -q -N "" -t rsa -f /root/.ssh/id_rsa
RUN cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys


# hadoop ###############################################################################
RUN curl -s http://mirrors.ibiblio.org/apache/hadoop/common/hadoop-2.6.0/hadoop-2.6.0.tar.gz | tar -xz -C /opt/
RUN ln -s /opt/hadoop-2.6.0 /opt/hadoop

RUN apt-get install -y procps

ENV HADOOP_PREFIX /opt/hadoop
ENV HADOOP_COMMON_HOME /opt/hadoop
ENV HADOOP_HDFS_HOME /opt/hadoop
ENV HADOOP_MAPRED_HOME /opt/hadoop
ENV HADOOP_YARN_HOME /opt/hadoop
ENV HADOOP_CONF_DIR /opt/hadoop/etc/hadoop
ENV YARN_CONF_DIR $HADOOP_PREFIX/etc/hadoop

ADD hdfs-site.xml $HADOOP_CONF_DIR/hdfs-site.xml
ADD mapred-site.xml $HADOOP_CONF_DIR/mapred-site.xml

  # files which are sed/tr'ed in bootstrap.sh
ADD core-site.xml $HADOOP_CONF_DIR/core-site.xml.template
ADD yarn-site.xml $HADOOP_CONF_DIR/yarn-site.xml.template
ADD slaves $HADOOP_CONF_DIR/slaves


# launch script ##########################################################################
ADD bootstrap.sh /etc/bootstrap.sh
RUN chown root:root /etc/bootstrap.sh
RUN chmod 700 /etc/bootstrap.sh


# start based on type of node ############################################################
CMD ["/etc/bootstrap.sh"]

