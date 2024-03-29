## Script Function
This script is used to install aws cli, terraform, aws eb cli and docker for local development

It is not OS agnostic, thus only ubuntu. 18.04 VM is recommended to run this in

After git clone run:
```
chmod +x ./resilient-devops/scripts/env_prep.sh

./resilient-devops/scripts/env_prep.sh

```
Upon Success of teh Script you will see some instructions which will look like this
```
Success!

    Note: To complete installation, ensure `eb` is in PATH. You can ensure this by executing:

    1. Bash:

       echo 'export PATH="/home/vagrant/.ebcli-virtual-env/executables:$PATH"' >> ~/.bash_profile && source ~/.bash_profile

    2. Zsh:

       echo 'export PATH="/home/vagrant/.ebcli-virtual-env/executables:$PATH"' >> ~/.zshenv && source ~/.zshenv

   
    - NOTE: To complete installation, ensure `python` is in PATH. You can ensure this by executing:
   
      1. Bash:
   
         echo 'export PATH=/home/vagrant/.pyenv/versions/3.7.2/bin:$PATH' >> /home/vagrant/.bash_profile && source /home/vagrant/.bash_profile
   
      2. Zsh:
   
         echo 'export PATH=/home/vagrant/.pyenv/versions/3.7.2/bin:$PATH' >> /home/vagrant/.zshrc && source /home/vagrant/.zshrc

```

Choose the 1. Bash Option and execute on terminal as below example:
```
 echo 'export PATH="/home/vagrant/.ebcli-virtual-env/executables:$PATH"' >> ~/.bash_profile && source ~/.bash_profile
```

Test if script worked you must get versions of all installed tools:
```
docker --version

terraform --version

aws --version

eb --version

```

## Issues you mya run into
# Docker permissions
Some times the script does not correctly add docker user to sudo group. If that is the issue kindly do the following.
```
    $ sudo groupadd docker
    
    $ sudo usermod -aG docker $USER

    $ newgrp docker 

    $ docker run hello-world # Test if user was added to sudo group
```

--> Now you should be ready to start your aws , terraform, docker operations. 

--> Proceed to resilient-devops/tfs/docker_eb/README.md
