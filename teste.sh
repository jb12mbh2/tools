#!/bin/bash

location[1]="uksouth"

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
  #az group create --name myResourceGroup --location centralus --only-show-errors 
  echo
  
  for regiao in "${location[@]}"
   do
     echo
     echo "Região $regiao da Subscription $assinatura"
     echo
     
     for i in {0..4}
      do 
         nome=$(date +"%d%m%Y%H%M%S")
         #VMList[$i]=$nome
         echo "Criando VM $nome ($i) na região $regiao da Subscription $assinatura"
         az vm create --resource-group myResourceGroup --name $nome --image UbuntuLTS --generate-ssh-keys --location $regiao --size "standard_f2" --no-wait
         echo

         CriandoVM=$(az vm list --query [$i].name)
         CriandoVM=${CriandoVM//'"'/}
         
         while [ "$CriandoVM" != "$nome" ]
         do
           echo "Aguardando provisionamento da VM ("$CriandoVM"!="$nome")..."
           sleep 5
           CriandoVM=$(az vm list --query [$i].name)
           CriandoVM=${CriandoVM//'"'/}
         done 
         
         echo
         echo "Criando Extension da VM $nome na região $regiao da Subscription $assinatura"
         cmd='"commandToExecute":"sh vm.sh $nome"'
         az vm extension set --publisher Microsoft.Azure.Extensions --version 2.0 --name CustomScript --vm-name $nome --resource-group myResourceGroup --no-wait --settings '{"fileUris": ["https://raw.githubusercontent.com/jb12mbh2/tools/master/vm.sh"],$cmd}'
         echo         
  
     done
     
  done

done
