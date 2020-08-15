#!/bin/bash
 
        CriandoVM=$(az vm list --query [0].name)
         
         while [ -z "$CriandoVM" ]
         do
            echo "eh vazio"
         done

            echo "nao eh mais vazio"
