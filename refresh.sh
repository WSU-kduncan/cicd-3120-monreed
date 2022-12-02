docker stop site
docker ps -a
docker rm site
docker ps -a
docker pull momankhoney/my-first-repo:latest
docker run -d --restart unless-stopped -p 8080:80 --name site momankhoney/my-first-repo

