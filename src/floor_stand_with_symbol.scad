text = "NO BUG";
font = "Arial Black";
font_size = 4.5;
line_spacing = 7;

stand_width = 40;
stand_height = 80;
stand_thickness = 4;
joint_spacing = 1;

symbol_source = "DEFAULT"; // [DEFAULT, PNG, UNICODE]

/* [FOR PNG SYMBOL] */
symbol_png = ""; // [image_surface:100x100]

/* [FOR UNICODE SYMBOL] */
symbol_unicode = "X";  
symbol_font = "Webdings";
symbol_font_size = 20;


/**
* hollow_out.scad
*
* Hollows out a 2D object. 
* 
* @copyright Justin Lin, 2017
* @license https://opensource.org/licenses/lgpl-3.0.html
*
* @see https://openhome.cc/eGossip/OpenSCAD/lib-hollow_out.html
*
**/

module hollow_out(shell_thickness) {
    difference() {
        children();
        offset(delta = -shell_thickness) children();
    }
}

/**
* hull_polyline2d.scad
*
* Creates a 2D polyline from a list of `[x, y]` coordinates. 
* As the name says, it uses the built-in hull operation for each pair of points (created by the circle module). 
* It's slow. However, it can be used to create metallic effects for a small $fn, large $fa or $fs.
* 
* @copyright Justin Lin, 2017
* @license https://opensource.org/licenses/lgpl-3.0.html
*
* @see https://openhome.cc/eGossip/OpenSCAD/hull_polyline2d.html
*
**/

module hull_polyline2d(points, width) {
    half_width = width / 2;
    leng = len(points);
    
    module hull_line2d(index) {
        point1 = points[index - 1];
        point2 = points[index];

        hull() {
            translate(point1) 
                circle(half_width);
            translate(point2) 
                circle(half_width);
        }

        // hook for testing
        test_line_segment(index, point1, point2, half_width);
    }

    module polyline2d_inner(index) {
        if(index < leng) {
            hull_line2d(index);
            polyline2d_inner(index + 1);
        }
    }

    polyline2d_inner(1);
}

// override it to test
module test_line_segment(index, point1, point2, radius) {

}

/**
* pie.scad
*
* Creates a pie (circular sector). You can pass a 2 element vector to define the central angle. Its $fa, $fs and $fn parameters are consistent with the circle module.
* 
* @copyright Justin Lin, 2017
* @license https://opensource.org/licenses/lgpl-3.0.html
*
* @see https://openhome.cc/eGossip/OpenSCAD/lib-pie.html
*
**/

function __shape_pie(radius, angle) =
    let(
        frags = __frags(radius),
        a_step = 360 / frags,
        leng = radius * cos(a_step / 2),
        angles = __is_vector(angle) ? angle : [0:angle],
        m = floor(angles[0] / a_step) + 1,
        n = floor(angles[1] / a_step),
        edge_r_begin = leng / cos((m - 0.5) * a_step - angles[0]),
        edge_r_end = leng / cos((n + 0.5) * a_step - angles[1]),
        shape_pts = concat(
            [[0, 0], __ra_to_xy(edge_r_begin, angles[0])],
            m > n ? [] : [
                for(i = [m:n]) 
                    let(a = a_step * i) 
                    __ra_to_xy(radius, a)
            ],
            angles[1] == a_step * n ? [] : [__ra_to_xy(edge_r_end, angles[1])]
        )
    ) shape_pts;
    
function __frags(radius) = $fn > 0 ? 
            ($fn >= 3 ? $fn : 3) : 
            max(min(360 / $fa, radius * 6.28318 / $fs), 5);

function __is_vector(value) = !(value >= "") && len(value) != undef;

function __ra_to_xy(r, a) = [r * cos(a), r * sin(a)];
 
module pie(radius, angle) {
    polygon(__shape_pie(radius, angle));
}

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



module no_bug() {
    $fn = 48;
    r = 10;
    color("black") linear_extrude(stand_thickness / 4) rotate(25) translate([0, -r * 0.175]) union() {
        difference() {
           union() {
                translate([-r, 0]) square([r * 2, r]);
                circle(r);
            }
            hull_polyline2d(points = [[0, r / 2], [0, r]], width = 2);    
        }
        translate([0, r * 1.15]) 
            pie(radius = r / 1.5, angle = [0, 180]);
        rotate(45) 
            hull_polyline2d(points = [[0, -1.5 * r], [0, 1.75 * r]], width = 2);
        rotate(-45) 
            hull_polyline2d(points = [[0, -1.5 * r], [0, 1.75 * r]], width = 2);
        rotate(90) 
            hull_polyline2d(points = [[0, -1.5 * r], [0, 1.5 * r]], width = 2);
    }
    color("red") linear_extrude(stand_thickness / 3) union() {
        hollow_out(shell_thickness = font_size / 2) 
            circle(2 * r);
                rotate(-45) 
        hull_polyline2d(points = [[0, -1.8 * r], [0, 1.8 * r]], width = font_size / 2);
    }
}        
        
module floor_stand_with_symbol(text, font, font_size, symbol_png, symbol_unicode, symbol_font, symbol_font_size, width, height, thickness, joint_spacing, line_spacing) {
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

    module content() {
        //color("black") 
        translate([0, 0, half_th]) 
            union() {
                color("black") linear_extrude(half_th / 2) 
                    union() {
                        hollow_out(shell_thickness = font_size / 4) 
                            offset(half_w / 10) 
                                scale([0.75, 0.675]) 
                                    polygon(points);
                                
                        translate([0, -half_h / 3, 0]) 
                            multiLine(split_str(text, " "), size = font_size, font = font, line_spacing = line_spacing, valign = "center", halign = "center");
                        
                    } 
                
                if(symbol_source == "DEFAULT") {
                    translate([0, half_h / 5, 0]) 
                        scale([0.6, 0.6, 1]) 
                            no_bug();
                }
                else if(symbol_source == "UNICODE") {                
                    color("black") linear_extrude(half_th / 2)             
                        translate([0, half_h / 5, 0]) 
                                    text(symbol_unicode, font = symbol_font, size = symbol_font_size, valign = "center", halign = "center");
                } 
                else {
                    symbol_png_size = 100;
                    symbol_png_scale = 0.25; 
          
                    color("black") translate([0, half_h / 5, half_th / 4]) 
                        scale([symbol_png_scale, symbol_png_scale, 1])
                            difference() {       
                                cube([symbol_png_size * 0.99, symbol_png_size  * 0.99, stand_thickness / 4], center = true);                        
                                translate([0, 0, -50])
                                    scale([1, 1, 100]) 
                                        surface(symbol_png, center = true); 

                            }
                    
                }
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
            translate([0, -height / 1.8, 0]) content();
        }
        ground_df();
    }

    translate([0, 0, thickness / 2]) 
    rotate([80, 0, 0]) 
    difference() {
        rotate([-80, 0, 0]) rotate(180) union() {
            color("yellow") board2();
            translate([0, -height / 1.8, 0]) content();
        }
        ground_df();
    }
}

floor_stand_with_symbol(text, font, font_size, symbol_png, symbol_unicode, symbol_font, symbol_font_size, stand_width, stand_height, stand_thickness, joint_spacing, line_spacing);

