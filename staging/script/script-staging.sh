sudo rsync -av * /go-trivia/
sudo docker build /go-trivia/frontend/. -t mraagil/trivia-frontend:staging
sudo docker build /go-trivia/backend/. -t mraagil/trivia-backend:staging
sudo docker push mraagil/trivia-backend:staging
sudo docker push mraagil/trivia-frontend:staging
su ubuntu -c 'kubectl create namespace staging'
su ubuntu -c 'cd /go-trivia/staging && make install namespace=staging'
