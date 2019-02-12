chmod -R 0777 $(pwd)

CONTAINERNAME=orderbread-nodered

echo '1 - to start and 2 - to stop and delete container: '
read option

if [ $option -eq '1' ]
then
    # Create a new node red container
    # docker run -it -p 1880:1880 -e FLOWS=$(pwd)/my_flows.json --name CONTAINERNAME -d nodered/node-red-docker
    docker run -it -p 1880:1880 -v "$(pwd)/data":/data --name $CONTAINERNAME -d nodered/node-red-docker
    
    # Open a shell in the container
    docker exec -it $CONTAINERNAME bash -c "cd /data & npm install node-red-node-mongodb"

    # Restart the container to load the new nodes
    docker stop $CONTAINERNAME
    docker start $CONTAINERNAME
else
    docker container stop $CONTAINERNAME
    docker container rm $CONTAINERNAME
fi