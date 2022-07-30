base_x = 120;
base_y = 80;

roof_angle = 30;
roof_height = 60;
eave = 10;
roof_run = (base_y/2)/cos(roof_angle)+eave;
wt = 3;

chimney_xy = 20;
chimney_z = 40;
end_y = base_y-2*wt;
gable_z = tan(roof_angle)*(end_y/2);
kerf = 0.1;

module base() {
    cube([base_x, base_y, wt]);
}
// base();

module side() {
    cube([base_x, roof_height, wt]);
}
module end() {
    cube([roof_height+wt, end_y, wt]);
    translate([roof_height+wt,0,0]) linear_extrude(wt) polygon([[0,0],[gable_z,end_y/2],[0,end_y]]);
}
// !end();
module roof() {
    cube([base_x,roof_run , wt]);
}
// !roof();

module chimney_front() {
    cube([chimney_xy, chimney_z, wt]);
}
// chimney_front();
module chimney_side() {
    difference() {
        cube([chimney_xy, chimney_z, wt]);
        translate([base_y/2-wt+chimney_xy/2,-roof_height-wt-gable_z+tan(roof_angle)*(chimney_xy/2),0]) rotate([0,0,90]) end();
    }
}
// chimney_side();
module chimney() {
    rotate([90,0,0]) chimney_front();
    translate([0,chimney_xy+wt,0]) rotate([90,0,0]) chimney_front();
    rotate([90,0,90]) chimney_side();
    translate([chimney_xy-wt,0,0]) rotate([90,0,90]) chimney_side();
}
// !chimney();
module assembled() {
    base();
    translate([0,wt,wt]) rotate([90,0,0]) side();
    translate([0,base_y,wt]) rotate([90,0,0]) side();
    translate([wt,wt,wt]) rotate([0,-90,0]) end();
    translate([base_x,wt,wt]) rotate([0,-90,0]) end();
    translate([0,0,roof_height+wt]) rotate([roof_angle,0,0]) translate([0,-eave,0]) roof();
    translate([0,base_y,roof_height+wt]) rotate([-roof_angle,0,0]) translate([0,eave-roof_run,0]) roof();
    translate([10, base_y/2-chimney_xy/2, roof_height+gable_z+5]) chimney();

}
module arranged(){
    projection() {
        side();
        translate([0,roof_height+kerf,0]) side();
        translate([base_x+kerf,0,0]) roof();
        translate([base_x+kerf,roof_run+kerf,0]) roof();

        translate([chimney_z,(roof_height+kerf)*2,0]) rotate([0,0,90]) union() {
            chimney_front();
            translate([0,-chimney_z-kerf,0]) chimney_front();
            translate([0,(-chimney_z-kerf)*2,0]) chimney_side();
            translate([0,(-chimney_z-kerf)*3,0]) chimney_side();
        }

        translate([base_y-wt*2,(roof_height+kerf)*2+chimney_xy+kerf,0]) rotate([0,0,90]) end();
        translate([(base_y-wt*2)*2+kerf,(roof_height+kerf)*2+chimney_xy+kerf,0]) rotate([0,0,90]) #end();

        translate([base_y+(base_y-wt*2+kerf)*2,(roof_height+kerf)*2+chimney_xy+kerf,0]) rotate([0,0,90]) base();

    }
}
// !arranged();
!assembled();