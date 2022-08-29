sudo rsync -av * /go-trivia/
sudo docker build /go-trivia/qa/frontend/. -t mraagil/trivia-frontend:qa
sudo docker build /go-trivia/qa/backend/. -t mraagil/trivia-backend:qa
sudo docker push mraagil/trivia-backend:qa
sudo docker push mraagil/trivia-frontend:qa
su ubuntu -c 'kubectl create namespace qa'
su ubuntu -c 'make install namespace=qa'
su ubuntu -c 'cd /go-trivia/qa && make uninstall namespace=qa && make install namespace=qa'