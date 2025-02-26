#! /bin/bash

cd /home/iziperr/Documents/Modsen-Practice/courses/ansible/task_1
vagrant ssh-config ubuntu > ../task_3/vagrant_ubuntu_ssh
# 2. ssh -F ./vagrant_[machine name]_ssh [machine name]
vagrant ssh-config fedora > ../task_3/vagrant_fedora_ssh
# 2. ssh -F ./vagrant_[machine name]_ssh [machine name]