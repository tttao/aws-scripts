#!/bin/bash

HEADER='"Resource ARN","Service","Region","Tags"'
REGIONS=`aws ec2 describe-regions \
         --query "Regions[].{Name:RegionName}" \
         --output text`

if [ $? -ne 0 ]; then
    echo "ERROR: aws ec2 describe-regions"
    exit -1
fi

echo $HEADER

for REGION in $REGIONS; do
    aws resourcegroupstaggingapi get-resources --region $REGION | jq -r '.ResourceTagMappingList[] | [.ResourceARN, (.ResourceARN | split(":"))[2], (.ResourceARN | split(":"))[3],((.Tags | map([.Key, .Value] | join("="))) | join(","))] | @csv'

    if [ $? -ne 0 ]; then
    echo "ERROR: aws resourcegroupstaggingapi get-resources"
    exit -1
fi
done;