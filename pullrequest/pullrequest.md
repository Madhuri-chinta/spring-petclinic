#  SPRINGPETCLINIC APPLICATION 
   ----------------------------

### SPRINGPETCLINIC APPLICATION MANUAL STEPS:

```
sudo apt update
sudo apt install openjdk-17-jdk -y
sudo apt install maven -y
git clone https://github.com/spring-projects/spring-petclinic.git
cd spring-petclinic
./mvnw package
java -jar target/*.jar

```
### CREATE JENKINS PIPELINE FOR SPRINGPETCLINIC APPLICATION:

* Create two ec2 machines, one is jenkins master and other is jenkins node
![preview](images.png/pr1.png)
* In jenkins master install java-17 version and install jenkins and once install jenkins we will check jenkins users list and give "permissions" and changes "password authentication" no to "yes" to that jenkins user
* In jenkins node install java-17 version and maven
* Next go to the browser give '<jenkins master ip>:8080' and open jenkinspage after that we will get one path from jenkins then we will get into path by using sudo cat/<path> and entered into the page
![preview](images.png/pr2.png)
![preview](images.png/pr3.png)
![preview](images.png/pr4.png)
![preview](images.png/pr5.png)
![preview](images.png/pr6.png)
![preview](images.png/pr7.png)
![preview](images.png/pr8.png)
![preview](images.png/pr9.png)
* After we will configure master with node by using ssh-username,password,label,node ip-address.Next we will check agent is connect or not.If the agent is connected to the jenkins we will start the next process
![preview](images.png/pr9.png) 
![preview](images.png/pr10.png)
![preview](images.png/pr11.png)
![preview](images.png/pr12.png)
![preview](images.png/pr13.png)
![preview](images.png/pr14.png)
![preview](images.png/pr15.png)
![preview](images.png/pr16.png)
![preview](images.png/pr17.png)
![preview](images.png/pr18.png)
![preview](images.png/pr19.png)

* Next we will install docker in jenkins master and create the container with sonarqube latest image after go to browser and give '<jenkins master ip>:9000' open the sonarqube account.Login with  username and password generate token it will give some secrete key.Go to the jenkins===>Manage jenkins===>Manage Pluggins===>Available Pluggins===>
install sonarqube scanner pluggin and go to the configuration system configure sonarqube scanner with generated token
![preview](images.png/pr20.png)
![preview](images.png/pr21.png)
![preview](images.png/pr22.png)
![preview](images.png/pr23.png)
![preview](images.png/pr24.png)
![preview](images.png/pr25.png)
![preview](images.png/pr26.png)
![preview](images.png/pr27.png)
![preview](images.png/pr28.png)
![preview](images.png/pr29.png)
![preview](images.png/pr30.png)
* Next we will create jfrog account sign in with github account and login to the account and create maven package and create one  repository and genertae token and copy the secrete key.Next go to the jenkins===>Manage jenkins===> Manage Pluggins===>Available Pluggins===>Arifactory and go to the configure system configure jfrog with generated token and username.
![preview](images.png/pr31.png)
![preview](images.png/pr32.png)
![preview](images.png/pr33.png)
![preview](images.png/pr34.png)
![preview](images.png/pr35.png)
![preview](images.png/pr36.png)
![preview](images.png/pr37.png) 
![preview](images.png/pr38.png)
* Next check the jfrog test connection
![preview](images.png/pr39.png)
![preview](images.png/pr40.png) 
* After give the tools configuration to the maven
![preview](images.png/pr41.png)
![preview](images.png/pr42.png) 
* After create user in both jenkins master and jenkins node and give sudo permissions to the user and change the password authentication no to yes. 
* Next configure the jenkins node with private ip to the  jenkins master (ssh-copy-id <username>@privateip of node) in master
* Next install ansible on jenkins master
```
 sudo apt update
 sudo apt install software-properties-common
 sudo add-apt-repository --yes --update ppa:ansible/ansible
 sudo apt install ansible
 ansible --version

``` 
* Next write hostfile, springpectclinic servicefile and springpetclinic playbook and run this playbook in jenkins master
* After deploy application using ansible
```
pipeline {
    agent { label 'UBUNTU_NODE1' }
    stages {
        stage('vcs') {
            steps {
                git url: 'https://github.com/Madhuri-chinta/spring-petclinic.git',
                    branch: 'develop'
            }
        }
        stage('package') {
            steps {
                sh './mvnw package'
            }
        }
        stage('sonarqube analysis') {
            steps {
                withSonarQubeEnv('madhuri') {
                    sh 'mvn clean package sonar:sonar'
                }
            }
        } 
        stage ('Artifactory configuration') {
            steps {
            
                rtMavenDeployer (
                    id: "jfrog",
                    serverId: "madhuri",
                    releaseRepo: "madhuri",
                    snapshotRepo: "madhuri"
                )
            }
        }

        stage ('Exec Maven') {
            steps {
                rtMavenRun (
                    tool: "MAVEN_GOAL", // Tool name from Jenkins configuration
                    pom: 'pom.xml',
                    goals: 'clean install',
                    deployerId: "jfrog"
                )
            }
        }

        stage ('Publish build info') {
            steps {
                rtPublishBuildInfo (
                    serverId: "madhuri"
                )
            }
        }   
        stage('post build') {
            steps {
                archiveArtifacts artifacts: '**/target/*.jar',
                                 onlyIfSuccessful: true
                junit testResults: '**/surefire-reports/TEST-*.xml'
            }
        }
        stage('deploy') {
            agent any
            steps {
                sh 'ansible -i ./ansible/hosts -m ping all'
                sh 'ansible-playbook -i ./ansible/hosts ./ansible/spc.yaml'
            }
        }    
    }
}

```
* After go to the github account and create the git hub token it gives some secretekey 
![preview](images.png/pr43.png)
![preview](images.png/pr44.png)
![preview](images.png/pr45.png)
![preview](images.png/pr46.png) 
* Next go to the our springpetclinic repository and go to the settings and create webhook
![preview](images.png/pr47.png)
![preview](images.png/pr48.png)
![preview](images.png/pr49.png)
![preview](images.png/pr50.png)
![preview](images.png/pr51.png)
![preview](images.png/pr52.png)
![preview](images.png/pr53.png)
* Afetr jenkins page install github pullrequest builder and configure the pluggin with secret text
![preview](images.png/pr54.png)
![preview](images.png/pr55.png) 
* Next create freestyle project and set up the pull request process
![preview](images.png/pr56.png)
![preview](images.png/pr57.png)
![preview](images.png/pr58.png)
![preview](images.png/pr59.png)
![preview](images.png/pr60.png)
![preview](images.png/pr61.png)
![preview](images.png/pr62.png)
![preview](images.png/pr63.png)
![preview](images.png/pr64.png)
* This springpetclinc application is in develop branch and create & checkout the feature branch
* Some changes in feature branch and pull request to the develop branch if it is code is correct the build is automatically triggered and accept the pull request in develop branch
![preview](images.png/pr65.png)
![preview](images.png/pr66.png)
![preview](images.png/pr67.png)
![preview](images.png/pr68.png)
![preview](images.png/pr69.png)
![preview](images.png/pr70.png) 
![preview](images.png/pr71.png)       