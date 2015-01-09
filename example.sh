NN=10.0.1.1
RM=10.0.1.2
S1=10.0.1.3
S2=10.0.1.4
Ss=$(echo $S1,$S2)

CIDs=""

#NAMENODE
C=$(boot2docker ssh "sudo ./weave run $NN/16 -it -e "NAMENODE=$NN" -e "RESOURCEMANAGER=$RM" -e "SLAVES=$Ss" kusimari/hadoop-docker:v1 /etc/bootstrap.sh -namenode")
echo "Namenode started: $C"
CIDs=$(echo $CIDs $C)

#RESOURCEMANAGER
C=$(boot2docker ssh "sudo ./weave run $RM/16 -it -e "NAMENODE=$NN" -e "RESOURCEMANAGER=$RM" -e "SLAVES=$Ss" kusimari/hadoop-docker:v1 /etc/bootstrap.sh -resourcemanager")
echo "Resource manager started: $C"
CIDs=$(echo $CIDs $C)

#SLAVES
C=$(boot2docker ssh "sudo ./weave run $S1/16 -it -e "NAMENODE=$NN" -e "RESOURCEMANAGER=$RM" -e "SLAVES=$Ss" kusimari/hadoop-docker:v1 /etc/bootstrap.sh -slave")
echo "Slave started: $C"
CIDs=$(echo $CIDs $C)

C=$(boot2docker ssh "sudo ./weave run $S2/16 -it -e "NAMENODE=$NN" -e "RESOURCEMANAGER=$RM" -e "SLAVES=$Ss" kusimari/hadoop-docker:v1 /etc/bootstrap.sh -slave")
echo "Slave started: $C"
CIDs=$(echo $CIDs $C)

#DONE
echo "Exporting YARN_CONTAINERS: $CIDs"
export YARN_CONTAINERS=$CIDs


#INITIALIZE
# docker attach $(boot2docker ssh "sudo ./weave run 10.0.1.50/16 -it -e "NAMENODE=10.0.1.1" -e "RESOURCEMANAGER=10.0.1.2" kusimari/hadoop-docker:v1 /etc/bootstrap.sh -init")

#CLIENT NODE
# docker attach $(boot2docker ssh "sudo ./weave run 10.0.1.50/16 -it -e "NAMENODE=10.0.1.1" -e "RESOURCEMANAGER=10.0.1.2" kusimari/hadoop-docker:v1 /etc/bootstrap.sh -client")

#IPYTHON SPARK NODE
# TODO:
