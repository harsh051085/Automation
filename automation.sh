name=harsh
timestamp=$(date '+%d%m%Y-%H%M%S')
s3_bucket=upgrad-harsh05

sudo apt-get update
sudo apt-get install apache2
systemctl enable apache2.service
systemctl start apache2.service

sudo apt update
sudo apt install awscli


tar -zcvf $name-httpd-logs-$timestamp.tar.gz /var/log/apache2/*.log
echo “Tar succesful”

mv *.gz  /tmp
aws s3 cp /tmp/$name-httpd-logs-$timestamp.tar.gz s3://$s3_bucket
echo “File Transferred to S3 bucket”


cd /tmp/
size=$(du -sh * |awk 'END{print $1}')

echo $size


#Logic for checking file existence

file=$(ls /var/www/html/ | grep inven)

if  [ $file == inventory.html ]
then
echo “file exists”

else

(echo  $'Log Type \tDate Created \t Type \t Size' > /var/www/html/inventory.html)

fi

echo -e "httpd-logs      $timestamp  tar    $size" >> /var/www/html/inventory.html
