#!/bin/bash

location[1]="koreacentral"
location[2]="eastasia"
location[3]="southeastasia"
location[4]="norwayeast"
location[5]="northeurope"
location[6]="southafricanorth"
location[7]="francecentral"
location[8]="germanywestcentral"
location[9]="koreasouth"
location[10]="australiacentral"
location[11]="australiaeast"
location[12]="brazilsouth"

#westcentralus sem VM

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
     echo
     echo "Região $regiao da Subscription $assinatura"
     
     RG=RG$(date +"%d%m%Y%H%M%S")
     
     echo
     echo "Criando Resource Group $RG na região $regiao da Subscription $assinatura"
     az group create --name $RG --location $regiao --only-show-errors -o none
     
     for i in {0..4}
      do 
         nome=$(date +"%d%m%Y%H%M%S")
         
         echo
         echo "Criando VM $nome ($i) na região $regiao da Subscription $assinatura"
         az vm create --resource-group $RG --name $nome --image UbuntuLTS --generate-ssh-keys --location $regiao --size "standard_f2" --no-wait

         j=0         
         echo
         
         CriandoVM=$(az vm list --query [$j].name -o tsv)     

         while [ "$CriandoVM" != "$nome" ]
         do
           CriandoVM=$(az vm list --query [$j].name -o tsv)

           if [ "$CriandoVM" ]; then
              echo "[$j] $CriandoVM" = "$nome"
              let "j++"
           else
             j=0
           fi

         done
         
         echo
         echo "Criando Extension da VM $nome na região $regiao da Subscription $assinatura"
         
         cmd='"commandToExecute"':'"sh vm.sh"'
         cmd="$cmd"
         #echo $cmd
         
         az vm extension set --publisher Microsoft.Azure.Extensions --version 2.0 --name CustomScript --vm-name $nome --resource-group $RG --no-wait --settings '{"fileUris": ["https://raw.githubusercontent.com/jb12mbh2/tools/master/vm.sh"],"commandToExecute":"sh vm.sh VM_$regiao "}'
     done
     
  done

done
