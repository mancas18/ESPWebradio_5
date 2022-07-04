$fn=90;

//FrontEinschub();

//Platine();




//DimTest();
//translate([0,3.5,0]) rotate([-90,180,0]) OLED();
//rotate([90,0,0])  translate([0,0,3]) buegel();
//rotate([90,0,0]) translate([0,0,-3]) buegel();


module Platine(){
    cube([54,44,1.6],center=true);
    translate([-47/2,-37/2,0]) cylinder(d=2,h=6);
    translate([-47/2,37/2,0]) cylinder(d=2,h=6);
    translate([47/2,-37/2,0]) cylinder(d=2,h=6);
    translate([47/2,37/2,0]) cylinder(d=2,h=6);
}

module Platinenpfosten(){ //Platine 54x44 Loch 47x37
      
    minkowski(){
    translate([0,1,37/2])cube([54,10-2,3-1],center=true);
        sphere(1);
    }
        minkowski(){
    translate([0,1,-37/2])cube([54,10-2,3-1],center=true);
        sphere(1);
    }
difference(){
union(){
 translate([54/2,5.3,37/2]) rotate([90,0,0])cylinder(r=3,h=20.3);
 translate([-54/2,5.3,37/2]) rotate([90,0,0])cylinder(r=3,h=20.3);
 translate([54/2,5.3,-37/2]) rotate([90,0,0])cylinder(r=3,h=20.3);
 translate([-54/2,5.3,-37/2]) rotate([90,0,0])cylinder(r=3,h=20.3);
}
translate([54/2,5.3-4,37/2]) rotate([90,0,0])cylinder(r=1,h=20.3);
 translate([-54/2,5.3-4,37/2]) rotate([90,0,0])cylinder(r=1,h=20.3);
 translate([54/2,5.3-4,-37/2]) rotate([90,0,0])cylinder(r=1,h=20.3);
 translate([-54/2,5.3-4,-37/2]) rotate([90,0,0])cylinder(r=1,h=20.3);
}
}
    
    


module buegel(){
    
   difference(){
      union(){ 
    minkowski(){
    cube([40-3.9,2,4-3.9],center=true);
    rotate([90,0,0]) cylinder(d=3.9,h=0.01);
    }
    
     translate([0,2,0]) minkowski(){
    cube([20-3.9,4,4-3.9],center=true);
    rotate([90,0,0]) cylinder(d=3.9,h=0.01);
    }
}
     translate([18,4,0]) rotate([90,0,0]) cylinder(d=1.9,h=10); //Bohrung
         translate([-18,4,0]) rotate([90,0,0]) cylinder(d=1.9,h=10);
}
}

module DimTest(){ //Einbauuntersuchung OLED
    

 difference(){
  union(){   
translate([18,4.7,3]) rotate([90,0,0])    cylinder(d=4,h=4.5);
    translate([-18,4.7,3]) rotate([90,0,0])    cylinder(d=4,h=4.5);
      translate([18,4.7,-3]) rotate([90,0,0])    cylinder(d=4,h=4.5);
    translate([-18,4.7,-3]) rotate([90,0,0])    cylinder(d=4,h=4.5);
  }
     translate([-18,5,3]) rotate([90,0,0]) cylinder(d=1.9,h=10);
         translate([18,5,3]) rotate([90,0,0]) cylinder(d=1.9,h=10);
       translate([-18,5,-3]) rotate([90,0,0]) cylinder(d=1.9,h=10);
         translate([18,5,-3]) rotate([90,0,0]) cylinder(d=1.9,h=10);
    }
     $fn=50;  
difference(){
 translate([0,5.5,0]) cube([40,1.6,40],center=true); //Frontplatte
 translate([0,3.3,0]) rotate([-90,180,0]) OLED();
    
translate([0,5.3,1.6]) rotate([-90,180,0]) LochkantenRundung();
}
}


module FrontEinschub(){
 //Buegelhalterung OLED
   translate([8,0,0])  difference(){
   union(){   
translate([18,4.7,3]) rotate([90,0,0])    cylinder(d=4,h=4.5);
    translate([-18,4.7,3]) rotate([90,0,0])    cylinder(d=4,h=4.5);
      translate([18,4.7,-3]) rotate([90,0,0])    cylinder(d=4,h=4.5);
    translate([-18,4.7,-3]) rotate([90,0,0])    cylinder(d=4,h=4.5);
  }
     translate([-18,5,3]) rotate([90,0,0]) cylinder(d=1.9,h=10);
         translate([18,5,3]) rotate([90,0,0]) cylinder(d=1.9,h=10);
       translate([-18,5,-3]) rotate([90,0,0]) cylinder(d=1.9,h=10);
         translate([18,5,-3]) rotate([90,0,0]) cylinder(d=1.9,h=10);
    }
    
    
    
//translate([0,0,0])ESP(); //handgelötete Platine
translate([6,0,0])    Platinenpfosten(); //JLCPCB Platine

difference(){
    union(){

    translate([-7,5.5,0]) cube([117-20,1.6,75-10],center=true); //Frontplatte
        
        //translate([53,6.3,0]) rotate([90,0,0])cylinder(r=12,h=6.3); //Poti Ummant
         //translate([53,6.3,0]) rotate([90,0,0])cylinder(r=5,h=7.3); //Poti Ummant
        translate([-28,6.3,0]) rotate([90,0,0])cylinder(r=12,h=9.3); //Drehgeber Ummant
               translate([-28,6.3,0]) rotate([90,0,0])cylinder(r=5,h=10.3); //Drehgeber Ummant
 /*     
      translate([0,0,-0.5]){  //Lochbild Display
          difference(){
              union(){
         translate([75/2,5.3,31/2]) rotate([90,0,0])cylinder(r=2.5,h=6.1); //Schraube Display
     translate([-75/2,5.3,31/2]) rotate([90,0,0])cylinder(r=2.5,h=6.1); //Schraube Display
     translate([75/2,5.3,-(31/2)]) rotate([90,0,0])cylinder(r=2.5,h=6.1); //Schraube Display
     translate([-75/2,5.3,-(31/2)]) rotate([90,0,0])cylinder(r=2.5,h=6.1); //Schraube Display
              }
          translate([75/2,5.3,31/2]) rotate([90,0,0])cylinder(r=0.8,h=10); //Schraube Display
     translate([-75/2,5.3,31/2]) rotate([90,0,0])cylinder(r=0.8,h=10); //Schraube Display
     translate([75/2,5.3,-(31/2)]) rotate([90,0,0])cylinder(r=0.8,h=10); //Schraube Display
     translate([-75/2,5.3,-(31/2)]) rotate([90,0,0])cylinder(r=0.8,h=10); //Schraube Display
      }
    }
    */
}
translate([8,3.3,-1.6]) rotate([-90,180,0]) OLED();

//translate([53,10+1.2,0]) rotate([90,0,0])cylinder(r=11,h=10); //Poti
translate([-28,10+1.2,0]) rotate([90,0,0])cylinder(r=11,h=13); //Drehgeber
    
//translate([53,10-2,0]) rotate([90,0,0])cylinder(r=3.5,h=10); //Poti
translate([-28,10-2,0]) rotate([90,0,0])cylinder(r=3.5,h=13); //Drehgeber    
    
//translate([0,4,0]) cube([71.4,10,24.4],center=true);    //Display
    
    //translate([0,-2,0]) cube([82,10,24],center=true);    //Display Absenkung
    //translate([0,-2,0]) cube([71,10,37],center=true);    //Display Absenkung
  /*  
 
    */
}
}

module ESP(){  //auf Lochplatine 24x18 
    minkowski(){
    translate([0,1,45.3/2])cube([65,10-2,3-1],center=true);
        sphere(1);
    }
        minkowski(){
    translate([0,1,-45.3/2])cube([66,10-2,3-1],center=true);
        sphere(1);
    }
difference(){
union(){
 translate([65.3/2,5.3,45.3/2]) rotate([90,0,0])cylinder(r=3,h=20.3);
 translate([-65.3/2,5.3,45.3/2]) rotate([90,0,0])cylinder(r=3,h=20.3);
 translate([65.3/2,5.3,-45.3/2]) rotate([90,0,0])cylinder(r=3,h=20.3);
 translate([-65.3/2,5.3,-45.3/2]) rotate([90,0,0])cylinder(r=3,h=20.3);
}
translate([65.3/2,5.3-4,45.3/2]) rotate([90,0,0])cylinder(r=0.8,h=20.3);
 translate([-65.3/2,5.3-4,45.3/2]) rotate([90,0,0])cylinder(r=0.8,h=20.3);
 translate([65.3/2,5.3-4,-45.3/2]) rotate([90,0,0])cylinder(r=0.8,h=20.3);
 translate([-65.3/2,5.3-4,-45.3/2]) rotate([90,0,0])cylinder(r=0.8,h=20.3);
}
}


module OLED(){
    // OLED Display;

$fn=(80);
difference(){
union(){
  translate([2.54/2,14-1.25,-11+1.1+1.2]) cylinder(d=0.6,h=11);  //stifte
  translate([2.54/2+2.54,14-1.25,-11+1.1+1.2]) cylinder(d=0.6,h=11);  
  translate([-2.54/2,14-1.25,-11+1.1+1.2]) cylinder(d=0.6,h=11);  
  translate([-2.54/2-2.54,14-1.25,-11+1.1+1.2]) cylinder(d=0.6,h=11);  
   
   translate([0,12.5,-1.25]) cube([10,2.8,2.5],center=true); //stiftisolierung
     translate([0,11.5,0.75+1.1]) cube([12,4.5,1.5],center=true); //stifte oben
      translate([0,-11.5,0.75+1.1]) cube([12,4.5,1.5],center=true); //flexband
    
translate([0,0,0.6]) cube([28,28,1.2],center=true); //basis
    translate([0,0,1.3]) cube([27+0.5,19+0.8,2.6],center=true); //OLED
      translate([0,1.6,1.6]) cube([23,13.2,3.1],center=true); //OLED oeffnung
}
translate([23.7/2,24/2,-0.1]) cylinder(d=2,h=2); //befestigungsbohrung
translate([-23.7/2,24/2,-0.1]) cylinder(d=2,h=2);
translate([23.7/2,-24/2,-0.1]) cylinder(d=2,h=2);
translate([-23.7/2,-24/2,-0.1]) cylinder(d=2,h=2);
}
}

module LochkantenRundung(){
    L=24;
    B=14.2;
    R=1;
    
    color([1,1,1]) difference(){
    translate([0,0,5])cube([L,B,10],center=true);
    
    
   translate([-(L+R/2)/2,B/2,0]) rotate([0,90,0])cylinder(r=R,h=L+R/2);
   translate([-(L+R/2)/2,-B/2,0]) rotate([0,90,0])cylinder(r=R,h=L+R/2); 
   translate([L/2,(B+R/2)/2,0]) rotate([90,0,0])cylinder(r=R,h=B+R/2); 
   translate([-L/2,(B+R/2)/2,0]) rotate([90,0,0])cylinder(r=R,h=B+R/2); 
}
}
