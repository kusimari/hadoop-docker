NN=10.0.1.1
RM=10.0.1.2
S1=10.0.1.3
S2=10.0.1.4
S3=10.0.1.5
CLIENT=10.0.1.6
Ss=$(echo $S1,$S2,$S3)

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

C=$(boot2docker ssh "sudo ./weave run $S3/16 -it -e "NAMENODE=$NN" -e "RESOURCEMANAGER=$RM" -e "SLAVES=$Ss" kusimari/hadoop-docker:v1 /etc/bootstrap.sh -slave")
echo "Slave started: $C"
CIDs=$(echo $CIDs $C)

echo "All YARN Containers: $CIDs"

#CLIENT NODE
C=$(boot2docker ssh "sudo ./weave run $CLIENT/16 -it -e "NAMENODE=$NN" -e "RESOURCEMANAGER=$RM" -e "SLAVES=$Ss" kusimari/hadoop-docker:v1 /etc/bootstrap.sh -dummy")
echo "Client Container: $C"


