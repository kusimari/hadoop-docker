NN=10.0.1.1
RM=10.0.1.2
S1=10.0.1.3
S2=10.0.1.4
Ss=$(echo $S1,$S2)

IMAGE="kusimari/hadoop-docker:2.6.0-alpha"

if [[ $1 == "-namenode" ]]; then
    HOSTNAME=$NN;
    CMD=$1
fi
if [[ $1 == "-resourcemanager" ]]; then
    HOSTNAME=$RM
    CMD=$1
fi
if [[ $1 == "-slave1" ]]; then
    HOSTNAME=$S1
    CMD="-slave"
fi
if [[ $1 == "-slave2" ]]; then
    HOSTNAME=$S2
    CMD="-slave"
fi
if [[ $1 == "-init" ]]; then
    HOSTNAME=10.0.1.50
    CMD="-init"
fi
if [[ $1 == "-client" ]]; then
    HOSTNAME=10.0.1.51
    CMD="-client"
fi


#sudo weave run $HOSTNAME/16 -it -h=$HOSTNAME -e NAMENODE=$NN -e RESOURCEMANAGER=$RM  -e SLAVES=$Ss $IMAGE /etc/bootstrap.sh $CMD

sudo weave run $HOSTNAME/16 -it -e NAMENODE=$NN -e RESOURCEMANAGER=$RM  -e SLAVES=$Ss $IMAGE /etc/bootstrap.sh $CMD
