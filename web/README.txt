Development commands


Backend
docker build --tag=snes-backend .
docker run -p 8000:8000 snes-backend

Frontend
docker build --tag=snes-frontend .
docker run -p 8080:80 snes-frontend

Delete old/dangling images
docker rmi -f (docker images -f "dangling=true" -q)
