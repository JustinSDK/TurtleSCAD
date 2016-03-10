use <turtle.scad>;

text = "3.141592653589793238462643383279502884197169399375105820974944592307816406286208998628034825342117067982148086513282306647093844609550582231725359408128481117450284102701938521105559644622948954930381964428810975665933446128475648233";
height = 4;
diameter = 90; 
symbol = "π";
spin = "OUT"; // [OUT,IN]

// Revrese a string, returns a vector which uses all characters as elements.
// Parameters: 
//     string - a string to be reversed.
// Returns:
//     A vector containing reversed characters.
function reverse(string) = [for(i = [len(string) - 1:-1:0]) string[i]];

// Get the tail of a vector.
// Parameters: 
//     index - the first index when tailing
//     vector - the original vector.
// Returns:
//     The tail of a vector.
function tailFrom(index, vector) = [for(i = [len(vector) - index:len(vector) - 1]) vector[i]];

// Moves the turtle spirally. The turtle forwards the 'length' distance, turns 'angle' degrees, minus the length with 'step' and then continue next spiral until the 'end_length' is reached. 
// Parameters: 
//     turtle - the turtle vector [[x, y], angle].
//     length - the beginning length.
//     step - the next length will be minus with the decreasing_step.
//     angle - the turned degrees after forwarding.
//     ending_length - the minimum length of the spiral.
//     text - the text to be spined.
//     ch_angle - used to rotate the character.
module spin_out_characters(turtle, length, step, angle, ending_length, text, ch_angle = 0, index = 0) {
    font_size = 5;

    if(index < len(text) && length < ending_length) {
	
		translate([turtle[0][0], turtle[0][1], 0]) 
			rotate([ch_angle, ch_angle, turtle[1]]) 
				text(text[index], valign = "center", halign = "center", size = font_size, font = "Courier New:style=Bold");
				
        turtle_after_turned = turn(forward(turtle, length), -angle);
        spin_out_characters(turtle_after_turned, length + step, step, angle, ending_length, text, ch_angle, index + 1);
    }
}

// It will reverse the text, and do the same thing as spin_out_characters.
// Parameters: 
//     turtle - the turtle vector [[x, y], angle].
//     length - the beginning length.
//     step - the next length will be minus with the decreasing_step.
//     angle - the turned degrees after forwarding.
//     ending_length - the minimum length of the spiral.
//     text - the text to be spined.
module spin_in_characters(turtle, length, step, angle, ending_length, text) {
    inner_diameter = length * 10;
	outer_diameter = ending_length * 10;
	
	spin_out_characters(turtle, length, step, -angle, ending_length, tailFrom((outer_diameter - inner_diameter) / 10 / step + 1, reverse(text)), 180);	
}

module spiral_characters(symbol, text, outer_diameter, height) {
    inner_diameter = 30;
	step = 0.05;
	angle = 12;
	
	beginning_length = inner_diameter / 10;
	
	outer_length = outer_diameter / 10;
	inner_length = beginning_length;

    // bottom
    linear_extrude(height / 2) 
	    circle(outer_diameter / 2 + 2);
	
	linear_extrude(height) union() {
		text(symbol, valign = "center", halign = "center", size = inner_diameter * 1.5 / 2, font = "Times New Roman:style=Bold");
		
		if(spin == "OUT") {
			translate([0, inner_diameter / 2, 0])  
				spin_out_characters(turtle(0, 0, 0), inner_length, step, angle, outer_length, text);
		} else {	
			rotate(180) translate([0, -inner_diameter / 2, 0]) 
				spin_in_characters(turtle(0, 0, 0), inner_length, step, angle, outer_length, text, 180);			
		}
	}		
}

spiral_characters(symbol, text, diameter, height);
    
