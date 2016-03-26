use <2d.scad>;

piece_side_length = 25;
// for n x n multiplication puzzle
n = 9; // [1:9]
spacing = 0.5;

// Create a puzzle piece with a text.
//
// Parameters: 
//     side_length - the length of the piece.
//     text - a text shown on the piece.
//     spacing - a small space between pieces to avoid overlaping while printing.
module puzzle_piece_with_text(side_length, text, spacing) {
    half_side_length = side_length / 2;
	
    difference() {
		puzzle_piece(side_length, spacing);
		translate([half_side_length, half_side_length, 0]) 
			rotate(-45) 
			     text(text, size = side_length / 3, 
					 halign = "center", valign = "center");
	}
}

// Create a multiplication_puzzle.
//
// Parameters: 
//     xs - the amount of pieces in x direction.
//     ys - the amount of pieces in y direction.
//     piece_side_length - the length of a piece.
//     spacing - a small space between pieces to avoid overlaping while printing.
module multiplication_puzzle(xs, ys, piece_side_length, spacing) {
    $fn = 48;
	circle_radius = piece_side_length / 10;
	half_circle_radius = circle_radius / 2;
	side_length_div_4 = piece_side_length / 4;
	
	intersection() {
		union() for(x = [0 : xs - 1]) {
			for(y = [0 : ys - 1]) {
			    r = (x + 1) * (y + 1);
				linear_extrude(r) union() {
					translate([piece_side_length * x, piece_side_length * y, 0]) 
						puzzle_piece_with_text(piece_side_length, str(r), spacing);
						
					if(x == 0) {
						translate([half_circle_radius, side_length_div_4 + piece_side_length * y, 0]) 
							circle(circle_radius);
						translate([half_circle_radius, side_length_div_4 * 3 + piece_side_length * y, 0]) 
							circle(circle_radius);			
					}
					if(y == ys - 1) {
						translate([side_length_div_4 + piece_side_length * x, piece_side_length * (y + 1) - half_circle_radius, 0]) 
							circle(circle_radius);
						translate([side_length_div_4 * 3 + piece_side_length * x, piece_side_length * (y + 1) - half_circle_radius, 0]) 
							circle(circle_radius);	
					}
				}
                linear_extrude(r - 0.6) 
					translate([piece_side_length * x, piece_side_length * y, 0]) 
					    puzzle_piece(piece_side_length, spacing);
			}
		}
		
		linear_extrude(81) square([piece_side_length * xs - spacing, piece_side_length * ys - spacing]);
	}
}

multiplication_puzzle(n, n, piece_side_length, spacing);
