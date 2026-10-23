// HC-SR501 PIR case with tank-lip clip  (Charles Hartmann, Oct 22 2026)
// Units mm. Origin: PCB centre, PCB front (lens side) face at y=0. +Y = back, +Z = up.
// The dome faces -Y. The U-clip under the floor straddles the tank lip (lip runs along X).
part = "assembled";   // assembled | section | body | lid | print_body | print_lid
$fn = 64;
eps = 0.01;

// ---- HC-SR501 (datasheet: 32 x 24 mm PCB, M2 holes 28 mm pitch, lens dia 23 x 15 mm tall) ----
pcb_w = 32.5;  pcb_h = 24;  pcb_t = 1.6;
lens_d = 23;   lens_hgt = 15;     // dome height above the PCB front face
lens_base = 3.5;                  // square lens frame thickness in front of the PCB
hdr_z = pcb_h/2 - 1.6;            // 3-pin header centre: on the top edge (board slid in header-up)
pot_x = [1.7, -6.6];  pot_z = -pcb_h/2 + 3.2;   // trim pots (seen from the front)

// ---- case ----
clr      = 0.35;       // PCB side clearance
wall     = 2.2;        // side + back walls
front_t  = 2.0;        // front wall
floor_t  = 2.5;
front_gap= 4.5;        // PCB front face -> front wall inner face (lens frame room)
back_clr = 10.5;       // PCB back face -> back wall inner face (pots/caps/header room)
top_z    = 15.5;       // wall top (lid sits on it)
lid_t    = 2.0;
hole_d   = 24.2;       // dome opening
ix  = pcb_w/2 + clr;               // inner half-width 16.6
zf  = -pcb_h/2;                    // floor inner face (PCB stands on it)
yfi = -front_gap;  yfo = yfi - front_t;
ybi = pcb_t + back_clr;  ybo = ybi + wall;
ox  = ix + wall;                   // outer half-width
zb  = zf - floor_t;                // floor underside = top of the clip gap

// openings in the back wall
hdr_slot_w = 11;  hdr_slot_z0 = 6;           // U-slot for header + 3 Dupont plugs, open to the top
pot_win_w = 22;   pot_win_h = 6;  pot_win_z = -8.5;   // screwdriver window over both pots

// ---- clip ----
gap     = 11.5;        // jaw face to jaw face at the root (a little under 1/2 in)
jaw_t   = 3.5;
jaw_len = 19.05;       // 0.75 in below the floor
tooth_h = 0.9;         // each sawtooth sticks out this far -> 9.7 mm between tooth tips
tooth_p = 2.4;         // pitch
lead    = 1.2;         // lead-in chamfer at the tips
fil_in  = 0.8;
yc = (yfo + ybo)/2;    // clip centred under the case

module box_shell() {
  difference() {
    translate([-ox, yfo, zb]) cube([2*ox, ybo-yfo, top_z-zb]);
    // cavity
    translate([-ix, yfi, zf]) cube([2*ix, ybi-yfi, 50]);
    // dome opening: circle + slot up to the top, so the PCB slides in from the top with its dome on.
    // The lid's front tongue closes the slot above the dome.
    translate([0, yfi+1, 0]) rotate([90,0,0]) linear_extrude(front_t+2) {
      circle(d=hole_d); translate([-hole_d/2, 0]) square([hole_d, 40]);
    }
    // outer chamfer so the wall never shades the dome's side view
    translate([0, yfo-eps, 0]) rotate([-90,0,0]) cylinder(d1=hole_d+3.2, d2=hole_d, h=1.6);
    // header U-slot
    translate([-hdr_slot_w/2, ybi-1, hdr_slot_z0]) cube([hdr_slot_w, wall+2, 50]);
    // pot window
    hull() for (s=[-1,1]) translate([s*(pot_win_w-pot_win_h)/2, ybi-1, pot_win_z]) rotate([-90,0,0]) cylinder(d=pot_win_h, h=wall+2);
    // snap grooves for the lid
    for (s=[-1,1]) translate([s*ix, 3.5, top_z-2.0]) rotate([-90,0,0]) cylinder(r=0.55, h=8.5, $fn=24);
  }
  // PCB guide ribs: slot y = -0.2 .. 1.8 (2.0 wide for a 1.6 board)
  for (s=[-1,1]) {
    translate([s>0 ? ix-1.6 : -ix, -1.6, zf-eps]) cube([1.6, 1.4, top_z-3-zf]);
    translate([s>0 ? ix-1.0 : -ix,  1.8, 0])      cube([1.0, 1.2, top_z-3]);
  }
}

module jaw2d() {  // the -Y jaw in (y,z); inner face at yi, teeth point +Y
  yi = yc - gap/2;  yo = yi - jaw_t;  z0 = zb;  zt = zb - jaw_len;
  n = floor((jaw_len - 1.0 - lead - 0.3) / tooth_p);
  teeth = [ for (i=[0:n-1]) let(zs = z0 - 1.0 - i*tooth_p)
              each [ [yi, zs], [yi+tooth_h, zs-tooth_h], [yi, zs-tooth_p] ] ];
  polygon(concat(
    [[yo-1.15, z0+eps], [yi+fil_in, z0+eps], [yi, z0-fil_in]],
    teeth,
    [[yi, zt+lead], [yi-lead, zt], [yo, zt], [yo, z0-1.15]]
  ));
}
module clip() {
  for (m=[0,1]) translate([0, yc, 0]) mirror([0, m, 0]) translate([0, -yc, 0])
    translate([-ox, 0, 0]) rotate([90,0,90]) linear_extrude(2*ox) jaw2d();
}
module body() { box_shell(); clip(); }

module lid() {
  translate([-ox, yfo, top_z]) cube([2*ox, ybo-yfo, lid_t]);
  // front tongue: fills the dome slot down to the dome, with the same outer chamfer
  difference() {
    translate([-(hole_d/2-0.15), yfo, 0]) cube([hole_d-0.3, front_t, top_z+eps]);
    translate([0, yfi+1, 0]) rotate([90,0,0]) cylinder(d=hole_d+0.3, h=front_t+2);
    translate([0, yfo-eps, 0]) rotate([-90,0,0]) cylinder(d1=hole_d+3.2, d2=hole_d, h=1.6);
  }
  for (s=[-1,1]) {
    // snap legs inside the side walls, with a 0.35 mm bump into the groove
    translate([s>0 ? ix-1.2 : -ix+0.2, 4, top_z-5+eps]) cube([1.0, 7, 5]);
    translate([s*(ix-0.2), 4, top_z-2.0]) rotate([-90,0,0]) cylinder(r=0.5, h=7, $fn=24);
    // hold-down tabs on the PCB top edge
    translate([s*10-1.5, 0.1, pcb_h/2+0.15]) cube([3, 1.4, top_z-pcb_h/2-0.15+eps]);
  }
}

// ---------- ghosts for the renders (not printed) ----------
module g_pcb() difference() {
    translate([-pcb_w/2, 0, -pcb_h/2]) cube([pcb_w, pcb_t, pcb_h]);
    for (s=[-1,1]) translate([s*14, -1, 0]) rotate([-90,0,0]) cylinder(d=2, h=4);
  }
module g_lens() {
    translate([-14.5, -lens_base, -pcb_h/2]) cube([29, lens_base, pcb_h]);
    translate([0, -lens_base, 0]) rotate([90,0,0]) cylinder(d=lens_d, h=lens_hgt-lens_base-lens_d/2+0.01);
    intersection() { translate([0, -(lens_hgt-lens_d/2), 0]) sphere(d=lens_d); translate([-20, -40, -20]) cube([40, 40-(lens_hgt-lens_d/2), 40]); }
}
module g_pots() for (x=pot_x) translate([x-3.25, pcb_t, pot_z-3.25]) cube([6.5, 4.8, 6.5]);
module g_potslot() for (x=pot_x) translate([x-0.4, pcb_t+4.6, pot_z-2]) cube([0.8,0.4,4]);
module g_hdr() translate([-3.8, pcb_t, hdr_z-1.25]) cube([7.6, 2.5, 2.5]);
module g_pins() for (i=[-1:1]) translate([i*2.54-0.32, pcb_t, hdr_z-0.32]) cube([0.64, 8.5, 0.64]);
module g_jumper() translate([13.8-1.3, pcb_t, -7-2.5]) cube([2.6, 6, 5]);
module g_ic() { translate([-7, pcb_t, -4]) cube([6.5, 3.2, 10]);
                for (x=[-11,9]) translate([x, pcb_t+0.01, 2]) rotate([-90,0,0]) cylinder(d=5, h=8); }
module g_dupont() for (i=[-1:1]) translate([i*2.54-1.25, pcb_t+2.5, hdr_z-1.25]) cube([2.5, 14, 2.5]);
module g_wire(i) {
    hull() { translate([i*2.54, pcb_t+16.5, hdr_z]) rotate([-90,0,0]) cylinder(d=1.6, h=2, $fn=12);
             translate([i*2.54, pcb_t+24, hdr_z-3]) sphere(d=1.6, $fn=12); }
    hull() { translate([i*2.54, pcb_t+24, hdr_z-3]) sphere(d=1.6, $fn=12);
             translate([i*2.54, pcb_t+26, zb-30]) sphere(d=1.6, $fn=12); }
}
GC = [["pcb",[0.1,0.5,0.2]],["lens",[0.96,0.96,0.93]],["pots",[0.95,0.55,0.1]],["potslot",[0.3,0.3,0.3]],
      ["hdr",[0.1,0.1,0.1]],["pins",[0.85,0.7,0.2]],["jumper",[0.95,0.85,0.1]],["ic",[0.15,0.15,0.15]],
      ["dupont",[0.12,0.12,0.12]],["w-1",[0.1,0.1,0.1]],["w0",[0.9,0.8,0.1]],["w1",[0.8,0.1,0.1]]];
module g_by(n) {
  if (n=="pcb") g_pcb(); if (n=="lens") g_lens(); if (n=="pots") g_pots(); if (n=="potslot") g_potslot();
  if (n=="hdr") g_hdr(); if (n=="pins") g_pins(); if (n=="jumper") g_jumper(); if (n=="ic") g_ic();
  if (n=="dupont") g_dupont(); if (n=="w-1") g_wire(-1); if (n=="w0") g_wire(0); if (n=="w1") g_wire(1);
}
module ghost_pir(wires=true) {
  for (g = GC) if (wires || (g[0] != "dupont" && g[0][0] != "w")) color(g[1]) g_by(g[0]);
}
module ghost_lip(th=10) {
  color([0.55,0.75,0.95,0.55]) translate([-40, yc-th/2, zb-40]) cube([80, th, 40]);
}

if (part == "assembled") {
  color([0.42,0.47,0.55]) body();
  color([0.55,0.6,0.68]) lid();
  ghost_pir();
  ghost_lip();
}
if (part == "assembled_nolip") {
  color([0.42,0.47,0.55]) body();
  color([0.55,0.6,0.68]) lid();
  ghost_pir();
}
module cut(c) color(c) translate([-50,-60,-80]) cube([50+pot_x[0], 120, 160]);
if (part == "section") {
  intersection() { color([0.42,0.47,0.55]) body(); cut([0.45,0.48,0.52]); }
  intersection() { color([0.55,0.6,0.68]) lid();  cut([0.55,0.58,0.62]); }
  intersection() { ghost_pir(true); cut([0.85,0.85,0.8]); }
  intersection() { ghost_lip(10); cut([0.55,0.75,0.95]); }
}
if (part == "body") body();
if (part == "lid") lid();
if (part == "print_body") translate([0,0,jaw_len - zb]) body();            // upright: jaw tips on the bed
if (part == "print_lid") translate([0,0,top_z+lid_t]) rotate([180,0,0]) lid();  // top face on the bed
