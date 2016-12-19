# Customizable tree curve

It's based on a 3D version of turtle algorithm. If you are using OpenSCAD and need a library of turtle graphics 3D, the code I wrote may be a reference. 

Can STLs here be printed? It may be hard for a FDM printer but easier for other types, such as those using a process that deposits a binder material onto a powder bed layer by layer. 

If you are still sticking to a FDM printer, challenging a version with fewer recursions would be a good start. In the customizer, recursions are limited by `init_leng`, `leng_limit` and `leng_scale` parameters. 

More recursions require more time to generate a preview in the customizer so the preview may be terminated by a browser due to security issues. If that's so, download the .scad and use [OpenSCAD](http://www.openscad.org/index.html) directly.

Someone said if all branches' overhang angles were under 90 degrees, it's possible for DLPs to print it. I upload [one](https://www.thingiverse.com/download:3085572) for this. If you have a DLP, give it a try. :)

![Customizable tree curve](http://thingiverse-production-new.s3.amazonaws.com/renders/a8/2b/cc/57/b0/20bc2d3861238412a0792c0ffe5043c0_preview_featured.JPG)