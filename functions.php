<?php
/*
 * @Author: anchen
 * @Date:   2015-04-20 12:39:30
 * @Last Modified by:   anchen
 * @Last Modified time: 2015-04-20 14:05:47
 *
 * 该函数移除一个附属于指定动作hook的函数。该方法可用来移除附属于特定动作hook的默认函数，并可能用其它函数取而代之。
 * 请参考remove_filter(), add_action() and add_filter()等的用法
 * 注意：添加hook时的$function_to_remove 和$priority参数要能够相匹配，这样才可以移除hook。
 * 该原则也适用于过滤器和动作。移除失败时不进行警告提示。
 * 下面是它的一些参数：
 * A.$tag（字符串）（必需）将要被删除的函数所连接到的动作hook。默认值：None
 * B.$function_to_remove（回调）（必需） 将要被删除函数的名称默认值：None
 * C.$priority（整数）（可选）函数优先级（在函数最初连接时定义）默认值：10
 * D.$accepted_args（整数）（必需）函数所接受参数的数量。默认值：1
 * 它的返回值是布尔，只有是与否两种状态！由（布尔值）来判断函数是否被移除。
 * A.Ttue 函数被成功移除
 * B.False函数未被移除
 */


remove_action( 'wp_head', 'feed_links', 2 ); //移除feed
remove_action( 'wp_head', 'feed_links_extra', 3 ); //移除feed
remove_action( 'wp_head', 'rsd_link' ); //移除离线编辑器开放接口
remove_action( 'wp_head', 'wlwmanifest_link' );  //移除离线编辑器开放接口
remove_action( 'wp_head', 'index_rel_link' );//去除本页唯一链接信息
remove_action('wp_head', 'parent_post_rel_link', 10, 0 );//清除前后文信息
remove_action('wp_head', 'start_post_rel_link', 10, 0 );//清除前后文信息
remove_action( 'wp_head', 'adjacent_posts_rel_link_wp_head', 10, 0 );//未知
remove_action('publish_future_post','check_and_publish_future_post',10, 1 );//未知
remove_action( 'wp_head', 'noindex', 1 );//未知
//remove_action( 'wp_head', 'wp_enqueue_scripts', 1 ); //Javascript的调用
//remove_action( 'wp_head', 'locale_stylesheet' );//未知
//remove_action( 'wp_head', 'wp_print_styles', 8 );//载入css
//remove_action( 'wp_head', 'wp_print_head_scripts', 9 );//未知
remove_action( 'wp_head', 'wp_generator' ); //移除WordPress版本

remove_action( 'wp_head', 'rel_canonical' );//未知
remove_action( 'wp_footer', 'wp_print_footer_scripts' );//未知
remove_action( 'wp_head', 'wp_shortlink_wp_head', 10, 0 );//移除头部默认短链接
remove_action( 'template_redirect', 'wp_shortlink_header', 11, 0 );//移除模版重定向默认短链接
remove_action('wp_head', 'adjacent_posts_rel_link');//移除临近的文章链接

remove_action('pre_post_update','wp_save_post_revision');//禁用修改历史记录

remove_action( 'load-update-core.php', 'wp_update_themes' );//停用版本更新通知(Core)
add_filter( 'pre_site_transient_update_themes', create_function( '$a', "return null;" ) );

remove_action( 'load-update-core.php', 'wp_update_plugins' );//停用插件更新通知(Plugins)
add_filter( 'pre_site_transient_update_plugins', create_function( '$a', "return null;" ) );

remove_action ('load-update-core.php', 'wp_update_themes');//停用主题更新通知(Themes)
add_filter( 'pre_site_transient_update_core', create_function( '$a', "return null;" ) );

add_action('widgets_init', 'my_remove_recent_comments_style');//移除最近提交
function my_remove_recent_comments_style() {
    global $wp_widget_factory;
    remove_action('wp_head', array($wp_widget_factory->widgets['WP_Widget_Recent_Comments'] ,'recent_comments_style'));
}

wp_deregister_script('l10n');//禁用l10n.js
wp_deregister_script('autosave');//禁用自动保存草稿
add_filter('show_admin_bar','__return_false');//彻底移除管理员工具条

remove_filter('the_content','wpautop');//禁止自动给文章段落添加p标签
remove_filter('the_excerpt','wpautop');//禁止自动给摘要段落添加p标签

function sb_remove_script_version( $src ){
    $parts = explode( '?', $src );
    return $parts[0];
}//去掉js和CSS的版本号
add_filter( 'script_loader_src', 'sb_remove_script_version', 15, 1 );
add_filter( 'style_loader_src', 'sb_remove_script_version', 15, 1 );

