How to run:
1. Create file "postgers.env" inside "task_2" directory, it should contain:

POSTGRES_PASSWORD="YOUR-PASSWORD"

This file is added to gitignore due to safety reasons.
1.1. Or "POSTGRES_PASSWORD_FILE" variable in compose file can be used instead
2. docker compose up -d

How to connect to ubuntu:
1. docker exec -it task_2-ubuntu-1 /bin/bash

How to connect from ubuntu to DB:
1. psql -h postgresql -U postgres
2. Input password from "postgers.env"