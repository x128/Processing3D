class Car
{
  float enginePower;
  float brakesEfficiency;
  float throttleBack;
  float impossibleSpeed;
  
  Car(String modelFileName)
  {
    this.shape = loadShape(modelFileName);
    this.enginePower = 100;
    this.brakesEfficiency = 100;
    this.throttleBack = -10;
    this.impossibleSpeed = 1e5;
  }
  PShape shape;
  
  float x, y, z;
  float attitude;
  float speed;
  
  boolean accelerating, braking, turningLeft, turningRight;
  
  void setPosition(float x, float y, float z, float attitude)
  {
    this.x = x;
    this.y = y;
    this.z = z;
    this.attitude = attitude;
  }
  
  int prevTimestamp;
  
  void updatePosition()
  {
    int timestamp = millis();
    float deltaTime = timestamp - prevTimestamp;
    prevTimestamp = timestamp;
    if (deltaTime > 500)
      return;
    
    float acceleration = 0;
    if (this.accelerating && !this.braking)
    {
      float throttle = 1;
      acceleration = exp(-this.speed) * throttle * this.enginePower;
    }
    else if (braking)
    {
      float brakingEffort = 1;
      acceleration = -this.brakesEfficiency * brakingEffort;
    }
    else
    {
      acceleration = throttleBack;
    }
    this.speed = constrain(this.speed + acceleration * deltaTime * 1e-5, 0, this.impossibleSpeed);

    float turningDirection = 0;
    if (this.turningLeft)
      turningDirection -= 1;
    if (this.turningRight)
      turningDirection += 1;
    this.attitude += turningDirection * atan(this.speed * 20) * 0.03;
      
    float speedX = this.speed * cos(attitude);
    float speedY = 0; // TODO =)
    float speedZ = this.speed * sin(attitude);

    this.x += speedX;
    this.y += speedY;
    this.z += speedZ;    
  }
}