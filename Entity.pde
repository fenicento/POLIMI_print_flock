class Entity extends VBoid{
  
  
 String name;
 int ttl;
 
 
 Entity(float x, float y, float z, float i, float r, String n) {
   
    super(x,y,z,i,r);
   this.ttl=0; 
   this.name=n;
   
   
 }
 
 int in(ArrayList<Entity> ent) {
   
  for (int i = 0; i<ent.size(); i++) {
   
    if(ent.get(i).name.equals(this.name)) {
     return i;
    }
   
  } 
  
  return -1;
   
 }
  
  
  
  
  
}
