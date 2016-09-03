radius = 15;

module cat_corner_protector(radius) {
    module ear() {
		translate([0, 0, radius * 0.85]) rotate([45, -90, 0]) translate([0, 0, -radius]) intersection() {
			difference() {
				sphere(radius);
				sphere(radius - 1);
			}
			linear_extrude(radius * 1.5) hull() {
				translate([radius * 0.4, 0, 0]) circle(radius * 0.1, $fn = 24);
				circle(radius * 0.5, $fn = 3);
			}	
		}
	}
	
	module beard_cube() {
	    linear_extrude(radius * 1.05) square([radius * 0.0275, radius * 0.3], center = true);
	}
	
	color("white") rotate([50, 0, 25]) ear();
	color("white") rotate([0, -50, -25]) ear();
	
	// beards
	color("black") intersection() {
		difference() {
			sphere(radius * 1.05, $fn = 48);
			sphere(radius, $fn = 48);
		}
		
		union() {	
			rotate([0, 70, -5]) beard_cube();
			rotate([0, 65, -5]) beard_cube();
			rotate([0, 70, 95]) beard_cube();
			rotate([0, 65, 95]) beard_cube();	
		}
	}
	
	// face
	color("white") difference() {
		sphere(radius, $fn = 48);
		translate([-radius * 0.25 , -radius * 0.25, -radius * 1.25]) 
			cube([radius * 1.5, radius * 1.5, radius * 1.5]);
	}

	// nose
	color("black") scale([1, 1, 0.75]) translate([radius * 0.6, radius * 0.6, radius * 0.55]) sphere(radius * 0.125, $fn = 24);

	// eyes
	color("black") translate([radius * 0.1, radius * 0.75, radius * 0.525]) sphere(radius * 0.115, $fn = 25);
		
	color("black") translate([radius * 0.75, radius * 0.1, radius * 0.525]) sphere(radius * 0.115, $fn = 25);

}

rotate(-135) cat_corner_protector(radius);



