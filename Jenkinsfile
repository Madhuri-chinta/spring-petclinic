pipeline {
  stages {
    stage('git') {
      git url: 'https://github.com/Kiranteja623/spring-petclinic.git'
          branch: 'develop'
    }
    stage('package') {
          sh 'mvn package'
    }
  }
}