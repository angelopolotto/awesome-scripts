# shellcheck disable=SC2046

# Comando para gerar o container do banco de dados de teste
# Vale lembrar que os dados serão persistidos no volume: my-database
# Para ver todos os volumes do docker e mais, use:
# -> docker volume ls
# A porta utilizada é a padrão para o Postgres: 5432
# A senha é: postgres
docker run --name my-postgres -e "POSTGRES_PASSWORD=postgres" -p 5432:5432 -v my-database:/var/lib/postgresql/data -d --restart unless-stopped postgres:12.0-alpine

# Para parar o container use:
# -> docker container stop my-postgres

# Para remover para sempre use:
# -> docker container rm my-postgres

# Fontes:
# https://docs.docker.com/config/containers/start-containers-automatically/
# https://dzone.com/articles/demystifying-the-data-volume-storage-in-docker

# UTIL
# instalando Ubuntu Subsystem no Windows 10:
# https://docs.microsoft.com/pt-br/windows/wsl/install-win10?redirectedfrom=MSDN

# installing docker on linux subsystem Windows:
# https://medium.com/@sebagomez/installing-the-docker-client-on-ubuntus-windows-subsystem-for-linux-612b392a44c4
