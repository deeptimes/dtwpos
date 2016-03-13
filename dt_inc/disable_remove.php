<?php
/**
 * 一些功能移除和禁止
 * @date    2016-02-06 19:36:48
 * @version 1.0
 */

// 移除Canonical标签,对一组内容完全相同或高度相似的网页可以告诉搜索引擎哪个页面为规范的网页;
remove_action( 'wp_head', 'rel_canonical' );

// 移除feed;
remove_action( 'wp_head', 'feed_links', 2 );
remove_action( 'wp_head', 'feed_links_extra', 3 );

// 移除离线编辑器开放接口;
remove_action( 'wp_head', 'rsd_link' );
remove_action( 'wp_head', 'wlwmanifest_link' );

// 移除当前页面的索引;
remove_action( 'wp_head', 'index_rel_link' );

// 移除前后文信息
remove_action( 'wp_head', 'parent_post_rel_link', 10, 0 );
remove_action( 'wp_head', 'start_post_rel_link', 10, 0 );

// 移除WordPress版本信息;
remove_action( 'wp_head', 'wp_generator' );

// 移除相邻文章的url
remove_action( 'wp_head', 'adjacent_posts_rel_link_wp_head', 10, 0 );

// 移除自动生成的短链接;
remove_action( 'wp_head', 'wp_shortlink_wp_head', 10, 0 );
remove_action( 'template_redirect', 'wp_shortlink_header', 11, 0 );

// 移除本地化样式表;
remove_action( 'wp_head', 'locale_stylesheet' );

// 移除索引
remove_action( 'wp_head', 'noindex', 1 );

// 移除不知道是啥东东;
remove_action( 'publish_future_post','check_and_publish_future_post',10, 1 );

//移除自动保存和修订版本
function disable_autosave() {
  wp_deregister_script('autosave');
}
add_action('wp_print_scripts','disable_autosave' );
remove_action('pre_post_update','wp_save_post_revision' );
//remove_action('post_updated', 'wp_save_post_revision',10,1);


// 禁用REST API;
add_filter( 'rest_enabled', '_return_false' );
add_filter( 'rest_jsonp_enabled', '_return_false' );



// 移除emoji's表情符号
function disable_emojis() {
remove_action( 'wp_head', 'print_emoji_detection_script', 7 );
remove_action( 'admin_print_scripts', 'print_emoji_detection_script' );
remove_action( 'wp_print_styles', 'print_emoji_styles' );
remove_action( 'admin_print_styles', 'print_emoji_styles' );
remove_filter( 'the_content_feed', 'wp_staticize_emoji' );
remove_filter( 'comment_text_rss', 'wp_staticize_emoji' );
remove_filter( 'wp_mail', 'wp_staticize_emoji_for_email' );
add_filter( 'tiny_mce_plugins', 'disable_emojis_tinymce' );}
add_action( 'init', 'disable_emojis' );
function disable_emojis_tinymce( $plugins ) {
    if ( is_array( $plugins ) ) {
    return array_diff( $plugins, array( 'wpemoji' ) );
    } else {
    return array();
    }
}

// 移除版本号
function sb_remove_script_version( $src ){
  $parts = explode( '?', $src );
  return $parts[0];
}
add_filter( 'script_loader_src', 'sb_remove_script_version', 15, 1 );
add_filter( 'style_loader_src', 'sb_remove_script_version', 15, 1 );


// 替换Gavagar头像地址
function dmeng_get_https_avatar($avatar) {
  //~ 替换为 https 的域名
  $avatar = str_replace(array("www.gravatar.com", "0.gravatar.com", "1.gravatar.com", "2.gravatar.com"), "secure.gravatar.com", $avatar);
  //~ 替换为 https 协议
  $avatar = str_replace("http://", "https://", $avatar);
  return $avatar;
}
add_filter('get_avatar', 'dmeng_get_https_avatar');// 替换Gavagar头像地址



/*
* 移除各类Googleapi的东西，包括Font,ajax
*/

// 移除 Open-Sans 在线字体服务
add_action('wp_default_styles','inn_open_sans_remover');
function inn_open_sans_remover($styles){
  $registered = $styles->registered;
  foreach($registered as $k => $v){
    /**              * search open-sans key              */
    $remove_key = array_search('open-sans',$v->deps);
    /**              * upset obj Property              */
    if($remove_key !== false) unset($registered[$k]->deps[$remove_key]);
  }
}