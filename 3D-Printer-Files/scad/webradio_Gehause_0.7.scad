$fn=90;
//fuer OLED Display


//include <FrontEinschub_OLED_0.3.scad> //Lochraster Platine
include <webradio_FrontEinschub_0.7.scad>  //JLCPCB Platine
//include <honeycomb_mesh.scad>




translate([-7,-22.7,42]) rotate([0,0,180]) color([1,1,0]) FrontEinschub();
difference(){
    
union(){ 

  translate([0,0,-10]) Deckel();
Gehause();
    }
 // translate([100,0,100]) cube([200,200,200],center=true); //Schnitt
   //   translate([0,0,80]) Stulpdeckel();
}



//translate([0,-58,60]) cube([71,10,24],center=true); //LED Display

//translate([52,-58,60]) rotate([90,0,0])cylinder(r=12,h=10); //Poti
//translate([-52,-58,60]) rotate([90,0,0])cylinder(r=12,h=10); //Drehgeber
//translate([0,-60,110]) Lautsprecher();

// - honeycomb length

//translate([0,0,129]) hexagonal_grid(box, hexagon_diameter, hexagon_thickness);

module Stulpdeckel(){
    
    difference(){
      translate([0,0,25/2]) cube([170,80,25],center=true);  
    difference(){
      minkowski(){ //Deckel aussen
      translate([0,0,25/2-2]) cube([158-20,60-20,25],center=true);
      cylinder(r=10,h=0.01);
}
    }
    
    
    
}
}





module Deckel(){
    
    
    
    
   // translate([0,0,111]) Lautsprecher();
    //translate([-75,-58,116]) cube([3,4,22],center=true);
    
 //  translate([0,1,98.51]) hexagonal_grid([155, 55, 3], 10, 3);
//translate([0,1,104]) cube([180,80,10],center=true);
 // translate([0,1,98]) hexagonal_grid([155, 55, 3], 10, 3.1);   
    
difference(){
   
difference(){
 minkowski(){ //Deckel aussen

translate([0,0,87]) cube([128-20,60-20,5],center=true);
cylinder(r=10,h=0.01);
}



minkowski(){ //Deckel innen
translate([0,1,85])cube([124-16,54-16,5],center=true);
cylinder(r=8,h=0.01);
}
}
 
//Rand am Deckel
translate([0,0,98]) difference(){
minkowski(){    
translate([0,1,98])cube([124-16,54-16,10],center=true);
cylinder(r=8,h=0.01);
}    
minkowski(){ // innen
translate([0,1,98])cube([120-12,50-12,11],center=true);
cylinder(r=6,h=0.01);
}
}


//translate([0,1,104]) cube([180,80,10],center=true);
}
//Rand am Deckel
translate([0,0,-14]) difference(){
minkowski(){    
translate([0,1,98])cube([124-16,54-16,3],center=true);
cylinder(r=8,h=0.01);
}    
minkowski(){ // innen
translate([0,1,98])cube([122-12,52-12,4],center=true);
cylinder(r=6,h=0.01);
}
}

}


module Lautsprecher(){
    difference(){
   union(){
        cube([188,3,35],center=true); //Lautsprecher
      translate([0,0,-18])cylinder(d=8,h=37);
   }
    translate([0,0,-19])cylinder(d=3.7,h=20);   
translate([-55,0,0]) {
       minkowski(){//Membran Lautsprecher
cube([55-20,10,28-20],center=true);
rotate([90,0,0])cylinder(r=10,h=0.01);
}




translate([-63.5/2,3,24/2])rotate([90,0,0]) cylinder(r=0.8,h=10);
translate([63.5/2,3,24/2])rotate([90,0,0]) cylinder(r=0.8,h=10);
translate([-63.5/2,3,-24/2])rotate([90,0,0]) cylinder(r=0.8,h=10);
translate([63.5/2,3,-24/2])rotate([90,0,0]) cylinder(r=0.8,h=10);
}
translate([55,0,0]) {
       minkowski(){//Membran Lautsprecher
cube([55-20,10,28-20],center=true);
rotate([90,0,0])cylinder(r=10,h=0.01);
}




translate([-63.5/2,3,24/2])rotate([90,0,0]) cylinder(r=0.8,h=10);
translate([63.5/2,3,24/2])rotate([90,0,0]) cylinder(r=0.8,h=10);
translate([-63.5/2,3,-24/2])rotate([90,0,0]) cylinder(r=0.8,h=10);
translate([63.5/2,3,-24/2])rotate([90,0,0]) cylinder(r=0.8,h=10);
}

}
}

module Gehause(){
difference(){
minkowski(){ //Gehause
translate([0,0,74.5/2])cube([128-20,60-20,74.5],center=true);
cylinder(r=10,h=0.01);
}    
minkowski(){ //Gehause innen
translate([0,1,89/2+10])cube([124-16,54-16,89],center=true);
cylinder(r=8,h=0.01);
}

minkowski(){
translate([0,0,17.4])cube([81-2,30-2,20],center=true);//Bodenloch
cylinder(r=1,h=0.01);
}

/*
minkowski(){
translate([0,20,58.5])cube([94-4,30-2,73.5-4],center=true);//Ruckwandloch
rotate([90,0,0]) cylinder(r=2,h=0.01);
}
*/
minkowski(){
translate([0,0,-4])rotate([0,0,45]) cylinder(r1=70,r2=65,h=10,$fn=4);
    sphere(2);
}


minkowski(){
translate([50,0,-4])rotate([0,0,45]) cylinder(r1=25,r2=20,h=10,$fn=4);
    sphere(2);
}

minkowski(){
translate([-50,0,-4])rotate([0,0,45]) cylinder(r1=25,r2=20,h=10,$fn=4);
    sphere(2);
}

minkowski(){
translate([0,-28,48.5]) cube([94-4,14,73.5-4],center=true); //Frontplattenloch
    rotate([90,0,0]) cylinder(r=2,h=0.01);
}

    translate([0,-28,48.5]) cube([98,2,78.5],center=true); //Frontplatteschlitz

//translate([100,0,0]) cube([200,200,200],center=true); //Schnitt Test
}
/*
difference(){
translate([0,-60,53]) cube([164,4,84],center=true); //Frontplatte Verstärkung
translate([0,-64,67.5]) cube([144,13,73.5],center=true); //Frontplatte
    translate([0,-61,66]) cube([148,2,73.5],center=true); //Frontplatteschlitz
}
*/
}


/***** Mesh ++++++++++++++
//---------------------------------------------------------------
//-- Openscad Honeycomb mesh used in Cool PCB Enclosure (.
//-- This is a simple honeycomb, reusing ideas and code from the following excellent projects:
//--   + "Customizable Fan Grille" (http://www.thingiverse.com/thing:52305).
//--   + "Radiator difussers" (http://www.thingiverse.com/thing:Resolution07)
//-- IMPORTANT NOTES:
//--   + The coordinate system is mostly center based in order to simplify the integration between different projects involved.
//-- Version: 1.0
//-- Jul-2016
//---------------------------------------------------------------
//-- Released under the GPL3 license
//---------------------------------------------------------------

//---------------------------------------------------------------
//-- CUSTOMIZER PARAMETERS
//---------------------------------------------------------------
*/
// - honeycomb length
hc_length = 113;
// - honeycomb width
hc_width = 186;
// - honeycomb height
hc_height = 3;
// - hexagon hole diameter
hexagon_diameter = 10;
// - hexagon frame thickness
hexagon_thickness = 3;


/* [HIDDEN] */

box = [hc_width, hc_length, hc_height];



//---------------------------------------------------------------
//-- MODULES
//---------------------------------------------------------------



// * HONEYCOMB

module hexagonal_grid(box, hexagon_diameter, hexagon_thickness){
// first arg is vector that defines the bounding box, length, width, height
// second arg in the 'diameter' of the holes. In OpenScad, this refers to the corner-to-corner diameter, not flat-to-flat
// this diameter is 2/sqrt(3) times larger than flat to flat
// third arg is wall thickness.  This also is measured that the corners, not the flats. 

// example 
//    hexagonal_grid([25, 25, 5], 5, 1);

    difference(){
        cube(box, center = true);
        hexgrid(box, hexagon_diameter, hexagon_thickness);
    }
}


module hex_hole(hexdiameter, height){
        translate([0, 0, 0]) rotate([0, 0, 0]) cylinder(d = hexdiameter, h = height, center = true, $fn = 6);
}


module hexgrid(box, hexagon_diameter, hexagon_thickness) {
    cos60 = cos(60);
    sin60 = sin(60);
    d = hexagon_diameter + hexagon_thickness;
    a = d*sin60;

    moduloX = (box[0] % (2*a*sin60));
//    numX = (box[0] - moduloX) / a;
    numX =  floor(box[0] / (2*a*sin60));
    oddX = numX % 2;
    numberX = numX;

    moduloY = (box[1] % a);
//    numY = (box[1] - moduloY) / a;
    numY =  floor(box[1]/a);
    oddY = numY % 2;
    numberY = numY;

// Center the central hexagon on the origin of coordinates
    deltaY = oddY == 1 ? a/2 : 0;

    x0 = (numberX + 2) * 2*a*sin60;
    y0 = (numberY + 2) * a/2 + deltaY;

    for(x = [ -x0: 2*a*sin60 : x0]) {
        for(y = [ -y0 : a : y0]) {
            translate([x, y, 0]) hex_hole(hexdiameter = hexagon_diameter, height = box[2] + 0.001);
           translate([x + a*sin60, y + a*cos60 , 0]) hex_hole(hexdiameter = hexagon_diameter, height = box[2] + 0.001);
// echo ([x, y]);
// echo ([x + a*sin60, y + a*cos60]);
            
         } //fo
    } //fo
} //mo

// * END OF HONEYCOMB



//---------------------------------------------------------------
//-- RENDERS
//---------------------------------------------------------------


    //hexagonal_grid(box, hexagon_diameter, hexagon_thickness);
//hexagonal_grid([25, 25, 5], 5, 1);


