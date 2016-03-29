use <2d.scad>;
use <3d.scad>;
use <turtle.scad>;
use <spiral_characters.scad>;

buttom_symbol_inside = "π";
buttom_symbol_outside = "π";

characters = "3.141592653589793238462643383279502884197169399375105820974944592307816406286208998628034825342117067982148086513282306647093844609550582231725359408128481117450284102701938521105559644622948954930381964428810975665933446128475648233786783165271201909145648566923460348610454326648213393607260249141273724587006606315588174881520920962829254091715364367892590360011330530548820466521384146951941511609433057270365759591953092186117381932611793105118548074462379962749567351885752724891227938183011949129833673362440656643086021394946395224737190702179860943702770539217176293176752384674818467669405132000568127145263560827785771342757789609173637178721468440901224953430146549585371050792279689258923";

bottom_quote = "I will love you until Pi runs out of decimal places.";

thickness = 2;

inner_wall = "YES";

function PI() = 3.14159;


// Create a character tower. If you want to print it easily, set the `inner_wall` parameter to `"YES"`. It will add an inner wall with the thickness of the half `thickness` value.
// Parameters: 
//     buttom_symbol_inside - the bottom symbol of the inside
//     buttom_symbol_outside - the bottom symbol of the outside
//     characters - the characters around the tower
//     thickness - the character thickness
//     inner_wall - `"YES"` will add an inner wall with the thickness of the half `thickness` value.
module tower_of_characters(buttom_symbol_inside, buttom_symbol_outside, bottom_quote, characters, thickness = 1, inner_wall = "NO") {
    radius = 40;
    
    characters_of_a_circle = 40;
    arc_angle = 360 / characters_of_a_circle;
    
    half_arc_angle = arc_angle / 2;
    font_size = 2 * radius * sin(half_arc_angle);
    z_desc = font_size / characters_of_a_circle;
	
	len_of_characters = len(characters);

    // characters
	
	for(i = [0 : len_of_characters - 1]) {
		translate([0, 0, -z_desc * i])
			rotate([0, 0, i * arc_angle]) 
				fake_cylinder_character(characters[i], arc_angle, radius, thickness = thickness, font_factor = 1.05);
				
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
        translate([0, 0, -z_desc * len_of_characters]) 
            linear_extrude(font_size) 
                circle(radius + thickness * 1.5, $fn=48);
            
        translate([0, 0, -z_desc * len_of_characters + font_size * 3 / 4]) 
            linear_extrude(font_size) 
			    text(buttom_symbol_inside, font = "Times New Roman:style=Bold", size = font_size * 5, halign = "center", valign = "center");
				
		translate([0, 0, -z_desc * len_of_characters - font_size])  rotate(180) mirror([1, 0, 0]) scale(1.2) 
		    scale(1.1) spiral_characters(buttom_symbol_outside, bottom_quote, 80, height = font_size, spin = "OUT");				
    }
}

tower_of_characters(buttom_symbol_inside, buttom_symbol_outside, bottom_quote, characters, thickness, inner_wall = inner_wall);

