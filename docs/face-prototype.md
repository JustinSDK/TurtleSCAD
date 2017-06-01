# Face

Want to sculpt a face? It's a concept of proof. Using OpenSCAD to sculpt a face is possible :p

Imagine you are scanning a face, you'll get a curve for each cross section. I just perform oppositely. For simplicity, each cross section is defined by three cubic Bézier curves in my code. Because a face is symmetric, I can use only five control points to define each cross section. For example:

    face_section([
        [5, 35, 7],
        [7, 35, 0],
        [17, 34, -8.5],
        [27, 34, 8.5],
        [53, 37, -20]
    ])

The function below calculates these points into 12 control points for three cubic Bézier curves.

    function face_section(ctrl_points) = 
        let(
            middle = [
                [-ctrl_points[1][0], ctrl_points[1][1], ctrl_points[1][2]],
                [-ctrl_points[0][0], ctrl_points[0][1], ctrl_points[0][2]],
                ctrl_points[0],
                ctrl_points[1]
            ],
            right = [
                ctrl_points[1],
                ctrl_points[2],
                ctrl_points[3],
                ctrl_points[4]
            ],
            left = [
                for(i = [0:3]) 
                    [
                        -right[3 - i][0],
                        right[3 - i][1],
                        right[3 - i][2]
                    ]
            ]
        ) __reverse(
            concat(
                bezier_curve(resolution, left), 
                bezier_curve(resolution, middle), 
                bezier_curve(resolution, right)
            )
        );

After getting a list of cross sections for a face, I can use my [polysections](https://openhome.cc/eGossip/OpenSCAD/lib-polysections.html) module to create a face:

    polysections(sections);

Or use my [function_grapher](https://openhome.cc/eGossip/OpenSCAD/lib-function_grapher.html) to get the mesh of the face.

    function_grapher(
        sections, 
        thickness, 
        style = "LINES", 
        $fn = 4
    );

The code below creates the mask:

    difference() {
        function_grapher(
            sections, 
            thickness, 
            style = "HULL_FACES", 
            $fn = 4
        );

        translate([27, 42, 0]) 
            linear_extrude(100, center = true) 
                polygon(shape_ellipse([14, 5], $fn = 8));
                
        translate([-27, 42, 0]) 
            linear_extrude(100, center = true) 
                polygon(shape_ellipse([14, 5], $fn = 8));            
    }  

The [shape_ellipse](https://openhome.cc/eGossip/OpenSCAD/lib-shape_ellipse.html) function is also included in [my library](https://justinsdk.github.io/dotSCAD/).

![Face](https://thingiverse-production-new.s3.amazonaws.com/renders/ac/b6/73/a8/fd/963ac418d63e1e7e6d16e6013b33d410_preview_featured.JPG)