length = 300;
width = 100;
thickness = 2;
fn = 48;
 
module one_over_fn_for_circle(r, fn) {
    a = 360 / fn;
	x = r * cos(a / 2);
	y = r * sin(a / 2);
	polygon(points=[[0, 0], [x, y],[x, -y]]);
}



module square_to_cylinder(length, width, square_thickness, fn) {
    r = length / 6.28318;
    a = 360 / fn;
	y = r * sin(a / 2);
	for(i = [0 : fn - 1]) {
	    rotate(a * i) translate([0, -(2 * y * i + y), 0]) intersection() {
		    translate([0, 2 * y * i + y, 0]) 
		        linear_extrude(width) 
				    one_over_fn_for_circle(r, fn);
			translate([r - square_thickness, 0, width]) 
	            rotate([0, 90, 0]) 
	                children(0);
		}
	}
}

module test(width, length, thickness) {     
	 difference() {
	     linear_extrude(thickness) square([width, length]);
	     translate([75, 5, 0]) rotate(90) linear_extrude(thickness) text("TESTABCADBC", size = 28);
	 }
}

module caterpillar(thickness) {
    difference() {
		intersection() {
			linear_extrude(thickness) square([100, 100]);
			surface(file = "caterpillar.png");
		}
		linear_extrude(0.1) square([100, 100]);
	}
}

module three_caterpillars(thickness) {     
	translate([100, 0, 0]) rotate(90) caterpillar(thickness);
	translate([100, 100, 0]) rotate(90) caterpillar(thickness);
	translate([100, 200, 0]) rotate(90) caterpillar(thickness);					
}

square_to_cylinder(length, width, thickness, fn) test(width, length, thickness);
//test(width, length, thickness);

*square_to_cylinder(length, width, thickness, fn) three_caterpillars(thickness);
// three_caterpillars(thickness);