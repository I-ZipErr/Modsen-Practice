## How to run:
1. Replace path where lies file to copy with yours in **copy_files.yml**
2. Open **task_3** directory in terminal
3. Run `ansible-playbook -i inventory.yml ../task_8/deploy_template.yml`
## How to chech web page:
1. Connect to VM over SSH  
*(you may skip this stage if VMs 80 port if forwarded to host)*
2. Run `curl localhost:80`  
*(or replace 80 port with forwarded one)*