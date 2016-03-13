<?php
/**
 * 一些插件的优化，包括移除Google字体,Googleapis下的ajax
 * @date    2016-02-06 20:11:09
 * @version 1.0
 * ACF  = Advanced Custom Fields
 * VC   = Visual Composer
 * SR   = Slider Revolution
 * CPT  = Custom Post Type - UI
 * ======================================================
 */


/*
* Advanced Custom Fields Pro
* 移除Google Fonts
*/



/*
* Slider Revolution
* 移除Google Fonts
*/
function rs_remover() {
    wp_deregister_script( 'webfont' );
    wp_register_script( 'webfont', false );
    wp_enqueue_script('webfont','');

    wp_deregister_style( 'rs-open-sans' );
    wp_register_style( 'rs-open-sans', false );
    wp_enqueue_style('rs-open-sans','');
}
add_action( 'init', 'rs_remover' );

/*
* WPBakery Visual Composer
* 移除Google Fonts
*/