module pin(type, shaft_r = 2.5, lip_r = 3, height = 6, spacing = 0.5, lip_fn = 4) {
    r_diff = lip_r - shaft_r;
    
    module pin_base(shaft_r, lip_r, height) {        
        linear_extrude(height) 
            circle(shaft_r);
            
        translate([0, 0, height - r_diff]) 
            rotate_extrude() 
                translate([lip_r - r_diff, 0, 0]) 
                    circle(r_diff, $fn = lip_fn);
    }

    module pinpeg() {
        difference() {
            pin_base(shaft_r, lip_r, height);
            
            translate([0, 0, r_diff * 2])  
                linear_extrude(height - r_diff * 2) 
                    square([r_diff * 2, lip_r * 2], center = true);
        
        }
    }

    module pinheightole() {
        pin_base(shaft_r + spacing, lip_r + spacing, height);
        translate([0, 0, height]) 
            linear_extrude(spacing) 
                circle(lip_r);
        
    }

    if(type == "peg") {
        pinpeg();
    } else if(type == "hole") {
        pinheightole();
    }
}



$fn = 48;

shaft_r = 2.5;
lip_r = 3;
height = 6;
spacing = 0.5;

*translate([0, 0, -1.5]) linear_extrude(1.5) 
        circle(lip_r * 1.5);
pin("peg", shaft_r, lip_r, height, spacing);
    
translate([10, 0, 0]) difference() {
    *linear_extrude(height - 0.001) 
        circle(lip_r * 1.5);
        
    pin("hole", shaft_r, lip_r, height, spacing);
}


