********** 修改WordPress基础配置文件wp-config.php **********
*
* 移除ICP备案栏
* 设置数据库表前缀=dtwp
* 屏蔽日志修订
* 禁用自动保存
* 关闭计划任务
* 禁止全部自动更新
* 禁用主题编辑功能
* 禁用后台主题上传安装功能
* 屏蔽外部请求
* 设置白名单*.w.org和*.wordpress.org
* 锁定网站域名
*
****************** 修改wordpress默认参数 ******************
*
* 修改默认配置信息移除撰写设置页的无用信息
* [×]：尝试通知文章中链接的博客
* [×]：允许其他博客发送链接通知（pingback和trackback）到新文章
* [×]：允许他人在新文章上发表评论
* [√]：用户必须注册并登录才可以发表评论
* [×]：默认不显示头像
* 默认缩略图 大图,中图尺寸设为0
*
* 删掉Dashboard里的新闻板块
* 修改时区为PRC
* 设置站点文件权限
*

## 使用说明
进入你的虚拟主机的目录后按下面方式执行  

    wget https://github.com/Deep-Time/dtwpos/archive/master.zip  
    unzip master.zip  
    cd dtwpos-master  
    chmod +x wpos.sh  
    ./wpos.sh  



## 更新说明
2016.3.13
添加dt_inc目录，包含

custom_post_type.php
disable_embeds.php
disable_remove.php
navwalker.php
plugins_optimized.php


2015.6.3
添加 Functions.php 文件

2015.8.20
添加  wpos.sh (wordpress optmize setup)

2015.10.29
添加外部数据库使用方式 v1.03
============================================

## DT_INC 说明
一些googleapis的内容，进行本土化


## webFonts

opensans.css
