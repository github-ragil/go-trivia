pipeline{
	agent any
   stages{
	 stage('Checkout Git') { 
		steps {
			checkout scm
			}
			
  }  

	stage('Build Docker') {
		steps {
			sh 'sudo bash ./script/build-docker.sh'


  }
  }
  
  }
  }