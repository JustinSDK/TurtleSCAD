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
module polyline(points, width = 1, index = 0) {
    if(index < len(points)) {
        if(index == 0) {
            polyline(points, width, index + 1);
        } else {
            line(points[index - 1], points[index], width);
            polyline(points, width, index + 1);
        }
    }
}

// Creates a polyline, defined by the vector of the segment points. 
//
// Parameters: 
//     points - the coordinates of the polyline segments.
//     width  - the line width.
module polyline(points, width = 1, index = 0) {
    if(index < len(points)) {
        if(index == 0) {
            polyline(points, width, index + 1);
        } else {
            line(points[index - 1], points[index], width);
            polyline(points, width, index + 1);
        }
    }
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
module arc(radius, angles, width = 1) {
    angle_from = angles[0];
    angle_to = angles[1];
    angle_difference = angle_to - angle_from;
    outer = radius + width;
    rotate(angle_from)
        if(angle_difference <= 90) {
            a_quarter_arc(radius, angle_difference, width);
        } else if(angle_difference > 90 && angle_difference <= 180) {
            arc(radius, [0, 90], width);
            rotate(90) a_quarter_arc(radius, angle_difference - 90, width);
        } else if(angle_difference > 180 && angle_difference <= 270) {
            arc(radius, [0, 180], width);
            rotate(180) a_quarter_arc(radius, angle_difference - 180, width);
        } else if(angle_difference > 270 && angle_difference <= 360) {
            arc(radius, [0, 270], width);
            rotate(270) a_quarter_arc(radius, angle_difference - 270, width);
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
module sector(radius, angles) {
    angle_from = angles[0];
    angle_to = angles[1];
    angle_difference = angle_to - angle_from;

    rotate(angle_from)
        if(angle_difference <= 90) {
            a_quarter_sector(radius, angle_difference);
        } else if(angle_difference > 90 && angle_difference <= 180) {
            sector(radius, [0, 90]);
            rotate(90) a_quarter_sector(radius, angle_difference - 90);
        } else if(angle_difference > 180 && angle_difference <= 270) {
            sector(radius, [0, 180]);
            rotate(180) a_quarter_sector(radius, angle_difference - 180);
        } else if(angle_difference > 270 && angle_difference <= 360) {
            sector(radius, [0, 270]);
            rotate(270) a_quarter_sector(radius, angle_difference - 270);
       }
}