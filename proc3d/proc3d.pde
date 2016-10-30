import damkjer.ocd.*;

float x0 = 0;
float y0 = 0;
float phi0 = -2.45;
float theta0 = 2.05;

float phi = phi0;
float theta = theta0;
final float bottomAngleLimit = PI/6;
final float topAngleLimit = 5*PI/6;

Camera camera;
float cameraDistance = 100;
final float cameraDistanceMin = 10;
final float cameraDistanceMax = 500;

PShape trackShape;
Car car;

void setup()
{
  fullScreen(P3D);
  camera = new Camera(this, 50, 50, 50, 1, 1000);
  updateView();

  trackShape = loadShape("Silverstone_circuit.svg");
  car = new Car("f1.obj");
  car.setPosition(0, 0, 0, PI/4);
}

void draw()
{
  camera.feed();
  background(204);
  lights();

  car.updatePosition();

  shapeWithTranslation(trackShape, 0, 0, 0, PI/2, 0, 0); 
  shapeWithTranslation(car.shape, car.x, car.y, car.z, 0, PI/2 - car.attitude, PI); 
}

void shapeWithTranslation(PShape shape, float x, float y, float z, float xRotate, float yRotate, float zRotate)
{
  pushMatrix();
  translate(x, y, z);
  rotateX(xRotate);
  rotateY(yRotate);
  rotateZ(zRotate);
  shape(shape);
  popMatrix();
}

void shapeWithTranslation(PShape shape, float x, float y, float z)
{
  shapeWithTranslation(shape, x, y, z, 0, 0, 0);
}

void boxWithTranslation(float x, float y, float z, float xSize, float ySize, float zSize)
{
  pushMatrix();
  translate(x, y, z);
  box(xSize, ySize, zSize);
  popMatrix();
}

void keyChangedState(boolean state)
{
  if (key == 'w' || key == 'W' || keyCode == UP)
    car.accelerating = state;
  else if (key == 's' || key == 'S' || keyCode == DOWN)
    car.braking = state;
  else if (key == 'a' || key == 'A' || keyCode == LEFT)
    car.turningLeft = state;
  else if (key == 'd' || key == 'D' || keyCode == RIGHT)
    car.turningRight = state;
}

void keyPressed()
{
  keyChangedState(true);
}

void keyReleased()
{
  keyChangedState(false);
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
  //println(phi, theta);
  float x = cameraDistance * sin(theta) * cos(phi);
  float y = cameraDistance * cos(theta);
  float z = cameraDistance * sin(theta) * sin(phi);
  camera.jump(x, y, z);
}