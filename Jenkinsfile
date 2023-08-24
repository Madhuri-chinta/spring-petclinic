pipeline {
    agent { label 'UBUNTU_NODE1'}
    triggers {
        pollSCM ('* * * * *')
    }
    parameters { choice(name: 'MVN_GOAL', choices: ['package', 'install', 'test'], description: 'maven package') }
    stages {
        stage ('VCS') {
            steps { 
                git url: 'https://github.com/Madhuri-chinta/spring-petclinic.git',
                    branch: 'main'
        }   
     }
        stage ('BUILD') {
            steps {
                sh 'mvn package'
            }
        }
  }
}