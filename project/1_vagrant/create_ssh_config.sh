#! /bin/bash

vagrant ssh-config master > vagrant_master
vagrant ssh-config worker1 > vagrant_worker1
vagrant ssh-config worker2 > vagrant_worker2