#!/bin/bash
# Author:  leosin <leosin@qq.com>
#
# Notes: Wordpress Optmize Setup Shell for RDS
# Version:1.0.3
# Project home page:
#       http://www.deep-time.com
#       https://github.com/Deep-Time/dtwpos
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

cur_dir=`pwd`
WEBPATH="/www/web"

VHOSTDIR=""
read -p "输入站点目录名称，如(www_abc_com)：" VHOSTDIR
while ( [ ! -d "$WEBPATH/$VHOSTDIR" ] || [ "$VHOSTDIR" = "" ] )
do
    if [ ! -d "$WEBPATH/$VHOSTDIR" ];then
        read -p "目录不存在：" VHOSTDIR

    elif [ "$VHOSTDIR" = "" ];then
        read -p "您还没有输入站点名称：" VHOSTDIR

    fi
done
echo "===========================ok"

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

echo ""
echo "按任意键安装..."
char=`get_char`

cd $WEBPATH/$VHOSTDIR

#2 替换wordpress中的google字体
sed -i '/open_sans_font_url/ s/fonts.googleapis.com.*/oss.idzn.net\/fonts\/opensans.css\"\;/g' wp-includes/script-loader.php
sed -i '/scripts/ s/ajax.googleapis.com/oss.idzn.net/g' wp-includes/script-loader.php
sed -i '/oss.idzn.net/ s/https/http/g' wp-includes/script-loader.php


sed -i '/open_sans_font_url/ s/fonts.googleapis.com\/css/oss.idzn.net\/fonts\/opensans.css/g' wp-admin/includes/class-wp-press-this.php
sed -i '/oss.idzn.net/ s/https/http/g' wp-admin/includes/class-wp-press-this.php

sed -i 's/fonts.googleapis.com.*/oss.idzn.net\/fonts\/opensans.css\")\;/g' wp-includes/js/tinymce/plugins/compat3x/css/dialog.css
sed -i '/oss.idzn.net/ s/https/http/g' wp-includes/js/tinymce/plugins/compat3x/css/dialog.css


#3替换2015主题中的Google字体
sed -i 's/fonts.googleapis.com\/css/oss.idzn.net\/fonts\/opensans.css/g' wp-content/themes/twentyfifteen/functions.php
sed -i '/oss.idzn.net/ s/https/http/g' wp-content/themes/twentyfifteen/functions.php
sed -i '/return/ s/\$fonts_url\;/\;/g' wp-content/themes/twentyfifteen/functions.php


#4替换Revolution Slider v4.6.93中的Google字体
#

#5 替换Visual Composer v4.6.2 中的Google字体
#
sed -i 's/ajax.googleapis.com/oss.idzn.net/g' wp-content/plugins/js_composer/include/classes/editors/class-vc-backend-editor.php
sed -i 's/ajax.googleapis.com/oss.idzn.net/g' wp-content/plugins/js_composer/include/classes/editors/class-vc-frontend-editor.php
sed -i 's/fonts.googleapis.com.*.greek/oss.idzn.net\/fonts\/opensans.css/g' wp-content/plugins/js_composer/assets/css/js_composer_frontend_editor_iframe.min.css
sed -i 's/fonts.googleapis.com.*.greek/oss.idzn.net\/fonts\/opensans.css/g' wp-content/plugins/js_composer/assets/css/js_composer_frontend_editor.min.css
sed -i 's/fonts.googleapis.com.*.greek/oss.idzn.net\/fonts\/opensans.css/g'  wp-content/plugins/js_composer/assets/css/js_composer_backend_editor.min.css
sed -i 's/platform.twitter.com\/widgets.js/\//g' wp-content/plugins/js_composer/include/templates/pages/vc-welcome/index.php





find . -name "*.php" | xargs grep "googleapis.com"
find . -name "*.css" | xargs grep "googleapis.com"
find . -name "*.css" | xargs grep "platform.twitter.com"