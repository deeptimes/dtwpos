<?php
//~ 顶部导航菜单
class MoMo_Menu extends Walker {

	public $tree_type = array( 'post_type', 'taxonomy', 'custom' );
	public $db_fields = array( 'parent' => 'menu_item_parent', 'id' => 'db_id' );
	public function start_lvl( &$output, $depth = 0, $args = array() ) {
		$indent = str_repeat("\t", $depth);
		if( $depth == 0 ){
		$output .= "\n$indent<div class=\"dropdown_fullwidth\"><ul class=\"list_unstyled\">\n";
		}else{
			$output .= '<ul class="dropdown_flyout_level">';
		}
	}

	public function end_lvl( &$output, $depth = 0, $args = array() ) {
		$indent = str_repeat("\t", $depth);
		if( $depth == 0 ){
			$output .= "$indent</ul></div>\n";
		}
		else{
			$output .= '</ul>';
		}
	}

	public function start_el( &$output, $item, $depth = 0, $args = array(), $id = 0 ) {
		$glyphicon_icon = '';
		
		$indent = ( $depth ) ? str_repeat( "\t", $depth ) : '';

		$classes = array();

		if( $item->current || $item->current_item_ancestor || $item->current_item_parent ){
			$classes[] = 'active';
		}

		

		$class_names = join( ' ', apply_filters( 'nav_menu_css_class', array_filter( $classes ), $item, $args, $depth ) );
		$class_names = $class_names ? ' class="' . esc_attr( $class_names ) . '"' : '';

		$id = apply_filters( 'nav_menu_item_id', 'menu-item-'. $item->ID, $item, $args, $depth );
		$id = $id ? ' id="' . esc_attr( $id ) . '"' : '';
	
		$output .= $indent . '<li role="presentation"' . $class_names .'>';

		$atts = array();
		$atts['title']  = ! empty( $item->attr_title ) ? $item->attr_title : '';
		$atts['target'] = ! empty( $item->target )     ? $item->target     : '';
		$atts['rel']    = ! empty( $item->xfn )        ? $item->xfn        : '';
		$atts['href']   = ! empty( $item->url )        ? $item->url        : '';

		$class_names = (array) get_post_meta( $item->ID, '_menu_item_classes', true );

			$glyphicon_icon = '<i class="fa ' . esc_attr( $class_names[0] ) . '"></i> ';
			

		$atts = apply_filters( 'nav_menu_link_attributes', $atts, $item, $args, $depth );

		$attributes = '';
		foreach ( $atts as $attr => $value ) {
			if ( ! empty( $value ) ) {
				$value = ( 'href' === $attr ) ? esc_url( $value ) : esc_attr( $value );
				$attributes .= ' ' . $attr . '="' . $value . '"';
			}
		}

		$item_output = $args->before;
		$item_output .= '<a'. $attributes .'>';
		/** This filter is documented in wp-includes/post-template.php */
		$item_output .= $args->link_before . $glyphicon_icon.apply_filters( 'the_title', $item->title, $item->ID ) . $args->link_after;
		$item_output .= '</a>';
		$item_output .= $args->after;

		$output .= apply_filters( 'walker_nav_menu_start_el', $item_output, $item, $depth, $args );
	}

	public function end_el( &$output, $item, $depth = 0, $args = array() ) {
		$output .= "</li>\n";
	}

} // Walker_Nav_Menu