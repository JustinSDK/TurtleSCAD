text = "Coder at Work";
// font = "微軟正黑體:style=Bold";   
font = "Arial Black";
font_size = 6;
line_spacing = 10;

stand_width = 40;
stand_height = 80;
stand_thickness = 4;
joint_spacing = 1;

/**
* sub_str.scad
*
* Returns a new string that is a substring of the given string.
* 
* @copyright Justin Lin, 2017
* @license https://opensource.org/licenses/lgpl-3.0.html
*
* @see https://openhome.cc/eGossip/OpenSCAD/lib-sub_str.html
*
**/ 

function sub_str(t, begin, end, result = "") =
    end == undef ? sub_str(t, begin, len(t)) : (
        begin == end ? result : sub_str(t, begin + 1, end, str(result, t[begin]))
    );

/**
* split_str.scad
*
* Splits the given string around matches of the given delimiting character.
* It depends on the sub_str function so remember to include sub_str.scad.
*
* @copyright Justin Lin, 2017
* @license https://opensource.org/licenses/lgpl-3.0.html
*
* @see https://openhome.cc/eGossip/OpenSCAD/lib-split_str.html
*
**/ 
   
function _split_t_by(idxs, t, ts = [], i = -1) = 
    i == -1 ? _split_t_by(idxs, t, [sub_str(t, 0, idxs[0])], i + 1) : (
        i == len(idxs) - 1 ? concat(ts, sub_str(t, idxs[i] + 1)) : 
            _split_t_by(idxs, t, concat(ts, sub_str(t, idxs[i] + 1, idxs[i + 1])), i + 1)
    );        

function split_str(t, delimiter) = 
    len(search(delimiter, t)) == 0 ? 
        [t] : _split_t_by(search(delimiter, t, 0)[0], t);      

module floor_stand(text, font, font_size, width, height, thickness, joint_spacing, line_spacing) {
    half_w = width / 2;
    half_h = height / 2;
    half_th = thickness / 2;
    half_sc = joint_spacing / 2;

    $fn = 24;

    points = [
        [half_w, -half_h], [width / 2.25, half_h], 
        [-width / 2.25, half_h], [-half_w, -half_h]
    ];

    module multiLine(lines, size = 10, font = "Arial", halign = "left", valign = "baseline", line_spacing = 15, direction = "ltr", language = "en", script = "latin"){
        to = len(lines) - 1;
        inc = line_spacing;
        offset_y = inc * to / 2;
        union(){
            for (i = [0 : to]) {
                translate([0 , -i * inc + offset_y, 0]) 
                    text(lines[i], size, font = font, valign = valign, halign = halign, direction = direction, language = language, script = script);
            }
        }
    }

    module board_base() {
        difference() {
            polygon(points);
            translate([0, -half_h, 0]) 
                scale([0.6, 0.1]) 
                    polygon(points);
        }
    }

    module word() {
        color("black")
        translate([0, 0, half_th]) 
            linear_extrude(half_th / 2) 
                union() {
                    difference() {
                        scale([0.85, 0.7]) 
                            polygon(points);
                        offset(r = -font_size / 4) 
                            scale([0.85, 0.7]) 
                                polygon(points);
                    }
                    multiLine(split_str(text, " "), size = font_size, font = font, line_spacing = line_spacing, valign = "center", halign = "center");
                }
    }

    module joint_top() {
        linear_extrude(thickness / 4 + half_sc, scale = 0.1) 
                                circle(thickness / 4 + half_sc);
    }

    module stick() {
        linear_extrude(thickness * 0.75) 
                square([width / 12, half_w], center = true);    
    }
    
    module slot_df() {
        translate([0, -half_h - thickness, -half_th]) 
            stick();    
    }

    module board1() {
        difference() {
            union() {
                linear_extrude(thickness, center = true) 
                    difference() {
                        translate([0, -half_h, 0]) 
                            board_base();
                        square([width / 1.5, height / 3], center = true);
                    }
                rotate([0, 90, 0]) 
                    linear_extrude(width / 2.25 * 2, center = true) 
                        circle(thickness / 2);
            }
            rotate([0, 90, 0]) 
                linear_extrude(width / 1.5, center = true) 
                    circle(thickness, $fn = 24);
                
            // joint            
            translate([half_w / 1.5 , 0, 0])         
                rotate([0, 90, 0]) 
                    joint_top();

            translate([-half_w / 1.5 , 0, 0])  
                rotate([0, -90, 0]) 
                    joint_top();
                        
            slot_df();        
        }
    }

    module board2() {
        difference() {
            union() {
                linear_extrude(thickness, center = true) 
                    union() {
                        difference() {
                            translate([0, -half_h, 0]) 
                                board_base();
                            square([width, height / 3], center = true);
                            

                        }
                        translate([0, -height / 12 - joint_spacing / 4, 0]) 
                            difference() {
                                square([width / 1.5 - joint_spacing, height / 6 + joint_spacing / 2], center = true);
                                square([width / 1.5 - thickness * 2, height / 6], center = true);
                            }
                    }
                rotate([0, 90, 0]) 
                    linear_extrude(width / 1.5 - joint_spacing, center = true) 
                        circle(half_th, $fn = 24);

                // joint
                translate([half_w / 1.5 - half_sc, 0, 0]) 
                    rotate([0, 90, 0]) 
                        joint_top();

                translate([-half_w / 1.5 + half_sc, 0, 0]) 
                    rotate([0, -90, 0]) 
                        joint_top();                
            }
            
            slot_df();
        }
    }

    module ground_df() {
        translate([0, 0, -height - half_th]) 
                linear_extrude(thickness) 
                    square(width, center = true);
    }

    // stick
    translate([width, 0, 0]) 
        stick();

    translate([0, 0, thickness / 2]) 
    rotate([-80, 0, 0]) 
    difference() {
        rotate([80, 0, 0]) union() {
            color("yellow") board1();
            translate([0, -height / 1.8, 0]) word();
        }
        ground_df();
    }

    translate([0, 0, thickness / 2]) 
    rotate([80, 0, 0]) 
    difference() {
        rotate([-80, 0, 0]) rotate(180) union() {
            color("yellow") board2();
            translate([0, -height / 1.8, 0]) word();
        }
        ground_df();
    }
}

floor_stand(text, font, font_size, stand_width, stand_height, stand_thickness, joint_spacing, line_spacing);