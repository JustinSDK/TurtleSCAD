use <2d.scad>;
use <turtle.scad>;
use <string.scad>;
use <symmetrical_virtual_triangle.scad>;
use <square_to_cylinder.scad>;

radius = 25;
height = 30;
xs = "10 -6.5 -3 0";
ys = "-6 -6 0 0";
triangle_side_length = 20;
line_width = 1.25;
thickness = 2;
fn = 24;

module generalized_zentangle(width, length, xs, ys, triangle_side_length, line_width, thickness) {
	x_triangles = width / triangle_side_length * 2.25;
	y_triangles = length / triangle_side_length * 1.25 + 1; 
	
	linear_extrude(thickness) union() {
		intersection() {
		    square([width, length]);
			translate([-triangle_side_length / 2.75, 0, 0]) symmetrical_virtual_triangle(strs_to_points(split(xs, " "), split(ys, " ")), triangle_side_length, x_triangles, y_triangles, line_width);
		}

		difference() {
			square([width, length]);
			offset(delta = -line_width * 2) square([width, length]);
		}
	}
}

module generalized_zentangle_bracelet(radius, height, xs, ys, triangle_side_length, line_width, thickness, fn) {
    length = 6.28318 * radius;
	width  = height;
	square_to_cylinder(length + line_width * 2,  width, 2, fn)  
		generalized_zentangle(height, 6.28318 * radius, xs, ys, triangle_side_length, line_width, thickness);
}

generalized_zentangle_bracelet(radius, height, xs, ys, triangle_side_length, line_width, thickness, fn);

// generalized_zentangle(height, 6.28318 * radius, xs, ys, triangle_side_length, line_width, thickness);
