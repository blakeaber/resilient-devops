#! /bin/bash

check_exit_status() {

  if [[ $? -eq 0 ]]
  then
    echo "Success"
  else
    echo
    echo "[ERROR] Process Failed! $?"
    echo

    read -p "The last command exited with an error. Exit script? (yes/no) " answer

    if [[ "$answer" == "yes" ]]
    then
      exit 1
    fi
  fi
}


greeting() {

  echo
  echo "Hello, $USER.  System Setup..."
  echo
}


update() {

  sudo apt update;
  check_exit_status

  sudo apt-get upgrade -y;
  check_exit_status

}

# Install terraform, aws cli adn docker
package_installs() {
  sudo snap install terraform;
  check_exit_status

  sudo snap install aws-cli --classic;
  check_exit_status

  sudo snap install docker;
  check_exit_status

  sudo groupadd docker;
  check_exit_status

  sudo usermod -aG docker $USER;
  check_exit_status

  newgrp docker;
  check_exit_status

  sudo apt install build-essential zlib1g-dev libssl-dev libncurses-dev libffi-dev libsqlite3-dev libreadline-dev libbz2-dev -y;
  check_exit_status

  # If this enviroment is shared with other usecases please consder using virtualenv
  git clone https://github.com/aws/aws-elastic-beanstalk-cli-setup.git;
  check_exit_status

  ./aws-elastic-beanstalk-cli-setup/scripts/bundled_installer;
  check_exit_status

  # Substitute this with equivalent of your workspace
  echo 'export PATH="/home/$USER/.ebcli-virtual-env/executables:$PATH"' >> ~/.bash_profile && source ~/.bash_profile;
  check_exit_status
}

housekeeping() {

    sudo apt-get autoremove -y;
    check_exit_status

    sudo apt-get autoclean -y;
    check_exit_status

    sudo updatedb;
    check_exit_status
}

leave() {

    echo
    echo "--------------------"
    echo "- Update Complete and Install Complete! -"
    echo "--------------------"
    echo
    exit
}

greeting
update
package_installs
update
housekeeping
leave
