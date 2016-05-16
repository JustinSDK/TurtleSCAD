use <2d.scad>;
use <turtle.scad>;
use <string.scad>;
use <symmetrical_virtual_triangle.scad>;
use <square_to_cylinder.scad>;

radius = 25;
height = 30;
line_width = 1.25;
thickness = 2;
fn = 24;

module zentangle(width, length, line_width, thickness) {
	xs = "-8.75.5 -4.75 -2.5 -0.75 0 0.75 2.5 4.75 8.75"; 
	ys = "-5 -5 -1.5 -2.5 0 -2.5 -1.5 -5 -5"; 
	triangle_side_length = 17.5; 
	x_triangles = 0.2 * width;
	y_triangles = 0.075 * length; 
	
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

module zentangle_bracelet(radius, height, line_width, thickness, fn) {
    length = 6.28318 * radius;
	width  = height;
	square_to_cylinder(length + line_width * 2,  width, 2, fn)  
		zentangle(width, length, line_width, thickness);
}

zentangle_bracelet(radius, height, line_width, thickness, fn);

// zentangle(height, 6.28318 * radius, line_width, thickness);
