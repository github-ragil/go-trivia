sudo rsync -av * /go-trivia/
sudo docker build /go-trivia/prod/frontend/. -t mraagil/trivia-frontend:prod
sudo docker build /go-trivia/prod/backend/. -t mraagil/trivia-backend:prod
sudo docker push mraagil/trivia-backend:prod
sudo docker push mraagil/trivia-frontend:prod
su ubuntu -c 'kubectl create namespace prod'
su ubuntu -c 'cd /go-trivia/prod && make upgrade namespace=prod'
#su ubuntu -c 'cd /go-trivia/prod && make uninstall namespace=prod && make install namespace=prod'