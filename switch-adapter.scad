// ============================================================
// Rocker-to-Toggle Switch Adapter Plate
// ============================================================
// Fills a Gardner Bender GSW-41 rocker switch panel cutout and
// provides a mounting hole for a standard toggle switch.
//
// Rocker switch cutout (GSW-41): 0.550" x 1.125" (14mm x 28.58mm)
//
// HOW TO USE:
//   1. Measure your toggle switch bushing/thread outer diameter
//   2. Set `toggle_hole_dia` to that value (see notes below)
//   3. Measure your enclosure panel thickness; set `panel_thickness`
//   4. Print with PLA/PETG, 3+ perimeters, 30%+ infill, no supports
//   5. Press adapter into the cutout from the outside; the flange
//      sits flush on the panel surface. Secure with toggle switch
//      nut from the inside.
//
// PRINT ORIENTATION: flange face DOWN on the build plate.
// ============================================================

// ---------- KEY PARAMETERS (adjust these) ----------

// Outer diameter of your toggle switch bushing/threads (mm).
// Gardner Bender GSW-series toggle switches (GSW-18, GSW-124, etc.)
// require a 1/2" (12.7 mm) panel hole.
//
// Common values:
//   6.0  = mini toggle (small/inexpensive units)
//   6.35 = 1/4" standard toggle
//  12.0  = 15/32" medium toggle
//  12.7  = 1/2" full-size toggle (Gardner Bender GSW series default)
//
// ⚠ IMPORTANT — narrow-wall warning:
// The rocker cutout is only 14 mm wide. With a 12.7 mm hole the
// wall on each side is ~0.5 mm. This is thin but acceptable because
// the toggle's locking nut (tightened from inside the box) provides
// the retention force. Use 3+ perimeters and 100% infill, or print
// in PETG for extra toughness.
toggle_hole_dia = 12.7;

// Thickness of the panel the rocker switch was mounted in (mm).
// Measure with calipers. A typical ABS/polycarbonate project box
// wall is 2–4mm. Use 3.0 as a starting estimate.
panel_thickness = 3.0;

// ---------- ROCKER CUTOUT DIMENSIONS (GSW-41, do not change) ----------
rocker_w = 14.0;   // 0.550" = 13.97 mm
rocker_h = 28.6;   // 1.125" = 28.58 mm

// ---------- FIT & GEOMETRY PARAMETERS ----------

// Reduce plug body by this amount (each side) for press-fit clearance.
// 0.15 mm per side (0.3 mm total) works well on most FDM printers.
// Increase to 0.2 if it's too tight after printing.
fit_clearance = 0.15;

// How far the flange lip overhangs the cutout on each side (mm).
flange_overhang = 2.5;

// Thickness of the flange (the visible face plate).
flange_thickness = 2.5;

// Corner radius on the flange (cosmetic).
flange_corner_r  = 2.0;

// Extra plug depth beyond the panel so the fit has some grip
// before the toggle nut is tightened. 1 mm is plenty.
plug_extra_depth = 1.0;

// ---------- DERIVED DIMENSIONS (do not edit) ----------
plug_w     = rocker_w - fit_clearance * 2;
plug_h_dim = rocker_h - fit_clearance * 2;
plug_depth = panel_thickness + plug_extra_depth;

flange_w = rocker_w + flange_overhang * 2;
flange_h = rocker_h + flange_overhang * 2;

total_height = flange_thickness + plug_depth;

// ============================================================
// MODEL
// Print orientation: flange face on build plate (Z=0).
// Z increases upward through the plug.
// ============================================================
difference() {
    union() {
        // Flange — rests on panel exterior, centered at (0,0)
        rounded_rect(flange_w, flange_h, flange_thickness, flange_corner_r);

        // Plug body — inserts into the rocker cutout
        // Cube bottom starts at z=flange_thickness; center=true needs
        // the translate at the cube's center: flange_thickness + plug_depth/2
        translate([0, 0, flange_thickness + plug_depth / 2])
            cube([plug_w, plug_h_dim, plug_depth], center = true);
    }

    // Toggle switch mounting hole — centered, runs full height + margin
    translate([0, 0, total_height / 2])
        cylinder(h = total_height + 2, d = toggle_hole_dia,
                 center = true, $fn = 64);
}

// ============================================================
// Helper: rounded-corner rectangle, centered at origin in X/Y,
// bottom face at Z=0, top face at Z=depth.
// ============================================================
module rounded_rect(w, h, depth, r) {
    hull() {
        for (x = [-w/2 + r, w/2 - r])
            for (y = [-h/2 + r, h/2 - r])
                translate([x, y, 0])
                    cylinder(h = depth, r = r, $fn = 32);
    }
}
