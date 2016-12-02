# Customizable Bezier vase

It's based on [Cubic Bézier curves](https://en.wikipedia.org/wiki/B%C3%A9zier_curve#Cubic_B.C3.A9zier_curves). You use four points to design your own Bézier curve. 

![Customizable Bezier vase](http://thingiverse-production-new.s3.amazonaws.com/renders/6f/d7/ea/b2/f1/74b8b10b33fa3327da2a0a7da2ec76c8_preview_featured.jpg)

For example, The points `[0, 0, 0]`, `[40, 60, 0]`, `[-50, 90, 0]` and `[0, 200, 0]` would create the Bézier curve below.

![Customizable Bezier vase](https://cdn.thingiverse.com/assets/44/b3/d0/99/3f/bezier_vase3.png)

The customizer would `translate([bottom_radius, 0, 0])`  and `rotate([90, 0, angle]) ` the curve `fn` times. The angle is calculated from `360 / fn`. Then I add a bottom and an optional inner vase.

Each point's `z` coordinate is always `0` so you only need to adjust `x` and `y` of these four points while using the customizer.




