filename = "star.png";  // [image_surface:100x100]
height = 50;  
thickness = 1;  
twist = 30;  
segments = 12;
flare = 50;  

// Load a png file and make a projection of its white area.
module png_projection(filename) {
    translate([-50, -50, 0]) projection() intersection() {
	    surface(filename);
	    translate([0, 0, 1]) linear_extrude(1, slices = 1) square([100, 100]);
    }   
} 

//  Based on the `png_projection` module. If `thickness` is zero, the shape will be solid. 
module shape(filename, thickness = 0, scale_factor = 1) {
    scale(scale_factor) difference() {
	    png_projection(filename);
		if(thickness != 0) {
            offset(r = -thickness) 
				    png_projection(filename);
		}
	}
}

//  Based on the `shape` module. Used to create a base for the vase. `twist` has the same meaning in the `linear_extrude`.
module base(filename, height, twist) {
    linear_extrude(height = height, twist = twist, slices = 1) 
	    shape(filename);
}

//  Based on the `shape` module. Used to create a segment of the body. `flare` is the final scale of the segment and `init_scale` is the initial scale of the segment.
module body_segment(filename, height, thickness, twist, flare, init_scale = 1) {
	linear_extrude(height = height, twist = twist, scale = flare, slices = 1) 
		shape(filename, thickness, init_scale);
}

// Create the body of the vase. `flare` is the maximum scale of the vase in the middle. 
module body(filename, flare, height, thickness, segments, twist) {
    initial_length = height / flare * 100;
    two_thirds_segments = segments * 2 / 3;
	step_angle = 90 / two_thirds_segments;
	two_thirds_body_height = height * 2 / 3;
	segment_height = height / segments;
	segment_twist = twist / segments;
	
	for(i = [1 : two_thirds_segments]) {
		init_len = initial_length + two_thirds_body_height * sin(step_angle * (i - 1)) * 2;
		target_len = initial_length + two_thirds_body_height * sin(step_angle * i) * 2;
		
		rotate(-(i - 1) * segment_twist) 
		    translate([0, 0, two_thirds_body_height / two_thirds_segments * (i - 1)]) 
			    body_segment(
				    filename, 
					segment_height, 
					thickness, 
					segment_twist, 
					target_len / init_len, 
					init_len / initial_length
				);	
	}

	rotate(-segment_twist * (two_thirds_segments + 1)) translate([0, 0, two_thirds_body_height]) 
	    for(i = [two_thirds_segments : -1 : two_thirds_segments / 2]) {
		    init_len = initial_length + two_thirds_body_height * sin(step_angle * i) * 2;
		    target_len = initial_length + two_thirds_body_height * sin(step_angle * (i - 1)) * 2;
		
		    rotate((i + 1 - two_thirds_segments) * segment_twist) 
		        translate([0, 0, two_thirds_body_height / two_thirds_segments * (two_thirds_segments - i)]) 
			        body_segment(
					    filename, 
					    segment_height, 
						thickness, 
						segment_twist, 
						target_len / init_len, 
						init_len / initial_length
					);	
	}
}

module png_to_twisted_vase(filename, flare, height, thickness, twist, segments) {
    
	segment_height = height / segments;
	segment_twist = twist / segments;

	base(filename, thickness, thickness / segment_height * segment_twist);

	body(
		filename, 
		flare, 
		height, 
		thickness, 
		segments, 
		twist
	);
}

png_to_twisted_vase(filename, flare, height, thickness, twist, segments);

