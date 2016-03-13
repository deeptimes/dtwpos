<?php
/*==========注册自定义文章类型_套图==========*/
function cpt_taotu() {

	$labels = array(
		'name'                  => _x( '套图', 'Post Type General Name', 'text_domain' ),
		'singular_name'         => _x( '套图集', 'Post Type Singular Name', 'text_domain' ),
		'menu_name'             => __( '套图专辑', 'text_domain' ),
		'name_admin_bar'        => __( '套图', 'text_domain' ),
		'parent_item_colon'     => __( '上级项目', 'text_domain' ),
		'all_items'             => __( '全部套图', 'text_domain' ),
		'add_new_item'          => __( '添加新套图', 'text_domain' ),
		'add_new'               => __( '添加新套图', 'text_domain' ),
		'new_item'              => __( '新的套图', 'text_domain' ),
		'edit_item'             => __( '编辑套图', 'text_domain' ),
		'update_item'           => __( '更新套图', 'text_domain' ),
		'view_item'             => __( '查看套图', 'text_domain' ),
		'search_items'          => __( '搜索套图', 'text_domain' ),
		'not_found'             => __( '没有找到套图', 'text_domain' ),
		'not_found_in_trash'    => __( '回收站里没有找到', 'text_domain' ),
		'items_list'            => __( '套图列表', 'text_domain' ),
		'items_list_navigation' => __( '套图列表导航', 'text_domain' ),
		'filter_items_list'     => __( '套图列表过滤', 'text_domain' ),
	);
	$rewrite = array(
		// 'slug'                  => '',
		// 'with_front'            => true,
		// 'pages'                 => true,
		// 'feeds'                 => true,
	);
	$args = array(
		'label'                 => __( '套图集', 'text_domain' ),
		'description'           => __( '自定义文章类型之套图列表', 'text_domain' ),
		'labels'                => $labels,
		'supports'              => array( 'title', 'thumbnail','editor'),
		'taxonomies'            => array( 'ct_brand', 'ct_hobby' ),
		'hierarchical'          => false,
		'public'                => true,
		'show_ui'               => true,
		'show_in_menu'          => true,
		'menu_position'         => 21,
		'menu_icon'             => 'dashicons-format-gallery',
		'show_in_admin_bar'     => true,
		'show_in_nav_menus'     => true,
		'can_export'            => true,
		'has_archive'           => true,
		'exclude_from_search'   => false,
		'publicly_queryable'    => true,
		// 'rewrite'               => $rewrite,
		'capability_type'       => 'post',
	);
	register_post_type( 'gallerys', $args );
}
add_action( 'init', 'cpt_taotu', 0 );


/*==========注册自定义文章类型_精选==========*/
function cpt_girls() {

	$labels = array(
		'name'                  => _x( '精选收藏', 'Post Type General Name', 'text_domain' ),
		'singular_name'         => _x( '精选集', 'Post Type Singular Name', 'text_domain' ),
		'menu_name'             => __( '精选收藏', 'text_domain' ),
		'name_admin_bar'        => __( '精选', 'text_domain' ),
		'parent_item_colon'     => __( '上级项目', 'text_domain' ),
		'all_items'             => __( '全部套图', 'text_domain' ),
		'add_new_item'          => __( '添加新套图', 'text_domain' ),
		'add_new'               => __( '添加新套图', 'text_domain' ),
		'new_item'              => __( '新的套图', 'text_domain' ),
		'edit_item'             => __( '编辑套图', 'text_domain' ),
		'update_item'           => __( '更新套图', 'text_domain' ),
		'view_item'             => __( '查看套图', 'text_domain' ),
		'search_items'          => __( '搜索套图', 'text_domain' ),
		'not_found'             => __( '没有找到套图', 'text_domain' ),
		'not_found_in_trash'    => __( '回收站里没有找到', 'text_domain' ),
		'items_list'            => __( '套图列表', 'text_domain' ),
		'items_list_navigation' => __( '套图列表导航', 'text_domain' ),
		'filter_items_list'     => __( '套图列表过滤', 'text_domain' ),
	);

	$args = array(
		'label'                 => __( 'Collection', 'text_domain' ),
		'description'           => __( '自定义文章类型之套图列表', 'text_domain' ),
		'labels'                => $labels,
		'supports'              => array( 'title', 'thumbnail'),
		'taxonomies'            => array( 'ct_hobby' ),
		'hierarchical'          => false,
		'public'                => true,
		'show_ui'               => true,
		'show_in_menu'          => true,
		'menu_position'         => 22,
		'menu_icon'             => 'dashicons-images-alt2',
		'show_in_admin_bar'     => true,
		'show_in_nav_menus'     => true,
		'can_export'            => true,
		'has_archive'           => true,
		'exclude_from_search'   => false,
		'publicly_queryable'    => true,
		'capability_type'       => 'post',
	);
	register_post_type( 'collections', $args );
}
add_action( 'init', 'cpt_girls', 0 );

/*==========注册自定义文章类型_视频==========*/
function cpt_video() {

	$labels = array(
		'name'                  => _x( '动感视频', 'Post Type General Name', 'text_domain' ),
		'singular_name'         => _x( '精选视频集', 'Post Type Singular Name', 'text_domain' ),
		'menu_name'             => __( '精选视频', 'text_domain' ),
		'name_admin_bar'        => __( '视频', 'text_domain' ),
		'parent_item_colon'     => __( '上级项目', 'text_domain' ),
		'all_items'             => __( '全部视频', 'text_domain' ),
		'add_new_item'          => __( '添加新视频', 'text_domain' ),
		'add_new'               => __( '添加新视频', 'text_domain' ),
		'new_item'              => __( '新的视频', 'text_domain' ),
		'edit_item'             => __( '编辑视频', 'text_domain' ),
		'update_item'           => __( '更新视频', 'text_domain' ),
		'view_item'             => __( '查看视频', 'text_domain' ),
		'search_items'          => __( '搜索视频', 'text_domain' ),
		'not_found'             => __( '没有找到视频', 'text_domain' ),
		'not_found_in_trash'    => __( '回收站里没有找到', 'text_domain' ),
		'items_list'            => __( '视频列表', 'text_domain' ),
		'items_list_navigation' => __( '视频列表导航', 'text_domain' ),
		'filter_items_list'     => __( '视频列表过滤', 'text_domain' ),
	);

	$args = array(
		'label'                 => __( '视频集', 'text_domain' ),
		'description'           => __( '自定义文章类型之视频', 'text_domain' ),
		'labels'                => $labels,
		'supports'              => array( 'title','editor','thumbnail'),
		'taxonomies'            => array( 'ct_brand', 'ct_hobby' ),
		'hierarchical'          => false,
		'public'                => true,
		'show_ui'               => true,
		'show_in_menu'          => true,
		'menu_position'         => 23,
		'menu_icon'             => 'dashicons-format-video',
		'show_in_admin_bar'     => true,
		'show_in_nav_menus'     => true,
		'can_export'            => true,
		'has_archive'           => true,
		'exclude_from_search'   => false,
		'publicly_queryable'    => true,
		'capability_type'       => 'post',
	);
	register_post_type( 'videos', $args );
}
add_action( 'init', 'cpt_video', 0 );

/*==========注册自定义分类法___套图分类==========*/
function ct_brand() {
	$labels = array(
		'name'                       => _x( '套图分类', 'Taxonomy General Name', 'text_domain' ),
		'singular_name'              => _x( '套图分类', 'Taxonomy Singular Name', 'text_domain' ),
		'menu_name'                  => __( '套图分类', 'text_domain' ),
		'all_items'                  => __( '全部分类', 'text_domain' ),
		'parent_item'                => __( '上级分类', 'text_domain' ),
		'parent_item_colon'          => __( '上级分类:', 'text_domain' ),
		'new_item_name'              => __( '新分类名称', 'text_domain' ),
		'add_new_item'               => __( '添加新分类', 'text_domain' ),
		'edit_item'                  => __( '编辑分类', 'text_domain' ),
		'update_item'                => __( '更新分类', 'text_domain' ),
		'view_item'                  => __( '查看分类', 'text_domain' ),
		'search_items'               => __( '搜索分类', 'text_domain' ),
		'not_found'                  => __( '没有找到分类', 'text_domain' ),
		'items_list'                 => __( '分类列表', 'text_domain' ),
		'items_list_navigation'      => __( '分类列表导航', 'text_domain' ),
	);
	$rewrite = array(
		// 'slug'                       => '',
		// 'with_front'                 => true,
		// 'hierarchical'               => true,
	);
	$args = array(
		'labels'                     => $labels,
		'hierarchical'               => true,
		'public'                     => true,
		'show_ui'                    => true,
		'show_admin_column'          => false,
		'show_in_nav_menus'          => true,
		'show_tagcloud'              => true,
		// 'rewrite'                    => $rewrite,
	);
	register_taxonomy( 'brands', array( 'gallerys','videos' ), $args );
}
add_action( 'init', 'ct_brand', 0 );

/*==========注册自定义分类法___性趣标签==========*/
function ct_hobby() {
	$labels = array(
		'name'                       => _x( '性趣标签', 'Taxonomy General Name', 'text_domain' ),
		'singular_name'              => _x( '性趣标签', 'Taxonomy Singular Name', 'text_domain' ),
		'menu_name'                  => __( '性趣标签', 'text_domain' ),
		'all_items'                  => __( 'All Items', 'text_domain' ),
		'parent_item'                => __( 'Parent Item', 'text_domain' ),
		'parent_item_colon'          => __( 'Parent Item:', 'text_domain' ),
		'new_item_name'              => __( '新标签名称', 'text_domain' ),
		'add_new_item'               => __( '添加新标签', 'text_domain' ),
		'edit_item'                  => __( '编辑标签', 'text_domain' ),
		'update_item'                => __( '更新标签', 'text_domain' ),
		'view_item'                  => __( '查看标签', 'text_domain' ),
		'separate_items_with_commas' => __( '用逗号分割标签', 'text_domain' ),
		'add_or_remove_items'        => __( 'Add or remove items', 'text_domain' ),
		'choose_from_most_used'      => __( '从最常用中选择', 'text_domain' ),
		'popular_items'              => __( 'Popular Items', 'text_domain' ),
		'search_items'               => __( '搜索标签', 'text_domain' ),
		'not_found'                  => __( '没有找到标签', 'text_domain' ),
		'items_list'                 => __( 'Items list', 'text_domain' ),
		'items_list_navigation'      => __( 'Items list navigation', 'text_domain' ),
	);
	$rewrite = array(
		// 'slug'                       => '/',
		// 'with_front'                 => true,
		// 'hierarchical'               => false,
	);
	$args = array(
		'labels'                     => $labels,
		'hierarchical'               => false,
		'public'                     => true,
		'show_ui'                    => true,
		'show_admin_column'          => false,
		'show_in_nav_menus'          => true,
		'show_tagcloud'              => true,
		// 'rewrite'                    => $rewrite,
	);
	register_taxonomy( 'hobbies', array( 'gallerys','collections','videos' ), $args );
}
add_action( 'init', 'ct_hobby', 0 );

?>