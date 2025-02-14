How to run:
1. Create file "postgers.env" inside "task_5" directory, it should contain:

POSTGRES_PASSWORD="YOUR-PASSWORD"

This file is added to gitignore due to safety reasons.
1.1. Or "POSTGRES_PASSWORD_FILE" variable in compose file can be used instead
2. docker compose up -d

How to connect to DB:
Pre. You need to install postgresql client:
sudo apt-get install -y postgresql-client-16
Or another thing to connect.
1. psql -h localhost:5432 -U [THE NAME YOU USED IN "docker-compose.yml"]
2. Input password from "postgers.env"