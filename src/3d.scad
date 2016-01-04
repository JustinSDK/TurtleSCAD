//////////////
// 2D Module
//

// Create a 3D character around a cylinder. The `radius` and `arc_angle` determine the font size of the character. 
// Parameters: 
//     character - 3D character you want to create
//     arc_angle - angle which the character go across
//     radius - the cylinder radius
//     font - the character font
//     thickness - the character thickness
//     font_factor - use this parameter to scale the calculated font if necessary
module cylinder_character(character, arc_angle, radius, font = "Courier New:style=Bold", thickness = 1, font_factor = 1) {
    half_arc_angle = arc_angle / 2;
    font_size = 2 * radius * sin(half_arc_angle) * font_factor;

    rotate([0, 0, -half_arc_angle]) intersection() {
       translate([0, 0, -font_size / 5]) 
             linear_extrude(font_size * 1.5) 
                 arc(radius, [0, arc_angle], thickness);
    
       rotate([90, 0, 90 + half_arc_angle]) 
            linear_extrude(radius + thickness) 
                text(character, font = font, size = font_size, halign = "center");
    }
} 

// Create a chain text around a cylinder.
// Parameters: 
//     text - the text you want to create
//     radius - the cylinder radius
//     thickness - the character thickness
module chain_text(text, radius, thickness = 1) {
    arc_angle = 360 / len(text);

    for(i = [0 : len(text) - 1]) {
        rotate([0, 0, i * arc_angle]) 
            cylinder_character(text[i], arc_angle, radius, thickness = thickness);
    }
}

// Create a chain text around a cylinder for Chinese characters. It uses the font "微軟正黑體".
// Parameters: 
//     text - the text you want to create
//     radius - the cylinder radius
//     thickness - the character thickness
module chain_text_chinese(text, radius, thickness = 1) {
    arc_angle = 360 / len(text);

    for(i = [0 : len(text) - 1]) {
        rotate([0, 0, i * arc_angle]) 
            cylinder_character(text[i], arc_angle, radius, "微軟正黑體", thickness, 0.85);
    }
}