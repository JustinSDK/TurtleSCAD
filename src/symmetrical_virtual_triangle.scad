xs = "0 1.5 1.5 -4 -6.5"; 
ys = "0 2.5 -6 -6 0";
triangle_side_length = 20;
x_triangles = 10;
y_triangles = 6;
line_width = 0.5;
height = 2;

use <2d.scad>;
use <turtle.scad>;
use <string.scad>;
  
////////////////////////////////
// Symmetrical virtual triangle

// Use the given points, draw a ployline. Repeat the previous step after rotate 120 and 240 degrees.
// Parameters: 
//     points - the coordinates of the polyline segments.
//     line_width  - the line width.
module virtual_triangle(points, line_width = 1) {
    polyline(points, line_width);
    rotate([0, 0, 120]) polyline(points, line_width);
    rotate([0, 0, 240]) polyline(points, line_width);
}

// Draw a symmetrical virtual triangle. 
// Parameters: 
//     points - the coordinates of the polyline segments of a single virtual_triangle.
//     length - the length of a triangle side.
//     x_tris - the numbers of triangles in the x directions
//     y_tris - the numbers of triangles in the y directions
//     line_width  - the line width.
module symmetrical_virtual_triangle(points, length, x_tris, y_tris, line_width = 1) {
    height = length * sqrt(3) / 2;
    x_numbers = x_tris % 2 == 0 ? x_tris + 1 : x_tris;
    y_numbers = y_tris - 1; //(y_tris % 2 == 0 ? y_tris + 1 : y_tris) - 1;
    for(y_factor = [0 : y_numbers]) {
        for(x_factor = [0 : x_numbers]) {
            x_offset = length / 2 * x_factor + (y_factor % 2) * length / 2;
            y_offset = height * y_factor;
            
            if(x_factor % 2 == 0) {
                if(x_factor != 0 || y_factor % 2 != 0) {
                    translate([x_offset, y_offset, 0]) 
                        virtual_triangle(points, line_width); 
                } 
            } else {
                if(x_factor != x_numbers || y_factor % 2 == 0) {
                    translate([x_offset, height / 3 + y_offset, 0])   
                    mirror([0, 1, 0]) 
                        virtual_triangle(points, line_width);
                } 
            }
        }
    }
}

/* Examples
points1 = [
    [17.5, -10], 
    [9.5, -10],
    [5, -2.5],
    [1.5, -2.5],
    [0, 0],
    [-1.5, -2.5],
    [-5, -2.5],
    [-9.5, -10],
    [-17.5, -10]
];

linear_extrude(2) symmetrical_virtual_triangle(points1, 35, 10, 4, 1);

points2 = [
    [10, -6], 
    [-6.5, -6],
    [-3, 0],
    [0, 0]
];

linear_extrude(2) translate([225, 0, 0]) symmetrical_virtual_triangle(points2, 20, 10, 4, 0.5);

points3 = [
    [0, 0], 
    [1.5, 2.5], 
    [1.5, -6],
    [-4, -6],
    [-6.5, 0]
];

linear_extrude(2) translate([0, 200, 0]) symmetrical_virtual_triangle(points3, 20, 10, 4, 0.5);
*/



// for MakerBot Customizer
function strs_to_points(xs, ys, points = [], index = 0) = 
    index == len(xs) ? points : strs_to_points(xs, ys, concat(points, [[parse_number(xs[index]), parse_number(ys[index])]]), index + 1);

linear_extrude(height) 
    symmetrical_virtual_triangle(strs_to_points(split(xs, " "), split(ys, " ")), triangle_side_length, x_triangles, y_triangles, line_width);
