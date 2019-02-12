chmod -R 0777 $(pwd)

CONTAINERNAME=orderbread-mongo

echo '1 - to start and 2 - to stop and delete container: '
read option

if [ $option -eq '1' ]
then
    docker run --name $CONTAINERNAME -v "$(pwd)/db":/data/db -p 27017:27017 -d mongo:3.6.9
    docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $CONTAINERNAME
else
    docker container stop $CONTAINERNAME
    docker container rm $CONTAINERNAME
fi