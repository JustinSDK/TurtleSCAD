use <joint.scad>;

boxes = 8; // [2,4,8,16]
box_width = 40;
box_height = 20;
box_thickness = 1;
joint_radius = 4;
joint_width = 15;
spacing = 0.5;

// a box for a magic_box
// Parameters: 
//     width - the width of the box.
//     height - the height of the box.
//     thickness - the thickness of the box.
module box(width, height, thickness) {
    difference() {
        cube([width, width, height]);
		translate([thickness, thickness, thickness]) 
		    cube([
			    width - 2 * thickness, 
				width - 2 * thickness, 
				height
			]);
	}
}

// 2x1 magic boxes.
// Parameters: 
//     box_data - [box_width, box_height, box_thickness]
//     joint_data - [joint_radius, joint_width]
//     spacing - a small space between parts to avoid overlaping while printing.
module magic_box_2x1(box_data, joint_data, spacing) {
	box_width = box_data[0];
	box_height = box_data[1];
	box_thickness = box_data[2];
	joint_radius = joint_data[0];
	joint_width = joint_data[1];

	box(box_width, box_height, box_thickness);
	
	translate([box_width + joint_radius + spacing, box_width / 2, box_height]) 
	    joint(joint_radius, joint_width, spacing);
	
	translate([box_width + joint_radius * 2 + spacing * 2, 0, 0])
	    box(box_width, box_height, box_thickness);
}

// determine the dimension for magic boxes
// Parameters:
//     boxes - total boxes
function box_dim(boxes) = 
    boxes == 2 ? [2, 1] : (
	    boxes == 4 ? [2, 2] : (
		    boxes == 8 ? [4, 2] : [4, 4]
		)
	);

// create magic_boxes.
// Parameters:
//     boxes - total boxes
//     box_data - [box_width, box_height, box_thickness]
//     joint_data - [joint_radius, joint_width]
//     spacing - a small space between parts to avoid overlaping while printing.
module magic_boxes(boxes, box_data, joint_data, spacing) {
    dim = box_dim(boxes);
    boxes_x = dim[0];
    boxes_y = dim[1];
	
    if((boxes_x + boxes_y) == 3) {
	    magic_box_2x1(
		    box_data, 
			[joint_radius, joint_width], 
			0.5
		);
	} else {
	    box_width = box_data[0];
	    box_height = box_data[1];
	    box_thickness = box_data[2];
	    // boxes
		for(x = [0 : boxes_x - 1]) {
			bj_step = (spacing + joint_radius) * 2 + box_width;
			
			for(y = [0 : boxes_y - 1]) {
				translate([x * bj_step, y * bj_step, 0]) 
					box(box_width, box_height, box_thickness);
			}
		}

		// x joints 
		for(x = [1 : boxes_x - 1]) {    
			for(y = [1 : boxes_y]) {
			    offset_x = x * (box_width + spacing + joint_radius) + 
				          (joint_radius + spacing) * (x - 1);
				
				offset_y = joint_width / 2 + spacing + 
				           (joint_radius * 2 + spacing * 2 + box_width) * (y - 1) + 
						   (x == 1 ? box_width - joint_width - spacing * 2 : 0);
				
				translate([offset_x, offset_y, box_height]) 
					joint(joint_radius, joint_width, spacing);
			}
		}

		// y joints
		for(y = [0 : boxes_y - 2]) {    
			for(x = [0 : boxes_x - 1]) {
			    offset_x = joint_width / 2 + spacing + 
				           (box_width + joint_radius * 2 + spacing * 2) * x + 
						   (y == 0 ? box_width - joint_width - spacing * 2 : 0);
				
				offset_y = box_width + spacing + joint_radius + 
				           (spacing * 2 + joint_radius * 2 + box_width) * y;
				
				translate([offset_x, offset_y, box_height]) 
					rotate(90) 
					    joint(joint_radius, joint_width, spacing);		
			}
		}
	}
}

magic_boxes(
    boxes, 
	[box_width, box_height, box_thickness], 
	[joint_radius, joint_width], 
	0.5
);



