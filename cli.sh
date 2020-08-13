#!/bin/bash
sudo apt-get -y update 
sudo git clone https://github.com/jb12mbh2/tools
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
cd tools
sudo chmod u+x create.sh
