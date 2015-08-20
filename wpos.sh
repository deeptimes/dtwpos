#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
# Current folder
cur_dir=`pwd`

WPVER=""
read -p "输入wordpress版本号！例如4.2.2：" WPVER
if [ "$WPVER" = "" ]; then
    echo "版本号不能为空!"
    exit 1
else
echo "===========================ok"
fi

DB_NAME=""
read -p "输入数据库名：" DB_NAME
if [ "$DB_NAME" = "" ]; then
    echo "数据库名不能为空!"
    exit 1
else
echo "===========================ok"
fi

DB_USER=""
read -p "输入数据库用户名：" DB_USER
if [ "$DB_USER" = "" ]; then
    echo "数据库用户名不能为空!"
    exit 1
else
echo "===========================ok"
fi

DB_PASSWORD=""
read -p "输入数据库密码：" DB_PASSWORD
if [ "$DB_PASSWORD" = "" ]; then
    echo "数据库密码不能为空"
    exit 1
else
echo "===========================ok"
fi


MYSQL_CMD="mysql -u${DB_USER} -p${DB_PASSWORD}"
create_db_sql="create database IF NOT EXISTS ${DB_NAME}"
echo ${create_db_sql}  | ${MYSQL_CMD}
if [ $? -ne 0 ] #判断是否创建成功
then
 echo "创建数据库${DBNAME} 失败..."
 exit 1
fi


get_char()
{
SAVEDSTTY=`stty -g`
stty -echo
stty cbreak
dd if=/dev/tty bs=1 count=1 2> /dev/null
stty -raw
stty echo
stty $SAVEDSTTY
}

echo "==========================="
echo "Wordpress版本：$WPVER"
echo "数据库名是：$DB_NAME"
echo "数据库用户名是：$DB_USER"
echo "数据库密码是：$DB_PASSWORD"
echo "==========================="
echo ""
echo "按任意键安装..."
char=`get_char`

file_wp="wordpress-${WPVER}-zh_CN.tar.gz"
if [ -f $file_wp ]; then
echo "文件$file_wp已存在!开始解压......"
else
wget https://cn.wordpress.org/$file_wp
fi

tar zxf $file_wp
# rm -rf *.tar.gz
cd wordpress
rm -rf readme.html
rm -rf license.txt
rm -rf xmlrpc.php
rm -rf wp-cron.php
rm -rf wp-trackback.php
rm -rf wp-content/themes/twentyfourteen
rm -rf wp-content/themes/twentythirteen
rm -rf wp-content/plugins/hello.php
rm -rf wp-content/plugins/akismet
mv $cur_dir/dt_inc .

#6 修改wp配置文件
sed -i '/WP_ZH_CN_ICP_NUM/ s/true/false/g' wp-config-sample.php
sed -i '/table_prefix/ s/wp/dtwp/g' wp-config-sample.php
# 设置数据库名称
sed -i '/DB_NAME/ s/database_name_here/'$DB_NAME'/g' wp-config-sample.php
# 设置数据库用户名
sed -i '/DB_USER/ s/username_here/'$DB_USER'/g' wp-config-sample.php
# 设置密码
sed -i '/DB_PASSWORD/ s/password_here/'$DB_PASSWORD'/g' wp-config-sample.php
# 
# 
AUTH_KEY=`cat /dev/urandom | head -1 | md5sum | head -c 32`
SECURE_AUTH_KEY=`cat /dev/urandom | head -1 | md5sum | head -c 32`
LOGGED_IN_KEY=`cat /dev/urandom | head -1 | md5sum | head -c 32`
NONCE_KEY=`cat /dev/urandom | head -1 | md5sum | head -c 32`
AUTH_SALT=`cat /dev/urandom | head -1 | md5sum | head -c 32`
SECURE_AUTH_SALT=`cat /dev/urandom | head -1 | md5sum | head -c 32`
LOGGED_IN_SALT=`cat /dev/urandom | head -1 | md5sum | head -c 32`
NONCE_SALT=`cat /dev/urandom | head -1 | md5sum | head -c 32`

sed -i '/AUTH_KEY/ s/put your unique phrase here/'$AUTH_KEY'/g' wp-config-sample.php
sed -i '/SECURE_AUTH_KEY/ s/put your unique phrase here/'$SECURE_AUTH_KEY'/g' wp-config-sample.php
sed -i '/LOGGED_IN_KEY/ s/put your unique phrase here/'$LOGGED_IN_KEY'/g' wp-config-sample.php
sed -i '/NONCE_KEY/ s/put your unique phrase here/'$NONCE_KEY'/g' wp-config-sample.php
sed -i '/AUTH_SALT/ s/put your unique phrase here/'$AUTH_SALT'/g' wp-config-sample.php
sed -i '/SECURE_AUTH_SALT/ s/put your unique phrase here/'$SECURE_AUTH_SALT'/g' wp-config-sample.php
sed -i '/LOGGED_IN_SALT/ s/put your unique phrase here/'$LOGGED_IN_SALT'/g' wp-config-sample.php
sed -i '/NONCE_SALT/ s/put your unique phrase here/'$NONCE_SALT'/g' wp-config-sample.php


# 修改时区为PRC
sed -i '/date_default_timezone_set/ s/UTC/PRC/g' wp-settings.php
# 修改默认配置信息
sed -i '/mailserver_url/ s/mail.example.com//g' wp-admin/includes/schema.php
sed -i '/mailserver_login/ s/login@example.com//g' wp-admin/includes/schema.php
sed -i '/mailserver_pass/ s/password//g' wp-admin/includes/schema.php
sed -i '/mailserver_port/ s/110/0/g' wp-admin/includes/schema.php
sed -i '/ping_sites/ s/http:\/\/rpc.pingomatic.com\///g' wp-admin/includes/schema.php
sed -i '/use_smilies/ s/1/0/g' wp-admin/includes/schema.php
sed -i '/default_pingback_flag/ s/1/0/g' wp-admin/includes/schema.php
sed -i '/default_ping_status/ s/open/closed/g' wp-admin/includes/schema.php
sed -i '/default_comment_status/ s/open/closed/g' wp-admin/includes/schema.php
sed -i '/comment_registration/ s/0/1/g' wp-admin/includes/schema.php
sed -i '/comment_moderation/ s/0/1/g' wp-admin/includes/schema.php
sed -i '/show_avatars/ s/1/0/g' wp-admin/includes/schema.php
sed -i '/large_size_w/ s/1024/0/g' wp-admin/includes/schema.php
sed -i '/large_size_h/ s/1024/0/g' wp-admin/includes/schema.php
sed -i '/medium_size_w/ s/300/0/g' wp-admin/includes/schema.php
sed -i '/medium_size_h/ s/300/0/g' wp-admin/includes/schema.php
# 删掉Dashboard里的新闻板块
sed -i '/wp_dashboard_primary/ s/wp_add_dashboard_widget/\/\/wp_add_dashboard_widget/g' wp-admin/includes/dashboard.php



cat >> wp-config-sample.php <<EOF

#锁定网站域名
\$home='http://'.\$_SERVER['HTTP_HOST'];
\$siteurl='http://'.\$_SERVER['HTTP_HOST'];
define('WP_HOME', \$home);
define('WP_SITEURL', \$siteurl);
#关闭计划任务
define('DISABLE_WP_CRON', true);
#屏蔽日志修订功能
define('WP_POST_REVISIONS', false);
#屏蔽外部请求
define('WP_HTTP_BLOCK_EXTERNAL', true);
#设置白名单
define('WP_ACCESSIBLE_HOSTS', 'ping.baidu.com');
#禁止全部自动更新
define('AUTOMATIC_UPDATER_DISABLED', true);
EOF

mv wp-config-sample.php wp-config.php


#2 替换google字体
sed -i 's/\/ajax.googleapis.com/dt_inc/g' wp-includes/script-loader.php
sed -i '/googleapis/ s/\/fonts.googleapis.com.*\"/dt_inc\/fonts\/opensans.css\"/g' wp-includes/script-loader.php
sed -i '/import/ s/\/fonts.googleapis.com.*\;/dt_inc\/fonts\/opensans.css\);/g' wp-includes/js/tinymce/plugins/compat3x/css/dialog.css
sed -i '/import/ s/\/fonts.googleapis.com.*\;/dt_inc\/fonts\/opensans.css\);/g' wp-admin/css/press-this-editor-rtl.css
sed -i '/import/ s/\/fonts.googleapis.com.*\;/dt_inc\/fonts\/opensans.css\);/g' wp-admin/css/press-this-editor.css


#3替换2015主题中的Google字体
sed -i 's/\/fonts.googleapis.com/dt_inc\/fonts/g' wp-content/themes/twentyfifteen/functions.php
sed -i '/return/ s/\$fonts_url\;/\;/g' wp-content/themes/twentyfifteen/functions.php


#4替换Revolution Slider v4.6.93中的Google字体
#


#5 替换Visual Composer v4.6.2 中的Google字体
#




#7 设置站点文件权限
find . -type f -exec chmod 644 {} \;
find . -type d -exec chmod 755 {} \;
find wp-content/ -type f -exec chmod 664 {} \;
chown -R www:www .

echo "安装成功......"