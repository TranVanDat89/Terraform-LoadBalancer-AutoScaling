#!/bin/bash -ex

# Update and install Apache
yum update -y
yum install -y httpd

# Wait to ensure everything is ready
sleep 5

# Start and enable Apache
systemctl start httpd
systemctl enable httpd

# Create simple web page
cd /var/www/html
echo "<html>" > index.html
echo "<h1 style='color:green;'>Welcome to Udemy instance - B</h1>" >> index.html
echo "<h4 style='color:red;'>You are running instance from this IP (For debug only!!!!Do not public this to user):</h4>" >> index.html

# Fetch instance metadata
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

echo "<br>Private IP: " >> index.html
curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/local-ipv4 >> index.html

echo "<br>Public IP: " >> index.html
curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/public-ipv4 >> index.html

echo "</html>" >> index.html
