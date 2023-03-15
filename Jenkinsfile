pipeline {
  agent { node { label 'ubuntu' } }
  stages {
    stage ('git') {
      steps {
      git url: 'https://github.com/Kiranteja623/spring-petclinic.git'
    }
    }
    stage ('package') {
      steps {
          sh 'mvn package'
    }
    }
}
}
