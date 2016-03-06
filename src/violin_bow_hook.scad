use <3d.scad>;

number = 4; // [1:5]

function violin_scale_vector(number) =
    number == 2 ? [0.8, 0.8, 1] : (
		number == 3 ? [1, 1, 1] : (
			number == 4 ? [1.2, 1.2, 1] : (
			    number == 5 ? [1.6, 1.6, 1] : [0.4, 0.4, 1])));
				
module violin_bow_hook(number) {
	$fn = 48;
	scale(violin_scale_vector(number)) union() {
		violin(1);
		linear_extrude(1) 
			offset(1) 
				projection() 
					violin(1);
	}

	for(y = [10:40:10 + 40 * (number - 1)]) { 
		translate([0, y, 0]) union() {
			linear_extrude(15) circle(2.5);
			translate([0, 0, 15]) sphere(4);
		}
	}
}

violin_bow_hook(number);
