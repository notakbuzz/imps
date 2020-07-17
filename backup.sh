#!/usr/bin/env bash
DATE=$(date)

cd ../..
sudo git status -v
sudo git add -v --all
sudo git add -v *.*
sudo git commit -m "Jenkins Server Backup $DATE"
sudo git push -v -u git@github.com:FreakyOS/jenkins_backup.git HEAD:master
