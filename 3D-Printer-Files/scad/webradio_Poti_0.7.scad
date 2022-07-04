$fn=60;


difference(){
translate([0,0,0.1])cylinder(r=10.5,h=12.5);
cylinder(r1=3.2,r2=3.1,h=12);
cylinder(r=6.5,h=5);


//translate([0,0,20.6])rotate([90,0,0])cylinder(r=0.6,h=20);


translate([0,0,10.5]) difference(){
    cylinder(r=22,h=4);
translate([0,0,-0.05]) cylinder(r2= 8.5,r1=12.5,h=4.1);
}
}