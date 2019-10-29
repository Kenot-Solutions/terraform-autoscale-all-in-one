
## Kenot Solutions by Tolgay Gul
#### terraform-autoscale-all-in-one AWS

This project create AWS auto scale with ubuntu image and configure nginx on it. 

## Overview



-- you need a ssh key gen to connect your server

	ssh-keygen -f mykey

-- you need to configure your AWS IAM user 
	create an IAM user with AdministratorAccess. Download the key and access secret code

-- you need to set AWS credentials
	aws configure

-- this repository will open the services on us-west-2 region

--  clone the respository to your local
	git clone https://github.com/Kenot-Solutions/terraform-autoscale-all-in-one.git .

--  happy usage 
	terraform init 
	terraform plan
-- do not forget to destory it 
        terraform destory 


Create Release 1.1.0 

### Powered by Beta Kuresel [Saglayici](http://www.saglayici.com/en).

```


