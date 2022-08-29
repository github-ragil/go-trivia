pipeline{
	agent any
   stages{
	 stage('Checkout Git') { 
		steps {
			checkout scm
			}
			
  }  
	stage('Deploy Changes') {
		steps {
			sh 'sudo rsync -av * /go-trivia/' 
			su ubuntu -c 'sudo docker-compose -f /livecode/docker-compose.yml up -d'
  }
  }
  
  }
  }