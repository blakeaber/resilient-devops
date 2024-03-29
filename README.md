# resilient-devops
Background:

Goals of the job / project:
- write a script (ideally using AWS CLI for reproducibility) that starts up, connects and deploys a dockerized app (located in Github, or zipped on S3, whatever is easiest) and required AWS services
- apply a certificate to the hosted app so that chrome users can access webcam via https (and confirm that webcam access requested in Chrome works)

Deploy a dockerized web app:
- I have a dockerized application that I want to deploy via Elastic Beanstalk
- There are associated services / databases that need to be connected to the container (e.g. RDS, Lambda, Cognito)
- I want an AWS CLI script that deploys the above in a repeatable way

App requires webcam access:
- I have app functionality that requires a user's webcam access (e.g. in Chrome)
- For webcam access, Chrome requires https with a verified certificate (otherwise it blocks the site)
- I want to confirm that I can access my webcam in Chrome in the deployed app

Prerequisites for this work
- I will provide a functioning, dockerized app (can also be run locally) where webcam access works correctly on localhost (Chrome only allows localhost and https)
- I will be available to troubleshoot any issues with you (I am a back-end engineer w/ novice AWS experience)


## Enviromental Setup on Local System(Linux)
- Install the follow packages in an ubuntu 18.04 box
  ```
  # System update, and tools installations
  sudo apt update
  
  sudo apt upgrade -y
  
  sudo apt install snap
  
  sudo snap install git-ubuntu --classic
  
  
  #Git configuraton
  git config --global user.name "<Your first and last name>"
  git config --global user.email "<your email>"
  ```
- Generate ssh keys to authenticate to github
  ```
  ssh-keygen -t rsa -C "<your email>"
  
  #Copy the output of this command
  cat ~/.ssh/<"Name of the Key create".pub> #example is_rsa.pub
  
  ```
  Add this to your github account and test if this works.
  - https://help.github.com/en/github/authenticating-to-github/adding-a-new-ssh-key-to-your-github-account
 
## Getting this Repo Cloned to you system.
- Pull existing repo to your enviroment
  ```
  mkdir <dir to hold repo locally>
  
  cd <dir created above>
  
  git init
  
  git clone git@github.com:blakeaber/resilient-devops.git
  
  ```

## Follow instructions on resilient-devops/script/README.md
```
  cd resilient-devops/script/
```
