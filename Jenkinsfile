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
    post {
        success {
            mail subject: "Jenkins Build of ${JOB_NAME} with id ${BUILD_ID} is success",
                 body: "Use this URL ${BUILD_URL} for more info",
                 to: 'sweety123@gmail.com',
                 from: 'madhuri123@gmail.com'
        }
        failure {
            mail subject: "Jenkins Build of ${JOB_NAME} with id ${BUILD_ID} is failed",
                 body: "Use this URL ${BUILD_URL} for more info",
                 to: "${GIT_AUTHOR_EMAIL}", // here pass jenkins environmental variable 
                 from: "${GIT_COMMITTER_EMAIL}" // here also pass jenkins environmental variable
        }  
    }
} 


  
