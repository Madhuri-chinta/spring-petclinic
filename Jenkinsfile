pipeline {
  agent { node { label 'ubuntu' } }
  stages {
    stage ('git') {
      steps {
      git url: 'https://github.com/Kiranteja623/spring-petclinic.git',
          branch: 'release'
    }
    }
    stage ('package') {
      steps {
          sh 'mvn package'
    }
    }
    stage ('sonarqube') {
        steps {
          withSonarQubeEnv('Kiranteja623') {
                    sh 'mvn clean package sonar:sonar -Dsonar.organization=kiranteja623 -Dsonar.login=ddfb007e5e67490bc157bd464d92bdfd2690f1d2 -Dsonar.host.url=https://sonarcloud.io -Dsonar.projectKey=kiranteja623/petclinic'
                }
        }
  }
}
}
=======
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
