radius = 30;
style = "Shell"; // [No shell, Shell, Inverted]
thickness = 1;

module chars_sphere(chars, sphere_radius, bottom_radius, font_size, char_gap, floor_density, top_offset, thickness, style) {
    b = sphere_radius * top_offset;
	
    module chars() {
	    for(i = [0:(180 * floor_density - b) / char_gap]) {
			j = b + i * char_gap;
			rotate([0, 0, j ])
				rotate([0, -90 + j / floor_density, 0])
				     
					translate([sphere_radius, 0, chars[i] == "." ? -font_size / 3 : 0]) rotate([90, 0, 90]) 
					    linear_extrude(thickness) 
						    text(chars[i], valign = "center", halign = "center", size = font_size, font = "Arial Black");
					 
						
								
							
		}
	}
	
	module line() {
	    step = style == "Shell" ? 1 : 0.5;
		for(i = [0:(180 * floor_density - b) / step]) {
			j = b + i * step;
			rotate([0, 0, j ])
				rotate([0, -90 + j / floor_density, 0])
					 translate([sphere_radius, 0, 0])
						rotate([90, 0, 90]) 
							linear_extrude(thickness) 
								translate([-font_size / 2, font_size / 2, 0]) square([0.5, style == "Inverted" ? thickness / 2 : thickness]);
								
							
		}
	}
	
	module bottom() {
		translate([0, 0, -sphere_radius - thickness * 1.5]) 
		union() {
			linear_extrude(thickness * 3) 
				circle(bottom_radius, center = true, $fn = 48);
			
			color("black") linear_extrude(thickness * 4) 
				rotate([0, 0, -90]) text("π", valign = "center", halign = "center", size = bottom_radius * 1.5, font = "Broadway");
		}	
	}
	
	module shell() {
	    fn = style == "Shell" ? 24 : 48;
		difference() {
			sphere(sphere_radius + thickness / 2, $fn = fn);
			sphere(sphere_radius - thickness / 2, $fn = fn);
			linear_extrude(sphere_radius * 2) 
					circle(bottom_radius * 1.2, center = true, $fn = 24);
		}
	}
	

	if(style == "Inverted") {
		difference() {
			shell();
			chars();
			line();
		} 
	} else {
		chars();
		line();
        if(style == "Shell") {
		    shell();
		}
	}
	bottom();
}

module pi_sphere(radius, style, thickness) {
    chars = "3.14159265358979323846264338327950288419716939937510582097494459230781640628620899862803482534211706798214808651328230664709384460955058223172535940812848111745028410270193852110555964462294895493038196442881097566593344612847564823378678316527120190914564856692346034861045432664821339360726024914127372458700660631558817";
    sphere_radius = 30;
	bottom_radius = 10;	
	font_size = 6;
	char_gap = 15;
	floor_density = 30;
	top_offset = 30;
	
	s = radius / sphere_radius;
	
	scale(s) 
	    chars_sphere(chars, sphere_radius, bottom_radius, font_size, char_gap, floor_density, top_offset, thickness / s, style);
}


pi_sphere(radius, style, thickness);
	
    