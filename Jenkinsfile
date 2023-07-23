pipeline {
    agent { label 'UBUNTU_NODE1'}
    //triggers { cron ('*/2 * * * 0') } with cron
    triggers { pollSCM ('*/2 * * * 0') }
    //parameters { string(name: 'MVN_GOAL', defaultValue: 'package', description: 'maven package') } only one option
    parameters { choice(name: 'MVN_GOAL', choices: ['package', 'install', 'clean install', 'clean package' ], description: 'maven package') }
    
    stages {
        stage ('vcs') {
            steps {
                git url: 'https://github.com/spring-projects/spring-petclinic.git',
                    branch: 'main'
            }
        }
            stage ('build') {
                tools {
                    jdk 'JDK_17'
                }
                steps {
                    //sh 'export "PATH=/usr/lib/jvm/java-17-openjdk-amd64/bin:$PATH" (no tool configuration)
                    sh "mvn ${params.MVN_GOAL}"   
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

  
