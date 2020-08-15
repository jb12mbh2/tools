#!/bin/bash

location[1]="centralus"
location[2]="uksouth"
location[3]="ukwest"
location[4]="australiasoutheast"
location[5]="canadacentral"
location[6]="southcentralus"
location[7]="westcentralus"
location[8]="eastus"
location[9]="eastus2"
location[10]="westus"
location[11]="westus2"
location[12]="koreacentral"
location[13]="eastasia"
location[14]="southeastasia"
location[15]="norwayeast"
location[16]="northeurope"
location[17]="southafricanorth"
location[18]="francecentral"
location[19]="germanywestcentral"
location[20]="koreasouth"
location[21]="australiacentral"
location[22]="australiaeast"
#location[23]="brazilsouth"

 #az account clear
 #az login -o table
 

i=0

echo
a[$i]="Login ok!"

 while [ "${a[$i]}" ]
 do
    if [ "${a[$i]}" != "Login ok!" ]; then
       let "i++"
    fi

    a[$i]=$( az account list --all --query '['$i'].id' -o json )

    if [ "${a[$i]}" ]; then
       subscription[$i]=${a[$i]}
       subscription[$i]=${subscription[$i]//'"'/}
    fi
done

for assinatura in "${subscription[@]}"
 do
  echo
  echo "Set Subscription $assinatura"
  az account set --subscription $assinatura
  
  echo
  echo "Criando Resource Group da Subscription $assinatura"
  az group create --name myResourceGroup --location centralus --only-show-errors 
  echo
  
  for regiao in "${location[@]}"
   do
     echo
     echo "Região $regiao da Subscription $assinatura"
     echo
     
     for i in {0..4}
      do 
         nome=$(date +"%d%m%Y%H%M%S")
         VMList[$i]=$nome
         echo "Criando VM $nome ($i) na região $regiao da Subscription $assinatura"
         az vm create --resource-group myResourceGroup --name $nome --image UbuntuLTS --generate-ssh-keys --location $regiao --size "standard_f2" --no-wait
         echo
         
         CriandoVM=$(az vm list --query [$i].name)
         
         while [ -z "$CriandoVM" ]
         do
            echo "Extension da VM ${VMList[$i]} na região $regiao da Subscription $assinatura"
            az vm extension set --publisher Microsoft.Azure.Extensions --version 2.0 --name CustomScript --vm-name $VM --resource-group myResourceGroup --no-wait --settings '{"fileUris": ["https://raw.githubusercontent.com/jb12mbh2/tools/master/vm.sh"],"commandToExecute":"sh vm.sh"}'
            echo   
         done
         
     done
     
  done

done
