#!/bin/bash

#ssh-keygen
eval "$(ssh-agent)"

ssh-copy-id -i ~/.ssh/id_rsa.pub root@master01
ssh-copy-id -i ~/.ssh/id_rsa.pub root@worker10
ssh-copy-id -i ~/.ssh/id_rsa.pub root@worker11

#ssh-copy-id -i ~/.ssh/id_rsa.pub root@master.example.com
#ssh-copy-id -i ~/.ssh/id_rsa.pub root@master01.example.com
#ssh-copy-id -i ~/.ssh/id_rsa.pub root@worker10.example.com
#ssh-copy-id -i ~/.ssh/id_rsa.pub root@worker11.example.com

ssh-add
