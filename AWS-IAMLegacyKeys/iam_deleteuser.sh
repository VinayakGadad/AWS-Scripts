#!/usr/bin/env bash
# Author Vinayak Gadad
# Unlike AWS console, you cant delete the user via CLI using the single command, you need to remove all the policies. access keys and groups from users profile.
# Run it as ./iam_deleteuser  username profilename
# 02/01/2019

if [ "$1" == "-help" ] || [ "$1" == "-h" ]; then
  echo "Run it as ./iam_deleteuser username profilename"
  echo "Check for .aws/credentils for profile name."
  exit 1
fi

if [[ -z "$1" ]]; then
   echo "Username not mentioned, retry again"
   exit 1
fi

if [[ -z "$2" ]]; then
   echo "Profile not mentioned, check the profile name in ~/.aws/credentials file"
   exit 1
fi

user_name=$1
profile=$2

keysdel(){
printf "\nDeleting Access Key for $user_name\n"
for keys in $(aws iam list-access-keys --user-name ${user_name} --profile $profile | jq -r '.AccessKeyMetadata[] | .AccessKeyId' ); do
    printf "--> $keys will be deleted."
    aws iam delete-access-key --access-key-id $keys --user-name ${user_name} --profile $profile
done
}

certsdel(){
printf "\nDeleting Signing Certificates for $user_name\n"
if (( $(aws iam list-signing-certificates --user-name ${user_name} --profile $profile | jq -r '.Certificates[] | .CertificateId' | wc -l) > 0 )); then
    for cert in $(aws iam list-signing-certificates --user-name ${user_name} --profile $profile | jq -r '.Certificates[] | .CertificateId'); do
        aws iam delete-signing-certificate --user-name ${user_name}  --certificate-id $cert --profile $profile
    done
fi
}

loginporfile(){
printf "\nDeleting Login Profile for $user_name\n"
if $(aws iam get-login-profile --user-name ${user_name} --profile $profile  &>/dev/null); then
    aws iam  delete-login-profile --user-name ${user_name} --profile $profile
fi
}

mfadel(){
printf "\nDeleting MFA Devices associated with user $user_name\n"
if (( $(aws iam list-mfa-devices --user-name ${user_name} --profile $profile | jq -r '.MFADevices[] | .SerialNumber' | wc -l) > 0 )); then
    for mfa_dev in $(aws iam list-mfa-devices --user-name ${user_name} --profile $profile | jq -r '.MFADevices[] | .SerialNumber'); do
        aws iam deactivate-mfa-device --user-name ${user_name}  --serial-number $mfa_dev
    done
fi
}

removepolicy(){
printf "\nRemoving attached Policies for the user $user_name\n"
aws iam list-attached-user-policies --user-name ${user_name} --profile $profile | jq -r '.AttachedPolicies[] | .PolicyName'
for policy in $(aws iam list-attached-user-policies --user-name ${user_name} --profile $profile | jq -r '.AttachedPolicies[] | .PolicyArn'); do
    aws iam detach-user-policy --user-name ${user_name} --policy-arn ${policy}  --profile $profile
done
}

removegroup(){
printf "\nRemoving Group Memberships for the user $user_name:\n"
for group in $(aws iam list-groups-for-user --user-name ${user_name} --profile $profile | jq -r '.Groups[] | .GroupName'); do
    echo $group
    aws iam remove-user-from-group --group-name ${group} --user-name ${user_name} --profile $profile
done
}

main(){
printf "\n---Deleting $user_name account from the AWS console---\n"
keysdel
certsdel
loginporfile
mfadel
removepolicy
removegroup
aws iam delete-user --user-name ${user_name} --profile $profile
printf "\n---Deleted the $user_name from the aws account.---\n"
}

main
