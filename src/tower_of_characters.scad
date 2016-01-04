use <2d.scad>;
use <3d.scad>;

button_symbol = ";";

characters = "I TURN COFFEE INTO CODE.I TURN COFFEE INTO CODE.I TURN COFFEE INTO CODE.I TURN COFFEE INTO CODE.I TURN COFFEE INTO CODE.I TURN COFFEE INTO CODE.I TURN COFFEE INTO CODE.I TURN COFFEE INTO CODE.I TURN COFFEE INTO CODE.I TURN COFFEE INTO CODE.I TURN COFFEE INTO CODE.I TURN COFFEE INTO CODE.I TURN COFFEE INTO CODE.I TURN COFFEE INTO CODE.I TURN COFFEE INTO CODE.I TURN COFFEE INTO CODE.I TURN COFFEE INTO CODE.I TURN COFFEE INTO CODE.I TURN COFFEE INTO CODE.I TURN COFFEE INTO CODE.I TURN COFFEE INTO CODE.I TURN COFFEE INTO CODE.";

thickness = 2;

inner_wall = "YES";


// Create a character tower. If you want to print it easily, set the `inner_wall` parameter to `"YES"`. It will add an inner wall with the thickness of the half `thickness` value.
// Parameters: 
//     symbol - the bottom symbol
//     characters - the characters around the tower
//     thickness - the character thickness
//     inner_wall - `"YES"` will add an inner wall with the thickness of the half `thickness` value.
module tower_of_characters(symbol, characters, thickness = 1, inner_wall = "NO") {
    radius = 40;
    
    characters_of_a_circle = 40;
    arc_angle = 360 / characters_of_a_circle;
    
    half_arc_angle = arc_angle / 2;
    font_size = 2 * radius * sin(half_arc_angle);
    z_desc = font_size / characters_of_a_circle;

    // characters
    
    for(i = [0 : len(characters) - 1]) {
        translate([0, 0, -z_desc * i])
            rotate([0, 0, i * arc_angle]) 
                cylinder_character(characters[i], arc_angle, radius, thickness = thickness, font_factor = 1.05);
                
        translate([0, 0, font_size - 1 -z_desc * i])
            rotate([-1.5, 0, i * arc_angle - half_arc_angle])
                linear_extrude(1.2) 
                    arc(radius, [0, arc_angle], thickness);

        if(inner_wall == "YES") {                    
            translate([0, 0, 0.2 - z_desc * i])
                rotate([-1.5, 0, i * arc_angle - half_arc_angle])
                    linear_extrude(font_size) 
                        arc(radius, [0, arc_angle], thickness / 2);
        }
    } 
    
    // bottom
    
    difference() {
        translate([0, 0, -z_desc * len(characters)]) 
            linear_extrude(font_size) 
                circle(radius + thickness * 1.5, $fn=48);
            
        translate([0, 0, -z_desc * len(characters) + font_size * 3 / 4]) 
            linear_extrude(font_size) 
			    text(symbol, font = "Courier New:style=Bold", size = font_size * 5, halign = "center", valign = "center");
    }
}

// Create a character tower for chinese. It uses the font "微軟正黑體". If you want to print it easily, set the `inner_wall` parameter to `"YES"`. It will add an inner wall with the thickness of the half `thickness` value.
// Parameters: 
//     symbol - the bottom symbol
//     characters - the characters around the tower
//     thickness - the character thickness
//     inner_wall - `"YES"` will add an inner wall with the thickness of the half `thickness` value.
module tower_of_chinese_characters(symbol, characters, thickness = 1, inner_wall = "NO") {
    radius = 40;
    
    characters_of_a_circle = 30;
	arc_angle = 360 / characters_of_a_circle;
    
    half_arc_angle = arc_angle / 2;
    font_size = 2 * radius * sin(half_arc_angle);
    z_desc = font_size / characters_of_a_circle;


    // characters
    
    for(i = [0 : len(characters) - 1]) {
        translate([0, 0, -z_desc * i])
            rotate([0, 0, i * arc_angle]) 
                cylinder_character(characters[i], arc_angle, radius, font = "微軟正黑體", thickness = thickness, font_factor = 0.75);
                
        translate([0, 0, font_size - 1 -z_desc * i])
            rotate([-2, 0, i * arc_angle - half_arc_angle])
                linear_extrude(1.2) 
                    arc(radius, [0, arc_angle], thickness);

        if(inner_wall == "YES") {                    
            translate([0, 0, 0.2 - z_desc * i])
                rotate([-2, 0, i * arc_angle - half_arc_angle])
                    linear_extrude(font_size) 
                        arc(radius, [0, arc_angle], thickness / 2);
        }
    } 
    
    // bottom
  
    difference() {
        translate([0, 0, -z_desc * len(characters)]) 
            linear_extrude(font_size) 
                circle(radius + thickness * 1.5, $fn=48);
            
        translate([0, 0, -z_desc * len(characters) + font_size * 3 / 4]) 
            linear_extrude(font_size) 
			    text(symbol, font = "微軟正黑體", size = font_size * 5, halign = "center", valign = "center");
    }
}


tower_of_characters(button_symbol, characters, thickness, inner_wall = inner_wall);
