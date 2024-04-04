/*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
&&  PlanerSled_Hardware: PlanerSled_Hardware.scad

        Copyright (c) 2024, Jeff Hessenflow
        All rights reserved.
        
        https://github.com/jshessen/PlanerSled_Hardware
        
        Parametric OpenSCAD file in support of the "Spring Factory 1.2"
        "How To Build a Planer Sled" by My Garage Woodshop
        https://www.youtube.com/watch?v=DNg9BV4IF2Q
&&
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&*/

/*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
&&  GNU GPLv3
&&
This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.
&&
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&*/




/*?????????????????????????????????????????????????????????????????
/*???????????????????????????????????????????????????????
?? Section: Customizer
??
    Description:
        The Customizer feature provides a graphic user interface for editing model parameters.
??
???????????????????????????????????????????????????????*/
/* [Global] */
// Display Verbose Output?
$VERBOSE=1; // [0:No,1:Level=1,2:Level=2,3:Developer]

/* [Design Characteristics] */
// Bolt Hole
custom_bolthole=0.3125; // [0.0625:0.0001:1]
// Enable Set Screw Hole
enable_setscrew=1;      // [1:Yes,0:No]
// Bolt Insert Type
bolt_insert=0;          // [1:Tee Nut,0:Heat Set Insert]
// Tee Nut Recess (ingnored for Heat Set Insert)
custom_teenut_recess=0.3333;    // [0.0625:0.0001:1]
// Tee Nut Diameter (ingnored for Heat Set Insert)
custom_teenut_d=0.75;           // [0.0625:0.0001:1]

/* [Slide Block] */
// Enabled
display_slideblock=1;           // [1:Yes,0:No]
// Width
custom_slideblock_w=3;          // [0.500:0.001:5]
// Depth
custom_slideblock_d=1.5;        // [0.500:0.001:5]
// Height
custom_slideblock_h=1.25;       // [0.500:0.001:5]
// Rabbet Depth
custom_rabbet_d=0.25;           // [0.0625:0.0001:5]
// Rabbet Height
custom_rabbet_h=0.5;            // [0.0625:0.0001:5]

/* [Base Plate Template] */
// Enabled
display_baseplate=1;            // [1:Yes,0:No]
// Width
custom_baseplate_w=3;           // [0.500:0.001:5]
// Depth
custom_baseplate_d=1.5;         // [0.500:0.001:5]
// Height
custom_baseplate_h=0.25;        // [0.500:0.001:5]
// Hole Size
custom_baseplate_hole=0.09375;  //[0.09375:#6-Hardwood (6/64),0.078125:#6-Softwood (5/64)]

/* [Hand Wheel] */
// Enabled
display_handwheel=1;            // [1:Yes,0:No]
// Diameter
custom_handwheel_d=2;           // [.500:.001:3.00]
// Thickness
custom_handwheel_h=.5;          // [.100:.001:3.00]
// Facet Number
hw_fn=24;                       // [6:1:360]
/*
?????????????????????????????????????????????????????????????????*/





/*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Section: Derived Variables
*/
/* [Hidden] */
//$fa = 0.1;
//$fs = 0.1;
fn=360;
$eps = 1/80;
render_offset=1.25;

bolthole_d=in2mm(custom_bolthole);
teenut_recess=in2mm(custom_teenut_recess);
teenut_d=in2mm(custom_teenut_d);

slideblock_w=in2mm(custom_slideblock_w);
slideblock_d=in2mm(custom_slideblock_d);
slideblock_h=in2mm(custom_slideblock_h);
rabbet_d=in2mm(custom_rabbet_d);
rabbet_h=in2mm(custom_rabbet_h);
setscrew_x_offset=slideblock_w/2-in2mm(1+1/16);
setscrew_z_offset=in2mm(1/5);
stopped_hole_gap=in2mm(1/8);
stopped_hole_y_offset=slideblock_d/2;

hard_wedge=0.5;

baseplate_w=in2mm(custom_baseplate_w);
baseplate_d=in2mm(custom_baseplate_d);
baseplate_h=in2mm(custom_baseplate_h);
baseplate_hole=in2mm(custom_baseplate_hole);

handwheel_d=in2mm(custom_handwheel_d);
handwheel_h=in2mm(custom_handwheel_h);
/*
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*/





/*/////////////////////////////////////////////////////////////////
// Section: Modules
*/
/*///////////////////////////////////////////////////////
// Module: make_PlanerSled_Hardware()
//
    Description:
        Wrapper module to create all Spring Factory objects

    Arguments:
        N/A
*/
// Example: Make sample objects
    make_PlanerSled_Hardware();
///////////////////////////////////////////////////////*/
module make_PlanerSled_Hardware(){
    if(display_slideblock){
        translate([0,0,slideblock_h/2]) {
            difference(){
                cube([slideblock_w,slideblock_d,slideblock_h], center=true);
                
                // Rabbet
                translate([0,-(slideblock_d-rabbet_d)/2,(slideblock_h-rabbet_h)/2])
                    cube([slideblock_w+$eps,rabbet_d+$eps,rabbet_h+$eps], center=true);
                // Top Hole
                translate([0,0,stopped_hole_gap])
                    cylinder(h=slideblock_h,d1=bolthole_d*hard_wedge,d2=bolthole_d, center=true, $fn=fn);
                if(enable_setscrew){
                    // Side Hole
                    translate([setscrew_x_offset,0,-setscrew_z_offset]) rotate([-90,0,0]) {
                        union(){
                            cylinder(h=(slideblock_d+$eps),d=(bolthole_d+$eps),center=true, $fn=fn);
                            if(bolt_insert){
                                translate([0,0,(slideblock_d-teenut_recess)/2])
                                    cylinder(h=(teenut_recess+$eps),d=(teenut_d+$eps),center=true,$fn=fn);
                            }
                        }
                    }
                }
                // Base Plate holes
                union(){
                        translate([-(slideblock_d/2),0,(slideblock_h-baseplate_h)/2]){
                            cylinder(h=baseplate_h+$eps,d=baseplate_hole,center=true,$fn=fn);
                        }
                        translate([(slideblock_d/2),0,(slideblock_h-baseplate_h)/2]){
                            cylinder(h=baseplate_h+$eps,d=baseplate_hole,center=true,$fn=fn);
                    }
                }
            }
        }
    }
    if(display_baseplate){
        shift_x=($preview) ? 0 : (display_slideblock) ? slideblock_w*render_offset : 0;
        shift_z=($preview) ? slideblock_h : 0;
        translate([shift_x,0,shift_z+baseplate_h/2]){
            difference(){
                color("lightblue") cube([baseplate_w,baseplate_d,baseplate_h],center=true);
                
                union(){
                    /*translate([-(baseplate_w/2-in2mm(3/4)),0,0]){
                        cylinder(h=baseplate_h+$eps,d=bolthole_d,center=true,$fn=fn);
                        }*/
                    translate([(baseplate_d/2-in2mm(3/4)),0,0]){
                        cylinder(h=baseplate_h+$eps,d=bolthole_d,center=true,$fn=fn);
                    }
                }
                
                union(){
                    /*translate([-(baseplate_w/2-in2mm(3/4)),baseplate_d/4,0]){
                        cylinder(h=baseplate_h+$eps,d=baseplate_hole,center=true,$fn=fn);
                    }
                    translate([-(baseplate_w/2-in2mm(3/4)),-baseplate_d/4,0]){
                        cylinder(h=baseplate_h+$eps,d=baseplate_hole,center=true,$fn=fn);
                    }*/
                    translate([(baseplate_w/2-in2mm(3/4)),0,0]){
                        cylinder(h=baseplate_h+$eps,d=baseplate_hole,center=true,$fn=fn);
                    }
                    translate([-(baseplate_w/2-in2mm(3/4)),0,0]){
                        cylinder(h=baseplate_h+$eps,d=baseplate_hole,center=true,$fn=fn);
                    }
                }            
            }
        }
    }
    if(display_handwheel){
        shift_x=($preview) ?
                0 :
                ((display_slideblock) ?
                    ((display_baseplate) ?
                        (slideblock_w+baseplate_w)*render_offset :
                        slideblock_w*render_offset) :
                    ((display_baseplate) ?
                    baseplate_w*render_offset :
                    0));
        shift_z=($preview) ? slideblock_h+baseplate_h : 0;
        
        translate([shift_x,0,shift_z+handwheel_h/2]){
            difference(){
                color("lavender")
                cylinder(h=handwheel_h,d=handwheel_d,center=true,$fn=hw_fn);
                
                cylinder(h=handwheel_h+$eps,d=bolthole_d, center=true, $fn=fn);
                
                if(bolt_insert){
                    translate([0,0,(handwheel_h-teenut_recess)/2])
                        cylinder(h=(teenut_recess+$eps),d=(teenut_d+$eps),center=true,$fn=fn);
                }
            }
        }
    }
}
/*
/////////////////////////////////////////////////////////////////*/





/*#################################################################
## Section: Functions - Conversions
*/
/*#######################################################
## Function: in2mm()
##
    Description:
        Convert number from Imperial-inches to Metric-millimeters (number*25.4)
    Parameter(s):
        number     (undef)      = Required. The number that you want to convert
    *Recursion Parameterss
        i      (len(number-1)   = Index variable to faciliate tail recursion
        v ([])             = Return vector
##
#######################################################*/
function in2mm(number, i,v=[]) =
    (!is_list(number))
    ?   number*25.4
    :   let(i=(!is_undef(i))?i:len(number)-1)
        (i<0)
        ?   v
        :   in2mm(number,i-1,concat(in2mm(number[i]),v));
/*
#################################################################*/