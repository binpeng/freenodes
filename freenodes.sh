#!/bin/bash

freenodes=`pbsnodes -l free |awk '{print $1}'`

queueHigh=`qmgr -c "print queue high" | awk -F '=' '/acl_hosts/ {print $2}'`
queueBL=`qmgr -c "print queue bl64Grack128G" | awk -F '=' '/acl_hosts/ {print $2}'`
queueNew=`qmgr -c "print queue new" | awk -F '=' '/acl_hosts/ {print $2}'`

queueHigh=`echo $queueHigh | sed 's/ /,/g'`
queueHigh=$queueHigh,

queueBL=`echo $queueBL | sed 's/ /,/g'`
queueBL=$queueBL,


queueNew=`echo $queueNew | sed 's/ /,/g'`
queueNew=$queueNew,

printf '%s \t %s \t\t %s \t %s \n' 'Queue' 'Node' 'CPUs' 'Free CPUs'
for node in $freenodes
do
   NP=`pbsnodes $node | awk '/np =/ {print $3 }'`
   FREENP=`pbsnodes $node | awk -F ',' '/jobs =/ { print NF }'`

   QUEUE='?'

   if [[ "${queueBL}" == *$node,* ]]
   then
     QUEUE="B"
   fi

   if [[ "${queueHigh}" == *$node,* ]]
   then
     QUEUE="H"
   fi

   if [[ "${queueNew}" == *$node,* ]]
   then
     QUEUE="N"
   fi


   if [ -z "$FREENP" ]
   then
     printf '%s \t %s \t %d \t %d\n' $QUEUE'*' $node  $NP  $NP
   else
     let FREENP=NP-FREENP
     printf '%s \t %s \t %d \t %d\n' $QUEUE $node  $NP  $FREENP
   fi
done


