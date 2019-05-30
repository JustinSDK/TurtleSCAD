
x1 = 4; // [-20:4]
x2 = 3; // [-20:4]
x3 = 4; // [-20:4]
y1 = 20; 
y2 = 40;
y3 = 60;
twist = 45;
t_step = 0.2;

module dancing_formosan(x1, x2, x3, y1, y2, y3, twist, t_step) {

    function cal_sections(shapt_pts, edge_path, twist) =
        let(
            sects = path_scaling_sections(shapt_pts, edge_path),
            leng = len(sects),
            twist_step = twist / leng
        )
        [
            for(i = [0:leng - 1]) 
            [
                for(p = sects[i]) 
                    rotate_p(p, twist_step * i)        
            ]
        ];

    taiwan = shape_taiwan(100, 0.6);
    fst_pt = [13, 0, 0];

    edge_path = bezier_curve(t_step, [
        fst_pt,
        fst_pt + [0, 0, 10],
        fst_pt + [x1, 0, y1],
        fst_pt + [x2, 0, 35],
        fst_pt + [x3, 0, y2],
        fst_pt + [0, 0, 55],
        fst_pt + [0, 0, y3]
    ]);


    offseted = bijection_offset(taiwan, -2);

    edge_paty2 = [for(p = edge_path) p + [-2, 0, 0]];
    taiwan2 = trim_shape(offseted, 1, len(offseted) - 4);

    sections = cal_sections(taiwan, edge_path, twist);
    sections2 = cal_sections(taiwan2, edge_paty2, twist);

    difference() {
        polysections(sections);
        polysections(sections2);
    }

    translate([0, 0, -2]) 
        linear_extrude(2) 
            rotate(twist - twist / len(sections)) 
                polygon(taiwan);

}

dancing_formosan(x1, x2, x3, y1, y2, y3, twist, t_step);
    
/**
 * The dotSCAD library
 * @copyright Justin Lin, 2017
 * @license https://opensource.org/licenses/lgpl-3.0.html
 *
 * @see https://github.com/JustinSDK/dotSCAD
*/


function _trim_shape_any_intersection_sub(lines, line, lines_leng, i, epsilon) =
    let(
        p = __line_intersection(lines[i], line, epsilon)
    )
    (p != [] && __in_line(line, p, epsilon) && __in_line(lines[i], p, epsilon)) ? [i, p] : _trim_shape_any_intersection(lines, line, lines_leng, i + 1, epsilon);

// return [idx, [x, y]] or []
function _trim_shape_any_intersection(lines, line, lines_leng, i, epsilon) =
    i == lines_leng ? [] : _trim_shape_any_intersection_sub(lines, line, lines_leng, i, epsilon);

function _trim_sub(lines, leng, epsilon) = 
    let(
        current_line = lines[0],
        next_line = lines[1],
        lines_from_next = [for(j = [1 : leng - 1]) lines[j]],
        lines_from_next2 = [for(j = [2 : leng - 1]) lines[j]],
        current_p = current_line[0],
        leng_lines_from_next2 = len(lines_from_next2),
        inter_p = _trim_shape_any_intersection(lines_from_next2, current_line, leng_lines_from_next2, 0, epsilon)
    )
    // no intersecting pt, collect current_p and trim remain lines
    inter_p == [] ? (concat([current_p], _trim_shape_trim_lines(lines_from_next, epsilon))) : (
        // collect current_p, intersecting pt and the last pt
        (leng == 3 || (inter_p[0] == (leng_lines_from_next2 - 1))) ? [current_p, inter_p[1], lines[leng - 1]] : (
            // collect current_p, intersecting pt and trim remain lines
            concat([current_p, inter_p[1]], 
                _trim_shape_trim_lines([for(i = [inter_p[0] + 1 : leng_lines_from_next2 - 1]) lines_from_next2[i]], epsilon)
            )
        )
    );
    
function _trim_shape_trim_lines(lines, epsilon) = 
    let(leng = len(lines))
    leng > 2 ? _trim_sub(lines, leng, epsilon) : _trim_shape_collect_pts_from(lines, leng);

function _trim_shape_collect_pts_from(lines, leng) = 
    concat([for(line = lines) line[0]], [lines[leng - 1][1]]);

function trim_shape(shape_pts, from, to, epsilon = 0.0001) = 
    let(
        pts = [for(i = [from:to]) shape_pts[i]],
        trimmed = _trim_shape_trim_lines(__lines_from(pts), epsilon)
    )
    len(shape_pts) == len(trimmed) ? trimmed : trim_shape(trimmed, 0, len(trimmed) - 1, epsilon);


function __to2d(p) = [p[0], p[1]];

/**
* m_scaling.scad
*
* @copyright Justin Lin, 2019
* @license https://opensource.org/licenses/lgpl-3.0.html
*
* @see https://openhome.cc/eGossip/OpenSCAD/lib-m_scaling.html
*
**/


function _to_3_elems_scaling_vect(s) =
     let(leng = len(s))
     leng == 3 ? s : (
         leng == 2 ? [s[0], s[1], 1] : [s[0], 1, 1]
     );

function _to_scaling_vect(s) = __is_float(s) ? [s, s, s] : _to_3_elems_scaling_vect(s);

function m_scaling(s) = 
    let(v = _to_scaling_vect(s))
    [
        [v[0], 0, 0, 0],
        [0, v[1], 0, 0],
        [0, 0, v[2], 0],
        [0, 0, 0, 1]
    ];

/**
* bijection_offset.scad
*
* @copyright Justin Lin, 2019
* @license https://opensource.org/licenses/lgpl-3.0.html
*
* @see https://openhome.cc/eGossip/OpenSCAD/lib-bijection_offset.html
*
**/

    
function _bijection_inward_edge_normal(edge) =  
    let(
        pt1 = edge[0],
        pt2 = edge[1],
        dx = pt2[0] - pt1[0],
        dy = pt2[1] - pt1[1],
        edge_leng = norm([dx, dy])
    )
    [-dy / edge_leng, dx / edge_leng];

function _bijection_outward_edge_normal(edge) = -1 * _bijection_inward_edge_normal(edge);

function _bijection_offset_edge(edge, dx, dy) = 
    let(
        pt1 = edge[0],
        pt2 = edge[1],
        dxy = [dx, dy]
    )
    [pt1 + dxy, pt2 + dxy];
    
function _bijection__bijection_offset_edges(edges, d) = 
    [ 
        for(edge = edges)
        let(
            ow_normal = _bijection_outward_edge_normal(edge),
            dx = ow_normal[0] * d,
            dy = ow_normal[1] * d
        )
        _bijection_offset_edge(edge, dx, dy)
    ];

function bijection_offset(pts, d, epsilon = 0.0001) = 
    let(
        es = __lines_from(pts, true), 
        offset_es = _bijection__bijection_offset_edges(es, d),
        leng = len(offset_es),
        last_p = __line_intersection(offset_es[leng - 1], offset_es[0], epsilon)
    )
    concat(
        [
            for(i = [0:leng - 2]) 
            let(
                this_edge = offset_es[i],
                next_edge = offset_es[i + 1],
                p = __line_intersection(this_edge, next_edge, epsilon)
            )
            // p == p to avoid [nan, nan], because [nan, nan] != [nan, nan]
            if(p != [] && p == p) p
        ],
        last_p != [] && last_p == last_p ? [last_p] : []
    );
    

/**
* path_scaling_sections.scad
*
* @copyright Justin Lin, 2019
* @license https://opensource.org/licenses/lgpl-3.0.html
*
* @see https://openhome.cc/eGossip/OpenSCAD/lib-path_scaling_sections.html
*
**/


function path_scaling_sections(shape_pts, edge_path) = 
    let(
        start_point = edge_path[0],
        base_leng = norm(start_point),
        scaling_matrice = [
            for(p = edge_path) 
            let(s = norm([p[0], p[1], 0]) / base_leng)
            m_scaling([s, s, 1])
        ]
    )
    __reverse([
        for(i = [0:len(edge_path) - 1])
        [
            for(p = shape_pts) 
            let(scaled_p = scaling_matrice[i] * [p[0], p[1], edge_path[i][2], 1])
            [scaled_p[0], scaled_p[1], scaled_p[2]]
        ]
    ]);

function __line_intersection(line_pts1, line_pts2, epsilon = 0.0001) = 
    let(
        a1 = line_pts1[0],
        a2 = line_pts1[1],
        b1 = line_pts2[0],
        b2 = line_pts2[1],
        a = a2 - a1, 
        b = b2 - b1, 
        s = b1 - a1
    )
    abs(cross(a, b)) < epsilon ? [] :  // they are parallel or conincident edges
        a1 + a * cross(s, b) / cross(a, b);

/**
* polysections.scad
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

    function to_v_pts(sects) = 
            [
            for(sect = sects) 
                for(pt = sect) 
                    pt
            ];                   

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
            f_idxes = side_indexes(sects);

            polyhedron(
                v_pts, 
                f_idxes
            ); 

            // hook for testing
            test_polysections_solid(v_pts, f_idxes);
        } else {
            first_idxes = [for(i = [0:leng_pts_sect - 1]) leng_pts_sect - 1 - i];  
            last_idxes = [
                for(i = [0:leng_pts_sect - 1]) 
                    i + leng_pts_sect * (leng_sects - 1)
            ];    

            f_idxes = concat([first_idxes], side_indexes(sects), [last_idxes]);
            
            polyhedron(
                v_pts, 
                f_idxes
            );   

            // hook for testing
            test_polysections_solid(v_pts, f_idxes);             
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

        v_pts = concat(outer_v_pts, inner_v_pts);

        if(begin_end_the_same()) {
            f_idxes = concat(outer_idxes, inner_idxes);

            polyhedron(
                v_pts,
                f_idxes
            );      

            // hook for testing
            test_polysections_solid(v_pts, f_idxes);                     
        } else {
            first_idxes = first_idxes();
            last_idxes = last_idxes(half_leng_v_pts - half_leng_sect);

            f_idxes = concat(first_idxes, outer_idxes, inner_idxes, last_idxes);
            
            polyhedron(
                v_pts,
                f_idxes
            ); 

            // hook for testing
            test_polysections_solid(v_pts, f_idxes);              
        }
    }
    
    module triangles_defined_sections() {
        module tri_sections(tri1, tri2) {
            hull() polyhedron(
                points = concat(tri1, tri2),
                faces = [
                    [0, 1, 2], 
                    [3, 5, 4], 
                    [1, 3, 4], [2, 1, 4], [2, 3, 0], 
                    [0, 3, 1], [2, 4, 5], [2, 5, 3]
                ]
            );  
        }

        module two_sections(section1, section2) {
            for(idx = triangles) {
               tri_sections(
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

// override it to test

module test_polysections_solid(points, faces) {

}

/**
* shape_taiwan.scad
*
* @copyright Justin Lin, 2017
* @license https://opensource.org/licenses/lgpl-3.0.html
*
* @see https://openhome.cc/eGossip/OpenSCAD/lib-shape_taiwan.html
*
**/

function shape_taiwan(h, dt = 0) = 
    let(tw = [[3.85724, 6.24078], [3.7902, 6.25779], [3.73596, 6.26288], [3.62807, 6.24587], [3.59581, 6.2602], [3.55429, 6.32386], [3.51698, 6.4571], [3.50768, 6.5361], [3.51188, 6.58284], [3.53917, 6.63708], [3.48981, 6.66934], [2.78286, 6.83905], [2.7218, 6.86112], [2.68441, 6.90272], [2.61063, 6.96209], [2.64288, 7.05549], [2.61062, 7.06568], [2.56396, 7.06058], [2.50281, 7.04109], [2.44849, 7.15647], [2.29319, 7.37123], [2.22438, 7.42555], [2.05644, 7.44248], [1.88674, 7.40509], [1.73901, 7.32879], [1.63795, 7.238], [1.58868, 7.14974], [1.54463, 7.0555], [1.5149, 7.0411], [1.48526, 7.01895], [1.53658, 6.9725], [1.58825, 6.92909], [1.63096, 6.86281], [1.61348, 6.80387], [1.57757, 6.83721], [1.53949, 6.89116], [1.48525, 6.87393], [1.43851, 6.87393], [1.40381, 6.86623], [1.37408, 6.85174], [1.28068, 6.77282], [1.20682, 6.7457], [0.723984, 6.65659], [0.586451, 6.60741], [0.5152, 6.57094], [0.458435, 6.52167], [0.393838, 6.47922], [0.108666, 6.38843], [-0.002506, 6.2925], [-0.110307, 6.16693], [-0.278327, 5.89785], [-0.312266, 5.80452], [-0.319942, 5.74076], [-0.35978, 5.72804], [-0.398773, 5.69411], [-0.431113, 5.64921], [-0.443073, 5.60508], [-0.45317, 5.54563], [-0.477762, 5.51429], [-0.504966, 5.48196], [-0.527025, 5.4379], [-0.511683, 5.32413], [-0.544022, 5.28008], [-0.630518, 5.10523], [-0.652506, 5.02118], [-0.721317, 4.96517], [-0.751047, 4.87851], [-0.807895, 4.81922], [-0.849502, 4.76313], [-0.835106, 4.67916], [-0.94535, 4.70123], [-1.03193, 4.67664], [-1.10318, 4.62476], [-1.16685, 4.55856], [-1.18724, 4.52125], [-1.20679, 4.47981], [-1.23643, 4.44755], [-1.33927, 4.41782], [-1.36462, 4.37621], [-1.38844, 4.28037], [-1.47747, 4.11993], [-1.51477, 4.03419], [-1.52674, 3.93321], [-1.55638, 3.87122], [-1.87389, 3.52162], [-1.92308, 3.43757], [-1.96721, 3.28479], [-2.11055, 3.03862], [-2.15224, 2.84946], [-2.18703, 2.75092], [-2.23874, 2.70864], [-2.2481, 2.65676], [-2.43313, 2.44284], [-2.47482, 2.40393], [-2.48998, 2.36148], [-2.49681, 2.20617], [-2.51727, 2.15951], [-2.59526, 2.09828], [-2.61312, 2.05583], [-2.62237, 2.00926], [-2.64705, 1.98728], [-2.68183, 1.97279], [-2.71915, 1.94559], [-2.76589, 1.90137], [-2.80741, 1.82768], [-2.89576, 1.58074], [-2.9601, 1.46267], [-3.00171, 1.34223], [-3.03396, 1.29978], [-3.14261, 1.19451], [-3.16223, 1.14945], [-3.18683, 1.04173], [-3.21142, 0.994987], [-3.30988, 0.906048], [-3.32504, 0.864443], [-3.42105, 0.738702], [-3.43797, 0.692212], [-3.47452, 0.558807], [-3.54409, 0.411083], [-3.62553, 0.283068], [-3.69434, 0.142925], [-3.72407, -0.047077], [-3.71634, -0.135425], [-3.67474, -0.317847], [-3.65948, -0.475761], [-3.62302, -0.539348], [-3.61029, -0.588533], [-3.62554, -0.628538], [-3.65703, -0.687068], [-3.61029, -0.73878], [-3.64002, -0.795629], [-3.57542, -0.918676], [-3.67902, -1.14784], [-3.62553, -1.18944], [-3.59589, -1.2046], [-3.60515, -1.24376], [-3.6476, -1.28781], [-3.68162, -1.37186], [-3.72138, -1.38205], [-3.74597, -1.40925], [-3.79785, -1.54426], [-3.80458, -1.58157], [-3.81731, -1.61121], [-3.84956, -1.65526], [-3.87677, -1.70958], [-3.8665, -1.75893], [-3.84714, -1.80812], [-3.83434, -1.86665], [-3.85397, -1.90666], [-3.89633, -1.91845], [-3.93532, -1.94052], [-3.94552, -2.0025], [-3.90315, -2.05169], [-3.83687, -2.10846], [-3.91452, -2.12525], [-3.92486, -2.16746], [-3.8021, -2.21718], [-3.78004, -2.24169], [-3.79537, -2.28599], [-3.84194, -2.30292], [-3.9014, -2.31052], [-3.94553, -2.3325], [-3.90902, -2.38984], [-3.81228, -2.42599], [-3.7487, -2.45311], [-3.7359, -2.49042], [-3.61032, -2.51249], [-3.51439, -2.52698], [-3.49737, -2.60598], [-3.53645, -2.69921], [-3.61031, -2.75101], [-3.55085, -2.813], [-3.52197, -2.86732], [-3.47455, -3.17194], [-3.46268, -3.20175], [-3.42108, -3.27805], [-3.36173, -3.36723], [-3.3667, -3.40353], [-3.39137, -3.45802], [-3.39137, -3.50468], [-3.37605, -3.57332], [-3.3048, -3.72879], [-3.22849, -3.84755], [-3.18689, -3.9332], [-3.16473, -4.02239], [-3.18175, -4.08606], [-3.21401, -4.15723], [-3.18942, -4.22848], [-3.1377, -4.29316], [-2.99756, -4.4237], [-2.91612, -4.51458], [-2.85675, -4.62575], [-2.84478, -4.76572], [-2.64282, -4.92119], [-2.55624, -4.90831], [-2.51219, -4.92877], [-2.47733, -4.95075], [-2.40355, -5.01441], [-2.33222, -5.06116], [-2.17691, -5.13485], [-2.10053, -5.19944], [-2.05126, -5.27328], [-2.00199, -5.30293], [-1.87641, -5.40147], [-1.84416, -5.44552], [-1.77804, -5.59577], [-1.69399, -5.70181], [-1.66687, -5.74611], [-1.35963, -6.53694], [-1.36899, -6.58351], [-1.4063, -6.638], [-1.41556, -6.68466], [-1.41556, -6.84915], [-1.42322, -6.93076], [-1.41556, -6.96992], [-1.33, -7.11073], [-1.34945, -7.21845], [-1.34692, -7.25315], [-1.28999, -7.29989], [-1.23921, -7.31522], [-1.20181, -7.27783], [-1.19675, -7.17685], [-1.07362, -7.20658], [-0.953101, -7.2609], [-0.849593, -7.33982], [-0.778259, -7.44248], [-0.775729, -7.35413], [-0.795186, -7.21416], [-0.797786, -7.08606], [-0.736641, -7.02913], [-0.685014, -6.99014], [-0.645009, -6.89851], [-0.620417, -6.78565], [-0.637343, -5.77062], [-0.612751, -5.52192], [-0.590692, -5.43534], [-0.443136, -5.1799], [-0.371802, -4.92362], [-0.341989, -4.73344], [-0.29036, -4.64283], [-0.16723, -4.48735], [-0.128151, -4.41105], [-0.046711, -4.20395], [-0.014539, -4.16235], [0.027066, -4.14297], [0.191803, -3.96039], [0.441265, -3.79565], [0.515127, -3.72608], [0.588904, -3.63285], [0.62032, -3.58105], [0.640788, -3.5317], [0.643228, -3.48757], [0.633124, -3.39173], [0.640794, -3.35189], [0.689979, -3.29336], [0.9039, -3.11338], [0.923353, -3.07093], [1.08363, -2.84522], [1.11605, -2.75342], [1.16262, -2.55407], [1.23396, -2.42344], [1.26116, -2.33518], [1.27809, -2.30031], [1.31035, -2.26637], [1.38421, -2.21213], [1.41638, -2.17987], [1.49024, -2.02701], [1.50464, -1.87935], [1.50212, -1.72405], [1.52671, -1.54937], [1.55897, -1.45589], [1.59897, -1.37942], [1.70669, -1.23616], [1.74147, -1.16044], [1.98243, 0.226167], [2.05637, 0.376416], [2.18195, 0.989965], [2.27788, 1.25316], [2.32959, 1.50186], [2.33469, 1.60107], [2.34741, 1.65447], [2.40173, 1.74366], [2.42118, 1.79798], [2.38391, 1.88363], [2.36176, 1.9185], [2.33473, 1.99994], [2.33213, 2.07136], [2.3542, 2.13747], [2.46798, 2.30473], [2.51203, 2.49221], [2.55625, 2.58553], [2.59356, 2.62284], [2.71147, 2.72138], [2.69968, 2.75364], [2.72175, 2.78497], [2.793, 2.8419], [2.89145, 2.97513], [2.98064, 3.06078], [2.97805, 3.26778], [2.98485, 3.3638], [2.99757, 3.41297], [3.01702, 3.44775], [3.03412, 3.48936], [3.02732, 3.59547], [3.03152, 3.64474], [3.14008, 3.76771], [3.23348, 3.82464], [3.27332, 3.8611], [3.26572, 3.90356], [3.23852, 3.94517], [3.22673, 3.98929], [3.23343, 4.02904], [3.32515, 4.08085], [3.33955, 4.16659], [3.31748, 4.26758], [3.2784, 4.34405], [3.3056, 4.3635], [3.37526, 4.38649], [3.39869, 4.42513], [3.32514, 4.42541], [3.22669, 4.4874], [3.17237, 4.58324], [3.16977, 4.70636], [3.19192, 4.7675], [3.19432, 4.8294], [3.14261, 5.06624], [3.14001, 5.17909], [3.14781, 5.29709], [3.1724, 5.41583], [3.20634, 5.51943], [3.25384, 5.59329], [3.54153, 5.94036], [3.62558, 6.01431], [3.94553, 6.17215], [3.91327, 6.21106]] / 15 * h)
    dt == 0 ? tw : [for(i = [0 : len(tw) - 1]) if(norm(tw[i] - tw[i + 1]) >  dt) tw[i]]; 


function __in_line(line_pts, pt, epsilon = 0.0001) =
    let(
        v1 = line_pts[0] - pt, 
        v2 = line_pts[1] - pt
    )
    (abs(cross(v1, v2)) < epsilon) && ((v1 * v2) <= epsilon);

function __lines_from(pts, closed = false) = 
    let(leng = len(pts))
    concat(
        [for(i = [0:leng - 2]) [pts[i], pts[i + 1]]], 
        closed ? [[pts[len(pts) - 1], pts[0]]] : []
    );
    

function __is_float(value) = value + 0 != undef;

function __to3d(p) = [p[0], p[1], 0];

function _midpt_smooth_sub(points, iend, i, closed = false) = 
    i == iend ? (
        closed ? [(points[i] + points[0]) / 2]
        : []
    ) : concat([(points[i] + points[i + 1]) / 2], _midpt_smooth_sub(points, iend, i + 1, closed)); 

function midpt_smooth(points, n, closed = false) =
    let(
        smoothed = _midpt_smooth_sub(points, len(points) - 1, 0, closed)
    )
    n == 1 ? smoothed : midpt_smooth(smoothed, n - 1, closed);

function __to_3_elems_ang_vect(a) =
     let(leng = len(a))
     leng == 3 ? a : (
         leng == 2 ? [a[0], a[1], 0] :  [a[0], 0, 0]
     );

function __to_ang_vect(a) = __is_float(a) ? [0, 0, a] : __to_3_elems_ang_vect(a);

/**
* rotate_p.scad
*
* @copyright Justin Lin, 2017
* @license https://opensource.org/licenses/lgpl-3.0.html
*
* @see https://openhome.cc/eGossip/OpenSCAD/lib-rotate_p.html
*
**/ 


function _q_rotate_p_3d(p, a, v) = 
    let(
        half_a = a / 2,
        axis = v / norm(v),
        s = sin(half_a),
        x = s * axis[0],
        y = s * axis[1],
        z = s * axis[2],
        w = cos(half_a),
        
        x2 = x + x,
        y2 = y + y,
        z2 = z + z,

        xx = x * x2,
        yx = y * x2,
        yy = y * y2,
        zx = z * x2,
        zy = z * y2,
        zz = z * z2,
        wx = w * x2,
        wy = w * y2,
        wz = w * z2        
    )
    [
        [1 - yy - zz, yx - wz, zx + wy] * p,
        [yx + wz, 1 - xx - zz, zy - wx] * p,
        [zx - wy, zy + wx, 1 - xx - yy] * p
    ];

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

function _rotate_p(p, a) =
    let(angle = __to_ang_vect(a))
    len(p) == 3 ? 
        _rotate_p_3d(p, angle) :
        __to2d(
            _rotate_p_3d(__to3d(p), angle)
        );


function _q_rotate_p(p, a, v) =
    len(p) == 3 ? 
        _q_rotate_p_3d(p, a, v) :
        __to2d(
            _q_rotate_p_3d(__to3d(p), a, v)
        );

function rotate_p(point, a, v) =
    v == undef ? _rotate_p(point, a) : _q_rotate_p(point, a, v);


/**
* bezier_curve.scad
*
* @copyright Justin Lin, 2017
* @license https://opensource.org/licenses/lgpl-3.0.html
*
* @see https://openhome.cc/eGossip/OpenSCAD/lib-bezier_curve.html
*
**/ 


function _combi(n, k) =
    let(  
        bi_coef = [      
               [1],     // n = 0: for padding
              [1,1],    // n = 1: for Linear curves, how about drawing a line directly?
             [1,2,1],   // n = 2: for Quadratic curves
            [1,3,3,1]   // n = 3: for Cubic Bézier curves
        ]  
    )
    n < len(bi_coef) ? bi_coef[n][k] : (
        k == 0 ? 1 : (_combi(n, k - 1) * (n - k + 1) / k)
    );
        
function bezier_curve_coordinate(t, pn, n, i = 0) = 
    i == n + 1 ? 0 : 
        (_combi(n, i) * pn[i] * pow(1 - t, n - i) * pow(t, i) + 
            bezier_curve_coordinate(t, pn, n, i + 1));
        
function _bezier_curve_point(t, points) = 
    let(n = len(points) - 1) 
    [
        bezier_curve_coordinate(
            t, 
            [for(p = points) p[0]], 
            n
        ),
        bezier_curve_coordinate(
            t,  
            [for(p = points) p[1]], 
            n
        ),
        bezier_curve_coordinate(
            t, 
            [for(p = points) p[2]], 
            n
        )
    ];

function bezier_curve(t_step, points) = 
    let(
        pts = concat([
            for(t = [0: ceil(1 / t_step) - 1])
                _bezier_curve_point(t * t_step, points)
        ], [_bezier_curve_point(1, points)])
    ) 
    len(points[0]) == 3 ? pts : [for(pt = pts) __to2d(pt)];


function __reverse(vt) = 
    let(leng = len(vt))
    [
        for(i = [0:leng - 1])
            vt[leng - 1 - i]
    ];

