use <2d.scad>;
use <3d.scad>;

thickness = 5;
height = 20;
layer_factor = 5; // [1:90]
tip_sharp_factor = 10; 

eclipse_heart(thickness, height / 3.12, layer_factor, tip_sharp_factor);


