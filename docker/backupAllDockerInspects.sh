#!/bin/bash
# Create a backup of the inspect of all the container.
# Each inspect is saved in a separated JSON file. 

# create a dir for the backup 
DIR="$(pwd)/backupAllDockerInspects/$(date +%Y-%m-%dT%H:%M:%S)"

# https://stackoverflow.com/questions/793858/how-to-mkdir-only-if-a-dir-does-not-already-exist
mkdir -p $DIR

echo "Start saving containers inspects in the folder: "
echo $DIR
echo
echo "Container ID      Image       Name        Status"

# change IFS to only interate thru the new line (\n)
OLDIFS=$IFS
IFS=$'\n'
# filter only the info that is required
# https://docs.docker.com/engine/reference/commandline/ps/
for CONTAINER in $(docker ps -a --format '{{.ID}} {{.Image}} {{.Names}}')
do
        # format the input to get only the wantes fields
        ID=$(echo "$CONTAINER" | tr -s " " | cut -d" " -f1)
        IMAGE=$(echo "$CONTAINER" | tr -s " " | cut -d" " -f2)
        NAME=$(echo "$CONTAINER" | tr -s " " | cut -d" " -f3)
        
        # save the inspect in a file
        docker inspect $ID > $DIR/"$ID"_"$NAME".json
        
        # show the status
        echo "$ID       $IMAGE      $NAME       Saved!"
done
# retrieve the old IFS
IFS=$OLDIFS

echo "Containers inspect backup finished!"
echo "*** Everything that is good ends quickly ***"