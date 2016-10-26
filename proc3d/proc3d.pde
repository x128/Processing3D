import damkjer.ocd.*;

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

PShape car;
PImage track;

void setup()
{
  fullScreen(P3D);
  camera = new Camera(this, 50, 50, 50);
  updateView();
  
  car = loadShape("f1.obj");
  //s.scale(20);
  car.rotate(PI);
  
  track = loadImage("silverstone.jpg");
}

void draw()
{
  camera.feed();
  background(204);
  lights();

/*
  rotatedImage(imgCar, 0, 0, 0, 50, 50, 0, 0, 0); 
  rotatedImage(imgCar, 0, 0, 0, 50, 50, 0, PI/4, 0); 
  rotatedImage(imgCar, 0, 50, 0, 50, 50, PI/2, 0, 0); 

  translatedBox(0, 0, 0, 50, 30, 5);
  translatedBox(50, 0, 0, 10, 10, 10);
*/
  
  rotatedImage(track, 15, 0, 0, 50, 50, PI/2, 0, 2); 
  shape(car, 0, 0);
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