sudo rsync -av * /go-trivia/
sudo docker build /go-trivia/frontend/. -t mraagil/trivia-frontend:latest
sudo docker build /go-trivia/backend/. -t mraagil/trivia-backend:latest
sudo docker push mraagil/trivia-backend:kitabisa
sudo docker push mraagil/trivia-frontend:kitabisa
su ubuntu -c 'cd /go-trivia && make uninstall && make install'