characters = "3.14159265358979323846264338327950288419716939937510582097494459230781640628620899862803362534211706798213608651328230664709384460955058223172535940812836111745028410270193852110555964462293695493038196442881097566593344612847563623378678316527120190914563656692346033661045432663621339360726024"; 
top_radius = 50; 
bottom_radius = 40;
height = 100;
thickness = 3; 
inverted = "NO"; // [YES,NO]
handler = "YES"; // [YES, NO]

module a_quarter_sector(radius, angle, width = 1) {
    outer = radius + width;
    intersection() {
	    offset(r = width) circle(radius, $fn=36); 
        polygon([[0, 0], [outer, 0], [outer, outer * sin(angle)], [outer * cos(angle), outer * sin(angle)]]);
    }
}

module spiral_characters(radius, characters, thickness = 1) {
    
    characters_of_a_circle = 36;
    sector_angle = 360 / characters_of_a_circle;
    
    half_sector_angle = sector_angle / 2;
    font_size = 4 * radius * sin(half_sector_angle);
    z_desc = font_size / characters_of_a_circle;
	
	len_of_characters = len(characters);

    // characters
	
	for(i = [0 : len_of_characters - 1]) {
		translate([0, 0, -z_desc * i])
			rotate([0, 0, i * sector_angle]) {
			    translate([radius, 0, 0]) 
				    rotate([90, 0, 90]) 
				        linear_extrude(thickness) 
                            text(characters[i], font = "Courier New:style=Bold", size = font_size * 1.05, halign = "center");
			}
				
		translate([0, 0, font_size - 1 -z_desc * i])
			rotate([-1.5, 0, i * sector_angle - half_sector_angle])
				linear_extrude(1.2) 
					a_quarter_sector(radius, sector_angle, thickness);
	} 
}


module cup(characters, top_radius, bottom_radius, height, total_thickness, inverted, handler) {
    $fn = 36;
	
    thickness = total_thickness / 2;
	
	module ring(radius, thickness) {
		rotate_extrude() 
			translate([radius - thickness / 2, 0, 0]) 
				circle(thickness / 2);
    }
	
	module handler() {
		rotate(90) difference() {
			translate([(bottom_radius + top_radius) / 2 , 0, height / 2]) rotate([90, 225, 0])
				scale([.75, 1, 1.75])  
					rotate_extrude() 
						translate([height / 3, 0, 0]) 
							circle(thickness * 3);
			cylinder(h=height, r1=bottom_radius, r2=top_radius);
		}
	}
	
    module body(top_radius, bottom_radius, height, thickness) {
		difference() {
			cylinder(h = height, r1 = bottom_radius, r2 = top_radius);
			cylinder(h = height + 1, r1 = bottom_radius - thickness, r2 = top_radius - thickness);
		}
	}
	
	module bottom() {
		// This makes the bottom ring rounded.
		ring(bottom_radius, thickness);

		// bottom
		cylinder(h = thickness, r1=bottom_radius, r2=(top_radius -  bottom_radius) / height * thickness + bottom_radius);
		
		translate([0, 0, -thickness / 2]) 
			linear_extrude(thickness) circle(bottom_radius - thickness / 2);
	}
	
	module body_with_text() {
		characters_of_a_circle = 36;
		arc_angle = 360 / characters_of_a_circle;
		
		font_size = 4 * (bottom_radius - thickness * 2) * sin(arc_angle / 2);
		
		// body with text
		if(inverted == "YES") {
			difference() {
				body(top_radius, bottom_radius, height, thickness);
				
				translate([0, 0, height - font_size]) 
					spiral_characters(bottom_radius - thickness * 2, characters, top_radius / 2);
			}
			// This makes the top ring rounded.
			translate([0, 0, height]) ring(top_radius, total_thickness);
		} else {
			intersection() {
				body(top_radius, bottom_radius, height, thickness);
				
				translate([0, 0, height - font_size]) 
					spiral_characters(bottom_radius - thickness * 2, characters, top_radius / 2);
			}
			// This makes the top ring rounded.
			translate([0, 0, height]) ring(top_radius - thickness, thickness);
		}
		
		body(top_radius - thickness, bottom_radius - thickness, height, thickness);
	}


	body_with_text();
	if(handler == "YES") {
	    handler();
	}
	bottom();
}


cup(characters, top_radius, bottom_radius, height, thickness, inverted, handler);
