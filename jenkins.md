
# apache config
<Virtualhost *:80>
    ServerName        jenkins.freakyos.xyz
    ProxyRequests     Off
    ProxyPreserveHost On
    AllowEncodedSlashes NoDecode
 
    <Proxy http://34.72.84.233:8080/*>
      Order deny,allow
      Allow from all
    </Proxy>
 
    ProxyPass         /  http://34.72.84.233:8080/ nocanon
    ProxyPassReverse  /  http://34.72.84.233:8080/
    ProxyPassReverse  /  http://jenkins.freakyos.xyz/
</Virtualhost>

# add a TYPE A record in the DNS resolver, under the name of the sub domain. (just the name not the entire url)


##
sudo a2enmod proxy
sudo a2enmod proxy_http
sudo service apache2 restart
