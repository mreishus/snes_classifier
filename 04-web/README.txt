**Docker compose**

docker-compose up
docker-compose down

**Development commands**

Backend
docker build --tag=snes-backend .
docker run -p 8000:8000 snes-backend

Frontend
docker build --tag=snes-frontend .
docker run -p 8080:80 snes-frontend

Delete old/dangling images
docker rmi -f (docker images -f "dangling=true" -q)

Stop an image from autostarting on boot
docker update --restart=no web_backend_1

*** Upload to docker hub ****

docker build --tag=mreishus/snes-backend .
docker push mreishus/snes-backend

docker build --tag=mreishus/snes-frontend .
docker push mreishus/snes-frontend

