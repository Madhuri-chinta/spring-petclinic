pipeline {
    agent { label 'UBUNTU_NODE1' }
    stages {
        stage('vcs') {
            steps {
                git url: 'https://github.com/Madhuri-chinta/spring-petclinic.git',
                    branch: 'pullrequest'
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
