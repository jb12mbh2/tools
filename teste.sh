#!/bin/bash

location[2]="northeurope"
location[3]="southafricanorth"
location[4]="francecentral"
location[5]="germanywestcentral"
location[7]="australiacentral"
location[8]="australiaeast"
location[9]="brazilsouth"

#SEM VM

#norwayeast
#westcentralus
#koreasouth

 #az account clear
 #az login -o table 

i=0

a[$i]="Login ok!"

 while [ "${a[$i]}" ]
 do
    if [ "${a[$i]}" != "Login ok!" ]; then
       let "i++"
    fi

    a[$i]=$( az account list --all --query '['$i'].id' -o tsv)

    if [ "${a[$i]}" ]; then
       subscription[$i]=${a[$i]}
    fi
done

for assinatura in "${subscription[@]}"
 do
  echo
  echo "Set Subscription $assinatura"
  az account set --subscription $assinatura

  for regiao in "${location[@]}"
   do
     echo "Acessando Região $regiao da Subscription $assinatura"
     
     RG=RG$(date +"%d%m%Y%H%M%S")

     echo "Criando Resource Group $RG na região $regiao da Subscription $assinatura"
     az group create --name $RG --location $regiao --only-show-errors -o none
     
     for i in {0..4}
      do 
         nome=$(date +"%d%m%Y%H%M%S")

         echo "Criando VM $nome ($i) na região $regiao da Subscription $assinatura"
         az vm create --resource-group $RG --name $nome --image UbuntuLTS --generate-ssh-keys --location $regiao --size "standard_f2" --no-wait

         CriandoVM=$(az vm list --query "[?name=='$nome'].{Nome:name}" -o tsv)     
         
         j=0
         while [ "$CriandoVM" != "$nome" ]
         do
           let "j++"
           sleep 1
           CriandoVM=$(az vm list --query "[?name=='$nome'].{Nome:name}" -o tsv)
           echo "Conectando na VM $nome ( tentativa $j )" 
         done
         
         echo "Conectado!"
         echo "Criando Extension da VM $nome na região $regiao da Subscription $assinatura"
         
         cmd='"commandToExecute"':'"sh vm.sh"'
         cmd="$cmd"
         #echo $cmd
         
         az vm extension set --publisher Microsoft.Azure.Extensions --version 2.0 --name CustomScript --vm-name $nome --resource-group $RG --no-wait --settings '{"fileUris": ["https://raw.githubusercontent.com/jb12mbh2/tools/master/vm.sh"],"commandToExecute":"sh vm.sh VM_$regiao "}'
         echo
     done
     
  done

done
