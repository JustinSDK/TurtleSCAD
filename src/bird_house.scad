use <2d.scad>;

house_length = 150;
wall_thickness = 1.5;
door_radius = 27.5;
door_above_floor = 30;
door_ring_radius = 4;
hang_ring_radius = 5;
air_holes = "YES"; // [YES, NO]

// 2D module, composed of a semi-circle and a square. The square's length is equal to the circle radius.
//
// Parameters: 
//     house_radius - the semi-circle radius of the house
module bird_house_2d_contour(house_radius) {
    sector(house_radius, [0, 180], 1);
    translate([0, -house_radius / 2, 0]) 
	    square([house_radius * 2, house_radius], center = true);
}

// The brid house with no top. The door radius is 1/2 `house_radius`. 
// The house depth is double `house_radius`. 
// Choose a suitable `door_ring_radius` for your bird's claw size.
//
// Parameters: 
//     house_radius - the semi-circle radius of the house
//     door_ring_radius - the ring radius on the door
//     wall_thickness - the wall thicnkess.
module bird_house_body(house_radius, door_radius, door_above_floor, door_ring_radius, wall_thickness) {
    house_depth = house_radius * 2;
	
	difference() {
	    // create the room
		linear_extrude(house_depth) 
			bird_house_2d_contour(house_radius);
			
		translate([0, 0, wall_thickness]) 
			linear_extrude(house_depth - wall_thickness * 2) 
				bird_house_2d_contour(house_radius - wall_thickness);
				
		// remove the top
        translate([0, -house_radius + wall_thickness, 0]) rotate([90, 0, 0]) 
		    linear_extrude(wall_thickness * 2) 
		        translate([-house_radius, 0, 0]) 
				    square(house_radius * 2);
				
		// create a door
		translate([0, door_radius - door_above_floor, wall_thickness]) 
		    linear_extrude(house_depth) 
			    circle(door_radius);
	}    

	// create the door ring
	translate([0, door_radius - door_above_floor, house_radius * 2]) 
		rotate_extrude(convexity = 10) 
			translate([door_radius + door_ring_radius, 0, 0]) 
				circle(door_ring_radius, $fn = 24);													
}

// The top cover of the bird house. 
// 
// Parameters: 
//     length - the length of the cover side
//     wall_thickness - the wall thicnkess.
module bird_house_cover(length, wall_thickness) {
    spacing = 0.6;
	five_wall_thickness = wall_thickness * 5;
	scale = 0.95;
	
	// the outer cover
	difference() {
		linear_extrude(five_wall_thickness)
			square(length, center = true);
				
		linear_extrude(five_wall_thickness, scale = scale) 
			square(length - wall_thickness * 2, center = true);
	}

	// the inner cover
	linear_extrude(five_wall_thickness, scale = scale)
		square(length - (wall_thickness + spacing) * 2, center = true);
}

// The hang ring of the bird house. 
// 
// Parameters: 
//     ring_radius - the radius of the hang ring
//     house_radius - the semi-circle radius of the house
//     wall_thickness - the wall thicnkess.
module hang_ring(ring_radius, house_radius, wall_thickness) {
    offset = (house_radius - 0.525 * wall_thickness) / 0.475 / 2;
	
    translate([offset, -house_radius - wall_thickness * 2, offset]) 
	    rotate([0, 90, -90]) 
	        linear_extrude(wall_thickness * 2) 
		        arc(ring_radius, [0, 180], wall_thickness * 2);
}

// A bird house. 
// The door radius is 1/2 `house_radius`. 
// The house depth is double `house_radius`. 
// Choose a suitable `door_ring_radius` for your bird's claw size.
// 
// Parameters: 
//     ring_radius - the radius of the hang ring
//     house_radius - the semi-circle radius of the house
//     door_ring_radius - the ring radius on the door. 
//     wall_thickness - the wall thicnkess.
module bird_house(house_length, door_radius, door_above_floor, hang_ring_radius, door_ring_radius, wall_thickness) {
    house_radius = house_length / 2;

    bird_house_body(house_radius, door_radius, door_above_floor, door_ring_radius, wall_thickness);

    length = (house_radius - 0.525 * wall_thickness) / 0.475;

    translate([0, -house_radius - wall_thickness * 4, house_radius])   
        rotate([-90, 0, 0]) 
            bird_house_cover(length, wall_thickness);

    hang_ring(hang_ring_radius, house_radius, wall_thickness);
    mirror([1, 0, 0]) 
	    hang_ring(hang_ring_radius, house_radius, wall_thickness);			
}

difference() {
	rotate([90, 0, 0])
		bird_house(house_length, door_radius, door_above_floor, hang_ring_radius, door_ring_radius, wall_thickness);

		
	if(air_holes == "YES") {
		// air holes	
		union() {
			translate([0, 0, -house_length / 3]) sphere(door_radius * 0.25);
			translate([house_length / 3, 0, -house_length / 3]) sphere(door_radius * 0.25);
			translate([-house_length / 3, 0, -house_length / 3]) sphere(door_radius * 0.25);

			translate([0, -house_length, -house_length / 2.5]) sphere(door_radius * 0.25);
			translate([house_length / 3, -house_length, -house_length / 3]) sphere(door_radius * 0.25);
			translate([-house_length / 3, -house_length, -house_length / 3]) sphere(door_radius * 0.25);
		}
	}
}

	


