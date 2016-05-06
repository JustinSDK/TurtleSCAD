use <generalized_soccer_polyhedron.scad>;
use <soccer_puzzle.scad>;

radius = 30;
concave = "hexagon";
spacing = 0.3;
shell_thickness = 3; 

// ==================================================================

// a generalized pentagon and a generalized hexagon for a puzzle.
// Parameters:
//     length : the side length
//     spacing : the gap between the pentagon and hexagon
module generalized_pentagon_based_sub_for_puzzle(length, spacing = 0.5) {
	pentagon_circle_r = 0.5 * length / sin(36);
	
	generalized_pentagon(length, spacing) children(0); 
	
	a = 37.325;
	
	offset_y = 0.5 * length * tan(54) + pentagon_circle_r * cos(a);
	offset_z = 0.5 * length * tan(60) * sin(a);
	
	for(i = [0:4]) {
		rotate(72 * i) translate([0, -offset_y, -offset_z]) 
			rotate([a, 0, 0]) 
				generalized_hexagon(length, spacing) children(1); 
	}
}

module pentagon_puzzle(radius, shell_thickness, spacing) {
    height = (radius + 2) * 2;
    line_length = height / 6.65;
	
	difference() {
		intersection() {
			translate([0, 0, line_length * 5.64875  -height / 2]) 
				generalized_pentagon_based_sub_for_puzzle(line_length, spacing) {
    pentagon_for_soccer_polyhedron(height);
	hexagon_for_single_soccer_puzzle_circles_only(height, spacing);
}


			sphere(radius, $fn = 48);
		}
		sphere(radius - shell_thickness, $fn = 48);
	}
}

// create a hexagon according the height of the soccer polyhedron
module hexagon_for_single_soccer_puzzle(height, spacing) {
    line_length = height / 6.65;
    r = 0.5 * line_length / sin(30);
	
	difference() {
		circle(r, $fn = 6);
		
		for(i = [0:2]) {
			rotate(90 + i * 120)
				translate([r / 1.325, 0, 0]) 
					circle(r / 4.5, $fn = 48);
		}
	}
}


// create circles around a hexagon according the height of the soccer polyhedron
module hexagon_for_single_soccer_puzzle_circles_only(height, spacing) {
    line_length = height / 6.65;
    r = 0.5 * line_length / sin(30);
	s = (r - spacing * 4) / r;	
	
	rotate(90) 
		translate([r / 1.325, 0, 0]) 
			scale([s, s, 1])
				circle(r / 4.5, $fn = 48);
}

module hexagon_puzzle(radius, shell_thickness, spacing) {
    height = (radius + 2) * 2;
    line_length = height / 6.65;
	
	rotate([37.325, 0, 0])
	difference() {
		intersection() {
			translate([0, 0, line_length * 5.5836  -height / 2]) 
				generalized_hexagon(height / 6.65, spacing)
				    hexagon_for_single_soccer_puzzle(height, spacing);

			sphere(radius, $fn = 48);
		}
		sphere(radius - shell_thickness, $fn = 48);
	}
}

pentagon_puzzle(radius, shell_thickness, spacing);
hexagon_puzzle(radius, shell_thickness, spacing);

*soccer_puzzle(radius, concave, shell_thickness, spacing);