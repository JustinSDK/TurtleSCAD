use <2d.scad>;
use <turtle.scad>;
use <string.scad>;
use <symmetrical_virtual_triangle.scad>;
use <square_to_cylinder.scad>;

filename = "";
thickness = 2;
fn = 24;

// read Heightmap information from a png file.
// Parameters:
//     filename - a png filename
//     width  - the png's width
//     length  - the png's length
//     thickness - the height of the model
module from_png(filename, length, width, thickness) {
	translate([width - 1, 0, 0]) rotate(90) 
		scale([1, 1, 0.01 * thickness]) surface(filename); 
}

module blank_pen_holder(length, width, thickness) {
	color("black") linear_extrude(width) difference() {
		circle(length / 6.28318 - thickness / 2);
		circle(length / 6.28318 - thickness);
	}
	color("white") linear_extrude(thickness / 2) circle(length / 6.28318);
}

module png_to_pen_holder(filename, length, width, thickness) {
	blank_pen_holder(length - 1, width - 1, thickness);
	color("white") 
	    square_to_cylinder(length - 1, width - 1, thickness, fn)    
		    from_png(filename, length, width, thickness);
}

png_to_pen_holder(filename, 335, 100, thickness);

/*

filename1 = ""; // [image_surface:100x100]
filename2 = ""; // [image_surface:100x100]
filename3 = ""; // [image_surface:100x100]

// specific for thingiverse customizer
module from_100x100_pngs(filenames, thickness) {
	translate([99, 0, 0]) rotate(90) { 
	    surface(filenames[0]); 
		translate([99, 0, 0]) surface(filenames[1]); 
		translate([198, 0, 0]) surface(filenames[2]); 
	} 
}

// specific for thingiverse customizer
module 100x100_pngs_to_pen_holder(filenames, thickness) {
	blank_pen_holder(300 - 4, 100 - 1, thickness);
	color("white") 
	    square_to_cylinder(300 - 3, 100 - 1, thickness, fn)    
		    from_100x100_pngs(filenames, thickness);
}

// specific for thingiverse customizer
//100x100_pngs_to_pen_holder([filename1, filename2, filename3], thickness);

*/




