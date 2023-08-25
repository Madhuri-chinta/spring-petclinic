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
       stage ('Build') {
           steps {
               sh 'docker image build -t madhurichinta/sweety:latest .'
        }
       }
       stage ('scan and push') {
           steps {
               sh 'echo docker scan madhurichinta/sweety:latest'
               sh 'docker image scan madhurichinta/sweety:latest'
           }
       }
  }
}