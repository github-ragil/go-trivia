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
			sh 'sudo rsync -av * /go-trivia/'
			sh 'sudo docker build /go-trivia/frontend/. -t mraagil/trivia-frontend:kitabisa'
			sh 'sudo docker build /go-trivia/backend/. -t mraagil/trivia-backend:kitabisa'
			sh 'sudo docker push mraagil/trivia-backend:kitabisa'
			sh 'sudo docker push mraagil/trivia-frontend:kitabisa'
			su ubuntu -c 'cd /go-trivia'
			su ubuntu -c 'make upgrade'
  }
  }
  
  }
  }