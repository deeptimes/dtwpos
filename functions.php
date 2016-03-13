<?php
/**
 * 
 * @authors 深海时代（Deep-Time.com）
 * @version Functions
 */
/*---------------------------------------------------------*/
//~ 载入 Bootstrap 菜单类
require_once( get_template_directory() . '/inc/disable_remove.php' );
require_once( get_template_directory() . '/inc/disable_embeds.php' );
require_once( get_template_directory() . '/inc/plugins_optimized.php' );
require_once( get_template_directory() . '/inc/navwalker.php' );
if ( ! function_exists( 'facn_setup' ) ) :
function facn_setup() {
    //让wordpress管理文档标题
    add_theme_support( 'title-tag' );
    //~ 注册菜单
    register_nav_menus( array(
      'header_menu' => __( '顶部菜单', 'momo' ),
      'hardware_menu' => __( '智能硬件横向菜单', 'momo' ),
      'solution_menu' => __( '方案与案例横向菜单', 'momo' ),
      'link_menu' => __( '友情连接', 'momo' ),
      'footer_menu' => __( '底部菜单', 'momo' ),
      'about_menu' => __( '关于我们', 'momo' ),
      'host_menu' => __( '智能主机', 'momo' )
    ) );
}
endif;
add_action( 'after_setup_theme', 'facn_setup' );
/*===============页面头部加载Javascript and CSS============*/
function reg_script() {
  // 注册css样式 ，默认主样式main.css
  wp_enqueue_style( 'bootstrap', get_template_directory_uri() . '/css/bootstrap.min.css');
  wp_enqueue_style( 'font-awesome', get_template_directory_uri() . '/css/font-awesome.min.css');
  wp_enqueue_style( 'megamenu', get_template_directory_uri() . '/css/megamenu.css');
  wp_enqueue_style( 'animate', get_template_directory_uri() . '/js/monitor/animate.css');
  wp_enqueue_style( 'slider', get_template_directory_uri() . '/css/slider.css');
  wp_enqueue_style( 'slide_background', get_template_directory_uri() . '/css/slide_background.css');
  wp_enqueue_style( 'slick', get_template_directory_uri() . '/css/slick.css');
  wp_enqueue_style( 'zozotabs', get_template_directory_uri() . '/css/zozo.tabs.min.css');
  wp_enqueue_style( 'mainstyle', get_template_directory_uri() . '/css/main.css');
  wp_enqueue_style( 'mainstyle', get_template_directory_uri() . '/css/main.css');
  wp_enqueue_style( 'just4ie', get_template_directory_uri() . '/css/ie.css' );
  wp_style_add_data( 'just4ie', 'conditional', 'lt IE 9' );
  // 注册js脚本,最后的true表示在footer加载
  wp_register_script( 'jquerymin', get_template_directory_uri() . '/js/jquery-1.12.0.min.js',false,'','');
  wp_enqueue_script( 'jquerymin' );
  wp_register_script( 'bootstrap', get_template_directory_uri() . '/js/bootstrap.min.js',false,'',true);
  wp_enqueue_script( 'bootstrap' );
  wp_register_script( 'megamenu_plugins', get_template_directory_uri() . '/js/megamenu_plugins.js',false,'',true);
  wp_enqueue_script( 'megamenu_plugins' );
  wp_register_script( 'megamenu', get_template_directory_uri() . '/js/megamenu.js',false,'',true);
  wp_enqueue_script( 'megamenu' );
  wp_register_script( 'appear', get_template_directory_uri() . '/js/monitor/jquery.appear.js',false,'',true);
  wp_enqueue_script( 'appear' );
  wp_register_script( 'zozotabs', get_template_directory_uri() . '/js/zozo.tabs.min.js',false,'',true);
  wp_enqueue_script( 'zozotabs' );
  wp_register_script( 'slick', get_template_directory_uri() . '/js/slick.min.js',false,'',true);
  wp_enqueue_script( 'slick' );
  wp_register_script( 'jrating', get_template_directory_uri() . '/js/jrating.jquery.js',false,'',true);
  wp_enqueue_script( 'jrating' );
  wp_register_script( 'parallax', get_template_directory_uri() . '/js/jquery.parallax-1.1.3.js',false,'',true);
  wp_enqueue_script( 'parallax' );
  //自定义脚本
  wp_register_script( 'plugins', get_template_directory_uri() . '/js/plugins_custom.js',false,'',true);
  wp_enqueue_script( 'plugins' );
  //IE9判断脚本
  wp_register_script( 'html5shiv', get_template_directory_uri() . '/js/html5shiv.js',false,'','');
  wp_script_add_data( 'html5shiv', 'conditional', 'lt IE 9' );
  wp_enqueue_script( 'html5shiv' );
  //删除已注册的系统自带的Jquery脚本
  wp_deregister_script( 'jquery' );
}
add_action( 'wp_enqueue_scripts', 'reg_script' );
function momo_get_the_thumbnail( $size = 'post-thumbnail' ) {
  $image_url = '';
  if ( has_post_thumbnail() ) {
    $image_url = wp_get_attachment_image_src( get_post_thumbnail_id() , full);
    $image_url = $image_url[0];
  } else {
    global $post;
    $output = preg_match_all('/<img.+src=[\'"]([^\'"]+)[\'"].*>/i', $post->post_content, $matches);
    if($output) $image_url = $matches[1][0];
  }
  if($image_url){
    return $image_url;
  }
}
function dmeng_get_current_page_url(){
  $ssl = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] == 'on') ? true:false;
    $sp = strtolower($_SERVER['SERVER_PROTOCOL']);
    $protocol = substr($sp, 0, strpos($sp, '/')) . (($ssl) ? 's' : '');
    $port  = $_SERVER['SERVER_PORT'];
    $port = ((!$ssl && $port=='80') || ($ssl && $port=='443')) ? '' : ':'.$port;
    $host = isset($_SERVER['HTTP_X_FORWARDED_HOST']) ? $_SERVER['HTTP_X_FORWARDED_HOST'] : isset($_SERVER['HTTP_HOST']) ? $_SERVER['HTTP_HOST'] : $_SERVER['SERVER_NAME'];
    return $protocol . '://' . $host . $port . $_SERVER['REQUEST_URI'];
}
function momo_add_excerpts_to_pages() {
    add_post_type_support( 'product', array( 'excerpt' ) );
}
add_action( 'init', 'momo_add_excerpts_to_pages' );
//统计文章浏览次数
function getPostViews($postID){
    $count_key = 'post_views_count';
    $count = get_post_meta($postID, $count_key, true);
    if($count==''){
        delete_post_meta($postID, $count_key);
        add_post_meta($postID, $count_key, '0');
        return "0";
    }
    return $count;
}
function setPostViews($postID) {
    $count_key = 'post_views_count';
    $count = get_post_meta($postID, $count_key, true);
    if($count==''){
        $count = 0;
        delete_post_meta($postID, $count_key);
        add_post_meta($postID, $count_key, '0');
    }else{
        $count++;
        update_post_meta($postID, $count_key, $count);
    }
}