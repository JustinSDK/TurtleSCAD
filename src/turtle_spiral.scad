height = 5;
beginning_length = 100;
decreasing_step = 0.5;
angle = 89;
ending_length = 5;
line_width = 1; 

use <2d.scad>;
use <turtle.scad>;
    
// Moves the turtle spirally. The turtle forwards the 'length' distance, turns 'angle' degrees, minus the length with 'decreasing_step' and then continue next  spiral until the 'ending_length' is reached. 
// Parameters: 
//     turtle - the turtle vector [[x, y], angle].
//     length - the beginning length.
//     decreasing_step - the next length will be minus with the decreasing_step.
//     angle - the turned degrees after forwarding.
//     ending_length - the minimum length of the spiral.
module spiral(turtle, length, decreasing_step, angle, ending_length = 10, line_width = 1) {
    if(length > ending_length) {
        turtle_after_forwarded = forward(turtle, length);
        line(turtle[0], turtle_after_forwarded[0], line_width);
        turtle_after_turned = turn(turtle_after_forwarded, angle);
        spiral(turtle_after_turned, length - decreasing_step, decreasing_step, angle, ending_length, line_width);
    }
}

module turtle_spiral(height, beginning_length, decreasing_step, angle, ending_length, line_width = 1) {
    linear_extrude(height) 
        spiral(turtle(0, 0, 0), beginning_length, decreasing_step, angle, ending_length, line_width);
}

turtle_spiral(height, beginning_length, decreasing_step, angle, ending_length, line_width);

    
