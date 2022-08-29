sudo rsync -av * /go-trivia/
sudo cd /go-trivia/frontend && make docker-push
sudo cd /go-trivia/backend && make docker-push
su ubuntu -c 'cd /go-trivia && make upgrade'