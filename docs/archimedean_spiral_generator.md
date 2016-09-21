# Archimedean spiral generator

[Archimedean spiral](https://en.wikipedia.org/wiki/Archimedean_spiral) is the base of [Spiral moving fish](https://www.thingiverse.com/thing:1763139). 

The equation of Archimedean spiral is `r = a + b * theta`. If you just increase theta with the same amount, the distance between each segment of the moving fish would also be increased. 

In order to equally spaced each segment, I need to find out all angles between each segment. That's what the `find_parent_angles` module does in the .scad file. 

For more precisely controlling  models between  each segment, I also divide all parent angles found by  the `find_parent_angles` module into several sub angles which may be controlled by the `children_per_step` parameter.

![Archimedean spiral generator](http://thingiverse-production-new.s3.amazonaws.com/renders/68/96/e8/c5/83/99191811f269e2e86136015b8cdc6410_preview_featured.JPG)