pipeline {
    agent { label 'UBUNTU_NODE1' }
    triggers { pollSCM('* * * * *') }
    parameters { choice(name: 'MAVEN_GOAL', choices: ['package', 'install', 'test'], description: 'maven') }
    stages {
        stage('git') {
            steps {
                git url: "https://github.com/Madhuri-chinta/spring-petclinic.git",
                    branch: "dev"
            }
        }
        stage('build') {
            tools {
                jdk 'JDK_17'
            }
            steps {
                //sh 'export "PATH=/usr/lib/jvm/java-17-openjdk-amd64/bin:$PATH"'
                sh "mvn ${params.MAVEN_GOAL}"
                            }
        }
        stage('Sonarqube') {
            steps {
                withSonarQubeEnv('SONAR_CLOUD') {
                    sh 'mvn clean package sonar:sonar'
        }
}
}
        stage ('Artifactory configuration') {
            steps {
                rtMavenDeployer (
                    id: 'Jfrog',
                    serverId: 'JFROG_KAPPA',
                    releaseRepo: 'chandu-libs-release-local',
                    snapshotRepo: 'chandu-libs-snapshot-local'
                )
            }
        }

        stage ('Exec Maven') {
            steps {
                rtMavenRun (
                    tool: 'MAVEN_GOAL', // Tool name from Jenkins configuration 
                    pom: 'pom.xml',
                    goals: 'clean install',
                    deployerId: 'Jfrog'
                )
            }
        }

        stage ('Publish build info') {
            steps {
                rtPublishBuildInfo (
                    serverId: 'JFROG_KAPPA'
                )
            }
       }
    
       // stage ('deployment') {
          //  steps {
               // sh "sudo wget https://akshara2509.jfrog.io/artifactory/chandu-libs-snapshot-local/org/springframework/samples/spring-petclinic/3.0.0-SNAPSHOT/spring-petclinic-3.0.0-20230814.100404-3.jar"
               
          //  }
       // }
    }
    post {
        success {
            mail subject: "Jenkins Build of ${JOB_NAME} with id ${BUILD_ID} is success",
                 body: "Use this URL ${BUILD_URL} for more info",
                 from: 'madhuri1413@gmail.com',
                 to: 'sweety1413@gmail.com'
        }
        failure {
            mail subject: "Jenkins Build of ${JOB_NAME} with id ${BUILD_ID} is failure",
                 body: "Use this URL ${BUILD_URL} for more info",
                 from: 'madhuri1413@gmail.com',
                 to: "${GIT_AUTHOR_EMAIL}"
        }
        }
                
        }
    


