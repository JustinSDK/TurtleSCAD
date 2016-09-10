use <2d.scad>;

from = 5; // from n-th fibonacci number
to = 10;  // to n-th fibonacci number
type = "Clockwise"; // [Clockwise, Count-clockwise, Both]
spirals = 10;
width = 1;
thickness = 50;
scale = 2;
twist = 30;


function fibonacci(nth) = 
    nth == 0 || nth == 1 ? nth : (
	    fibonacci(nth - 1) + fibonacci(nth - 2)
	);
	

module golden_spiral(from, to, count_clockwise = false, width = 1) {
    if(from <= to) {
		f1 = fibonacci(from);
		f2 = fibonacci(from + 1);
		
		offset = f1 - f2;

		a_quarter_arc(f1, 90, width);

		translate([count_clockwise ? 0 : offset, count_clockwise ? offset : 0, 0]) rotate(count_clockwise ? 90 : -90) 
			golden_spiral(from + 1, to, count_clockwise, width);

	}
}


linear_extrude(thickness, scale = scale, twist = twist) 
	for(i = [0:360 / spirals:360]) {
		rotate(i)
			golden_spiral(from, to, type == "Count-clockwise", width);
	}

if(type == "Both") {
	linear_extrude(thickness, scale = scale, twist = twist) 
		for(i = [0:360 / spirals:360]) {
			rotate(i)
				golden_spiral(from, to, !(type == "Count-clockwise"), width);
		}
}

