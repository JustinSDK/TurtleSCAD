use <generalized_soccer_polyhedron.scad>;
use <single_soccer_puzzle_concave_hexagon.scad>;

radius = 30;
piece_set = "black"; // [black, white]
spacing = 0.3;
shell_thickness = 3;

// create a pentagon according the height of the soccer polyhedron
module pentagon_for_soccer_puzzle_with_text(height, text) {
	difference() {
		pentagon_for_soccer_polyhedron(height);
		rotate(-18) text(text, font = "MS Gothic", valign = "center", halign = "center", size = height / 7);
	}	
}

module pentagon_puzzle_with_text(radius, text, shell_thickness, spacing) {
    height = (radius + 2) * 2;
    line_length = height / 6.65;
	
	difference() {
		intersection() {
			translate([0, 0, line_length * 5.64875  -height / 2]) 
				generalized_pentagon_based_sub_for_puzzle(line_length, spacing) {
    pentagon_for_soccer_puzzle_with_text(height, text);
	hexagon_for_single_soccer_puzzle_circles_only(height, spacing);
}


			sphere(radius, $fn = 48);
		}
		sphere(radius - shell_thickness, $fn = 48);
	}
	
	pentagon_puzzle(radius - 1, shell_thickness - 1, spacing);
}

// create a hexagon according the height of the soccer polyhedron
module hexagon_for_single_soccer_puzzle_with_text(height, text, spacing) {
	difference() {
		hexagon_for_single_soccer_puzzle(height, spacing);
		translate([0, -height / 45, 0]) rotate(180) text(text, font = "MS Gothic", valign = "center", halign = "center", size = height / 7);
	}
}

module hexagon_puzzle_with_text(radius, text, shell_thickness, spacing) {
    height = (radius + 2) * 2;
    line_length = height / 6.65;
	
	difference() {
		intersection() {
			translate([0, 0, line_length * 5.5836  -height / 2]) 
				generalized_hexagon(height / 6.65, spacing)
				    hexagon_for_single_soccer_puzzle_with_text(height, text, spacing);

			sphere(radius, $fn = 48);
		}
		sphere(radius - shell_thickness, $fn = 48);
	}
	rotate([-37.325, 0, 0]) hexagon_puzzle(radius - 1, shell_thickness - 1, spacing);
}

module pieces(radius, black_or_white, shell_thickness, spacing) {
    offset = 0.85 * radius;
	
	ps = black_or_white == "black" ? "♟♜♞♝♚♛" : "♙♖♘♗♔♕";
	
	for(i = [0:3]) {
	    for(j = [0:1]) {
			translate([offset * i, offset * j, 0])
   			    hexagon_puzzle_with_text(radius, ps[0], shell_thickness, spacing);
		}
	}

	for(i = [0:1]) {
		translate([offset * i, offset * 2, 0]) 
			hexagon_puzzle_with_text(radius, ps[1], shell_thickness, spacing);
	}
	
	for(i = [2:3]) {
		translate([offset * i, offset * 2, 0]) 
		    pentagon_puzzle_with_text(radius, ps[2], shell_thickness, spacing);
	}
 

	for(i = [0:1]) {
		translate([offset * i, offset * 3, 0]) 
		    pentagon_puzzle_with_text(radius, ps[3], shell_thickness, spacing);
	}

	translate([offset * 2, offset * 3, 0])
    	pentagon_puzzle_with_text(radius, ps[4], shell_thickness, spacing);
	
	translate([offset * 3, offset * 3, 0])
    	pentagon_puzzle_with_text(radius, ps[5], shell_thickness, spacing);
}

pieces(radius, piece_set, shell_thickness, spacing);


