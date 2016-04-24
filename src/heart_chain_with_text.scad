use <2d.scad>;

text = "MONICA";
heart_thickness = 2.5;
heart_width = 18;
spacing = 0.5;

// a ring for connecting hearts.
// Parameters:
//     radius - the ring radius
//     thickness - the ring thickness
//     spacing - the spacing while two rings are connecting together
module a_ring_between_hearts(radius, thickness, spacing) {
	union() {
		linear_extrude(thickness) 
			arc(radius, [0, 240], radius / 1.5);
			
		translate([0, 0, thickness + spacing]) linear_extrude(thickness) 	
			arc(radius, [240, 360], radius / 1.5);
			
		linear_extrude(thickness * 2 + spacing) arc(radius, [0, 20], radius / 1.5);
		
		linear_extrude(thickness * 2 + spacing) arc(radius, [220, 240], radius / 1.5);	
	}
}

module heart_sub_component(radius) {
    rotated_angle = 45;
    diameter = radius * 2;
    $fn = 48;

    translate([-radius * cos(rotated_angle), 0, 0]) 
        rotate(-rotated_angle) union() {
            circle(radius);
            translate([0, -radius, 0]) 
                square(diameter);
        }
}

// creater a heart.
//     Parameters:
//         radius - the radius of the circle in the heart
//         center - place the heart center in the origin or not
module heart(radius, center = false) {
    offsetX = center ? 0 : radius + radius * cos(45);
    offsetY = center ? 1.5 * radius * sin(45) - 0.5 * radius : 3 * radius * sin(45);

    translate([offsetX, offsetY, 0]) union() {
        heart_sub_component(radius);
        mirror([1, 0, 0]) heart_sub_component(radius);
    }
}

// a heart with two rings
//     Parameters:
//         heart_width - the width of the heart
//         heart_thickness - the thickness of the heart
//         spacing - the spacing between rings
module heart_with_rings(heart_width, heart_thickness, spacing) {
	radius_for_heart = 0.5 * heart_width / (1 + cos(45));
	ring_radius = radius_for_heart / 3;
	ring_x = heart_width / 2 + spacing;
	ring_thickness = 0.5 * (heart_thickness - spacing);
	
	linear_extrude(heart_thickness) 
	    heart(radius_for_heart, center = true);

	translate([ring_x, radius_for_heart * sin(45), 0]) 
		rotate(-15) 
		    a_ring_between_hearts(ring_radius, ring_thickness, spacing); 

	translate([-ring_x, radius_for_heart * sin(45), 0]) 
	    rotate(165) 
		    a_ring_between_hearts(ring_radius, ring_thickness, spacing);
}

// create a heart with a character in it
//     Parameters:
//         ch - the character
//         heart_width - the width of the heart
//         heart_thickness - the thickness of the heart
//         spacing - the spacing between rings
module a_heart_with_rings_character(ch, heart_width, heart_thickness, spacing) {
    radius_for_heart = 0.5 * heart_width / (1 + cos(45));
	difference() {
		heart_with_rings(heart_width, heart_thickness, spacing);
		translate([0, 0, heart_thickness / 2])
			linear_extrude(heart_thickness / 2) 
				heart(radius_for_heart * 0.9, center = true);
	}
	translate([0, radius_for_heart / 4, heart_thickness / 2])
		linear_extrude(heart_thickness / 2)  
		    text(ch, font = "Arial Black", size = radius_for_heart * 1.2, valign = "center", halign="center");
} 

// create a heart chain
//     Parameters:
//         ch - the character
//         heart_width - the width of the heart
//         heart_thickness - the thickness of the heart
//         spacing - the spacing between rings
module heart_chain_with_text(chs, heart_width, heart_thickness, spacing) {
    offset_x = 0.315 * heart_width / (1 + cos(45)) + spacing + heart_width;

	for(i = [0 : len(chs) - 1]) {
	    translate([offset_x * i, 0, 0]) 
	        a_heart_with_rings_character(chs[i], heart_width, heart_thickness, spacing);
	}
}

heart_chain_with_text(text, heart_width, heart_thickness, spacing);



