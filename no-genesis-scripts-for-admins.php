<?php
/*
Plugin Name: No Genesis Scripts for Admins
Plugin URI: https://webplantmedia.com
Description: Most scripts are for tracking users. Remove scripts for admin users. Display only for visitors.
Author: Web Plant Media
Author URI: http://webplantmedia.com/
Version: 1.0
License: GPLv2 or later
*/

add_filter( 'genesis_footer_scripts', 'ngsfa_genesis_header_footer_scripts', 10, 1 );
add_filter( 'genesis_header_scripts', 'ngsfa_genesis_header_footer_scripts', 10, 1 );
function ngsfa_genesis_header_footer_scripts( $script ) {
	if( current_user_can( 'administrator' ) ) {
		return '';
	}

	return $script;
}
