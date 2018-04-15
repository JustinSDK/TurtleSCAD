t = "(f => (x => f(n => x(x)(n)))(x => f(n => x(x)(n))))(m => l => f => (_ => _)((l => l(_ => _ => (_ => f => f(_ => _))))(l))(_ => (_ => (f => _ => f(_ => _))))(_ => (h => t => (l => r => f => f(l)(r))(h)(t))(f((p => p(l => _ => l))(l)))(m((p => p(_ => r => r))(l))(f))))((e => (l => (f => (x => f(n => x(x)(n)))(x => f(n => x(x)(n))))(v => r => l => (_ => _)((l => l(_ => _ => (_ => f => f(_ => _))))(l))(_ => r)(_ => v((h => t => (l => r => f => f(l)(r))(h)(t))((p => p(l => _ => l))(l))(r))((p => p(_ => r => r))(l))))(_ => (f => _ => f(_ => _)))(l))(e(_ => _ => (f => _ => f(_ => _)))))((f => (x => f(n => x(x)(n)))(x => f(n => x(x)(n))))(r => t => h => (_ => _)((n => n(_ => (_ => f => f(_ => _)))(_ => f => f(_ => _)))(h))(_ => t)(_ => r((h => t => (l => r => f => f(l)(r))(h)(t))(h)(t))))(_ => (f => _ => f(_ => _)))(f => x => f(x))(f => x => f(f(x)))(f => x => f(f(f(x))))))(e => (m => n => n(n => (p => p(l => _ => l))(n(p => (l => r => f => f(l)(r))((p => p(_ => r => r))(p))((n => f => x => f(n(f)(x)))((p => p(_ => r => r))(p))))((l => r => f => f(l)(r))(_ => _)(_ => x => x))))(m))(e)(f => x => f(x)))";

module main() {
    points = archimedean_spiral(
        arm_distance = 15,
        init_angle = 450, 
        point_distance = 12, 
        num_of_points = len(t) 
    ); 
    linear_extrude(4) for(i = [0: len(points) - 1]) {
        translate(points[i][0])          
            rotate(points[i][1] + 90)  
                text(t[i], valign = "center", halign = "center");
    }

    linear_extrude(2) circle(280, $fn = 96);
    
}

main();
    
/**
 * The dotSCAD library
 * @copyright Justin Lin, 2017
 * @license https://opensource.org/licenses/lgpl-3.0.html
 *
 * @see https://github.com/JustinSDK/dotSCAD
*/

/**
* archimedean_spiral.scad
*
*  Gets all points and angles on the path of an archimedean spiral. The distance between two  points is almost constant. 
* 
*  It returns a vector of [[x, y], angle]. 
*
*  In polar coordinates (r, �c) Archimedean spiral can be described by the equation r = b�c where
*  �c is measured in radians. For being consistent with OpenSCAD, the function here use degrees.
*
*  An init_angle less than 180 degrees is not recommended because the function uses an approximate 
*  approach. If you really want an init_angle less than 180 degrees, a larger arm_distance 
*  is required. To avoid a small error value at the calculated distance between two points, you 
*  may try a smaller point_distance.
* 
* @copyright Justin Lin, 2017
* @license https://opensource.org/licenses/lgpl-3.0.html
*
* @see https://openhome.cc/eGossip/OpenSCAD/lib-archimedean_spiral.html
*
**/ 

function _radian_step(b, theta, l) =
    let(r_square = pow(b * theta, 2))
    acos((2 * r_square - pow(l, 2)) / (2 * r_square)) / 180 * 3.14159;

function _find_radians(b, point_distance, radians, n, count = 1) =
    let(pre_radians = radians[count - 1])
    count == n ? radians : (
        _find_radians(
            b, 
            point_distance, 
            concat(
                radians,
                [pre_radians + _radian_step(b, pre_radians, point_distance)]
            ), 
            n,
        count + 1) 
    );

function archimedean_spiral(arm_distance, init_angle, point_distance, num_of_points, rt_dir = "CT_CLK") =
    let(b = arm_distance / 6.28318, init_radian = init_angle *3.14159 / 180)
    [
        for(theta = _find_radians(b, point_distance, [init_radian], num_of_points)) 
           let(r = b * theta, a = (rt_dir == "CT_CLK" ? 1 : -1) * theta * 57.2958)
           [[r * cos(a), r * sin(a)], a]
    ];

