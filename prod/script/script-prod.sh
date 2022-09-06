sudo rsync -av * /go-trivia/
sudo docker build /go-trivia/frontend/. -t mraagil/trivia-frontend:prod
sudo docker build /go-trivia/backend/. -t mraagil/trivia-backend:prod
sudo docker push mraagil/trivia-backend:prod
sudo docker push mraagil/trivia-frontend:prod
cd /go-trivia/prod && make install frontendhpa=true backendhpa=true'