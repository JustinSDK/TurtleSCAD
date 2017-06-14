/* [BASIC] */

text = "LOL";
font_size = 16;
font_name = "Arial Black";
text_depth = 1;

/* [ADVANCED] */

sphere_radius = 14;
helix_line_thickness = 6;
cross_line_thickness = 4;
levels = 1;
level_dist = 70;
fn = 24;

// Commonly-used private API

function __frags(radius) = $fn > 0 ? 
            ($fn >= 3 ? $fn : 3) : 
            max(min(360 / $fa, radius * 6.28318 / $fs), 5);
            
function __nearest_multiple_of_4(n) =
    let(
        remain = n % 4
    )
    (remain / 4) > 0.5 ? n - remain + 4 : n - remain;

function __is_vector(value) = !(value >= "") && len(value) != undef;    
    
function __to2d(p) = [p[0], p[1]];

function __to3d(p) = [p[0], p[1], 0];

function __reverse(vt) = 
    let(leng = len(vt))
    [
        for(i = [0:leng - 1])
            vt[leng - 1 - i]
    ];

function __angy_angz(p1, p2) = 
    let(
        dx = p2[0] - p1[0],
        dy = p2[1] - p1[1],
        dz = p2[2] - p1[2],
        ya = atan2(dz, sqrt(pow(dx, 2) + pow(dy, 2))),
        za = atan2(dy, dx)
    ) [ya, za];
    
function __length_between(p1, p2) =
    let(
        dx = p2[0] - p1[0],
        dy = p2[1] - p1[1],
        dz = p2[2] - p1[2]
    ) sqrt(pow(dx, 2) + pow(dy, 2) + pow(dz, 2));
    
/**
* line3d.scad
*
* Creates a 3D line from two points. 
* 
* @copyright Justin Lin, 2017
* @license https://opensource.org/licenses/lgpl-3.0.html
*
* @see https://openhome.cc/eGossip/OpenSCAD/lib-line3d.html
*
**/
    

module line3d(p1, p2, thickness, p1Style = "CAP_CIRCLE", p2Style = "CAP_CIRCLE") {
    r = thickness / 2;

    frags = __nearest_multiple_of_4(__frags(r));
    half_fa = 180 / frags;
    
    dx = p2[0] - p1[0];
    dy = p2[1] - p1[1];
    dz = p2[2] - p1[2];
    
    length = sqrt(pow(dx, 2) + pow(dy, 2) + pow(dz, 2));
    ay = 90 - atan2(dz, sqrt(pow(dx, 2) + pow(dy, 2)));
    az = atan2(dy, dx);

    angles = [0, ay, az];

    module cap_with(p) { 
        translate(p) 
            rotate(angles) 
                children();  
    } 

    module cap_butt() {
        cap_with(p1)                 
            linear_extrude(length) 
                circle(r, $fn = frags);
        
        // hook for testing
        test_line3d_butt(p1, r, frags, length, angles);
    }

    module cap(p, style) {
        if(style == "CAP_CIRCLE") {
            cap_leng = r / 1.414;
            cap_with(p) 
                linear_extrude(cap_leng * 2, center = true) 
                    circle(r, $fn = frags);

            // hook for testing
            test_line3d_cap(p, r, frags, cap_leng, angles);
        } else if(style == "CAP_SPHERE") { 
            cap_leng = r / cos(half_fa);
            cap_with(p)
                sphere(cap_leng, $fn = frags);  
            
            // hook for testing
            test_line3d_cap(p, r, frags, cap_leng, angles);
        }            
    }


    cap_butt();
    cap(p1, p1Style);
    cap(p2, p2Style);
}

// Override them to test
module test_line3d_butt(p, r, frags, length, angles) {

}

module test_line3d_cap(p, r, frags, cap_leng, angles) {
    
}


/**
* helix.scad
*
* Gets all points on the path of a spiral around a cylinder. 
* Its $fa, $fs and $fn parameters are consistent with the cylinder module.
* It depends on the circle_path module so you have to include circle_path.scad.
* 
* @copyright Justin Lin, 2017
* @license https://opensource.org/licenses/lgpl-3.0.html
*
* @see https://openhome.cc/eGossip/OpenSCAD/lib-helix.html
*
**/ 

function helix(radius, levels, level_dist, vt_dir = "SPI_DOWN", rt_dir = "CT_CLK") = 
    let(
        is_vt = __is_vector(radius),
        r1 = is_vt ? radius[0] : radius,
        r2 = is_vt ? radius[1] : radius,
        init_r = vt_dir == "SPI_DOWN" ? r2 : r1,
        _frags = __frags(init_r),
        h = level_dist * levels,
        vt_d = vt_dir == "SPI_DOWN" ? 1 : -1,
        rt_d = rt_dir == "CT_CLK" ? 1 : -1,
        r_diff = (r1 - r2) * vt_d,
        h_step = level_dist / _frags * vt_d,
        r_step = r_diff / (levels * _frags),
        a_step = 360 / _frags * rt_d,
        begin_r = vt_dir == "SPI_DOWN" ? r2 : r1,
        begin_h = vt_dir == "SPI_DOWN" ? h : 0
    )
    [
        for(i = [0:_frags * levels]) 
            let(r = begin_r + r_step * i, a = a_step * i)
                [r * cos(a), r * sin(a), begin_h - h_step * i]
    ];

/**
* rotate_p.scad
*
* Rotates a point 'a' degrees around an arbitrary axis. 
* The rotation is applied in the following order: x, y, z. 
* 
* @copyright Justin Lin, 2017
* @license https://opensource.org/licenses/lgpl-3.0.html
*
* @see https://openhome.cc/eGossip/OpenSCAD/lib-rotate_p.html
*
**/ 

function _rotx(pt, a) = 
    let(cosa = cos(a), sina = sin(a))
    [
        pt[0], 
        pt[1] * cosa - pt[2] * sina,
        pt[1] * sina + pt[2] * cosa
    ];

function _roty(pt, a) = 
    let(cosa = cos(a), sina = sin(a))
    [
        pt[0] * cosa + pt[2] * sina, 
        pt[1],
        -pt[0] * sina + pt[2] * cosa, 
    ];

function _rotz(pt, a) = 
    let(cosa = cos(a), sina = sin(a))
    [
        pt[0] * cosa - pt[1] * sina,
        pt[0] * sina + pt[1] * cosa,
        pt[2]
    ];

function _rotate_p_3d(point, a) =
    _rotz(_roty(_rotx(point, a[0]), a[1]), a[2]);

function to_avect(a) =
     len(a) == 3 ? a : (
         len(a) == 2 ? [a[0], a[1], 0] : (
             len(a) == 1 ? [a[0], 0, 0] : [0, 0, a]
         ) 
     );

function rotate_p(point, a) =
    let(angle = to_avect(a))
    len(point) == 3 ? 
        _rotate_p_3d(point, angle) :
        __to2d(
            _rotate_p_3d(__to3d(point), angle)
        );

    
/**
* polysections.scad
*
* Crosscutting a tube-like shape at different points gets several cross-sections.
* This module can operate reversely. It uses cross-sections to construct a tube-like shape.
* 
* @copyright Justin Lin, 2017
* @license https://opensource.org/licenses/lgpl-3.0.html
*
* @see https://openhome.cc/eGossip/OpenSCAD/lib-polysections.html
*
**/

module polysections(sections, triangles = "SOLID") {

    function side_indexes(sects, begin_idx = 0) = 
        let(       
            leng_sects = len(sects),
            leng_pts_sect = len(sects[0])
        ) 
        concat(
            [
                for(j = [begin_idx:leng_pts_sect:begin_idx + (leng_sects - 2) * leng_pts_sect])
                    for(i = [0:leng_pts_sect - 1]) 
                        [
                            j + i, 
                            j + (i + 1) % leng_pts_sect, 
                            j + (i + 1) % leng_pts_sect + leng_pts_sect
                        ]
            ],
            [
                for(j = [begin_idx:leng_pts_sect:begin_idx + (leng_sects - 2) * leng_pts_sect])
                    for(i = [0:leng_pts_sect - 1]) 
                        [
                            j + i, 
                            j + (i + 1) % leng_pts_sect + leng_pts_sect , 
                            j + i + leng_pts_sect
                        ]
            ]      
        );

    function search_at(f_sect, p, leng_pts_sect, i = 0) =
        i < leng_pts_sect ?
            (p == f_sect[i] ? i : search_at(f_sect, p, leng_pts_sect, i + 1)) : -1;
    
    function the_same_after_twisting(f_sect, l_sect, leng_pts_sect) =
        let(
            found_at_i = search_at(f_sect, l_sect[0], leng_pts_sect)
        )
        found_at_i <= 0 ? false : 
            l_sect == concat(
                [for(i = [found_at_i:leng_pts_sect-1]) f_sect[i]],
                [for(i = [0:found_at_i - 1]) f_sect[i]]
            );        

    module solid_sections(sects) {
        
        leng_sects = len(sects);
        leng_pts_sect = len(sects[0]);
        first_sect = sects[0];
        last_sect = sects[leng_sects - 1];
   
        v_pts = [
            for(sect = sects) 
                for(pt = sect) 
                    pt
        ];

        function begin_end_the_same() =
            first_sect == last_sect || 
            the_same_after_twisting(first_sect, last_sect, leng_pts_sect);

        if(begin_end_the_same()) {
            polyhedron(
                v_pts, 
                side_indexes(sects)
            ); 
        } else {
            first_idxes = [for(i = [0:leng_pts_sect - 1]) leng_pts_sect - 1 - i];  
            last_idxes = [
                for(i = [0:leng_pts_sect - 1]) 
                    i + leng_pts_sect * (leng_sects - 1)
            ];       

            polyhedron(
                v_pts, 
                concat([first_idxes], side_indexes(sects), [last_idxes])
            );    
        }
    }

    module hollow_sections(sects) {
        leng_sects = len(sects);
        leng_sect = len(sects[0]);
        half_leng_sect = leng_sect / 2;
        half_leng_v_pts = leng_sects * half_leng_sect;

        function strip_sects(begin_idx, end_idx) = 
            [
                for(i = [0:leng_sects - 1]) 
                    [
                        for(j = [begin_idx:end_idx])
                            sects[i][j]
                    ]
            ]; 

        function first_idxes() = 
            [
                for(i =  [0:half_leng_sect - 1]) 
                    [
                       i,
                       i + half_leng_v_pts,
                       (i + 1) % half_leng_sect + half_leng_v_pts, 
                       (i + 1) % half_leng_sect
                    ] 
            ];

        function last_idxes(begin_idx) = 
            [
                for(i =  [0:half_leng_sect - 1]) 
                    [
                       begin_idx + i,
                       begin_idx + (i + 1) % half_leng_sect,
                       begin_idx + (i + 1) % half_leng_sect + half_leng_v_pts,
                       begin_idx + i + half_leng_v_pts
                    ]     
            ];            

        outer_sects = strip_sects(0, half_leng_sect - 1);
        inner_sects = strip_sects(half_leng_sect, leng_sect - 1);

        function to_v_pts(sects) = 
             [
                for(sect = sects) 
                    for(pt = sect) 
                        pt
             ];

        outer_v_pts =  to_v_pts(outer_sects);
        inner_v_pts = to_v_pts(inner_sects);

        outer_idxes = side_indexes(outer_sects);
        inner_idxes = [ 
            for(idxes = side_indexes(inner_sects, half_leng_v_pts))
                __reverse(idxes)
        ];

        first_outer_sect = outer_sects[0];
        last_outer_sect = outer_sects[leng_sects - 1];
        first_inner_sect = inner_sects[0];
        last_inner_sect = inner_sects[leng_sects - 1];
        
        leng_pts_sect = len(first_outer_sect);

        function begin_end_the_same() = 
           (first_outer_sect == last_outer_sect && first_inner_sect == last_inner_sect) ||
           (
               the_same_after_twisting(first_outer_sect, last_outer_sect, leng_pts_sect) && 
               the_same_after_twisting(first_inner_sect, last_inner_sect, leng_pts_sect)
           ); 

        if(begin_end_the_same()) {
            polyhedron(
                concat(outer_v_pts, inner_v_pts),
                concat(outer_idxes, inner_idxes)
            );             
        } else {
            first_idxes = first_idxes();
            last_idxes = last_idxes(half_leng_v_pts - half_leng_sect);
            
            polyhedron(
                concat(outer_v_pts, inner_v_pts),
                concat(first_idxes, outer_idxes, inner_idxes, last_idxes)
            ); 
        }
    }
    
    module triangles_defined_sections() {
        module tri_sections(tri1, tri2) {
            polyhedron(
                points = concat(tri1, tri2),
                faces = [
                    [0, 1, 2], 
                    [3, 5, 4], 
                    [0, 4, 1], [1, 5, 2], [2, 3, 0], 
                    [0, 3, 4], [1, 4, 5], [2, 5, 3]
                ]
            );  
        }

        module two_sections(section1, section2) {
            for(idx = triangles) {
                // hull is for preventing from WARNING: Object may not be a valid 2-manifold
                hull() tri_sections(
                    [
                        section1[idx[0]], 
                        section1[idx[1]], 
                        section1[idx[2]]
                    ], 
                    [
                        section2[idx[0]], 
                        section2[idx[1]], 
                        section2[idx[2]]
                    ]
                );
            }
        }
        
        for(i = [0:len(sections) - 2]) {
             two_sections(
                 sections[i], 
                 sections[i + 1]
             );
        }
    }
    
    if(triangles == "SOLID") {
        solid_sections(sections);
    } else if(triangles == "HOLLOW") {
        hollow_sections(sections);
    }
    else {
        triangles_defined_sections();
    }
}

/**
* path_extrude.scad
*
* It extrudes a 2D shape along a path. 
* This module is suitable for a path created by a continuous function.
* It depends on the rotate_p function and the polysections module. 
* Remember to include "rotate_p.scad" and "polysections.scad".
*
* @copyright Justin Lin, 2017
* @license https://opensource.org/licenses/lgpl-3.0.html
*
* @see https://openhome.cc/eGossip/OpenSCAD/lib-path_extrude.html
*
**/

module path_extrude(shape_pts, path_pts, triangles = "SOLID", twist = 0, scale = 1.0, closed = false) {
    sh_pts = len(shape_pts[0]) == 3 ? shape_pts : [for(p = shape_pts) __to3d(p)];
    pth_pts = len(path_pts[0]) == 3 ? path_pts : [for(p = path_pts) __to3d(p)];

    len_path_pts = len(pth_pts);    
    len_path_pts_minus_one = len_path_pts - 1;     

    scale_step_vt = __is_vector(scale) ? 
        [(scale[0] - 1) / len_path_pts_minus_one, (scale[1] - 1) / len_path_pts_minus_one] :
        [(scale - 1) / len_path_pts_minus_one, (scale - 1) / len_path_pts_minus_one];

    scale_step_x = scale_step_vt[0];
    scale_step_y = scale_step_vt[1];
    twist_step = twist / len_path_pts_minus_one;

    function first_section() = 
        let(
            p1 = pth_pts[0], 
            p2 = pth_pts[1],
            angy_angz = __angy_angz(p1, p2),
            ay = -angy_angz[0],
            az = angy_angz[1]
        )
        [
            for(p = sh_pts) 
                rotate_p(
                    rotate_p(p, [90, 0, -90]), 
                    [0, ay, az]
                ) + p1
        ];

    function section(p1, p2, i) = 
        let(
            length = __length_between(p1, p2),
            angy_angz = __angy_angz(p1, p2),
            ay = -angy_angz[0],
            az = angy_angz[1]
        )
        [
            for(p = sh_pts) 
                let(scaled_p = [p[0] * (1 + scale_step_x * i), p[1] * (1 + scale_step_y * i), p[2]])
                rotate_p(
                     rotate_p(
                         rotate_p(scaled_p, twist_step * i), [90, 0, -90]
                     ) + [length, 0, 0], 
                     [0, ay, az]
                ) + p1
        ];
    
    function path_extrude_inner(index) =
       index == len_path_pts ? [] :
           concat(
               [section(pth_pts[index - 1], pth_pts[index],  index)],
               path_extrude_inner(index + 1)
           );

    if(closed && pth_pts[0] == pth_pts[len_path_pts_minus_one]) {
        // round-robin
        sections = path_extrude_inner(1);
        polysections(
            concat(sections, [sections[0]]),
            triangles = triangles
        );   
    } else {
        polysections(
            concat([first_section()], path_extrude_inner(1)),
            triangles = triangles
        ); 
    }
}

/**
* circle_path.scad
*
* Sometimes you need all points on the path of a circle. Here's 
* the function. Its $fa, $fs and $fn parameters are consistent 
* with the circle module.
* 
* @copyright Justin Lin, 2017
* @license https://opensource.org/licenses/lgpl-3.0.html
*
* @see https://openhome.cc/eGossip/OpenSCAD/lib-circle_path.html
*
**/

function circle_path(radius, n) =
    let(
        _frags = __frags(radius),
        step_a = 360 / _frags,
        end_a = 360 - step_a * ((n == undef || n > _frags) ? 1 : _frags - n + 1)
    )
    [
        for(a = [0 : step_a : end_a]) 
            [radius * cos(a), radius * sin(a)]
    ];

module text_helix() {
    $fn = fn;

    circle_pts = circle_path(helix_line_thickness / 2);

    points1 = helix(
        radius = sphere_radius, 
        levels = levels , 
        level_dist = level_dist 
    );

    points2 = [
        for(p = points1) rotate_p(p, 180)
    ];

    angle = 180 * levels;

    module connected_helixs() {
        path_extrude(circle_pts, points1);
        path_extrude(circle_pts, points2);
        
        for(i = [1:len(points1) - 2]) {
            line3d(points1[i], points2[i], cross_line_thickness);
        } 
    }

    module sphere_chr(c) {
        rotate(angle) 
            translate([0, -sphere_radius, 0]) 
                rotate([90, 0, 0]) 
                    linear_extrude(sphere_radius, center = true) 
                        text(c, 
                             font = font_name , 
                             size = font_size, 
                             valign = "center", 
                             halign = "center"
                        );
    }

    for(i = [0:len(text) - 1]) {
        translate([(sphere_radius + helix_line_thickness + 1) * 2 * i, 0, 0]) 
        union() {
            connected_helixs();
            
            translate([0, 0, level_dist  * levels  / 2]) union() {
                difference() {
                    sphere(sphere_radius);
                    sphere_chr(text[i]);
                    rotate(180) sphere_chr(text[i]);
                }
                
                color("white") 
                    sphere(sphere_radius - text_depth);
            }
                
            // base
            linear_extrude(helix_line_thickness, center = true) 
                circle(sphere_radius + helix_line_thickness);
        }
    }
}

text_helix();

