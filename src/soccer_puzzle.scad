use <generalized_soccer_polyhedron.scad>;

radius = 30; 
concave = "pentagon";
spacing = 0.3;
shell_thickness = 3;

// create a pentagon according the height of a soccer puzzle
module pentagon_for_soccer_puzzle(height, spacing) {
    line_length = height / 6.65;
	r = 0.5 * line_length / sin(36);
	s = (r - spacing * 4) / r;
	
	difference() {
		circle(r, $fn = 5);
		
		for(i = [1:2:9]) {
		    rotate(36 * i) 
			    translate([r / 1.375, 0, 0]) 
		            circle(r / 4.5, $fn = 48);
		}
	}
	
	for(i = [1:2:9]) {
	    rotate(36 * i) 
		    translate([r / 1.375, 0, 0]) 
			    scale([s, s, s])
				    circle(r / 4.5, $fn = 48);
	}
}

// create a hexagon according the height of a soccer puzzle
module hexagon_for_soccer_puzzle(height, spacing) {
    line_length = height / 6.65;
    r = 0.5 * line_length / sin(30);
	s = (r - spacing * 4) / r;	
	
	difference() {
		circle(r, $fn = 6);
		
		for(i = [0:2]) {
			rotate(90 + i * 120) 
				translate([r / 1.325, 0, 0]) 
					circle(r / 4.5, $fn = 48);
		}
	}
	
	for(i = [0:2]) {
		rotate(90 + i * 120) 
			translate([r / 1.325, 0, 0]) 
				scale([s, s, 1]) 
				    circle(r / 4.5, $fn = 48);
	}
}

// create a soccer puzzle
module soccer_puzzle(radius, concave, shell_thickness, spacing) {

	height = (radius + 2) * 2;
	
	difference() {
		intersection() {
		    if(concave == "pentagon") {
				generalized_soccer_polyhedron(height, spacing) {
					pentagon_for_soccer_puzzle(height, spacing);
					hexagon_for_soccer_polyhedron(height);
				}
			} else if(concave == "hexagon") {
				generalized_soccer_polyhedron(height, spacing) {
				    pentagon_for_soccer_polyhedron(height);
				    hexagon_for_soccer_puzzle(height, spacing);
			    }
			}

			sphere(radius, $fn = 48);
		}
		
		sphere(radius - shell_thickness, $fn = 48);
	}
}

soccer_puzzle(radius, concave, shell_thickness, spacing);