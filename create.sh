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
location[23]="brazilsouth"

 az account clear
 az login -o table

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

#username=$( az account show --query user.name )
#username=${username//'"'/}
#sed -i 's/export pool_pass1=POOL/export pool_pass1='$username'/' Pool.json

count=1
count1=1

for assinatura in "${subscription[@]}"
 do
  echo
  echo "Set Subscription $assinatura $count1/${#subscription[@]}"
  az account set --subscription $assinatura
  
  echo
  echo "Criando Resource Group da Subscription $assinatura"
  az group create --name myResourceGroup --location westeurope --only-show-errors
  echo
  
  count2=1

  for regiao in "${location[@]}"
   do
     nome=$(date +"%d%m%Y%H%M%S")

     let "perc= $(( $count * 100 / (${#location[@]} * ${#subscription[@]}) ))"

     echo "Criando Lote $nome $count2/${#location[@]} em $regiao da Subscription $assinatura $count1/${#subscription[@]}  > $perc% Concluído"
     az batch account create --resource-group myResourceGroup --name $nome --location $regiao --only-show-errors
     echo

     echo "Acessando Lote $nome $count2/${#location[@]} em $regiao da Subscription $assinatura $count1/${#subscription[@]}  > $perc% Concluído"
     az batch account login --resource-group myResourceGroup --name $nome --shared-key-auth --only-show-errors
     echo

     echo "Criando Pool no Lote $nome $count2/${#location[@]} em $regiao da Subscription $assinatura $count1/${#subscription[@]}  > $perc% Concluído"
     az batch pool create --json-file Pool.json --only-show-errors
     echo

     echo "Lote $nome $count2/${#location[@]} em $regiao da Subscription $assinatura $count1/${#subscription[@]} ok!  > $perc% Concluído"
     echo

     let "count++"
     let "count2++"

  done

  let "count1++"

done
