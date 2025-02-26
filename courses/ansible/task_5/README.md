## How to run:
1. Open **task_3** directory in terminal
2. Create password and hash it by command: `mkpasswd --method=SHA-512`
3. Copy hash and paste it in **task_5/manage_users.yml**
4. Run `ansible-playbook -i inventory.yml ../task_4/install_packages.yml`
## How to login as created user:
1. Connect to VM over SSH
2. Run `su - ansible_user` and input password