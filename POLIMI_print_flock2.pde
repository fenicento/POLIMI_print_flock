import punktiert.math.Vec;
import punktiert.physics.*;
//import megamu.mesh.*;
import peasy.*;
import java.util.TreeSet;
import java.util.Iterator;

PeasyCam cam;

//world object

float fact= 4;
int gttl = 1000;
VPhysics placesGroup;
VPhysics peopleGroup;
VPhysics compsGroup;
Vec mouse;
float threer=3*sqrt(3);

//JSON
JSONObject json;
JSONArray values;
float i = 0;
JSONObject current;
JSONArray currPlaces;
JSONArray currComps;
JSONArray currPeople;

//PArticles

ArrayList<VParticle> placesTBR = new ArrayList<VParticle>();
ArrayList<Entity> finPlaces = new ArrayList<Entity>();
ArrayList<VParticle> peopleTBR = new ArrayList<VParticle>();
ArrayList<Entity> finPeople = new ArrayList<Entity>();
ArrayList<VParticle> compsTBR = new ArrayList<VParticle>();
ArrayList<Entity> finComps = new ArrayList<Entity>();

BAttraction vort1;
BAttraction vort2;
BAttraction vort3;
BConstantForce force;
BSeparate separation;

String dat="";

void setup() {
  size(1920, 1080, OPENGL);
 

//force1 = new BConstantForce(new Vec(0,0.04f,0));
//force2= new BConstantForce(new Vec(0,0.04f,0));
//force3 = new BConstantForce(new Vec(0,0.04f,0));


  //cam = new PeasyCam(this, 500);
  //
  vort1=new BAttraction(new Vec(width/6,height,0),width,0.05);
  vort2=new BAttraction(new Vec(width/2,height,0),width,0.05);
  vort3=new BAttraction(new Vec(5*width/6,height,0),width,0.05);
  
  
  //BWorldBox boxx = new BWorldBox(new Vec(), new Vec(width, 1080, 0));
  //boxx.setBounceSpace(true);
//  placesGroup.physics.addBehavior(boxx);
//  peopleGroup.physics.addBehavior(boxx);
//  compsGroup.physics.addBehavior(boxx);

  placesGroup=new VPhysics(new Vec(0,0), new Vec(width-10, height-100));
  peopleGroup=new VPhysics(new Vec(0,0), new Vec(width-10, height-100));
  compsGroup=new VPhysics(new Vec(0,0), new Vec(width-10, height-100));
  
  
//  placesGroup.setfriction(0.4f);
//  peopleGroup.setfriction(0.4f);
//  compsGroup.setfriction(0.4f);
  
//  placesGroup.addBehavior(force);
//  peopleGroup.addBehavior(force);
//  compsGroup.addBehavior(force);


  placesGroup.addBehavior(vort1);
  
  peopleGroup.addBehavior(vort2);
  compsGroup.addBehavior(vort3);


  json = loadJSONObject("corriere.json");
  values = json.getJSONArray("results");

  background(0);
}

void draw() {
 
  background(0);
  //fill(0, 20);
  //rect(0, 0, width, height);

  placesTBR.clear();
  placesGroup.update();

  peopleTBR.clear();
  peopleGroup.update();

  compsTBR.clear();
  compsGroup.update();

  //Update array cycle
  if (i>=values.size()-1) i=0;
  else i+=0.10;  

  if (i % 1 < 0.1) {

    current = values.getJSONObject(int(i));
  
    currPlaces = current.getJSONArray("locations");
    currPeople = current.getJSONArray("people");
    currComps = current.getJSONArray("companies");
    dat=current.getString("start").substring(0,7);
    
//    if(currPlaces.size()==0 && currPeople.size()==0 && currComps.size()==0) {
//       i+=1f; 
//    }
    
    
    
    
    for (int j = 0; j<currPlaces.size(); j++) {

      String nam=currPlaces.getJSONObject(int(j)).getString("name");
      int val=currPlaces.getJSONObject(int(j)).getInt("count");
      Entity particle=new Entity(random(0, width), random(-40,10),0, 1, sqrt(val)*fact,nam);
      particle.swarm.setSeperationScale(3*.7);

      placesGroup.addParticle(particle);    
    }
    

    for (int j = 0; j<currPeople.size(); j++) {
      String nam=currPeople.getJSONObject(int(j)).getString("name");
      int val=currPeople.getJSONObject(int(j)).getInt("count");
      
      Entity particle=new Entity(random(0, width), random(-40,10),0, 1, sqrt(val)*fact,nam);
      particle.swarm.setSeperationScale(1*.7);


      //add to array and to the world
      peopleGroup.addParticle(particle); 
    }

    for (int j = 0; j<currComps.size(); j++) {
      String nam=currComps.getJSONObject(int(j)).getString("name");
      int val=currComps.getJSONObject(int(j)).getInt("count");
      
      Entity particle=new Entity(random(0, width), random(-40,10),0, 1, sqrt(val)*fact,nam);
      particle.swarm.setSeperationScale(6*.7);

      //add to array and to the world
      compsGroup.addParticle(particle); 
    }
  }

  for (VParticle p : placesGroup.particles) {

    if(((Entity)p).ttl>=gttl) placesTBR.add(p);
    
    if(((Entity)p).y>=height-200 && ((Entity)p).radius>4) {
     int in=((Entity)p).in(finPlaces);
      
      if(in>=0) finPlaces.get(in).radius+=p.radius; 
      else finPlaces.add(((Entity)p));  
      
      placesTBR.add(p);
    }
}

  for (VParticle p : peopleGroup.particles) {
 
    if(((Entity)p).ttl>=gttl) peopleTBR.add(p);
    
    if(((Entity)p).y>=height-200 && ((Entity)p).radius>4) {
      
      int in=((Entity)p).in(finPeople);
      
      if(in>=0) finPeople.get(in).radius+=p.radius; 
      else finPeople.add(((Entity)p));  
      
      peopleTBR.add(p);
    }
  }


  for (VParticle p : compsGroup.particles) {
 
    if(((Entity)p).ttl>=gttl) compsTBR.add(p);
    
    if(((Entity)p).y>=height-200 && ((Entity)p).radius>4) {
     int in=((Entity)p).in(finComps);
      
      if(in>=0) finComps.get(in).radius+=p.radius; 
      else finComps.add(((Entity)p));  
      
      compsTBR.add(p);
    }
  }


  for (VParticle p : placesTBR) {   
    placesGroup.removeParticle(p);
  } 

  for (VParticle p : peopleTBR) {
    peopleGroup.removeParticle(p);
  } 

  for (VParticle p : compsTBR) {
    compsGroup.removeParticle(p);
  } 

 
  drawDelaunay(placesGroup.particles, #0081c2);

  drawDelaunay(peopleGroup.particles, #00c2ab);
 
  drawDelaunay(compsGroup.particles, #ffcc33);

  drawAreas(finPlaces, #0081c2, 30, vort1);
  drawAreas(finPeople, #00c2ab, 1*width/3, vort2);
  drawAreas(finComps, #ffcc33, 2*width/3, vort3);

  drawTitles();


 
}

void drawRectangle(VParticle p, int r) {
  
  float deform = p.getVelocity().mag();
  float rad = p.getRadius();
  deform = map(deform, 0, 1.5f, rad, 0);
  deform = max (rad *.2f, deform);

  float rotation = p.getVelocity().heading();    
  noStroke();
  fill(r);
  pushMatrix();
  translate(p.x, p.y);
  rotate(HALF_PI*.5f+rotation);
  beginShape();
  vertex(-rad, +rad);
  vertex(deform, deform);
  vertex(rad, -rad);
  vertex(-deform, -deform);
  endShape(CLOSE);
  popMatrix();
}


void drawCircle(VParticle p, int r) {

  float deform = p.getVelocity().mag();
  float rad = p.getRadius();
  deform = map(deform, 0, 1.5f, rad, 0);
  deform = max (rad *.2f, deform);

  float rotation = p.getVelocity().heading();    
  noStroke();
  fill(r);
  pushMatrix();
  translate(p.x, p.y);
  ellipse(0, 0, rad, rad);
  popMatrix();
}



void drawShape(VParticle p, int r) {

  float deform = p.getVelocity().mag();
  float rad = p.getRadius();
  deform = map(deform, 0, 1.5f, rad, 0);
  deform = max (rad *.2f, deform);
  vertex(p.x, p.y);
  //popMatrix();
}  


void drawDelaunay(ArrayList<VParticle> particles, int col) {
 
  for (int h=0; h<particles.size();h++) {
    
    Entity b =  (Entity)particles.get(h);
    
    float rad=b.getRadius();
   
   if(b.ttl>gttl-255) fill(col, 255+(gttl-255-b.ttl));
   
   else fill(col, 255);
    noStroke();

   
    //ellipse(particles.get(h).x,particles.get(h).y,rad,rad);
     drawTriangle(b);
   
   
   b.ttl+=1+10/b.radius;
    
  }
  
  //vort1.setAttractor(new Vec(mouseX,mouseY,0));
  
}


void drawTitles() {

  hint(DISABLE_DEPTH_TEST);
  
  fill(255);
  textSize(35);
  text(dat, width-180, 40);
  hint(ENABLE_DEPTH_TEST);
}


void drawPrisms(ArrayList<VParticle> particles, int col) {
  
  fill(col, 255);
    noStroke();
    
  for (VParticle p : particles) {
   float r = sqrt(p.radius)*5; 
   pushMatrix();
   translate(p.x,p.y);
   beginShape(QUADS);
   
   vertex(0,0,0);
   vertex(r,0,0);
   vertex(r,0,r);
   vertex(0,0,r);
   
   endShape(CLOSE);
   
   
   
    beginShape(QUADS);
   
   vertex(r,0,0);
   vertex(r,r,0);
    vertex(r,r,r);
   vertex(r,0,r);
  
   
   endShape(CLOSE);
   
   
   
   beginShape(TRIANGLE);
   
   vertex(r,0,r);
   vertex(r,r,r);
   vertex(0,0,r);
  
   
   endShape(CLOSE);
  
  
  popMatrix(); 
    
  }
  
}

 void drawTriangle(VParticle v) {   
    
    float r = sqrt(4*v.radius/threer)*4;
    float an = v.getVelocity().heading();
    
    float an2 = an+(2f/3f)*PI;
    float an3 = an+(4f/3f)*PI;

    beginShape(TRIANGLES);
    vertex(v.x+r*cos(an),v.y+r*sin(an),0);
    
    vertex(v.x+r*cos(an2),v.y+r*sin(an2),0);
    
    vertex(v.x+r*cos(an3),v.y+r*sin(an3),0);

    endShape(CLOSE);
    //triangle(v.x+r*cos(an),v.y+r*sin(an),v.x+r*cos(an+(2/3)*PI),v.y+r*sin(an+(2/3)*PI),v.x+r*cos(an+(4/3)*PI),v.y+r*sin(an+(4/3)*PI));
 
  }
  
  void drawAreas(ArrayList<Entity> ent, int col, float base, BAttraction vort) {
   int i = 0;
   float l = 72;
   float h = 0;
   fill(col,255);
   stroke(col);
   strokeWeight(2);
   
   
   
   
   Iterator<Entity> iter = ent.iterator();
   while (iter.hasNext()) {
    i++;
    Entity e =  iter.next();
     if (e.ttl>=gttl) iter.remove();
     else {
       h=e.radius/4;
       
       for(int j=0; j<h; j++) {
        
         line(base+(i*l)+2,height-100-(j*6),1,base+(i*l)+l,height-100-(j*6),1);
         
       }
  
        e.ttl+=1+2/e.radius;
     }
   }
  
   for (int j = 0; j<ent.size(); j++) {
    
     hint(DISABLE_DEPTH_TEST);
         textAlign(CENTER);
         rectMode(CORNERS);
          textSize(13);
          fill(255);
          text(ent.get(j).name,base+((j+1)*l)+2,height-90,base+((j+1)*l)+l,height-40);
        
        hint(ENABLE_DEPTH_TEST);
     
   }
   
   vort.setAttractor(new Vec(base+(i/2)*l,height,0));
   
   
    
  }
