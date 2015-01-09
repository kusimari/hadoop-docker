#!/bin/bash

#${HADOOP_PREFIX:=/usr/local/hadoop}

#$HADOOP_PREFIX/etc/hadoop/hadoop-env.sh

#rm /tmp/*.pid

# installing libraries if any - (resource urls added comma separated to the ACP system variable)
#cd $HADOOP_PREFIX/share/hadoop/common ; for cp in ${ACP//,/ }; do  echo == $cp; curl -LO $cp ; done; cd -

# altering the core-site configuration
#sed s/HOSTNAME/$HOSTNAME/ /usr/local/hadoop/etc/hadoop/core-site.xml.template > /usr/local/hadoop/etc/hadoop/core-site.xml


#service sshd start
#$HADOOP_PREFIX/sbin/start-dfs.sh
#$HADOOP_PREFIX/sbin/start-yarn.sh

#if [[ $1 == "-d" ]]; then
#  while true; do sleep 1000; done
#fi

#if [[ $1 == "-bash" ]]; then

# format and start namenode

sed s/HOSTNAME/$NAMENODE/ $HADOOP_CONF_DIR/core-site.xml.template > $HADOOP_CONF_DIR/core-site.xml;
sed s/HOSTNAME/$RESOURCEMANAGER/ $HADOOP_CONF_DIR/yarn-site.xml.template > $HADOOP_CONF_DIR/yarn-site.xml;
echo $SLAVES | tr "," "\n" >> $HADOOP_CONF_DIR/slaves


if [[ $1 == "-namenode" ]]; then
    #DO ONLY IF STARTING FROM SCRATCH
    $HADOOP_PREFIX/bin/hdfs namenode -format;
    $HADOOP_PREFIX/sbin/hadoop-daemon.sh --config $HADOOP_CONF_DIR --script hdfs start namenode;
fi


if [[ $1 == "-resourcemanager" ]]; then
    $HADOOP_PREFIX/sbin/hadoop-daemon.sh --config $HADOOP_CONF_DIR --script hdfs start resourcemanager;
fi


if [[ $1 == "-slave" ]]; then
    $HADOOP_PREFIX/sbin/hadoop-daemon.sh --config $HADOOP_CONF_DIR --script hdfs start datanode;
    $HADOOP_PREFIX/sbin/hadoop-daemon.sh --config $HADOOP_CONF_DIR --script hdfs start nodemanager;
fi


if [[ $1 == "-init" ]]; then
    $HADOOP_PREFIX/bin/hdfs dfs -mkdir /user;
    $HADOOP_PREFIX/bin/hdfs dfs -mkdir /user/spark;
fi


if [[ $1 == "-client" ]]; then
    echo "Dummy test node";
fi

/bin/bash
