# Multiplication puzzle generator

This is based on [Puzzle generator](https://www.thingiverse.com/thing:1427568). It places a multiplication table on a puzzle. The piece's height, as the number shown, is in millimeter.

Parameters: 
- `piece_side_length`
- `same_side`
- `n`
- `spacing`

Basically, the `n` parameter may be any positive value, but I restrict it from 1 to 9 in the Customizer because I don't want the number too small. The number size is `piece_side_length / 3` is the .scad file. 

If you want to generate a multiplication puzzle with a `n` bigger than 9. Download the .scad file and modify the `size` parameter of the `text` in the `puzzle_piece_with_text` module. 

![Multiplication puzzle generator](http://thingiverse-production-new.s3.amazonaws.com/renders/39/80/75/4e/de/2c09d485905986e153babcd68421fe5a_preview_featured.JPG)
