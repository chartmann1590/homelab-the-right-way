// ============================================================
//  Looki L1 hoodie-collar mount  v4 (bumps raised to the real widest edge, wall +3 mm)
//  was: Looki L1 hoodie-collar mount  v3  (parametric, OpenSCAD)
//  v3 (Oct 19 2026): v2 was ROTATED 90 deg from the real device. Fixed.
//  Real size settled from three sources: looki.ai spec "50.53x16.84x48.02mm",
//  the official Go Clip (50.3 mm across the device's width) and FCC ID 2BPT4-LNMBB001
//  External Photos Fig 3 (device on a ruler). With "Own Your Story" upright the Looki is
//  WIDER than tall: 50.53 side to side (long axis, X), 48.02 ear tip to ear tip (short
//  axis, Y), 16.84 thick. Ears at the four corners, pointing up/down.
//  - outline re-traced from the FCC Fig 3 silhouette (4-fold symmetrised), scaled to 50.53 x 48.02
//  - 1.0 mm clearance all round, +0.6 mm extra room at the four corner ears
//  - 4 small ramped bumps (0.5 mm over the rim): right side, top-left ear slope, 2 on the bottom edge
//  Same clip, same screw positions relative to the cradle top (15 mm off centre, 12 mm below the top).
//  PART = "cradle" | "clip" | "ring" (8 mm fit-test ring) | "assembly" | "cradle_proxy"
// ============================================================

// ---------- 1. LOOKI SIZE (spec + FCC photo; the shape below is scaled to these) ----------
dev_w   = 50.53;  // side to side across the smooth button sides  (LONG axis, X)
dev_h   = 48.02;  // top ear tips to bottom ear tips              (SHORT axis, Y)
dev_t   = 16.84;  // thickness (spec)
clr     = 1.0;    // clearance all round the pocket
ear_extra = 0.6;  // extra room around each corner ear

// ---------- 2. HOODIE (clip, unchanged from v1) ----------
collar_t = 12;  squeeze = 3;  tilt = 0;

// ---------- 3. PRINT / STRENGTH ----------
wall    = 2.5;    // pocket wall thickness (ABS-friendly)
floor_t = 3.0;    // back plate
bump_ov = 0.8;    // v4: deeper grab
clip_w  = 40;  clip_len = 26;  arm_t = 5.0;  armb_t = 3.0;  bight_t = 3.0;  tooth_h = 0.8;
magnet  = true;  screws = true;
ring_h  = 8;      // fit-test ring height
ring_wall = 1.2;

PART = "assembly";
$fn = 48;

// ---------- derived ----------
sx = dev_w/50.53;  sy = dev_h/48.02;  sz = dev_t/16.84;
rim_z   = 9.7*sz;                 // v4: widest edge measured on the real device ~ at the v3 wall top (Charles's photo Oct 19)
bump_z  = rim_z + 0.6;            // bump peak, just above the widest edge
wall_h  = rim_z + 2.8;            // wall height above the floor
y_top   = dev_h/2 + clr + ear_extra + wall;   // cradle top edge at the ear corners
scr_x   = 15;  scr_s = 12;
win_w   = 19;  win_h = 10;
mag_y   = dev_h/2 - 14;
BUMPS   = [ [25.26,0.00,180.0],[-16.90,21.98,-121.9],[-7.50,-19.43,77.6],[7.50,-19.43,102.4] ];   // [x, y, inward-normal angle] on the device outline (v3: right side, top-left ear slope, bottom x2)

module outline() scale([sx,sy]) polygon([ [25.27,-0.00],[25.26,0.44],[25.22,0.89],[25.18,1.33],[25.11,1.77],[25.08,2.21],[25.00,2.64],[24.95,3.08],[24.87,3.52],[24.79,3.95],[24.66,4.37],[24.54,4.80],[24.41,5.22],[24.30,5.65],[24.18,6.07],[24.07,6.49],[23.95,6.91],[23.81,7.33],[23.66,7.74],[23.52,8.15],[23.38,8.56],[23.24,8.98],[23.10,9.40],[22.99,9.82],[22.87,10.25],[22.74,10.68],[22.60,11.10],[22.46,11.52],[22.32,11.95],[22.24,12.41],[22.18,12.89],[22.16,13.40],[22.16,13.94],[22.22,14.53],[22.32,15.16],[22.46,15.84],[22.63,16.56],[22.85,17.34],[23.13,18.20],[23.41,19.10],[23.63,19.97],[23.73,20.77],[23.69,21.48],[23.54,22.09],[23.27,22.62],[22.95,23.10],[22.55,23.50],[22.08,23.83],[21.47,23.99],[20.75,24.01],[19.85,23.79],[18.80,23.35],[17.57,22.61],[16.27,21.70],[15.06,20.83],[14.04,20.17],[13.25,19.75],[12.55,19.44],[11.93,19.21],[11.36,19.02],[10.87,18.95],[10.43,18.93],[10.01,18.95],[9.62,19.00],[9.23,19.05],[8.86,19.13],[8.49,19.19],[8.13,19.28],[7.77,19.37],[7.42,19.44],[7.06,19.53],[6.71,19.62],[6.36,19.69],[5.99,19.73],[5.63,19.76],[5.27,19.80],[4.92,19.84],[4.56,19.88],[4.21,19.91],[3.85,19.95],[3.50,20.00],[3.15,20.04],[2.80,20.06],[2.45,20.06],[2.10,20.08],[1.75,20.10],[1.40,20.13],[1.05,20.15],[0.70,20.18],[0.35,20.19],[-0.00,20.19],[-0.35,20.19],[-0.70,20.18],[-1.05,20.15],[-1.40,20.13],[-1.75,20.10],[-2.10,20.08],[-2.45,20.06],[-2.80,20.06],[-3.15,20.04],[-3.50,20.00],[-3.85,19.95],[-4.21,19.91],[-4.56,19.88],[-4.92,19.84],[-5.27,19.80],[-5.63,19.76],[-5.99,19.73],[-6.36,19.69],[-6.71,19.62],[-7.06,19.53],[-7.42,19.44],[-7.77,19.37],[-8.13,19.28],[-8.49,19.19],[-8.86,19.13],[-9.23,19.05],[-9.62,19.00],[-10.01,18.95],[-10.43,18.93],[-10.87,18.95],[-11.36,19.02],[-11.93,19.21],[-12.55,19.44],[-13.25,19.75],[-14.04,20.17],[-15.06,20.83],[-16.27,21.70],[-17.57,22.61],[-18.80,23.35],[-19.85,23.79],[-20.75,24.01],[-21.47,23.99],[-22.08,23.83],[-22.55,23.50],[-22.95,23.10],[-23.27,22.62],[-23.54,22.09],[-23.69,21.48],[-23.73,20.77],[-23.63,19.97],[-23.41,19.10],[-23.13,18.20],[-22.85,17.34],[-22.63,16.56],[-22.46,15.84],[-22.32,15.16],[-22.22,14.53],[-22.16,13.94],[-22.16,13.40],[-22.18,12.89],[-22.24,12.41],[-22.32,11.95],[-22.46,11.52],[-22.60,11.10],[-22.74,10.68],[-22.87,10.25],[-22.99,9.82],[-23.10,9.40],[-23.24,8.98],[-23.38,8.56],[-23.52,8.15],[-23.66,7.74],[-23.81,7.33],[-23.95,6.91],[-24.07,6.49],[-24.18,6.07],[-24.30,5.65],[-24.41,5.22],[-24.54,4.80],[-24.66,4.37],[-24.79,3.95],[-24.87,3.52],[-24.95,3.08],[-25.00,2.64],[-25.08,2.21],[-25.11,1.77],[-25.18,1.33],[-25.22,0.89],[-25.26,0.44],[-25.27,0.00],[-25.26,-0.44],[-25.22,-0.89],[-25.18,-1.33],[-25.11,-1.77],[-25.08,-2.21],[-25.00,-2.64],[-24.95,-3.08],[-24.87,-3.52],[-24.79,-3.95],[-24.66,-4.37],[-24.54,-4.80],[-24.41,-5.22],[-24.30,-5.65],[-24.18,-6.07],[-24.07,-6.49],[-23.95,-6.91],[-23.81,-7.33],[-23.66,-7.74],[-23.52,-8.15],[-23.38,-8.56],[-23.24,-8.98],[-23.10,-9.40],[-22.99,-9.82],[-22.87,-10.25],[-22.74,-10.68],[-22.60,-11.10],[-22.46,-11.52],[-22.32,-11.95],[-22.24,-12.41],[-22.18,-12.89],[-22.16,-13.40],[-22.16,-13.94],[-22.22,-14.53],[-22.32,-15.16],[-22.46,-15.84],[-22.63,-16.56],[-22.85,-17.34],[-23.13,-18.20],[-23.41,-19.10],[-23.63,-19.97],[-23.73,-20.77],[-23.69,-21.48],[-23.54,-22.09],[-23.27,-22.62],[-22.95,-23.10],[-22.55,-23.50],[-22.08,-23.83],[-21.47,-23.99],[-20.75,-24.01],[-19.85,-23.79],[-18.80,-23.35],[-17.57,-22.61],[-16.27,-21.70],[-15.06,-20.83],[-14.04,-20.17],[-13.25,-19.75],[-12.55,-19.44],[-11.93,-19.21],[-11.36,-19.02],[-10.87,-18.95],[-10.43,-18.93],[-10.01,-18.95],[-9.62,-19.00],[-9.23,-19.05],[-8.86,-19.13],[-8.49,-19.19],[-8.13,-19.28],[-7.77,-19.37],[-7.42,-19.44],[-7.06,-19.53],[-6.71,-19.62],[-6.36,-19.69],[-5.99,-19.73],[-5.63,-19.76],[-5.27,-19.80],[-4.92,-19.84],[-4.56,-19.88],[-4.21,-19.91],[-3.85,-19.95],[-3.50,-20.00],[-3.15,-20.04],[-2.80,-20.06],[-2.45,-20.06],[-2.10,-20.08],[-1.75,-20.10],[-1.40,-20.13],[-1.05,-20.15],[-0.70,-20.18],[-0.35,-20.19],[0.00,-20.19],[0.35,-20.19],[0.70,-20.18],[1.05,-20.15],[1.40,-20.13],[1.75,-20.10],[2.10,-20.08],[2.45,-20.06],[2.80,-20.06],[3.15,-20.04],[3.50,-20.00],[3.85,-19.95],[4.21,-19.91],[4.56,-19.88],[4.92,-19.84],[5.27,-19.80],[5.63,-19.76],[5.99,-19.73],[6.36,-19.69],[6.71,-19.62],[7.06,-19.53],[7.42,-19.44],[7.77,-19.37],[8.13,-19.28],[8.49,-19.19],[8.86,-19.13],[9.23,-19.05],[9.62,-19.00],[10.01,-18.95],[10.43,-18.93],[10.87,-18.95],[11.36,-19.02],[11.93,-19.21],[12.55,-19.44],[13.25,-19.75],[14.04,-20.17],[15.06,-20.83],[16.27,-21.70],[17.57,-22.61],[18.80,-23.35],[19.85,-23.79],[20.75,-24.01],[21.47,-23.99],[22.08,-23.83],[22.55,-23.50],[22.95,-23.10],[23.27,-22.62],[23.54,-22.09],[23.69,-21.48],[23.73,-20.77],[23.63,-19.97],[23.41,-19.10],[23.13,-18.20],[22.85,-17.34],[22.63,-16.56],[22.46,-15.84],[22.32,-15.16],[22.22,-14.53],[22.16,-13.94],[22.16,-13.40],[22.18,-12.89],[22.24,-12.41],[22.32,-11.95],[22.46,-11.52],[22.60,-11.10],[22.74,-10.68],[22.87,-10.25],[22.99,-9.82],[23.10,-9.40],[23.24,-8.98],[23.38,-8.56],[23.52,-8.15],[23.66,-7.74],[23.81,-7.33],[23.95,-6.91],[24.07,-6.49],[24.18,-6.07],[24.30,-5.65],[24.41,-5.22],[24.54,-4.80],[24.66,-4.37],[24.79,-3.95],[24.87,-3.52],[24.95,-3.08],[25.00,-2.64],[25.08,-2.21],[25.11,-1.77],[25.18,-1.33],[25.22,-0.89],[25.26,-0.44] ]);   // FCC Fig 3 silhouette, 50.53 x 48.02

module ears() intersection(){ outline(); for (i=[-1,1], j=[-1,1]) translate([i*(12.5*sx+20), j*(15.5*sy+20)]) square(40, center=true); }

module pocket2d(extra=0) union(){ offset(r=clr+extra) outline(); offset(r=clr+ear_extra+extra) ears(); }

module bump(z0){   // one ramped bump, local frame: x along wall, y inward, origin on the device edge
    p = clr + bump_ov;
    hull(){
        translate([-3.5, -clr-0.8, z0+bump_z-p]) cube([7, 0.81, p + 0.4 + 1.5*p]);   // root, buried in the wall
        translate([-2, bump_ov-0.01, z0+bump_z]) cube([4, 0.01, 0.4]);               // crest
    }
}
module bumps(z0) for (b=BUMPS) translate([b[0]*sx, b[1]*sy, 0]) rotate([0,0,b[2]-90]) bump(z0);

module cradle(){
    difference(){
        union(){
            linear_extrude(floor_t) pocket2d(wall);
            translate([0,0,floor_t]) linear_extrude(wall_h) difference(){ pocket2d(wall); pocket2d(0); }
            intersection(){ bumps(floor_t); translate([0,0,floor_t]) linear_extrude(wall_h) pocket2d(wall); }
        }
        // open top centre: lens view + lets the top flex
        translate([-12*sx, dev_h/2-7.2*sy, floor_t+0.01]) cube([24*sx, 20, 50]);
        // side buttons (on the LEFT as you look at the lens)
        translate([-dev_w/2-20, -13*sy, floor_t+0.01]) cube([20+4*sx, 26*sy, 50]);
        // back window over the charging pins (also the push-out hole)
        translate([0,0,-1]) linear_extrude(floor_t+2) offset(r=3) square([win_w-6, win_h-6], center=true);
        if (magnet) translate([0, mag_y, floor_t-1.5]) cylinder(d=8.5, h=2);
        if (screws) for (s=[-1,1]) translate([s*scr_x, y_top - scr_s, 0]) {
            translate([0,0,-1]) cylinder(d=3.4, h=floor_t+2);
            translate([0,0,floor_t-1.8]) cylinder(d1=3.4, d2=6.6, h=1.81);
        }
    }
}

// fit-test ring: the pocket outline + the same bumps, 8 mm tall (reaches past the widest rim), no floor (Looki back sits on the table)
module ring(){
    difference(){
        union(){
            linear_extrude(ring_h) difference(){ pocket2d(ring_wall); pocket2d(0); }
            intersection(){ bumps(0); linear_extrude(ring_h) pocket2d(ring_wall); }
        }
        translate([-dev_w/2-20, -13*sy, -1]) cube([20+4*sx, 26*sy, 50]);   // same button gap as the cradle
    }
    // 1.2 mm flange around the outside (kept across the button gap) so the open ring stays stiff and flat
    linear_extrude(1.2) difference(){ pocket2d(ring_wall+2.5); pocket2d(0.6); }
}

// ---------- clip (identical to v1) ----------
G0 = collar_t;  G1 = collar_t - squeeze;  ld = 4;  F = 2.5;
tt = tan(tilt);
zf = -(arm_t + clip_len*tt);
function inner_b(y) = (y > -(clip_len-ld)) ?
        zf - (G0 + (G1-G0)*(-y-bight_t)/(clip_len-ld-bight_t)) :
        zf - G1 - F*(-y-(clip_len-ld))/ld;
module clip_profile(){
    yb = -clip_len;
    pts = concat(
        [[0,0], [clip_len*tt, yb], [-zf, yb], [-zf, -bight_t]],
        [for (y=[-bight_t:-1:yb]) [-inner_b(y), y]],
        [for (y=[yb:1:-bight_t]) [-inner_b(y)+armb_t, y]],
        [[-inner_b(-bight_t)+armb_t, 0]]
    );
    offset(r=-1.5) offset(delta=1.5) polygon(pts);
    for (y0=[-(bight_t+3) : -3 : -(clip_len-ld-1)]) {
        polygon([[-zf-0.4, y0], [-zf+tooth_h, y0], [-zf-0.4, y0-1.8]]);
        zb = inner_b(y0);
        polygon([[-zb+0.4, y0], [-zb-tooth_h, y0], [-inner_b(y0-1.8)+0.4, y0-1.8]]);
    }
}
module clip(){
    win_top = 26.9 - win_h/2;     // v1 value kept so the clip is byte-identical to v1
    difference(){
        rotate([0,90,0]) linear_extrude(clip_w, center=true) clip_profile();
        if (clip_len > win_top - 1) {
            a = win_w/2 + 1;  T = win_top - 1;  e = clip_len + 1 - T;
            translate([0,0,zf-tooth_h-0.5]) linear_extrude(-zf+tooth_h+2)
                polygon([[-a,-T],[a,-T],[a+e,-clip_len-1],[-a-e,-clip_len-1]]);
        }
        if (screws) for (s=[-1,1]) translate([s*scr_x, -scr_s*cos(tilt), -scr_s*sin(tilt)]) rotate([tilt,0,0]) {
            thick_n = (arm_t + clip_len*tt - scr_s*sin(tilt)) * cos(tilt);
            translate([0,0,-thick_n-1.5]) cylinder(d=3.4, h=thick_n+2.5);
            translate([0,0,-thick_n-1.5]) rotate([0,0,30]) cylinder(d=6.6, h=1.5+2.6, $fn=6);
        }
    }
}

// device ghost at the spec size 50.53 x 48.02 x 16.84 (ears at the corners)
module looki_proxy(){
    // stepped body: smaller back face, full outline at the widest rim, front shell stepping in to the lens disc
    color([0.55,0.75,1.0,0.55]) translate([0,0,floor_t]) {
        linear_extrude(2) offset(delta=-1.5) outline();
        translate([0,0,2]) linear_extrude(rim_z-1.5) outline();
        for (i=[0:5]) translate([0,0,rim_z+0.5+i*(dev_t-rim_z-1.1)/6]) linear_extrude((dev_t-rim_z-1.1)/6+0.01) offset(delta=-0.6-i*0.9) outline();
    }
    color([0.1,0.1,0.1]) translate([0,0,floor_t+dev_t-0.6]) cylinder(d=36*sx, h=0.6);
    color([0.3,0.3,0.35]) translate([0, 9*sy, floor_t+dev_t-0.1]) cylinder(r=3.5, h=0.4);
}

module assembly(){
    rotate([tilt,0,0]) translate([0,-y_top,0]) { color("orange") cradle(); looki_proxy(); }
    color("deepskyblue") clip();
}

if (PART=="cradle") cradle();
else if (PART=="clip") translate([0,0,clip_w/2]) rotate([0,-90,0]) clip();
else if (PART=="ring") ring();
else if (PART=="proxy") looki_proxy();
else if (PART=="cradle_proxy") { color("orange") cradle(); looki_proxy(); }
else if (PART=="assembly") assembly();

echo(str("v3 cradle: outer ", dev_w+2*(clr+wall), " x ", dev_h+2*(clr+ear_extra+wall), " (ears), wall top ", floor_t+wall_h, " mm; pocket opening ", dev_w+2*clr, " x ", dev_h+2*(clr+ear_extra), " (at the ears), depth ", wall_h, " above the floor"));
