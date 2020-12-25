                                              GERRIT SETUP FOR UBUNTU 16.04 LTS



# MAKE SURE TO READ A NOTE AT THE END!!!

################################
****packages required****
###############################
```bash
[*] sudo apt-get update && sudo apt-get upgrade && sudo apt-get install apache2 mysql-server openssh-server git-core openjdk-8-jdk gitweb git-review curl 
[*] wget https://gerrit-releases.storage.googleapis.com/gerrit-3.1.4.war (https://gerrit-releases.storage.googleapis.com/index.html)
[*] mkdir lib && mkdir plugins (https://gerrit-ci.gerritforge.com/) {github-oauth}
[*] java -jar gerrit-3.1.4.war init
[*] setup apache proxy & gerrit config
[*] java -jar gerrit-3.1.4.war reindex -d {gerrit_path}
[*] {gerrit_path}/bin/gerrit.sh start/restart/stop
[*] modify the All-Projects Access {refer ss attached in the repos}
[*] change branch HEAD for each repo
[*] add webhookSecret in secret.config  {git password}

[*] open port in vpc [gmail~in-out] 25, 465, 587, [in] 8080, 29418
```




#############################
****/etc/apache/sites-availabe/000*.conf****
################################
```bash
<VirtualHost *:80>
  ServerName freakyos.xyz
  ProxyRequests Off
  ProxyVia Off
  ProxyPreserveHost On

  <Proxy *:80>
    Order deny,allow
    Allow from all
    # Use following line instead of the previous two on Apache >= 2.4
    # Require all granted
  </Proxy>

  <Location https://github.com/>
    AuthType Basic
    AuthName "Git"
    Require valid-user
  </Location>

  AllowEncodedSlashes On
  ProxyPass / http://127.0.0.1:8080/ nocanon
  ProxyPassReverse / http://127.0.0.1:8080/
</VirtualHost>
```




#################################################
****gerrit.config****
##################################################

```bash
[gerrit]
        basePath = git
        canonicalWebUrl = http://freakyos.xyz/
        serverId = 52305d8f-5d5a-4b15-9a96-2f03c7c153c6
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
        logoutUrl = http://oauth.reset@freakyos.xyz/
        loginText = Sign-in with GitHub
        registerPageUrl = "/#/register"
[receive]
        enableSignedPush = true
[sendemail]
        enable = true
        smtpServer = smtp.gmail.com
        smtpServerPort = 587
        smtpEncryption = TLS
        smtpUser = himanshuakela@gmail.com
[sshd]
        listenAddress = *:29418
[httpd]
        listenUrl = proxy-http://*:8080/
        filterClass = com.googlesource.gerrit.plugins.github.oauth.OAuthFilter
[cache]
        directory = cache
[github]
        url = https://github.com
        apiUrl = https://api.github.com
        clientId = c2b1cac0d2a9495975b7
        webhookUser = bunnyyTheFreak
        scopes = USER_EMAIL,REPO,READ_ORG
        wizardFlow = account.gh => repositories.html
        wizardFlow = repositories-next.gh => pullrequests.html
        wizardFlow = pullrequests-next.gh R> / #/admin/projects/
[lfs]
        plugin = lfs
[lfs "?/*"]
        enabled = true
        maxObjectSize = 500 M
[plugin "avatars-external"]
        url = https://github.com/${user}.png
[plugins]
    allowRemoteAdmin = true
[plugin "verify-status"]
        dbType = h2
        database = /home/himanshusinghal780/db/CiDB
```


#####################################
****secret.config**** //nibba copy and hack us!! >:D
#####################################

```bash
[auth]
        registerEmailPrivateKey = ******
[sendemail]
        smtpPass = *****
[github]
        webhookSecret = *****
        clientSecret = *****
[remote "bunnyyTheFreak"]
        username = bunnyyTheFreak
        password = *******
```



#####################################
****replication.config**** //just for reference!!
#####################################

```bash
[remote "bunnyyTheFreak"]
        url = https://github.com/${name}.git
        projects = FreakyOS/packages_apps_MusicFX
        projects = FreakyOS/packages_apps_Messaging
        projects = FreakyOS/packages_apps_FMRadio
        projects = FreakyOS/packages_apps_ExactCalculator
        projects = FreakyOS/manifest
        projects = FreakyOS/system_core
        projects = FreakyOS/packages_apps_Contacts
        projects = FreakyOS/vendor_freaky
        projects = FreakyOS/frameworks_base
        projects = FreakyOS/hardware_custom_interfaces
        projects = FreakyOS/official_devices
        projects = FreakyOS/system_netd
        projects = FreakyOS/packages_apps_FreakyGraveyard
        projects = FreakyOS/ota_config
        projects = FreakyOS/device_custom_sepolicy
        projects = FreakyOS/build_soong
        projects = FreakyOS/external_airbnb-lottie
        projects = FreakyOS/system_sepolicy
        projects = FreakyOS/packages_apps_WallBucket
        projects = FreakyOS/system_bt
        projects = FreakyOS/packages_apps_Updater
        projects = FreakyOS/build
        projects = FreakyOS/frameworks_opt_telephony
        projects = FreakyOS/hardware_qcom-caf_msm8952_media
        projects = FreakyOS/hardware_qcom-caf_msm8952_display
        projects = FreakyOS/hardware_qcom-caf_msm8952_audio
        projects = FreakyOS/frameworks_native
        projects = FreakyOS/packages_services_Telecomm
        projects = FreakyOS/packages_apps_Snap
        projects = FreakyOS/packages_apps_DeskClock
        projects = FreakyOS/packages_apps_Dialer
        projects = FreakyOS/frameworks_av
        projects = FreakyOS/packages_services_Telephony
        projects = FreakyOS/external_skia
        projects = FreakyOS/packages_apps_Settings
        projects = FreakyOS/FreakySite
        projects = FreakyOS/packages_apps_OmniStyle
        projects = FreakyOS/ota_config
        projects = FreakyOS/packages_apps_OmniStyle
        projects = FreakyOS/packages_apps_WallBucket
        push = refs/*:refs/*
        rescheduleDelay = 15
```


#####################################
****Apache libs enable****
#####################################

```bash
[*] sudo a2enmod ssl
[*] sudo a2enmod proxy
[*] sudo a2enmod proxy_balancer
[*] sudo a2enmod proxy_http
[*] sudo a2enmod ssl
[*] sudo a2ensite default-ssl
[*] sudo service apache2 reload
[*] sudo service apache2 restart
[*] sudo systemctl start apache2 {start/restart/status}
[*] sudo systemctl enable apache2
```

 
##################################
****Domain Configs****
##################################
```bash
- Point DNS Nameservers to the {machine_ip}. #cloudflare
- Set firewall rule for port 8080 & 29418 in Gcloud (VPC Console). {http & ssh ports} 
- Set hostname for the Gcloud server as the {host_server_name}. #cesiumos.me
```




##############################
****Plugins**** //completely upom the user which plugins to add!!
###############################

```bash
$ wget https://gerrit-ci.gerritforge.com/view/Plugins-stable-3.1/job/plugin-account-bazel-stable-3.1/lastSuccessfulBuild/artifact/bazel-bin/plugins/account/account.jar
$ wget https://gerrit-ci.gerritforge.com/view/Plugins-stable-3.1/job/plugin-admin-console-bazel-master-stable-3.1/lastSuccessfulBuild/artifact/bazel-bin/plugins/admin-console/admin-console.jar
$ wget https://gerrit-ci.gerritforge.com/view/Plugins-stable-3.1/job/plugin-analytics-sbt-stable-3.1/lastSuccessfulBuild/artifact/target/scala-2.11/analytics.jar
$ wget https://gerrit-ci.gerritforge.com/view/Plugins-stable-3.1/job/plugin-avatars-external-bazel-master-stable-3.1/lastSuccessfulBuild/artifact/bazel-bin/plugins/avatars-external/avatars-external.jar
$ wget https://gerrit-ci.gerritforge.com/view/Plugins-stable-3.1/job/plugin-changemessage-bazel-master-stable-3.1/lastSuccessfulBuild/artifact/bazel-bin/plugins/changemessage/changemessage.jar
$ weget https://gerrit-ci.gerritforge.com/view/Plugins-stable-3.1/job/plugin-events-log-bazel-stable-3.1/lastSuccessfulBuild/artifact/bazel-bin/plugins/events-log/events-log.jar
$ wget https://gerrit-ci.gerritforge.com/view/Plugins-stable-3.1/job/plugin-events-log-bazel-stable-3.1/lastSuccessfulBuild/artifact/bazel-bin/plugins/events-log/events-log.jar
$ wget https://gerrit-ci.gerritforge.com/view/Plugins-stable-3.1/job/plugin-go-import-bazel-stable-3.1/lastSuccessfulBuild/artifact/bazel-bin/plugins/go-import/go-import.jar 
$ wget https://gerrit-ci.gerritforge.com/view/Plugins-stable-3.1/job/plugin-healthcheck-bazel-stable-3.1/lastSuccessfulBuild/artifact/bazel-bin/plugins/healthcheck/healthcheck.jar
$ wget https://gerrit-ci.gerritforge.com/view/Plugins-stable-3.1/job/plugin-its-base-bazel-stable-3.1/lastSuccessfulBuild/artifact/bazel-bin/plugins/its-base/its-base.jar
$ wget https://gerrit-ci.gerritforge.com/view/Plugins-stable-3.1/job/plugin-lfs-bazel-stable-3.1/lastSuccessfulBuild/artifact/bazel-bin/plugins/lfs/lfs.jar
$ wget https://gerrit-ci.gerritforge.com/view/Plugins-stable-3.1/job/plugin-log-level-bazel-stable-3.1/lastSuccessfulBuild/artifact/bazel-bin/plugins/log-level/log-level.jar
$ wget https://gerrit-ci.gerritforge.com/view/Plugins-stable-3.1/job/plugin-login-redirect-bazel-master-stable-3.1/lastSuccessfulBuild/artifact/bazel-bin/plugins/login-redirect/login-redirect.jar
$ wget https://gerrit-ci.gerritforge.com/view/Plugins-stable-3.1/job/plugin-messageoftheday-bazel-master-stable-3.1/lastSuccessfulBuild/artifact/bazel-bin/plugins/messageoftheday/messageoftheday.jar
$ wget https://gerrit-ci.gerritforge.com/view/Plugins-stable-3.1/job/plugin-motd-bazel-master-stable-3.1/lastSuccessfulBuild/artifact/bazel-bin/plugins/motd/motd.jar
$ wget https://gerrit-ci.gerritforge.com/view/Plugins-stable-3.1/job/plugin-multi-site-bazel-stable-3.1/lastSuccessfulBuild/artifact/bazel-bin/plugins/multi-site/multi-site.jar
$ wget https://gerrit-ci.gerritforge.com/view/Plugins-stable-3.1/job/plugin-out-of-the-box-bazel-master-stable-3.1/lastSuccessfulBuild/artifact/bazel-bin/plugins/out-of-the-box/out-of-the-box.jar
$ wget https://gerrit-ci.gerritforge.com/view/Plugins-stable-3.1/job/plugin-owners-bazel-stable-3.1/lastSuccessfulBuild/artifact/bazel-bin/plugins/owners/owners.jar
$ wget https://gerrit-ci.gerritforge.com/view/Plugins-stable-3.1/job/plugin-owners-bazel-stable-3.1/lastSuccessfulBuild/artifact/bazel-bin/plugins/owners/owners-autoassign.jar
$ wget https://gerrit-ci.gerritforge.com/view/Plugins-stable-3.1/job/plugin-pull-replication-bazel-stable-3.1/lastSuccessfulBuild/artifact/bazel-bin/plugins/pull-replication/pull-replication.jar
$ wget https://gerrit-ci.gerritforge.com/view/Plugins-stable-3.1/job/plugin-quota-bazel-master-stable-3.1/lastSuccessfulBuild/artifact/bazel-bin/plugins/quota/quota.jar
$ wget https://gerrit-ci.gerritforge.com/view/Plugins-stable-3.1/job/plugin-rate-limiter-bazel-stable-3.1/lastSuccessfulBuild/artifact/bazel-bin/plugins/rate-limiter/rate-limiter.jar
$ wget https://gerrit-ci.gerritforge.com/view/Plugins-stable-3.1/job/plugin-rename-project-bazel-stable-3.1/lastSuccessfulBuild/artifact/bazel-bin/plugins/rename-project/rename-project.jar
$ wget https://gerrit-ci.gerritforge.com/view/Plugins-stable-3.1/job/plugin-reviewers-bazel-stable-3.1/lastSuccessfulBuild/artifact/bazel-bin/plugins/reviewers/reviewers.jar
$ wget https://gerrit-ci.gerritforge.com/view/Plugins-stable-3.1/job/plugin-secure-config-bazel-stable-3.1/lastSuccessfulBuild/artifact/bazel-bin/plugins/secure-config/secure-config.jar
$ wget https://gerrit-ci.gerritforge.com/view/Plugins-stable-3.1/job/plugin-serviceuser-bazel-stable-3.1/lastSuccessfulBuild/artifact/bazel-bin/plugins/serviceuser/serviceuser.jar
$ wget https://gerrit-ci.gerritforge.com/view/Plugins-stable-3.1/job/plugin-task-bazel-master-stable-3.1/lastSuccessfulBuild/artifact/bazel-bin/plugins/task/task.jar
$ wget https://gerrit-ci.gerritforge.com/view/Plugins-stable-3.1/job/plugin-uploadvalidator-bazel-master-stable-3.1/lastSuccessfulBuild/artifact/bazel-bin/plugins/uploadvalidator/uploadvalidator.jar
$ wget https://gerrit-ci.gerritforge.com/view/Plugins-stable-3.1/job/plugin-websession-broker-bazel-stable-3.1/lastSuccessfulBuild/artifact/bazel-bin/plugins/websession-broker/websession-broker.jar
```







!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

# MAKE SURE TO STOP GERRIT SERVICE BEFORE MAKING ANY CHANGES ELSE IT'D BREAK!!               ###NOTE###

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

# '#' refers to comment/examples
