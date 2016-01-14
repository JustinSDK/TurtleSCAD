use <2d.scad>

//////////////
// 3D Module
//

// Create a 3D character around a cylinder. The `radius` and `arc_angle` determine the font size of the character. 
// Parameters: 
//     character - 3D character you want to create
//     arc_angle - angle which the character go across
//     radius - the cylinder radius
//     font - the character font
//     thickness - the character thickness
//     font_factor - use this parameter to scale the calculated font if necessary
module cylinder_character(character, arc_angle, radius, font = "Courier New:style=Bold", thickness = 1, font_factor = 1) {
    half_arc_angle = arc_angle / 2;
    font_size = 2 * radius * sin(half_arc_angle) * font_factor;

    rotate([0, 0, -half_arc_angle]) intersection() {
       translate([0, 0, -font_size / 5]) 
             linear_extrude(font_size * 1.5) 
                 arc(radius, [0, arc_angle], thickness);
    
       rotate([90, 0, 90 + half_arc_angle]) 
            linear_extrude(radius + thickness) 
                text(character, font = font, size = font_size, halign = "center");
    }
} 

// It has the same visual effect as `cylinder_character`, but each character is created by the `text` module. Use this module if your `arc_angle` is small enough and you want to render a model quickly. 
// Parameters: 
//     character - 3D character you want to create
//     arc_angle - angle which the character go across
//     radius - the cylinder radius
//     font - the character font
//     thickness - the character thickness
//     font_factor - use this parameter to scale the calculated font if necessary
module fake_cylinder_character(character, arc_angle, radius, font = "Courier New:style=Bold", thickness = 1, font_factor = 1) {
    half_arc_angle = arc_angle / 2;
    font_size = 2 * radius * sin(half_arc_angle) * font_factor;

    translate([radius, 0, 0]) rotate([90, 0, 90]) 
        linear_extrude(thickness) 
            text(character, font = font, size = font_size, halign = "center");
    
} 

// Create a chain text around a cylinder.
// Parameters: 
//     text - the text you want to create
//     radius - the cylinder radius
//     thickness - the character thickness
module chain_text(text, radius, thickness = 1) {
    arc_angle = 360 / len(text);

    for(i = [0 : len(text) - 1]) {
        rotate([0, 0, i * arc_angle]) 
            cylinder_character(text[i], arc_angle, radius, thickness = thickness);
    }
}

// Create a chain text around a cylinder for Chinese characters. It uses the font "微軟正黑體".
// Parameters: 
//     text - the text you want to create
//     radius - the cylinder radius
//     thickness - the character thickness
module chain_text_chinese(text, radius, thickness = 1) {
    arc_angle = 360 / len(text);

    for(i = [0 : len(text) - 1]) {
        rotate([0, 0, i * arc_angle]) 
            cylinder_character(text[i], arc_angle, radius, "微軟正黑體", thickness, 0.85);
    }
}

// Create a hollow_sphere with a inner `radius`.
// Parameters: 
//     radius - the sphere radius
//     thickness - the thickness of the sphere
module hollow_sphere(radius, thickness = 1) {
    difference() {
	    sphere(radius + thickness, $fn = 96);
        sphere(radius, $fn = 96);
	}
}

// Creates a hollow cylinder or cone.
// Parameters: 
//     r1 - radius, bottom of cone
//     r2 - radius, top of cone
//     height - height of the cylinder or cone
module hollow_cylinder(r1, r2, height) {
	difference() {
		cylinder(height, r1=r1,  r2=r2, $fn = 96);
		translate([0, 0, -1]) 
		    cylinder(height + 2, r1=r1 - 1,  r2=r2 - 1, $fn = 96);    			
    }
}

// Creates a ring text.
// Parameters: 
//     text - the text you want to create
//     radius - the inner radius of the ring
//     font_density - adjust the density between words
module ring_text(text, radius, font_density = 1) {
    font_size = 2 *  PI() * radius / len(text) * font_density;
	
	negative_self_font_size = -font_size / 2;
	font_size_div_5 = font_size / 5;
	arc_angle = 360 / len(text);
	outer_r = radius + font_size;
	
    font_height = 2 * radius;
	
	projection() intersection() {
		union() {
			for(i = [0 : len(text) - 1]) {
				rotate([90, 0, i * arc_angle]) 
					 translate([negative_self_font_size, 0, 0]) 
						 linear_extrude(height = font_height) 
							 text(text[i], font = "Courier New:style=Bold", size = font_size);	
			}
		}
	
	    hollow_cylinder(outer_r - font_size_div_5, radius - font_size_div_5, font_size);
	}
}

// The same as `ring_text` without using the `projection` internally.
// Parameters: 
//     text - the text you want to create
//     radius - the inner radius of the ring
//     font_density - adjust the density between words
module ring_text_without_projection(text, radius, font_density = 1) {
    font_size = 2 *  PI() * radius / len(text) * font_density;
	negative_self_font_size = -font_size / 2;
	arc_angle = 360 / len(text);
	font_r = radius + font_size * 0.8;
    
	for(i = [0 : len(text) - 1]) {
        rotate([0, 0, i * arc_angle]) 
		    translate([negative_self_font_size, -font_r , 0]) 
		         text(text[i], font = "Courier New:style=Bold", size = font_size);	
		
	}
}