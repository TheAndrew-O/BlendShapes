
Camera camera;
Vec3[][] shape; //ball
Vec3[][] shape2; //squished
Vec3[][] shape3; //stretch
Vec3[][] middle;
Vec3[][] middle2;
Vec3[][] middle3;
Vec3[][] middle4;
int lod = 150;
float r = 200;
float a = 1;
float b = 1;
float offset = 0;
float cons = 6;
float rate;
float x;
float y;
float z;
String windowTitle = "BlendShapes";
/*
//float rad = superShape(0,0.521395,0.71,cons,longitude);
//float rad2 = superShape(3,0,-0.8625,cons,latitude);
*/
void setup(){
  size(800,800, P3D);
  camera = new Camera();
  colorMode(RGB,255,255,255);
  shape = new Vec3[lod+1][lod+1];
  middle = new Vec3[lod+1][lod+1];
  shape2 = new Vec3[lod+1][lod+1];
  //shape3 = new Vec3[lod+1][lod+1];
  //middle2 = new Vec3[lod+1][lod+1];
  //middle3 = new Vec3[lod+1][lod+1];
  //middle4 = new Vec3[lod+1][lod+1];
  
  for(int i = 0; i <= lod; i++){
    float latitude = map(i, 0, lod, -HALF_PI, HALF_PI);
    float rad2 = superShape(2,1,1,6,latitude);
    for(int j = 0; j <= lod; j++){
      float longitude = map(j, 0, lod, -PI, PI);
      float rad = superShape(1,1,1,3,longitude);
      
      //Convert longitude and latitude to cartesian coordinates
      float x2 = r * rad * cos(longitude) * rad2 * cos(latitude);
      float y2 = r * rad * sin(longitude) * rad2 * cos(latitude);
      float z2 = r * rad2 * sin(latitude);
      
      float x = r * sin(longitude) * cos(latitude);
      float y = (r * sin(longitude) * sin(latitude));
      float z = r * cos(longitude);
      
      
      shape[i][j] = new Vec3(x,y,z);
      middle[i][j] = shape[i][j];
      shape2[i][j] = new Vec3(x2,y2,z2);
      
      //shape3[i][j] = rotateY_axis(new Vec3(x3,y3,z3),80);
      //middle2[i][j] = shape2[i][j];
      //middle3[i][j] = shape3[i][j];
      //println("x1:",x," y1:",y, " z1:",z);
      //println("x2:",x2," y2:",y2, " z2:",z2);
      //println("_________________________________________________________");
    }
  }
}
//Gielis superformula
float superShape2(float c1,float c2,float c3,float m, float m2,float theta){
  
  float num = abs((1 / a) * cos((theta / 4) * m));
  num = pow(num,c2);
  
  float num2 = abs((1 / b) * sin((theta / 4) * m2));
  num2 = pow(num2,c3);
  
  float num3 = num + num2;
  num3 = pow(num3, (-1 / c1));
  
  return num3;
}

float superShape(float c1, float c2, float c3, float m, float theta){ 
  float num = abs((1 / a) * cos((theta / 4) * m));
  num = pow(num,c2);
  
  float num2 = abs((1 / b) * sin((theta / 4) * m));
  num2 = pow(num2,c3);
  
  float num3 = num + num2;
  num3 = pow(num3, (-1 / c1));
  
  return num3;
}

Vec3 rotateX_axis(Vec3 point, float theta){
  Vec3 row1 = new Vec3(1, 0, 0);
  Vec3 row2 = new Vec3(0, cos(theta), -sin(theta));
  Vec3 row3 = new Vec3(0, sin(theta), cos(theta));
  Vec3 rotation = new Vec3(dot(row1, point), dot(row2,point), dot(row3,point)); 
  
  return rotation;
}

Vec3 rotateY_axis(Vec3 point, float theta){
  Vec3 row1 = new Vec3(cos(theta), 0, sin(theta));
  Vec3 row2 = new Vec3(0, 1, 0);
  Vec3 row3 = new Vec3(-sin(theta), 0, cos(theta));
  Vec3 rotation = new Vec3(dot(row1, point), dot(row2,point), dot(row3,point)); 
  
  return rotation;
}

Vec3 translateY_axis(Vec3 point, float dist){
  
  Vec3 translation = new Vec3(point.x, point.y - dist, point.z); 
  
  return translation;
}

void drawNewShapes(float[] arr1, float[] arr2){
  
  for(int i = 0; i <= lod; i++){
    float latitude = map(i, 0, lod, -HALF_PI, HALF_PI);
    float rad2 = superShape(arr2[0],arr2[1],arr2[2],arr2[3],latitude);
    for(int j = 0; j <= lod; j++){
      float longitude = map(j, 0, lod, -PI, PI);
      float rad = superShape(arr1[0],arr1[1],arr1[2],arr1[3],longitude);
      
      //Convert longitude and latitude to cartesian coordinates
      float x2 = r * rad * cos(longitude) * rad2 * cos(latitude);
      float y2 = r * rad * sin(longitude) * rad2 * cos(latitude);
      float z2 = r * rad2 * sin(latitude);      
      
      shape[i][j] = shape2[i][j];
      middle[i][j] = shape[i][j];
      shape2[i][j] = new Vec3(x2,y2,z2);

    }
  }
  
}

public Vec3 linearInterpolation(Vec3 v1, Vec3 v2, float amount){
  
  float new_x = v1.x + (v2.x - v1.x) * amount;
  float new_y = v1.y + (v2.y - v1.y) * amount;
  float new_z = v1.z + (v2.z - v1.z) * amount;
  return new Vec3(new_x,new_y,new_z);
}


public Vec3 slerp(Vec3 v1, Vec3 v2, float amount){
  float thetax = acos(v1.x * v2.x);
  float thetay = acos(v1.y * v2.y);
  float thetaz = acos(v1.z * v2.z);
  
  float new_x = v1.x * (sin((1-amount) * thetax) / sin(thetax)) + v2.x * (sin(amount*thetax) / sin(thetax));
  float new_y = v1.y * (sin((1-amount) * thetay) / sin(thetay)) + v2.y * (sin(amount*thetay) / sin(thetay));
  float new_z = v1.z * (sin((1-amount) * thetaz) / sin(thetaz)) + v2.z * (sin(amount*thetaz) / sin(thetaz));
  return new Vec3(new_x,new_y,new_z);
}

boolean frame = false;
boolean rotateX = false;
boolean rotateY = false;
float d;
float off = PI/5.0;
float counter;
void draw(){
  background(0);
  noStroke();
  lights();
  surface.setTitle(windowTitle + " "+ nf(frameRate,0,2) + "FPS");
  //cons = map(sin(rate), -1, 1, 0, 7);
  //rate += 0.05;
  camera.Update(1.0/frameRate);
  offset += 3;
  
    for(int i = 0; i <= lod; i++){
      for(int j = 0; j <= lod; j++){
        //Vec3 rand = new Vec3(random(2),random(2),random(2));
        middle[i][j] = interpolate(middle[i][j],shape2[i][j],0.02);
        //middle[i][j].add(rand);
      }
    }
  
    //stroke(255);
    //noFill();
    if(frame){
      stroke(255);
      noFill();
    }
    else{
      noStroke();
    }
    offset += 5;
    pushMatrix();
  //rotateX(d + off);
    for(int i = 0; i < lod; i++){
      beginShape(TRIANGLE_STRIP);
      float hue = map(i, 0, lod, 0, 255 * 6);
      if(!frame)
        fill(255,40,40);
      for(int j = 0; j < lod + 1; j++){
        
        if(rotateX){
          Vec3 vec = rotateX_axis(middle[i][j], d + off);
          vertex(vec.x,vec.y,vec.z);
          Vec3 vec2 = rotateX_axis(middle[i+1][j], d + off);
          vertex(vec2.x,vec2.y,vec2.z);
        }
        
        else if(rotateY){
          Vec3 vec = rotateY_axis(middle[i][j], d + off);
          vertex(vec.x,vec.y,vec.z);
          Vec3 vec2 = rotateY_axis(middle[i+1][j], d + off);
          vertex(vec2.x,vec2.y,vec2.z);
        }
        
        else{
          Vec3 vec = middle[i][j];      
          vertex(vec.x,vec.y,vec.z);         
          Vec3 vec2 = middle[i+1][j];
          vertex(vec2.x,vec2.y,vec2.z);
        }
        
      }
      endShape();
    }
    popMatrix();

  d += 0.01;
}

void keyPressed()
{
  if(key == ' '){
    
    float[] num_params = new float[4];
    float[] num_params2 = new float[4];
    
    for(int i = 0; i < 4; i++){
      num_params[i] = random(-1.91,10/ 1.001);
      num_params2[i] = random(-1.91, 10/ 1.001);
    } 
    drawNewShapes(num_params, num_params2);
  }
  
  if(key == 'f'){
      //println("dasd");
      if(frame){
        frame = false;
      }
      else{
        frame = true;
      }
    }
    if(key == '3'){
      //println("dasd");
      if(rotateX){
        rotateX = false;
      }
      else{
        rotateX = true;
        rotateY = false;
      }
    }
    if(key == '4'){
      //println("dasd");
      if(rotateY){
        rotateY = false;
      }
      else{
        rotateY = true;
        rotateX = false;
      }
    }
    
    if(key =='1'){
      lod +=1;
    }
    if(key =='2'){
      lod -= 1;
    }
  camera.HandleKeyPressed();
  
}

void keyReleased()
{
  camera.HandleKeyReleased();
}



public class Vec4 {
  public float w, x, y, z;
  
  public Vec4(float w, float x, float y, float z){
    this.w = w;
    this.x = x;
    this.y = y;
    this.z = z;
  }
  
  float dot(Vec4 a, Vec4 b){
    return a.w*b.w + a.x*b.x + a.y*b.y + a.z*b.z;
  }
}
