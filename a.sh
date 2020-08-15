#!/bin/bash
 
        CriandoVM=$(az vm list --query [$i].name)
         
         while [ -z "$CriandoVM" ]
         do
            echo "eh vazio"
         done

            echo "nao eh mais vazio"
