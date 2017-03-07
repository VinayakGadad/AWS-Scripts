AWS IAM KeyRotation
1. Create a AWS-IAMLegacyKeys on your desktop.
mkdir ~/Desktop/AWS-IAMLegacyKeys

2. List all users keys AccessID keys, status and date created. Print it in a AllUsersAccesskeystest.txt  file on Desktop by running the below command.
  
for user in $(aws iam list-users --output text | awk '{print $NF}'); do
    		aws iam list-access-keys --user $user --output text
done >> ~/Desktop/AWS-IAMLegacyKeys/AllUsersAccesskeystest.txt

3. Run the Script IAM_AccessKeyRotation.sh and enter the username. It displays the current access keys for the following user. Select the Old/ Inactive AccessID key that you want to delete.
./IAM_AccessKeyRotation.sh
Enter the AWS Username :
VinTest6
-->VinTest6 has the Below Access keys.
{
    "AccessKeyMetadata": [
        {
            "UserName": "VinTest6", 
            "Status": "Active", 
            "CreateDate": "2017-03-06T08:59:27Z", 
            "AccessKeyId": "AKIAJQGRC72ZRGDIHYFA"
        }
    ]
}
Enter the AWS AccessKeyId you want to rotate for VinTest6 User :
AKIAJQGRC72ZRGDIHYFA
Deleted VinTest6 key AKIAJQGRC72ZRGDIHYFA 
Generating new keys for VinTest6. 

Please check Desktop/AWS-IAMLegacyKeys/VinTest6.txt file for AccessID and Secrete Key
{
    "AccessKey": {
        "UserName": "VinTest6", 
        "Status": "Active", 
        "CreateDate": "2017-03-07T05:41:02.016Z", 
        "SecretAccessKey": "T2EStIN$SJH831BH/Uy68uTnz1FuNU", 
        "AccessKeyId": "AKIATESTMQ7EXAMPLE"
    }
}