#!/bin/sh
#
# Author: leosin<leosin@qq.com>
# Notes: Wordpress Optmize Setup Shell for LNMP
# Version:2016/03/13
# Project home page: https://github.com/Deep-Time/dtwpos


export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/mysql/bin
clear
printf "
#######################################################################
#      Wordpress Optmize Setup Shell for LNMP                         #
#      https://github.com/Deep-Time/dtwpos                            #
#######################################################################
"
# 设置文字颜色
echo=echo
for cmd in echo /bin/echo; do
  $cmd >/dev/null 2>&1 || continue
  if ! $cmd -e "" | grep -qE '^-e'; then
    echo=$cmd
    break
  fi
done
CSI=$($echo -e "\033[")
CEND="${CSI}0m"
CDGREEN="${CSI}32m"
CRED="${CSI}1;31m"
CGREEN="${CSI}1;32m"
CYELLOW="${CSI}1;33m"
CBLUE="${CSI}1;34m"
CMAGENTA="${CSI}1;35m"
CCYAN="${CSI}1;36m"
CSUCCESS="$CGREEN"
CFAILURE="$CRED"
CQUESTION="$CMAGENTA"
CWARNING="$CYELLOW"
CMSG="$CCYAN"

# 设置路径与变量
cur_dir=`pwd`
WEBPATH="/www/web"
DATAPATH="/www/data/mysql"
RDS="deeptime.mysql.rds.aliyuncs.com"
VHOSTDIR=""
DB_HOST=""
DB_NAME=""
DB_USER=""
DB_PASSWORD=""
LANG=""
WPVER=""

# Check if user is root
[ $(id -u) != "0" ] && { echo "${CFAILURE}Error: You must be root to run this script${CEND}"; exit 1; }


# 语言选择 ====================================================================================
while :
echo '请选择语言版本:'
echo -e "\t${CMSG}1${CEND}. 中文版"
echo -e "\t${CMSG}2${CEND}. 英文版"
do
  read -p "请选择对应数字(默认为1,回车即可)：" LANG
  [ -z "$LANG" ] && LANG=1
  if [ $LANG != 1 -a $LANG != 2 ];then
    echo "${CWARNING}输入错误，请输入1或2${CEND}"
  else
    break
  fi
done

# 版本选择 ====================================================================================
if [ "$LANG" == '1' ];then
  echo
  echo "${CSUCCESS}您已选择中文版${CEND}"
  echo
  read -p "请填写wordpress-${CMSG}x${CEND}.${CMSG}x${CEND}.${CMSG}xx${CEND}-zh_CN.tar.gz对应的版本号${CMSG}x${CEND},(如4.4.2)：" WPVER
  wp_file="$cur_dir/wordpress-${WPVER}-zh_CN.tar.gz"
  wp_install="http://cn.wordpress.org/wordpress-${WPVER}-zh_CN.tar.gz"
  while ( [ "$WPVER" = "" ] || [ ! -f "$wp_file" ] )
  do
    if [ "$WPVER" = "" ];then
      read -p "${CWARNING}您还没有输入版本号! ：${CEND}" WPVER
    elif [ ! -f "$wp_file" ];then
      # read -p "${CWARNING}当前目录没有您要的版本! ：${CEND}" WPVER
      echo "${CWARNING}当前目录没有$WPVER的中文版本，稍后会自动下载...${CEND}"
      break
    fi
  done
  echo
  echo "${CSUCCESS}即将安装$wp_file${CEND}"
  echo
elif [ "$LANG" == '2' ];then
  echo
  echo "${CSUCCESS}您已选择英文版${CEND}"
  echo
  read -p "请填写wordpress-${CMSG}x${CEND}.${CMSG}x${CEND}.${CMSG}xx${CEND}.tar.gz对应的版本号${CMSG}x${CEND},(如4.4.2,回车为最新版)：" WPVER
  wp_file="$cur_dir/wordpress-${WPVER}.tar.gz"
  wp_install="http://wordpress.org/wordpress-${WPVER}.tar.gz"
  while ( [ "$WPVER" = "" ] || [ ! -f "$wp_file" ] )
  do
    if [ "$WPVER" = "" ];then
      wp_install="http://wordpress.org/latest.tar.gz"
      wp_file="latest.tar.gz"
      echo "将下载最新英文版本"
      break
    elif [ ! -f "$wp_file" ];then
      # read -p "${CWARNING}当前目录没有您要的版本!：${CEND}" WPVER
      echo "${CWARNING}当前目录没有$WPVER的英文版本，稍后会自动下载...${CEND}"
      break
    fi
  done
  echo
  echo "${CSUCCESS}即将安装$wp_file${CEND}"
  echo
fi

# 设置站点目录 ====================================================================================
echo "请输入站点目录名称！"
read -p "默认位置相对于${CCYAN}$WEBPATH/" VHOSTDIR
while ( [ ! -d "$WEBPATH/$VHOSTDIR" ] || [ "$VHOSTDIR" = "" ] || [ "`ls -A $WEBPATH/$VHOSTDIR`" != "" ] )
do
  if [ ! -d "$WEBPATH/$VHOSTDIR" ];then
    mkdir -p $WEBPATH/$VHOSTDIR
    echo
    echo "${CFAILURE}目录不存在!自动创建 $VHOSTDIR目录${CEND}"
    # echo "${CSUCCESS}已在$WEBPATH/下创建创建${CWARNING}$VHOSTDIR${CEND}${CSUCCESS}目录${CEND}"
  elif [ "$VHOSTDIR" = "" ];then
    read -p "${CWARNING}您还没有输入站点名称：${CEND}" VHOSTDIR
  elif [ -d "$WEBPATH/$VHOSTDIR/wp-content" ];then
    read -p "${CWARNING}此目录已按装过wordperss：${CEND}" VHOSTDIR
  fi
done
echo
echo "${CSUCCESS}目录$WEBPATH/$VHOSTDIR设置完毕！${CEND}"

# 设置数据库名称 ====================================================================================
while :
echo
echo "${CEND}请选择数据库服务器："
echo -e "\t${CMSG}1${CEND}. 本地服务器"
echo -e "\t${CMSG}2${CEND}. 远程服务器"
do
  read -p "请选择对应数字(默认为1,回车即可)：" DB_HOST
  [ -z "$DB_HOST" ] && DB_HOST=1
  if [ $DB_HOST != 1 -a $DB_HOST != 2 ];then
    echo "${CWARNING}输入错误，请输入1或2${CEND}"
  else
    break
  fi
done

# 判断远程或本地主机
if [ "$DB_HOST" == '1' ];then
  DB_HOST=localhost
# 设置本地数据库名称
  while :
  do
    echo
    read -p "输入数据库名：" DB_NAME
    if [ -d "$DATAPATH/$DB_NAME" ] || [ "$DB_NAME" = "" ];then
        echo "${CWARNING}数据库已存在,请重新输入${CEND}"
    else
        break
    fi
  done
# 设置本地数据库用户名
  while :
  do
    echo
    read -p "输入数据库用户名：" DB_USER
    if [ "$DB_USER" = "" ];then
        echo "${CWARNING}用户名不能为空,请重新输入${CEND}"
    else
        break
    fi
    break
  done
# 设置本地数据库密码
  while :
  do
    echo
    read -p "输入数据库密码：" DB_PASSWORD
    if [ "$DB_PASSWORD" = "" ];then
        echo "${CWARNING}密码不能为空,请重新输入${CEND}"
    else
        break
    fi
    break
  done
# 创建本地数据库
  MYSQL_CMD="mysql -u${DB_USER} -p${DB_PASSWORD} -h${DB_HOST}" #数据库登录信息
  create_db_sql="create database IF NOT EXISTS ${DB_NAME}" #如果数据库不存在则创建
  echo ${stop_create}${create_db_sql} | ${MYSQL_CMD} #创建数据库
  if [ $? -ne 0 ] #判断是否创建成功
    then
    echo "${CFAILURE}创建数据库 ${DB_NAME} 失败 ...${CEND}"
    exit 1
  fi
elif [ "$DB_HOST" == '2' ];then
  DB_HOST=$RDS
  echo
  echo "${CMSG}请到RDS的控制台手动创建数据库先...${CEND}"
# 设置远程数据库主机地址
  echo
  read -p "填写远程数据库主机地址(默认$RDS)：" DB_HOST
  [ -z "$DB_HOST" ] && DB_HOST=$RDS
# 设置远程数据库名称
  while :
  do
    echo
    read -p "填写已创建的远程数据库名：" DB_NAME
    if [ "$DB_NAME" = "" ];then
        echo "${CWARNING}远程数据库名称不能为空,请重新输入${CEND}"
    else
        break
    fi
  done
# 设置远程数据库用户名
  while :
  do
    echo
    read -p "填写远程数据库用户名：" DB_USER
    if [ "$DB_USER" = "" ];then
        echo "${CWARNING}用户名不能为空,请重新输入${CEND}"
    else
        break
    fi
    break
  done
# 设置远程数据库密码
  while :
  do
    echo
    read -p "填写远程数据库密码：" DB_PASSWORD
    if [ "$DB_PASSWORD" = "" ];then
        echo "${CWARNING}密码不能为空,请重新输入${CEND}"
    else
        break
    fi
    break
  done
fi

get_char(){
  SAVEDSTTY=`stty -g`
  stty -echo
  stty cbreak
  dd if=/dev/tty bs=1 count=1 2> /dev/null
  stty -raw
  stty echo
  stty $SAVEDSTTY
}

echo
echo "*********************************"
echo "*  Wordpress版本：${CMSG}$WPVER${CEND}"
echo "*  站点目录名称：${CMSG}$WEBPATH/$VHOSTDIR${CEND}"
echo "*  数据库主机地址：${CMSG}$DB_HOST${CEND}"
echo "*  数据库名称：${CMSG}$DB_NAME${CEND}"
echo "*  数据库用户名：${CMSG}$DB_USER${CEND}"
echo "*  数据库密码：${CMSG}$DB_PASSWORD${CEND}"
echo "*********************************"
echo
echo "按任意键安装..."
char=`get_char`

Optimization(){
tar zxf $wp_file
cd wordpress
rm -rf readme.html
rm -rf license.txt
rm -rf wp-content/themes/twentythirteen
rm -rf wp-content/themes/twentyfourteen
rm -rf wp-content/themes/twentyfifteen
rm -rf wp-content/plugins/hello.php
rm -rf wp-content/plugins/akismet

# 修改wp配置文件
echo
echo "${CMSG}********** 修改WordPress基础配置文件wp-config.php **********${CEND}"
echo "${CMSG}*${CEND}"
echo "${CMSG}*${CEND} 移除ICP备案栏"
echo "${CMSG}*${CEND} 设置数据库表前缀=dtwp"
echo "${CMSG}*${CEND} 屏蔽日志修订"
echo "${CMSG}*${CEND} 禁用自动保存"
echo "${CMSG}*${CEND} 关闭计划任务"
echo "${CMSG}*${CEND} 禁止全部自动更新"
echo "${CMSG}*${CEND} 禁用主题编辑功能"
echo "${CMSG}*${CEND} 禁用后台主题上传安装功能"
echo "${CMSG}*${CEND} 屏蔽外部请求"
echo "${CMSG}*${CEND} 设置白名单*.w.org和*.wordpress.org"
echo "${CMSG}*${CEND} 锁定网站域名"
# 移除ICP备案栏
sed -i '/WP_ZH_CN_ICP_NUM/ s/true/false/g' wp-config-sample.php
# 设置数据库表前缀=dtwp
sed -i '/table_prefix/ s/wp/dtwp/g' wp-config-sample.php
# 设置数据库名称
sed -i '/DB_NAME/ s/database_name_here/'$DB_NAME'/g' wp-config-sample.php
# 设置数据库用户名
sed -i '/DB_USER/ s/username_here/'$DB_USER'/g' wp-config-sample.php
# 设置密码
sed -i '/DB_PASSWORD/ s/password_here/'$DB_PASSWORD'/g' wp-config-sample.php
# 设置数据库主机
sed -i '/DB_HOST/ s/localhost/'$DB_HOST'/g' wp-config-sample.php
# 创建身份认证密钥
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

cat > wp-config-custom.tmp <<EOF
# ========================自.定.义.开.始=================================
#
define('WP_POST_REVISIONS', false); # 屏蔽日志修订
define('AUTOSAVE_INTERVAL', false); # 禁用自动保存
define('DISABLE_WP_CRON', true); # 关闭计划任务
define('AUTOMATIC_UPDATER_DISABLED', true); # 禁止全部自动更新
define('DISALLOW_FILE_EDIT', true); # 禁用主题编辑功能
define('DISALLOW_FILE_MODS',true); # 禁用后台主题上传安装功能
define('WP_HTTP_BLOCK_EXTERNAL', true); # 屏蔽外部请求
define('WP_ACCESSIBLE_HOSTS', '*.w.org,*.wordpress.org'); # 设置白名单
# 锁定网站域名
\$home='http://'.\$_SERVER['HTTP_HOST'];
\$siteurl='http://'.\$_SERVER['HTTP_HOST'];
define('WP_HOME', \$home);
define('WP_SITEURL', \$siteurl);
#
# ========================自.定.义.结.束=================================
EOF
sed -i '/#@-/r wp-config-custom.tmp' wp-config-sample.php
rm -f wp-config-custom.tmp
mv wp-config-sample.php wp-config.php

echo "${CMSG}*${CEND}"
echo "${CMSG}****************** 修改wordpress默认参数 ******************${CEND}"
echo "${CMSG}*${CEND}"
echo "${CMSG}*${CEND} 修改默认配置信息移除撰写设置页的无用信息"
sed -i '/mailserver_url/ s/mail.example.com//g' wp-admin/includes/schema.php
sed -i '/mailserver_login/ s/login@example.com//g' wp-admin/includes/schema.php
sed -i '/mailserver_pass/ s/password//g' wp-admin/includes/schema.php
sed -i '/mailserver_port/ s/110/0/g' wp-admin/includes/schema.php
sed -i '/ping_sites/ s/http:\/\/rpc.pingomatic.com\///g' wp-admin/includes/schema.php
sed -i '/use_smilies/ s/1/0/g' wp-admin/includes/schema.php
echo "${CMSG}*${CEND} [×]：尝试通知文章中链接的博客"
sed -i '/default_pingback_flag/ s/1/0/g' wp-admin/includes/schema.php
echo "${CMSG}*${CEND} [×]：允许其他博客发送链接通知（pingback和trackback）到新文章"
sed -i '/default_ping_status/ s/open/closed/g' wp-admin/includes/schema.php
echo "${CMSG}*${CEND} [×]：允许他人在新文章上发表评论"
sed -i '/default_comment_status/ s/open/closed/g' wp-admin/includes/schema.php
echo "${CMSG}*${CEND} [√]：用户必须注册并登录才可以发表评论"
sed -i '/comment_registration/ s/0/1/g' wp-admin/includes/schema.php
sed -i '/comment_moderation/ s/0/1/g' wp-admin/includes/schema.php
echo "${CMSG}*${CEND} [×]：默认不显示头像"
sed -i '/show_avatars/ s/1/0/g' wp-admin/includes/schema.php
echo "${CMSG}*${CEND} 默认缩略图 大图,中图尺寸设为0"
sed -i '/large_size_w/ s/1024/0/g' wp-admin/includes/schema.php
sed -i '/large_size_h/ s/1024/0/g' wp-admin/includes/schema.php
sed -i '/medium_size_w/ s/300/0/g' wp-admin/includes/schema.php
sed -i '/medium_size_h/ s/300/0/g' wp-admin/includes/schema.php
echo "${CMSG}*${CEND}"
echo "${CMSG}*${CEND} 删掉Dashboard里的新闻板块"
sed -i '/wp_dashboard_primary/ s/wp_add_dashboard_widget/\/\/wp_add_dashboard_widget/g' wp-admin/includes/dashboard.php
echo "${CMSG}*${CEND} 修改时区为PRC"
sed -i '/date_default_timezone_set/ s/UTC/PRC/g' wp-settings.php
echo "${CMSG}*${CEND} 设置站点文件权限"
find . -type f -exec chmod 644 {} \;
find . -type d -exec chmod 755 {} \;
find wp-content/ -type f -exec chmod 664 {} \;
chown -R www:www .
echo "${CMSG}*${CEND}"
echo "${CMSG}******************** 修改默认配置结束 ********************${CEND}"
}

# 执行优化脚本
if [ -f "$wp_file" ]; then
echo
echo "文件$wp_file已存在!开始解压......"
else
  wget $wp_install
  echo
  echo "即将下载......"
fi


if [ -f "$wp_file" ]; then
  Optimization 2>&1 | tee -a $cur_dir/install.log
else
  break
fi

# 判断文件是否存在并移动文件到虚拟主机目录
if [ -f "$cur_dir/wordpress/wp-config.php" ]; then
  echo
  echo "${CSUCCESS}移动文件到虚拟主机目录 - 成功${CEND}"
  mv $cur_dir/wordpress/* $WEBPATH/$VHOSTDIR
  rm -rf $cur_dir/wordpress
else
  echo
  echo "${CFAILURE}移动文件到虚拟主机目录 - 失败${CEND}"
  break
fi


# 安装完毕测试是否成功
if [ -f "$WEBPATH/$VHOSTDIR/wp-config.php" ]; then
  echo
  echo "${CSUCCESS}优化后的wordpress安装成功...${CEND}"
  echo
else
  echo
  echo "${CFAILURE}优化后的wordpress安装失败...${CEND}"
  echo
fi
# End