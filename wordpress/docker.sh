MYSQLCONTAINERNAME=ksql
WPCONTAINERNAME=kwordpress

echo '1 - start docker-compose,
2 - stop docker-compose,
3 - to start container,
4 - to stop and delete container,
5 - to create wordpress and mysql backup, 
6 - to restore wordpress and mysql backup'
read option

if [ $option -eq '1' ]
then
    docker-compose -f stack.yml up -d

elif [ $option -eq '2' ]
then
    docker-compose -f stack.yml down

elif [ $option -eq '3' ]
then
    # my containers are running like this:
    docker run --name $MYSQLCONTAINERNAME -e MYSQL_ROOT_PASSWORD=789789 -d mysql:5.7
    docker run --name $WPCONTAINERNAME --link $MYSQLCONTAINERNAME:mysql -p 80:80 -d wordpress

elif [ $option -eq '4' ]
then
    docker container stop $MYSQLCONTAINERNAME
    docker container rm $MYSQLCONTAINERNAME

    docker container stop $WPCONTAINERNAME
    docker container rm $WPCONTAINERNAME
elif [ $option -eq '5' ]
then
    # https://github.com/docker-library/wordpress/issues/16
    # backup wordpress files:
    docker run --rm -it -v "$PWD/backups":/backups --volumes-from=$WPCONTAINERNAME busybox tar -c /var/www/html -f /backups/html.tar

    # backup mysql:
    docker run --rm -it -v "$PWD/backups":/backups --link=$MYSQLCONTAINERNAME:dz mysql sh -c 'mysqldump --host $DZ_PORT_3306_TCP_ADDR -u root --password=$DZ_ENV_MYSQL_ROOT_PASSWORD wordpress > /backups/wordpress.sql'
else
    # https://stackoverflow.com/questions/31475044/how-to-untar-rootfs-tar-gz-file-faster-or-with-multiple-threads-using-busybox-sh
    # retore backup wordpress files:
    docker run --rm -it -v "$PWD/backups":/backups --volumes-from=$WPCONTAINERNAME busybox tar xf /backups/html.tar -C /var/www/html

    # https://www.sitepoint.com/back-up-restore-wordpress-databases/
    # restore backup mysql:
    docker run --rm -it -v "$PWD/backups":/backups --link=$MYSQLCONTAINERNAME:dz mysql sh -c 'mysqldump --host $DZ_PORT_3306_TCP_ADDR -u root --password=$DZ_ENV_MYSQL_ROOT_PASSWORD wordpress < /backups/wordpress.sql'    
fi