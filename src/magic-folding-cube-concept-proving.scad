use <joint.scad>;

cube_width = 30;
joint_radius = 4;
joint_width = 15;
spacing = 0.5;
 
// 2x1 magic folding cube.
// Parameters: 
//     cube_width - the width of each cube
//     joint_data - [joint_radius, joint_width]
//     spacing - a small space between parts to avoid overlaping while printing.
module magic_folding_cube_2x1(cube_width, joint_data, spacing) {
	joint_radius = joint_data[0];
	joint_width = joint_data[1];

	cube(cube_width);
	
	translate([cube_width + joint_radius + spacing, cube_width / 2, cube_width]) 
	    joint(joint_radius, joint_width, spacing);
	
	translate([cube_width + joint_radius * 2 + spacing * 2, 0])
	    cube(cube_width);
}

// 2x2 magic folding cube.
// Parameters: 
//     cube_width - the width of each cube
//     joint_data - [joint_radius, joint_width]
//     spacing - a small space between parts to avoid overlaping while printing.
module magic_folding_cube_2x2(cube_width, joint_data, spacing) {
	translate([0, cube_width, 0]) rotate([90, 0, 0]) magic_folding_cube_2x1(cube_width, joint_data, 0.5);

	translate([0, cube_width + joint_data[0] * 2 + spacing * 2, cube_width]) rotate([-90, 0, 0]) magic_folding_cube_2x1(cube_width, joint_data, 0.5);

	translate([cube_width, 0, 0]) rotate([0, 0, 90]) magic_folding_cube_2x1(cube_width, joint_data, 0.5);
}

// create magic folding cube.
// Parameters:
//     cube_width - the width of each cube
//     joint_data - [joint_radius, joint_width]
//     spacing - a small space between parts to avoid overlaping while printing.
module magic_folding_cube(cube_width, joint_data, spacing) {
    joint_radius = joint_data[0];

	magic_folding_cube_2x2(cube_width, [joint_radius, joint_width], spacing);

	translate([cube_width * 4 + joint_radius * 6 + spacing * 6, 0, 0]) mirror([1, 0, 0]) magic_folding_cube_2x2(cube_width, joint_data, spacing);

	translate([cube_width + joint_radius * 2 + spacing * 2, 0, cube_width]) mirror([0, 0, 1]) magic_folding_cube_2x1(cube_width, joint_data, spacing);

	translate([cube_width +  joint_radius * 2 + spacing * 2, cube_width +  joint_radius * 2 + spacing * 2, cube_width]) mirror([0, 0, 1]) magic_folding_cube_2x1(cube_width, joint_data, spacing);
}

magic_folding_cube(cube_width, [joint_radius, joint_width], spacing);

