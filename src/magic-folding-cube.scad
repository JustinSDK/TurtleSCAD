use <joint.scad>;

cube_width = 30;
joint_radius = 4;
joint_width = 15;
spacing = 0.5;

// a magic folding cube.
// Parameters: 
//     cube_width - the width of each cube
//     joint_data - [joint_radius, joint_width]
//     spacing - a small space between parts to avoid overlaping while printing.
module a_magic_cube(cube_width, joint_data, spacing) {
     $fn = 48;
	 
     joint_radius = joint_data[0];
	 joint_width = joint_data[1];
	 
	 difference() {
		 cube(cube_width);
		 
		 translate([cube_width + spacing / 2, cube_width / 2, cube_width]) cube([joint_radius * 2 + spacing * 2, joint_width + spacing * 4, joint_radius * 3 + spacing * 4], center = true);
	 }
}

// 2x1 magic folding cube.
// Parameters: 
//     cube_width - the width of each cube
//     joint_data - [joint_radius, joint_width]
//     spacing - a small space between parts to avoid overlaping while printing.
module magic_folding_cube_2x1(cube_width, joint_data, spacing) {
	joint_radius = joint_data[0];
	joint_width = joint_data[1];

	a_magic_cube(cube_width, joint_data, spacing);
	
	translate([cube_width + spacing / 2, cube_width / 2, cube_width]) 
	    joint(joint_radius, joint_width, spacing);
	
	translate([cube_width * 2 + spacing, 0, 0])
	    mirror([1, 0, 0]) a_magic_cube(cube_width, joint_data, spacing);
}

// 2x2 magic folding cube.
// Parameters: 
//     cube_width - the width of each cube
//     joint_data - [joint_radius, joint_width]
//     spacing - a small space between parts to avoid overlaping while printing.
module magic_folding_cube_2x2(cube_width, joint_data, spacing) {
    $fn = 48;

    difference() {
		union() {
			translate([0, cube_width, 0]) rotate([90, 0, 0]) magic_folding_cube_2x1(cube_width, joint_data, 0.5);

			translate([0, cube_width + spacing, cube_width]) rotate([-90, 0, 0]) magic_folding_cube_2x1(cube_width, joint_data, 0.5);
		}
		translate([cube_width / 2, cube_width + spacing / 2, cube_width]) rotate(90) cube([joint_radius * 2 + spacing * 2, joint_width + spacing * 4, joint_radius * 3 + spacing * 4], center = true);
	}
	
	translate([cube_width / 2, cube_width + spacing / 2, cube_width]) rotate(90) joint(joint_radius, joint_width, spacing);
}



// create magic folding cube.
// Parameters:
//     cube_width - the width of each cube
//     joint_data - [joint_radius, joint_width]
//     spacing - a small space between parts to avoid overlaping while printing.
module magic_folding_cube(cube_width, joint_data, spacing) {
    $fn = 48;
    joint_radius = joint_data[0];

	difference() {
		union() {
			magic_folding_cube_2x2(cube_width, [joint_radius, joint_width], spacing);

			translate([cube_width * 4 + spacing * 3, 0, 0]) mirror([1, 0, 0]) magic_folding_cube_2x2(cube_width, joint_data, spacing);
		}
		
		translate([cube_width * 2 + spacing * 1.5, cube_width / 2, 0]) cube([joint_radius * 2 + spacing * 2, joint_width + spacing * 4, joint_radius * 3 + spacing * 4], center = true);
	
		translate([cube_width * 2 + spacing * 1.5, cube_width * 1.5 + spacing , 0]) cube([joint_radius * 2 + spacing * 2, joint_width + spacing * 4, joint_radius * 3 + spacing * 4], center = true);
	}
	
	translate([cube_width * 2 + spacing * 1.5, cube_width / 2, 0]) rotate([0, 180, 0]) joint(joint_radius, joint_width, spacing);

    translate([cube_width * 2 + spacing * 1.5, cube_width * 1.5 + spacing , 0]) rotate([0, 180, 0]) joint(joint_radius, joint_width, spacing);
}


magic_folding_cube(cube_width, [joint_radius, joint_width], spacing);


