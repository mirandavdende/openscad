$fn = 100;
$fa = 1;
height = 40; // of the shape
radius = 11; // of the cylinder
thickness = 2.5; // of the walls
angle_1 = -15; // angle of the first cube
width = 41;
length = 70;

difference(){
union(){
difference(){
    union(){
        //cylinder(h = height, r = radius);
        rcylinder(r=radius,h=height,f=2);
        translate([(radius-50), 0, 0])
            roundedcube([50, 73-radius, height], false, 2, "y");
            // cube([50, 73-radius, height]);

    rotate([0, 0, angle_1])
        translate([-(56-radius), -radius, 0])
            roundedcube([(56-radius), 50, height], false, 2, "x");
            // cube([(56-radius), 50, height]);
}

#translate([radius+thickness, 71-radius, 0])
    rotate([0, 0, 180-43])
        translate([0, -10, 0])
            cube([50, 100, height]);
}
}


union(){
translate([-thickness, thickness, thickness])
difference(){
    union(){
        cylinder(h = height-(2*thickness), r = radius);
        translate([(radius-50), 0, 0])
            cube([50, 73-radius, height-(2*thickness)]);

    rotate([0, 0, angle_1])
        translate([-(56-radius), -radius, 0])
            cube([(56-radius), 50, height-(2*thickness)]);
}

translate([radius-thickness, 71-radius, 0])
    rotate([0, 0, 180-43])
        translate([0, -10, 0])
            cube([50, 100, height]);
}
}
}


module roundedcube(size = [1, 1, 1], center = false, radius = 0.5, apply_to = "all") {
	// If single value, convert to [x, y, z] vector
	size = (size[0] == undef) ? [size, size, size] : size;

	translate_min = radius;
	translate_xmax = size[0] - radius;
	translate_ymax = size[1] - radius;
	translate_zmax = size[2] - radius;

	diameter = radius * 2;

	obj_translate = (center == false) ?
		[0, 0, 0] : [
			-(size[0] / 2),
			-(size[1] / 2),
			-(size[2] / 2)
		];

	translate(v = obj_translate) {
		hull() {
			for (translate_x = [translate_min, translate_xmax]) {
				x_at = (translate_x == translate_min) ? "min" : "max";
				for (translate_y = [translate_min, translate_ymax]) {
					y_at = (translate_y == translate_min) ? "min" : "max";
					for (translate_z = [translate_min, translate_zmax]) {
						z_at = (translate_z == translate_min) ? "min" : "max";

						translate(v = [translate_x, translate_y, translate_z])
						if (
							(apply_to == "all") ||
							(apply_to == "xmin" && x_at == "min") || (apply_to == "xmax" && x_at == "max") ||
							(apply_to == "ymin" && y_at == "min") || (apply_to == "ymax" && y_at == "max") ||
							(apply_to == "zmin" && z_at == "min") || (apply_to == "zmax" && z_at == "max")
						) {
							sphere(r = radius);
						} else {
							rotate = 
								(apply_to == "xmin" || apply_to == "xmax" || apply_to == "x") ? [0, 90, 0] : (
								(apply_to == "ymin" || apply_to == "ymax" || apply_to == "y") ? [90, 90, 0] :
								[0, 0, 0]
							);
							rotate(a = rotate)
							cylinder(h = diameter, r = radius, center = true);
						}
					}
				}
			}
		}
	}
}

module rcylinder(r=1, r1=0, r2=0, h=1, f=0) {
	if(f==0) {
		if(r1==0) {
			cylinder(r=r,h=h);
		}
		else {
			cylinder(r1=r1,r2=r2,h=h);
		}
	}
	else {
		assign(
			v=acos(h/(sqrt( h*h + (r1-r2)*(r1-r2) )))
		) {
			assign(
				byo=sin(v)*f,
				bxo=cos(v)*f
			) {
				union() {
					translate([0,0,0])
						cylinder(r=(r1==0?r-f:r1-f),h=f*2);
					translate([0,0,h-2*f])
						cylinder(r=(r2==0?r-f:r2-f),h=f*2);
					translate([0,0,f+byo])
						cylinder(r1=(r1==0?r:r1-f+bxo),r2=(r2==0?r:r2-f+bxo),h=h-2*f);
					translate([0,0,h-f])
						rotate_extrude()
							translate([(r2==0?r-f:r2-f),0,0])
								circle(r=f);
					translate([0,0,f])
						rotate_extrude()
							translate([(r1==0?r-f:r1-f),0,0])
								circle(r=f);
				}
			}
		}
	}
}