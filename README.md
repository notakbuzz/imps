` GERRIT SETUP FOR UBUNTU 16.04 LTS





###################################################
/etc/apache/sites-availabe/000*.conf
###################################################

<VirtualHost *:80>
  ServerName cesiumos.me
  ProxyRequests Off
  ProxyVia Off
  ProxyPreserveHost On

  <Proxy *:80>
    Order deny,allow
    Allow from all
    # Use following line instead of the previous two on Apache >= 2.4
    # Require all granted
  </Proxy>

  AllowEncodedSlashes On
  ProxyPass / http://127.0.0.1:8080/ nocanon
</VirtualHost>







#################################################
gerrit.config
##################################################


[gerrit]
        basePath = git
        canonicalWebUrl = http://cesiumos.me/
        serverId = 2ecb2013-1fd8-4f39-83b3-93ac8b7e074c
[container]
        javaOptions = "-Dflogger.backend_factory=com.google.common.flogger.backend.log4j.Log4jBackendFactory#getInstance"
        javaOptions = "-Dflogger.logging_context=com.google.gerrit.server.logging.LoggingContext#getInstance"
        user = root
        javaHome = /usr/lib/jvm/java-8-openjdk-amd64/jre
[index]
        type = lucene
[auth]
        type = HTTP
        httpHeader = GITHUB_USER
        httpExternalIdHeader = GITHUB_OAUTH_TOKEN
        loginUrl = /login
        loginText = Sign-in with GitHub
        registerPageUrl = "/#/register"
[receive]
        enableSignedPush = true
[sendemail]
        smtpServer = smtp.gmail.com
        smtpServerPort = 587
        smtpEncryption = TLS
        smtpUser = himanshuakela@gmail.com
[sshd]
        listenAddress = *:29418
[httpd]
        listenUrl = http://*:8080/
        filterClass = com.googlesource.gerrit.plugins.github.oauth.OAuthFilter
[cache]
        directory = cache
[github]
        url = https://github.com
        apiUrl = https://api.github.com
        clientId = e875b5ad8c2d2e105eaa
[lfs]
        plugin = lfs
[lfs "?/*"]
        enabled = true
        maxObjectSize = 200 M
[avatar]
        url = https://github.com/avatars/%s.jpg
        changeUrl = https://github.com/account.html
        sizeParameter = s=${size}x${size}





#####################################
Apache libs enable
#####################################

[*] sudo a2enmod ssl
[*] sudo a2enmod proxy
[*] sudo a2enmod proxy_balancer
[*] sudo a2enmod proxy_http
[*] sudo service apache2 restart
[*] sudo a2enmod ssl
[*] sudo a2ensite default-ssl
[*] service apache2 reload
[*] sudo service apache2 reload
[*] sudo service apache2 restart
