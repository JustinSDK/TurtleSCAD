chars = "τ6.28318530717958647692528676";
radius = 45;
height = 150;
angle = 90;
brim_offset = 4;
top_bottom_thickness = 2;

module customizable_text_container() {
    half_angle = angle / 2;
    b = 90 - half_angle;

    PI = 3.14159;
    circumference = 2 * PI * radius;
    chars_len = len(chars);
    font_size = circumference / chars_len;
    step_angle = 360 / chars_len;

    side_length = 2 * radius * sin(half_angle);

    for(i = [0 : chars_len - 1]) {
        rotate(i * step_angle) 
            multmatrix(
                m = [ 
                [1, 0, -side_length * cos(b), radius],
                [0, 1, side_length * sin(b) , 0     ],
                [0, 0, height               , 0     ],
                [0, 0, 0                    ,  1    ]
            ]) linear_extrude(1) 
                   rotate(angle + 90) 
                      offset(brim_offset) 
                            text(chars[i],  
                                font = "Courier New:style=Bold",
                                size = font_size,
                                valign = "center", 
                                halign = "center"
                            );
    }

    rotate(step_angle / 2) 
        linear_extrude(top_bottom_thickness) 
            circle(radius - font_size / 4, $fn = chars_len);

    translate([0, 0, height]) 
        for(i = [0 : chars_len - 1]) {
            rotate(i * step_angle + angle) 
                translate([radius, 0, 0]) 
                    linear_extrude(top_bottom_thickness) 
                        rotate(90) 
                        text(
                            chars[i], 
                            font = "Courier New:style=Bold", 
                            size = font_size, 
                            valign = "center", 
                            halign = "center"
                        );
        }
}

customizable_text_container();