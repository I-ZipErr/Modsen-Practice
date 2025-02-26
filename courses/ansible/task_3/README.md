## How to prepare inventory:
1. Replace path to **ansible/task_1** folder with yours in **create_ssh_config.sh**
2. Run **create_ssh_config.sh**

## How to check inventory:
1. Open **task_3** folder with terminal
2. run: `ansible all -m ping -i inventory.yml`