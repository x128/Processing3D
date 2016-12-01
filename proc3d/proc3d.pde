import damkjer.ocd.*;
import toxi.geom.Quaternion;

float x0 = 0;
float y0 = 0;
float phi0 = 0.5;
float theta0 = 2;

float phi = phi0;
float theta = theta0;
final float bottomAngleLimit = PI/6;
final float topAngleLimit = 5*PI/6;

Camera camera;
float cameraDistance = 100;
final float cameraDistanceMin = 50;
final float cameraDistanceMax = 500;

PImage imgCar;
PShape paddle;


import io.thp.psmove.*;
PSMove [] moves;


void setup()
{
  fullScreen(P3D);
  camera = new Camera(this, 50, 50, 50);
  updateView();
  
  imgCar = loadImage("car.jpg");
  paddle = loadShape("paddle.obj");
  paddle.scale(20);
  
  
  
  moves = new PSMove[psmoveapi.count_connected()];
  for (int i=0; i<moves.length; i++) {
    moves[i] = new PSMove(i);
    moves[i].enable_orientation(1); // PSMove_Bool (0 = False, 1 = True)
    if(moves[i].has_orientation() == 1) {
      moves[i].reset_orientation(); // Sets the 
      println("Orientation enabled for PS Move #"+i);
    }
    else
      println("Orientation tracking is not available for controller #"+i);
  }
}





Quaternion q;

void handle(int i, PSMove move)
{
  float [] quat0 = {0.f}, quat1 = {0.f}, quat2 = {0.f}, quat3 = {0.f};

  while (move.poll() != 0) {}
  
  move.get_orientation(quat0, quat1, quat2, quat3);
  
  //println("quatW = "+quat0[0]+" | quatX = "+quat1[0]+" | quatY = "+quat2[0]+" | quatZ = "+quat3[0]);
  
  q = new Quaternion(quat0[0], quat1[0], quat2[0], quat3[0]);
  println(q.toString());
  
  long [] pressed = {0};  // Button press events
  long [] released = {0}; // Button release events
  
  // Reset the values of the quaternions to [1, 0, 0, 0] when the MOVE button is pressed
  move.get_button_events(pressed, released);
  if ((pressed[0] & Button.Btn_MOVE.swigValue()) != 0) {
    move.reset_orientation();
    println("Orientation reset for controller #"+i);
  }
}





void draw()
{
  camera.feed();
  background(204);
  lights();

  rotatedImage(imgCar, 0, 0, 0, 50, 50, 0, 0, 0); 
  rotatedImage(imgCar, 0, 0, 0, 50, 50, 0, PI/4, 0); 
  rotatedImage(imgCar, 0, 50, 0, 50, 50, PI/2, 0, 0); 

  translatedBox(0, 0, 0, 50, 30, 5);
  translatedBox(50, 0, 0, 10, 10, 10);
  
  for (int i=0; i<moves.length; i++) {
    handle(i, moves[i]);
  }
  
  rotatedShape(paddle, q.x, q.y, q.z);
}

void rotatedImage(PImage img, float x, float y, float z, float xSize, float ySize, float xRotate, float yRotate, float zRotate)
{
  pushMatrix();
  translate(x, y, z);
  rotateX(xRotate);
  rotateY(yRotate);
  rotateZ(zRotate);
  image(img, 0, 0, xSize, ySize);
  popMatrix();
}  


void rotatedShape(PShape sh, float xRotate, float yRotate, float zRotate)
{
  pushMatrix();
  rotateX(xRotate);
  rotateY(yRotate);
  rotateZ(zRotate);
shape(sh, 0, 0);
  popMatrix();
}  



void translatedBox(float x, float y, float z, float xSize, float ySize, float zSize)
{
  pushMatrix();
  translate(x, y, z);
  box(xSize, ySize, zSize);
  popMatrix();
}  

void mousePressed()
{
  x0 = mouseX;
  y0 = mouseY;
  phi0 = phi;
  theta0 = theta;
  updateView();
}

void mouseDragged()
{
  phi = phi0 + map(mouseX - x0, 0, width, 0, PI);
  theta = theta0 + map(mouseY - y0, 0, height, 0, PI);
  theta = constrain(theta, bottomAngleLimit, topAngleLimit);

  updateView();
}

void mouseWheel(MouseEvent event)
{
  cameraDistance += event.getCount();
  cameraDistance = constrain(cameraDistance, cameraDistanceMin, cameraDistanceMax);

  updateView();
}

void updateView()
{
  float x = cameraDistance * sin(theta) * cos(phi);
  float y = cameraDistance * cos(theta);
  float z = cameraDistance * sin(theta) * sin(phi);
  camera.jump(x, y, z);
}