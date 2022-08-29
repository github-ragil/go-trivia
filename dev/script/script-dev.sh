sudo rsync -av * /go-trivia/
sudo docker build /go-trivia/dev/frontend/. -t mraagil/trivia-frontend:dev
sudo docker build /go-trivia/dev/backend/. -t mraagil/trivia-backend:dev
sudo docker push mraagil/trivia-backend:dev
sudo docker push mraagil/trivia-frontend:dev
su ubuntu -c 'cd /go-trivia/dev && make uninstall namespace=qa'
su ubuntu -c 'kubectl create namespace dev'
su ubuntu -c 'make install namespace=dev'
su ubuntu -c 'cd /go-trivia/dev && make uninstall namespace=dev && make install namespace=dev'