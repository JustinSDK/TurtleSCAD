height = 30; 
spacing = 0.5;

// create a pentagon by length.
// Parameters:
//     length : the side length
//     spacing : the gap between a pentagon or a hexagon
module pentagon(length, spacing = 0.5) {
    color("black") 
	    rotate(18) 
		     linear_extrude(length, scale = 1.425)
		        offset(r = -spacing / 2) 
			        circle(0.5 * length / sin(36), $fn = 5);
}

// create a hexagon by length.
// Parameters:
//     length : the side length
//     spacing : the gap between a pentagon or a hexagon
module hexagon(length, spacing = 0.5) {
    color("white") 
	     linear_extrude(length - length * 0.02389, scale = 1.425) 
		    offset(r = -spacing / 2) 
		        circle(0.5 * length / sin(30), $fn = 6);
}

// a pentagon and a hexagon.
// Parameters:
//     length : the side length
//     spacing : the gap between the pentagon and hexagon
module pentagon_based_sub_comp(length, spacing = 0.5) {
	pentagon_circle_r = 0.5 * length / sin(36);
	
	offset_y = pentagon_circle_r * cos(36);

	pentagon(length, spacing);
	
	rotate(144) translate([0, -offset_y, 0]) 
	   rotate([37.5, 0, 0]) 
	       translate([0, -pentagon_circle_r, 0]) 
		       hexagon(length, spacing);
	
}

// two hexagons and one pentagon.
// Parameters:
//     length : the side length
//     spacing : the gap between the pentagon and hexagon
module hexagon_based_sub_comp(length, spacing = 0.5) {
    hexagon(length, spacing);
	
	length_center_to_side = 0.5 * length * tan(54);
		
	rotate(120) 
	    translate(
		    [ 
			  0, 
			  length_center_to_side * cos(36) + length * tan(60) / 2,
			  length_center_to_side * sin(-36)
			]
		) rotate([-37.5, 0, 0]) pentagon_based_sub_comp(length, spacing);
}

// a half of soccer polyhedron.
// Parameters:
//     line_length : the side length of pentagons and hexagons
//     spacing : the gap between the pentagon and hexagon
module half_soccer_polyhedron(line_length, spacing = 0.5) {
	pentagon_circle_r = 0.5 * line_length / sin(36);
	offset_y = pentagon_circle_r * cos(36);

	pentagon(line_length, spacing);
	for(i = [0:4]) {
		rotate(72 * i) 
		    translate([0, -offset_y, 0]) 
		        rotate([37.5, 0, 0]) 
				    translate([0, -pentagon_circle_r * 1.018, 0])
  					    hexagon_based_sub_comp(line_length, spacing);
	}
}

// a soccer polyhedron.
// Parameters:
//     line_length : the side length of pentagons and hexagons
//     spacing : the gap between the pentagon and hexagon
//     center : center it or not
module soccer_polyhedron(height, spacing = 0.5, center = true) {
    line_length = height / 6.6;
	offset_for_center = center ? height / 2: 0;
	
	translate([0, 0, line_length - offset_for_center]) union() {
		translate([0, 0, line_length * 4.6]) rotate(36) half_soccer_polyhedron(line_length, spacing);
		mirror([0, 0, 1]) half_soccer_polyhedron(line_length, spacing);
	}
}

soccer_polyhedron(height, spacing); 