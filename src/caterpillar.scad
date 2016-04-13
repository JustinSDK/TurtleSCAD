use <2d.scad>;

radius = 5;

module wheel(radius) {
    $fn = 96;
    rotate_extrude() translate([radius, 0, 0]) circle(radius / 2);
}

module wheels(radius) {
	wheel(radius);
	translate([radius * 4, 0, 0]) wheel(radius);
	translate([radius * 8, 0, 0]) wheel(radius);
}

module track(radius) {
    $fn = 96;
    translate([-radius * 4, 0, -radius])
	scale([1, 1, 1.5])  union() {
		color("black") difference() {
			linear_extrude(radius * 1.5) offset(r = radius / 5) hull() {
				circle(1.5 * radius);
				translate([radius * 8, 0, 0]) circle(1.5 * radius);
			}

			translate([0, 0, -radius / 4]) linear_extrude(radius * 2) hull() {
				circle(1.25 * radius);
				translate([radius * 8, 0, 0]) circle(1.25 * radius);
			}
		}
		color("white") translate([0, 0, radius * 0.75]) scale([1, 1, 1.5]) wheels(radius);
	}
}

module eye(radius) {
    $fn = 96;
	translate([-radius / 15, 0, 0]) 
	    rotate([0, 0, 90]) 
		    arc(radius / 2, [0, 180], radius / 5);
			
    translate([0, radius / 3, 0]) circle(radius / 3);
}

module eyebrow(radius) {
	rotate([0, 0, 90]) 
		arc(radius / 1.25, [25, 155], radius / 10);
}


module body(radius) {
    $fn = 96;
    scale([1, 1, 0.9]) union() {
		color("yellow") sphere(radius * 4);
		color("Aqua") rotate([85, 0, 90]) intersection() {
			linear_extrude(radius * 4.5) sector(radius * 3.5, [0, 180]);
			difference() {
				sphere(radius * 4 + radius / 5);
				sphere(radius * 4);
			}
		}
		
		// eyes
		color("black") union() {    
			rotate([0, 65, 16]) 
				linear_extrude(radius * 4.25)
					eye(radius);
			
			rotate([0, 65, -16]) 
				linear_extrude(radius * 4.25) 
					eye(radius);
		}
		
		// eyebrows
		color("black") union() {
			rotate([0, 55, 20]) 
				linear_extrude(radius * 4.25)
  				    eyebrow(radius);
				
			rotate([0, 55, -20]) 
				linear_extrude(radius * 4.25) 
				    eyebrow(radius);				
		}

	}
}

module arm(radius) {
    $fn = 96;
    translate([0, 0, -radius]) union() {
		translate([0, 0, radius / 2]) linear_extrude(radius) 
		union() {
			translate([0, -radius * 0.75, 0]) square([radius * 9, radius * 1.5]);
			rotate(80) translate([0, -radius * 0.5, 0]) square([radius * 9, radius]);
		}

		
		translate([0, 0, radius * 0.25]) 
		    linear_extrude(radius * 1.5) circle(radius);
		linear_extrude(radius * 2)  
		    translate([radius * 9, 0, 0]) circle(radius);
		
	}
}

module glove(radius) {
    $fn = 96;
    scale([0.8, 0.8, 1.2]) union() {
		color("white") union() {
			hull() {
				scale([1.1, 1, 0.5]) sphere(radius * 2.5);
				translate([-radius * 1.75, 0, radius / 1.5]) scale([1, 1.75, 0.8]) sphere(radius);
			}

			translate([-radius * 2.5, 0, radius / 1.5]) scale([1.2, 2, 1]) sphere(radius);


			rotate(-10) translate([0, -radius * 2.5, 0])  scale([1.75, 1, 0.8]) sphere(radius / 1.5);	
			
		}   
		color("black") intersection() {
			scale([1.1, 1, 0.55]) sphere(radius * 2.5);
			union() {
				translate([0, radius * 0.75, -radius * 2])  
					linear_extrude(radius) 
						square([radius * 2, radius / 4], center = true);
				translate([0, -radius * 0.75, -radius * 2])  
					linear_extrude(radius) 
						square([radius * 2, radius / 4], center = true);				
			}
		}
	}
}

module big_caterpillar(radius) {
	translate([0, -radius * 4, 0]) rotate([90, 0, 0]) track(radius);
	translate([0, 0, radius * 3]) body(radius);
	translate([0, radius * 4, 0]) rotate([90, 0, 0]) track(radius);
	
	color("yellow") translate([radius * 6, -radius * 4.5, radius * 9.5]) rotate([90, 135, 0]) arm(radius);
	
	translate([radius * 10.75, -radius * 4.5, radius / 2.325]) rotate([0, 70, 180]) glove(radius);
}

module small_caterpillar(radius) {
    $fn = 96;
	color("LimeGreen") union() {
		translate([0, 0, -radius / 3]) sphere(radius);
		translate([radius * 1.5, 0, 0]) sphere(radius);
		translate([radius * 3, 0, radius]) sphere(radius);
		translate([radius * 4.25, 0, radius * 2]) sphere(radius);
	}

	color("white") translate([radius * 4.75, 0, radius * 3]) union() {
		translate([0, radius / 2, 0]) sphere(radius / 1.5);
		translate([0, -radius / 2, 0]) sphere(radius / 1.5);
	}

	color("black") translate([radius * 5.25, radius / 4, radius * 3]) union() {
		translate([0, radius / 2, 0]) sphere(radius / 3);
		translate([0, -radius / 2, 0]) sphere(radius / 3);
	}

	color("white") translate([radius * 5.4, radius / 2.75, radius * 3]) union() {
		translate([0, radius / 2, 0]) sphere(radius / 6);
		translate([0, -radius / 2, 0]) sphere(radius / 6);
	}
}

module caterpillars(radius) {
	big_caterpillar(radius);
	translate([radius * 3.5, -radius * 4.5, radius * 9.75]) 
		rotate([0, -15, 0]) 
			scale([0.8, 0.8, 0.8]) small_caterpillar(radius);
}

caterpillars(radius);


