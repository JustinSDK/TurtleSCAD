//////////////
// 2D Drawing
//

// Draws a line between the points.
//
// Parameters: 
//     point1 - the start point [x1, y1] of the line.
//     point2 - the end point [x2, y2] of the line.
//     width  - the line width.
//     cap_round - ends the line with round decorations that has a radius equal to half of the width of the line.
module line(point1, point2, width = 1, cap_round = true) {
    angle = 90 - atan((point2[1] - point1[1]) / (point2[0] - point1[0]));
    offset_x = 0.5 * width * cos(angle);
    offset_y = 0.5 * width * sin(angle);
    
    offset1 = [-offset_x, offset_y];
    offset2 = [offset_x, -offset_y];
    
    if(cap_round) {
        translate(point1) circle(d = width, $fn = 24);
        translate(point2) circle(d = width, $fn = 24);
    }
    
    polygon(points=[
        point1 + offset1, point2 + offset1,  
        point2 + offset2, point1 + offset2
    ]);
}

// Creates a polyline, defined by the vector of the segment points. 
//
// Parameters: 
//     points - the coordinates of the polyline segments.
//     width  - the line width.
module polyline(points, width = 1) {
	module polyline_inner(points, index) {
		if(index < len(points)) {
			line(points[index - 1], points[index], width);
			polyline_inner(points, index + 1);
		}
	}
	
	polyline_inner(points, 1);
}

function PI() = 3.14159;

// Given a `radius` and `angle`, draw an arc from zero degree to `angle` degree. The `angle` ranges from 0 to 90.
// Parameters: 
//     radius - the arc radius 
//     angle - the arc angle 
//     width - the arc width 
module a_quarter_arc(radius, angle, width = 1) {
    outer = radius + width;
    intersection() {
        difference() {
            offset(r = width) circle(radius, $fn=48); 
            circle(radius, $fn=48);
        }
        polygon([[0, 0], [outer, 0], [outer, outer * sin(angle)], [outer * cos(angle), outer * sin(angle)]]);
    }
}

// Given a `radius` and `angles`, draw an arc from `angles[0]` degree to `angles[1]` degree. 
// Parameters: 
//     radius - the arc radius 
//     angles - the arc angles 
//     width - the arc width
//     fn - the same as $fn of circle module
module arc(radius, angles, width = 1, fn = 24) {
    difference() {
		sector(radius + width, angles, fn);
		sector(radius, angles, fn);
	}
}

// Given a `radius` and `angle`, draw a sector from zero degree to `angle` degree. The `angle` ranges from 0 to 90.
// Parameters: 
//     radius - the sector radius
//     angle - the sector angle
module a_quarter_sector(radius, angle) {
    intersection() {
        circle(radius, $fn=96);
        
        polygon([[0, 0], [radius, 0], [radius, radius * sin(angle)], [radius * cos(angle), radius * sin(angle)]]);
    }
}

// Given a `radius` and `angle`, draw a sector from `angles[0]` degree to `angles[1]` degree. 
// Parameters: 
//     radius - the sector radius
//     angles - the sector angles
//     fn - the same as $fn of circle module
module sector(radius, angles, fn = 24) {
	r = radius / cos(180 / fn);
	step = -360 / fn;

	points = concat([[0, 0]],
		[for(a = [angles[0] : step : angles[1] - 360]) 
			[r * cos(a), r * sin(a)]
		],
		[[r * cos(angles[1]), r * sin(angles[1])]]
	);
	
	difference() {
	    circle(radius, $fn = fn);
		polygon(points);
	}
}


// The heart is composed of two semi-circles and two isosceles trias. 
// The tria's two equal sides have length equals to the double `radius` of the circle.
// That's why the `solid_heart` module is drawn according a `radius` parameter.
// 
// Parameters: 
//     radius - the radius of the semi-circle 
//     tip_factor - the sharpness of the heart tip
module solid_heart(radius, tip_factor) {
    offset_h = 2.2360679774997896964091736687313 * radius / 2 - radius * sin(45);
	tip_radius = radius / tip_factor;
	
    translate([radius * cos(45), offset_h, 0]) rotate([0, 0, -45])
    hull() {
        circle(radius, $fn = 96);
		translate([radius - tip_radius, -radius * 2 + tip_radius, 0]) 
		    circle(tip_radius, center = true, $fn = 96);
	}
	
	translate([-radius * cos(45), offset_h, 0]) rotate([0, 0, 45]) hull() {
        circle(radius, $fn = 96);
		translate([-radius + tip_radius, -radius * 2 + tip_radius, 0]) 
		    circle(tip_radius, center = true, $fn = 96);
	}
}

// Create a puzzle piece.
//
// Parameters: 
//     side_length - the length of the piece.
//     spacing - a small space between pieces to avoid overlaping while printing.
//     same_side - whether the piece has the same side.
module puzzle_piece(side_length, spacing, same_side = true) {
	$fn = 48;

	circle_radius = side_length / 10;
	half_circle_radius = circle_radius / 2;
	side_length_div_4 = side_length / 4;
	bulge_circle_radius = circle_radius - spacing;

	difference() {
		square(side_length - spacing);
		
		// left
		translate([half_circle_radius, side_length_div_4, 0]) 
			circle(circle_radius);
		translate([half_circle_radius, side_length_div_4 * 3, 0]) 
			circle(circle_radius);
			
		// top
		if(same_side) {
			translate([side_length_div_4, side_length - half_circle_radius, 0]) 
				circle(circle_radius);
		
			translate([side_length_div_4 * 3, side_length - half_circle_radius, 0]) 
				circle(circle_radius);		
		} else {
			translate([side_length_div_4 * 2, side_length - half_circle_radius, 0]) 
				circle(circle_radius * 1.5);
		}
	}

	// right
	translate([side_length + half_circle_radius, side_length_div_4, 0]) 
		circle(bulge_circle_radius);
	translate([side_length + half_circle_radius, side_length_div_4 * 3, 0]) 
		circle(bulge_circle_radius);

	// bottom
	if(same_side) {
		translate([side_length_div_4, -half_circle_radius, 0]) 
			circle(bulge_circle_radius);
		translate([side_length_div_4 * 3, -half_circle_radius, 0]) 
			circle(bulge_circle_radius);
	} else {
		translate([side_length_div_4 * 2, -half_circle_radius, 0]) 
			circle(bulge_circle_radius * 1.5);	
	}
}