#!/bin/bash
#This script will delete the AWS IAM Keys and re-generate new keys.
#Author: Vinayak Gadad

echo "Enter the AWS Username :"
read USERNAME

echo "-->$USERNAME has the Below Access keys."
aws iam list-access-keys --user-name "$USERNAME"

printf "Enter the AWS AccessKeyId you want to rotate for $USERNAME User :\n"
read ACCESSKEYID

aws iam delete-access-key --access-key "$ACCESSKEYID" --user-name "$USERNAME"
printf "\nDeleted $USERNAME key $ACCESSKEYID \n"

printf "Generating new keys for $USERNAME. \n\nPlease check Desktop/AWS-IAMLegacyKeys/$USERNAME.txt file for AccessID and Secrete Key\n"
aws iam create-access-key --user-name "$USERNAME" >> ~/Desktop/AWS-IAMLegacyKeys/$USERNAME.txt
cat ~/Desktop/AWS-IAMLegacyKeys/$USERNAME.txt

