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
![preview](./pullrequest/images/pr1.png)
* In jenkins master install java-17 version and install jenkins and once install jenkins we will check jenkins users list and give "permissions" and changes "password authentication" no to "yes" to that jenkins user
* In jenkins node install java-17 version and maven
* Next go to the browser give '<jenkins master ip>:8080' and open jenkinspage after that we will get one path from jenkins then we will get into path by using sudo cat/<path> and entered into the page
![preview](./pullrequest/images/pr2.png)
![preview](./pullrequest/images/pr3.png)
![preview](./pullrequest/images/pr4.png)
![preview](./pullrequest/images/pr5.png)
![preview](./pullrequest/images/pr6.png)
![preview](./pullrequest/images/pr7.png)
![preview](./pullrequest/images/pr8.png)
![preview](./pullrequest/images/pr9.png)
* After we will configure master with node by using ssh-username,password,label,node ip-address.Next we will check agent is connect or not.If the agent is connected to the jenkins we will start the next process
![preview]./pullrequest/(images/pr9.png) 
![preview](./pullrequest/images/pr10.png)
![preview](./pullrequest/images/pr11.png)
![preview](./pullrequest/images/pr12.png)
![preview](./pullrequest/images/pr13.png)
![preview](./pullrequest/images/pr14.png)
![preview](./pullrequest/images/pr15.png)
![preview]./pullrequest/(images/pr16.png)
![preview](./pullrequest/images/pr17.png)
![preview](./pullrequest/images/pr18.png)
![preview](./pullrequest/images/pr19.png)

* Next we will install docker in jenkins master and create the container with sonarqube latest image after go to browser and give '<jenkins master ip>:9000' open the sonarqube account.Login with  username and password generate token it will give some secrete key.Go to the jenkins===>Manage jenkins===>Manage Pluggins===>Available Pluggins===>
install sonarqube scanner pluggin and go to the configuration system configure sonarqube scanner with generated token
![preview](./pullrequest/images/pr20.png)
![preview](./pullrequest/images/pr21.png)
![preview](./pullrequest/images/pr22.png)
![preview](./pullrequest/images/pr23.png)
![preview](./pullrequest/images/pr24.png)
![preview](./pullrequest/images/pr25.png)
![preview](./pullrequest/images/pr26.png)
![preview](./pullrequest/images/pr27.png)
![preview](./pullrequest/images/pr28.png)
![preview](./pullrequest/images/pr29.png)
![preview](./pullrequest/images/pr30.png)
* Next we will create jfrog account sign in with github account and login to the account and create maven package and create one  repository and genertae token and copy the secrete key.Next go to the jenkins===>Manage jenkins===> Manage Pluggins===>Available Pluggins===>Arifactory and go to the configure system configure jfrog with generated token and username.
![preview](./pullrequest/images/pr31.png)
![preview](./pullrequest/images/pr32.png)
![preview](./pullrequest/images/pr33.png)
![preview](./pullrequest/images/pr34.png)
![preview](./pullrequest/images/pr35.png)
![preview](./pullrequest/images/pr36.png)
![preview](./pullrequest/images/pr37.png) 
![preview](./pullrequest/images/pr38.png)
* Next check the jfrog test connection
![preview](./pullrequest/images/pr39.png)
![preview](./pullrequest/images/pr40.png) 
* After give the tools configuration to the maven
![preview](./pullrequest/images/pr41.png)
![preview](./pullrequest/images/pr42.png) 
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
![preview](./pullrequest/images/pr43.png)
![preview](./pullrequest/images/pr44.png)
![preview](./pullrequest/images/pr45.png)
![preview](./pullrequest/images/pr46.png)
* Next go to the our springpetclinic repository and go to the settings and create webhook
![preview](./pullrequest/images/pr47.png)
![preview](./pullrequest/images/pr48.png)
![preview](./pullrequest/images/pr49.png)
![preview](./pullrequest/images/pr50.png)
![preview](./pullrequest/images/pr51.png)
![preview](./pullrequest/images/pr52.png)
![preview](./pullrequest/images/pr53.png)
* Afetr jenkins page install github pullrequest builder and configure the pluggin with secret text
![preview](./pullrequest/images/pr54.png)
![preview](./pullrequest/images/pr55.png) 
* Next create freestyle project and set up the pull request process
![preview](./pullrequest/images/pr56.png)
![preview](./pullrequest/images/pr57.png)
![preview](./pullrequest/images/pr58.png)
![preview](./pullrequest/images/pr59.png)
![preview](./pullrequest/images/pr60.png)
![preview](./pullrequest/images/pr61.png)
![preview](./pullrequest/images/pr62.png)
![preview](./pullrequest/images/pr63.png)
![preview](./pullrequest/images/pr64.png)
* This springpetclinc application is in develop branch and create & checkout the feature branch
* Some changes in feature branch and pull request to the develop branch if it is code is correct the build is automatically triggered and accept the pull request in develop branch
![preview](./pullrequest/images/pr65.png)
![preview](./pullrequest/images/pr66.png)
![preview](./pullrequest/images/pr67.png)
![preview](./pullrequest/images/pr68.png)
![preview](./pullrequest/images/pr69.png)
![preview](./pullrequest/images/pr70.png) 
![preview](./pullrequest/images/pr71.png)  
