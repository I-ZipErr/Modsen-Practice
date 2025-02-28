## How to run:
1. Open **task_3** directory in terminal
2. Run `ansible-playbook -i inventory.yml ../task_7/configure_firewall.yml`
## How to chech firewall setting:
1. On Debian-based distros run: `sudo ufw status`
2. On RedHat-based distros run: `sudo firewall-cmd --list-all`