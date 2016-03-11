use <3d.scad>;

number = 4; // [1:5]
				
module violin_bow_hook(number) {
	$fn = 48;
	ratio = [0.4, 0.8, 1, 1.2, 1.6][number - 1];
	scale([ratio, ratio, 1]) union() {
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
