use <2d.scad>;
use <3d.scad>;
 
text = "IT WORKS ON MY MACHINE ";
radius = 40;
height = 120;
wall_thickness = 1;
bottom_height = 5;

bottom_factor = 0.825;
font_density = 1.7;

// Create a character_container. 
// Parameters: 
//     text - the text you want to create
//     radius - the inner radius of the container
//     bottom_height - the height of the bottom
//     wall_thickness - the thickness of the inner wall
//     bottom_factor - adjust the radius of the bottom
//     font_density - adjust the density between words
module character_container(text, radius, bottom_height, wall_thickness = 1, bottom_factor = 0.8, font_density = 1.5) { 
    font_size = 2 *  PI() * radius / len(text) * font_density;
	
	linear_extrude(height) union() {
		ring_text(text, radius, font_density);
		arc(radius - wall_thickness, [0, 360], wall_thickness);
	}
		
	linear_extrude(bottom_height) 
	    circle(radius + font_size * bottom_factor, $fn = 96);	  
}

// The same as `ring_text` but use `ring_text_without_projection` internally.
// Parameters: 
//     text - the text you want to create
//     radius - the inner radius of the container
//     bottom_height - the height of the bottom
//     wall_thickness - the thickness of the inner wall
//     bottom_factor - adjust the radius of the bottom
//     font_density - adjust the density between words
module character_container_without_projection(text, radius, bottom_height, wall_thickness = 1, bottom_factor = 0.825, font_density = 1.5) { 
    font_size = 2 *  PI() * radius / len(text) * font_density;
	
	linear_extrude(height) union() {
		ring_text_without_projection(text, radius, font_density);
		arc(radius - wall_thickness, [0, 360], wall_thickness);
	}
	
	linear_extrude(bottom_height) 
		circle(radius + font_size * bottom_factor, $fn = 96);	 
}

character_container_without_projection(text, radius, bottom_height, wall_thickness, bottom_factor, font_density);

// Use this if you have little words. It's slow because it uses the `projection` function internally.
// character_container(text, radius, bottom_height, wall_thickness, 0.8, font_density);

	