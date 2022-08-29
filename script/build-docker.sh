sudo rsync -av * /go-trivia/
su ubuntu -c 'cd /go-trivia/frontend && make docker-push'
su ubuntu -c 'cd /go-trivia/backend && make docker-push'
su ubuntu -c 'cd /go-trivia && make uninstall && make install'