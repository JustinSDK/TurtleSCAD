use <generalized_soccer_polyhedron.scad>;
use <soccer_puzzle.scad>;

radius = 30; 
spacing = 0.3;
shell_thickness = 3;

// a generalized hexagon and a generalized pentagon for a puzzle.
// Parameters:
//     length : the side length
//     spacing : the gap between the pentagon and hexagon
module generalized_hexagon_based_sub_for_puzzle(length, spacing = 0.5) {
    
    generalized_hexagon(length, spacing) 
	    children(1); 
	
	length_center_to_side = 0.5 * length * tan(54);
	
    a = -37.325;
	
	offset_y = 0.5 * length * (tan(54) * cos(a) + tan(60));
	offset_z = length_center_to_side * sin(a);
	
	for(i = [1:3]) {
		rotate(120 * i) translate([0, offset_y, offset_z]) 
			rotate([a, 0, 0]) 
			    rotate(-18) 
				    generalized_pentagon(length, spacing) 
			            children(0);
	}
}

// create a pentagon according the height of the soccer polyhedron
module pentagon_for_single_soccer_puzzle(height, spacing) {
    line_length = height / 6.65;
	r = 0.5 * line_length / sin(36);
	s = (r - spacing * 4) / r;
	
	difference() {
		circle(r, $fn = 5);
		
		for(i = [1:2:9]) {
		    rotate(36 * i) 
			    translate([r / 1.4, 0, 0]) 
		            circle(r / 4.5, $fn = 48);
		}
	}
}

module pentagon_puzzle(radius, shell_thickness, spacing) {
    height = (radius + 2) * 2;
    line_length = height / 6.65;
	
	difference() {
		intersection() {
			translate([0, 0, line_length * 5.64875  -height / 2]) 
				generalized_pentagon(height / 6.65, spacing) 
					pentagon_for_single_soccer_puzzle(height, spacing);

			sphere(radius, $fn = 48);
		}
		sphere(radius - shell_thickness, $fn = 48);
	}

}

// create circles around a pentagon according the height of the soccer polyhedron
module pentagon_for_single_soccer_puzzle_circles_only(height, spacing) {
    line_length = height / 6.65;
	r = 0.5 * line_length / sin(36);
	s = (r - spacing * 4) / r;
	
	rotate(270) 
	    translate([r / 1.4, 0, 0]) 
		    scale([s, s, s])
			    circle(r / 4.5, $fn = 48);
}

module hexagon_puzzle(radius, shell_thickness, spacing) {
    height = (radius + 2) * 2;
    line_length = height / 6.65;
	
	rotate([37.325, 0, 0])
	difference() {
		intersection() {
			translate([0, 0, line_length * 5.5836  -height / 2]) 
				generalized_hexagon_based_sub_for_puzzle(line_length, spacing) 
				    {
				        pentagon_for_single_soccer_puzzle_circles_only(height, spacing); 
						hexagon_for_soccer_polyhedron(height);
					}

			sphere(radius, $fn = 48);
		}
		sphere(radius - shell_thickness, $fn = 48);
	}

}

pentagon_puzzle(radius, shell_thickness, spacing);
hexagon_puzzle(radius, shell_thickness, spacing);

*soccer_puzzle(radius, "pentagon", shell_thickness, spacing);
