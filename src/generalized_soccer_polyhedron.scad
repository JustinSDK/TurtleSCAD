height = 30; 
spacing = 0.5;

// create a generalized pentagon by length.
// Parameters:
//     length : the side length
//     spacing : the gap between a pentagon or a hexagon
module generalized_pentagon(length, spacing = 0.5) {
    color("black") 
	    rotate(18) 
		     linear_extrude(length, scale = 1.425)
		        offset(r = -spacing / 2) 
				    children();
}

// create a generalized hexagon by length.
// Parameters:
//     length : the side length
//     spacing : the gap between a pentagon or a hexagon
module generalized_hexagon(length, spacing = 0.5) {
    color("white") 
	     linear_extrude(length - length * 0.02389, scale = 1.425) 
		    offset(r = -spacing / 2) 
		        children();
}

// a generalized pentagon and a generalized hexagon.
// Parameters:
//     length : the side length
//     spacing : the gap between the pentagon and hexagon
module generalized_pentagon_based_sub_comp(length, spacing = 0.5) {
	pentagon_circle_r = 0.5 * length / sin(36);
	
	offset_y = pentagon_circle_r * cos(36);

	generalized_pentagon(length, spacing) children(0);
	    
	
	rotate(144) translate([0, -offset_y, 0]) 
	   rotate([37.5, 0, 0]) 
	       translate([0, -pentagon_circle_r, 0]) 
		       generalized_hexagon(length, spacing) children(1);           
}

// two generalized hexagons and one generalized pentagon.
// Parameters:
//     length : the side length
//     spacing : the gap between the pentagon and hexagon
module generalized_hexagon_based_sub_comp(length, spacing = 0.5) {
    generalized_hexagon(length, spacing) children(1);

	length_center_to_side = 0.5 * length * tan(54);
		
	rotate(120) 
	    translate(
		    [ 
			  0, 
			  length_center_to_side * cos(36) + length * tan(60) / 2,
			  length_center_to_side * sin(-36)
			]
		) rotate([-37.5, 0, 0]) 
		      generalized_pentagon_based_sub_comp(length, spacing) {
			      children(0); 
				  children(1); 
		      }
}

// a half of generalized soccer polyhedron.
// Parameters:
//     line_length : the side length of pentagons and hexagons
//     spacing : the gap between the pentagon and hexagon
module generalized_half_generalized_soccer_polyhedron(line_length, spacing = 0.5) {
	pentagon_circle_r = 0.5 * line_length / sin(36);
	offset_y = pentagon_circle_r * cos(36);

	generalized_pentagon(line_length, spacing) children(0);
	
	for(i = [0:4]) {
		rotate(72 * i) 
		    translate([0, -offset_y, 0]) 
		        rotate([37.5, 0, 0]) 
				    translate([0, -pentagon_circle_r * 1.018, 0])
  					    generalized_hexagon_based_sub_comp(line_length, spacing) 
						    {
							    children(0); 
								children(1); 
							}
	}
}

// a generalized soccer polyhedron.
// Parameters:
//     line_length : the side length of pentagons and hexagons
//     spacing : the gap between the pentagon and hexagon
//     center : center it or not
module generalized_soccer_polyhedron(height, spacing = 0.5, center = true) {
    line_length = height / 6.6;
	offset_for_center = center ? height / 2: 0;
	
	translate([0, 0, line_length - offset_for_center]) union() {
		translate([0, 0, line_length * 4.6]) rotate(36) generalized_half_generalized_soccer_polyhedron(line_length, spacing) {
		    children(0);
			children(1);
		}
		
		mirror([0, 0, 1]) 
		    generalized_half_generalized_soccer_polyhedron(line_length, spacing) {
		        children(0);
			    children(1);
		}
	}
}

// create a pentagon according the height of the soccer polyhedron
module pentagon_for_soccer_polyhedron(height) {
    r = 0.5 * height / 6.6 / sin(36);
    circle(r, $fn = 5);
}

// create a hexagon according the height of the soccer polyhedron
module hexagon_for_soccer_polyhedron(height) {
    r = 0.5 * height / 6.6 / sin(30);
    circle(r, $fn = 6);
}

generalized_soccer_polyhedron(height, spacing) {
    pentagon_for_soccer_polyhedron(height);
	hexagon_for_soccer_polyhedron(height);
}