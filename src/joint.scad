// A joint base without a convex or concave.
// Parameters: 
//     radius - the radius  of the circle on the joint
//     width - the width of the joint
//     spacing - a small space between parts to avoid overlaping while printing.
module joint_base(radius, width, spacing) {
    $fn = 48;
	linear_extrude(width) union() {
		circle(radius);
		polygon(points = [
				[-radius * 3 / sqrt(13), radius * 2 / sqrt(13)], 
				[radius + spacing, 3 * radius], 
				[radius + spacing, 0],
				[radius, 0]
			]
		);
	}
}

// A convex for creating a joint
// Parameters: 
//     radius - the radius  of the convex
//     spacing - a small space between parts to avoid overlaping while printing.
module convex(radius, spacing) {
    $fn = 48;
    inner_radius = radius - spacing * 1.414;

	linear_extrude(inner_radius * 0.75 + spacing , scale = 1 / 4) 
	    circle(inner_radius);
}

// A joint with a convex.
// Parameters: 
//     radius - the radius  of the circle on the joint
//     width - the width of the joint
//     spacing - a small space between parts to avoid overlaping while printing.
module joint_convex(radius, width, spacing) {
    joint_base(radius, width, spacing);
	translate([0, 0, width]) 
	    convex(radius - radius / 3, spacing);
    mirror([0, 0, 1]) 
	    convex(radius - radius / 3, spacing);
}

// A concave for creating a joint
// Parameters: 
//     radius - the radius  of the concave
module concave(radius) {
    $fn = 48;
	linear_extrude(radius * 0.75 , scale = 1 / 4) 
	    circle(radius);
}

// concave_convex demo
// Parameters: 
//     radius - the radius  of the convex and the concave
//     spacing - a small space between parts to avoid overlaping while printing.
module concave_convex(radius, spacing) {
    $fn = 48;
	inner_radius = radius - spacing * 1.414;
	
	linear_extrude(radius * 0.75 , scale = 1 / 4) 
	    circle(radius);

	translate([0, 0, -spacing]) 
	    linear_extrude(inner_radius * 0.75 + spacing , scale = 1 / 4)
    		circle(inner_radius);
}

// A joint with a concave.
// Parameters: 
//     radius - the radius  of the circle on the joint
//     width - the width of the joint
//     spacing - a small space between parts to avoid overlaping while printing.
module joint_concave(radius, width, spacing) {
	difference() {
	    joint_base(radius, width, spacing);
	    concave(radius - radius / 3);
	}
}

// A joint between cubes.
// Parameters: 
//     radius - the radius  of the circle on the joint
//     width - the total width of the joint
//     spacing - a small space between parts to avoid overlaping while printing.
module joint(radius, width, spacing) {
    width_convex = width / 2;
	width_concave = width / 4;
	
    rotate([-90, 0, 0]) translate([0, 0, -width_concave]) union() {
		joint_convex(radius, width_convex, spacing);
		
		mirror([1, 0, 0]) union() {
			translate([0, 0, width_convex + spacing]) 
			    joint_concave(radius, width_concave, spacing);
				
			translate([0, 0, -spacing]) mirror([0, 0, 1]) 
			    joint_concave(radius, width_concave, spacing);
		}
	}
}