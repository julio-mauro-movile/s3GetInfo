#!/bin/bash
# get all S3 buckets size and total objects


while getopts p:b: flag
do
    case "${flag}" in
        p) PROFILE=${OPTARG};;
        b) BUCKETS=${OPTARG};;
    esac
done

if [ -z "$PROFILE" ]
    then
        echo ""
        echo "AWS profile supplied. 
        
Example: 
        
        s3GetInfo.sh -p PROFILE-NAME 
        
Use 'default' if you don't have more than one profile in the ..aws/credentials file.
        "
        exit
fi
if [ -z "$BUCKETS" ]
    then
        echo ""
        echo ""
        echo "Getting information from all buckets. To get information to a specific bucket use '-b BUCKET_NAME'"
        for i in {15..01}
            do
                tput cup 10 $l
                echo -n "Starting in $i seconds. 

Press CONTROL + C to cancel..."
                sleep 1
            done
        BUCKETS=`aws --profile ${PROFILE} s3 ls | awk {'print $3'}`
fi
clear
echo "Please wait... creating s3GetInfo.csv file"
echo ""

echo "BUCKET,TOTAL OBJECTS,TOTAL SIZE
---------------------------------------------,-------------,----------" > exit_file

for S3B in $BUCKETS
do
    echo "${S3B},`aws --profile capacity_infra s3 ls  --summarize --human-readable --recursive s3://${S3B} | tail -n 2  | tr '\n' ' ' | awk {'print $3","$6" "$7'}`" >> exit_file
done
column -t -s, exit_file
mv exit_file s3GetInfo.csv
