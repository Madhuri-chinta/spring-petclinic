pipeline {
    agent { label 'UBUNTU_NODE1'}
    stages {
        stage ('vcs') {
            steps {
                git url: 'https://github.com/spring-projects/spring-petclinic.git',
                    branch: 'main'
            }
        }
            stage ('build') {
                steps {
                    sh 'export "PATH=/usr/lib/jvm/java-17-openjdk-amd64/bin:$PATH" && mvn package'
                }
            }
            stage ('archiveartifacts') {
                steps {
                    archiveArtifacts artifacts: '**/target/spring-petclinic-3.1.0-SNAPSHOT.jar', 
                                     onlyIfSuccessful: true,
                                     allowEmptyArchive : false        
            }
        }
            stage ('testresults') {
                steps {
                    junit testResults: '**/surefire-reports/TEST-*.xml',
                          allowEmptyResults : true
                          
                }
            }
    }
} 

  
