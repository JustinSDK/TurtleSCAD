head_side_length = 30;
triangle_numbers = 3;
triangle_thickness = 3;
spacing = 0.6;

module joint(inner_length, inner_width, height, thickness) {
    $fn = 24;

	// U 
	linear_extrude(height, center = true) difference() {
	    offset(delta = thickness, chamfer = true) 
		    square([inner_length, inner_width], center = true);
			
	    square([inner_length, inner_width], center = true);
		
		translate([-thickness / 2 - inner_length / 2, 0, 0]) 
		    square([thickness, inner_width], center = true);
	}
	
	// ring
	translate([height / 2 + inner_length / 2 + thickness / 2, 0, 0]) 
	rotate([90, 0, 0])
	linear_extrude(thickness, center = true) difference() {
	    union() {
			circle(height / 2);
			translate([-height / 4, 0, 0]) square([height / 2, height], center = true);
		}
		circle(height / 2 - thickness);
	}
}


module fish_triangle(side_length, triangle_thickness, spacing) {
    joint_thickness = triangle_thickness / 3 * 2;
	echo(joint_thickness);
	slot_height = joint_thickness * 3 + spacing * 2;
	slot_width = joint_thickness + spacing * 2;

	radius = side_length * cos(30) * 2 / 3;
	
	translate([0, 0, (radius - 1) / 2 + 1]) union() {
		rotate([0, -90, 0])  union() {
			// triangle
			linear_extrude(triangle_thickness, center = true)   difference() {
				offset(r = 1) circle(radius - 1, $fn = 3);
				// slot
				translate([-(radius - 1) / 2 - 1 , -slot_width / 2, 0]) square([slot_height + spacing, slot_width]);
			}		
			// stick
			translate([-(radius - 1) / 2 - 1 + triangle_thickness / 3 + joint_thickness + spacing, 0, 0]) rotate([90, 0, 0]) linear_extrude(slot_width, center = true) circle(triangle_thickness  / 3, $fn = 24);
		}
			
		translate([slot_width, 0, slot_height / 2 -(radius - 1) / 2 - 1])
			joint(joint_thickness, slot_width, slot_height, joint_thickness);
	}
}

module head(triangle_length, contact_thickness) {
    $fn = 24;
	
	radius = triangle_length * cos(30) * 2 / 3;
	r = triangle_length * sin(60) / 4;
	
	translate([0, 0, (radius - 1) / 2 + 1]) rotate([0, -90, 0])
	union() {
		difference() {
			hull() {
				linear_extrude(contact_thickness, center = true) 
					offset(r = 1) circle(radius - 1, $fn = 3);
							
					translate([triangle_length / 14 * 3, 0, triangle_length / 2]) sphere(r);
					
					translate([-triangle_length / 4 , 0, triangle_length / 2]) sphere(r);
			}
			
			linear_extrude(triangle_length * 1.5, center = true) translate([-triangle_length / 2 - (radius - 1) / 2 - 1, 0, 0]) square([triangle_length, triangle_length], center = true);
			
			translate([0, 0, triangle_length / 1.25]) rotate([90, 0, 0]) 
		 scale([0.75, 1, 1]) linear_extrude(triangle_length, center = true) circle(triangle_length / 1.5, $fn = 3);
		}
		
		// eyes
		translate([triangle_length / 4, triangle_length / 5, triangle_length / 5]) sphere(triangle_length / 10);
		
		translate([triangle_length / 4, -triangle_length / 5, triangle_length / 5]) sphere(triangle_length / 10);
	}
}

module moving_fish(head_side_length, triangle_numbers, triangle_thickness, spacing) {

    $fn = 25;
	
	joint_thickness = triangle_thickness / 3 * 2;
	slot_width = joint_thickness + spacing * 2;
	slot_height = joint_thickness * 3 + spacing * 2;
	offset = joint_thickness * 2.5 + slot_width + spacing;
	
	radius = head_side_length * cos(30) * 2 / 3;
	
	step = (radius / 2 * 3 - slot_height * 1.5) / triangle_numbers;
	
	for(i = [0:triangle_numbers - 1]) {
		translate([offset * i, 0, 0]) 
			fish_triangle(head_side_length - step * (i + 1), triangle_thickness, spacing);
	}
	
	// tail
	translate([offset * (triangle_numbers + 0.6), 0, 0])
		linear_extrude(slot_height)  union() {
			difference() {
				circle(head_side_length / 3);
				translate([head_side_length / 4, 0, 0]) 
					circle(head_side_length / 3);
			}
			
			// ring
			difference() {
				offset(r = triangle_thickness / 2.4) circle(triangle_thickness / 1.2);
				circle(triangle_thickness / 1.2);
			}
	    }
	
	// head
	translate([-offset, 0, 0]) union() {
		fish_triangle(head_side_length, triangle_thickness, spacing); 
		head(head_side_length, triangle_thickness);
	}
}

moving_fish(head_side_length, triangle_numbers, triangle_thickness, spacing);