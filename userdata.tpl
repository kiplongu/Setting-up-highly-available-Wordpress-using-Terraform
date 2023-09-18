#!/bin/bash -e
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
cd /var/www/html
# set database details with perl find and replace
perl -pi -e "s/database_name_here/${db_name}/g" wp-config.php
perl -pi -e "s/username_here/${db_user}/g" wp-config.php
perl -pi -e "s/password_here/${db_pass}/g" wp-config.php
perl -pi -e "s/localhost/${db_host}/g" wp-config.php
#set WP salts
perl -i -pe'
  BEGIN {
    @chars = ("a" .. "z", "A" .. "Z", 0 .. 9);
    push @chars, split //, "!@#$%^&*()-_ []{}<>~\`+=,.;:/?|";
    sub salt { join "", map $chars[ rand @chars ], 1 .. 64 }
  }
  s/put your unique phrase here/salt()/ge
' wp-config.php

