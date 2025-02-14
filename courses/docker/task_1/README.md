How to build:
1. Open "task_1" directory in terminal
2. Execute:
docker build -t custom_nginx . 

How to run:
1. Execute:
docker run -d -p 8080:80 --rm --name custom_nginx_container custom_nginx
