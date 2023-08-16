public class Quaternion{
public float a, b, c ,d;

  public Quaternion(float a, float b, float c, float d){
    this.a = a;
    this.b = b;
    this.c = c;
    this.d = d;
  }
  
  public void PrintQuaternion(Quaternion obj){
    
    String s = a + " + " + b + "i + " + c + "j +" + d + "k";
    println(s);
    
  }
}
