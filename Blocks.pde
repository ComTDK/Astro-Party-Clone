class Blocks
{
  float RectX1, RectY1, W, H;
  Blocks(float x1, float y1, float Width, float Height)
  {
    RectX1 = x1;
    RectY1 = y1;
    W = Width;
    H = Height;
  }
  
  void display()
  {
    line(RectX1, RectY1, RectX1 + W, RectY1);
    line(RectX1, RectY1, RectX1, RectY1 + H);
    line(RectX1, RectY1 + H, RectX1 + W, RectY1 + H);
    line(RectX1 + W, RectY1, RectX1 + W, RectY1 + H);
  }
  
  boolean CheckInside(float x, float y)
  {
    float minX = min(RectX1, RectX1 + W + 15*(W/abs(W))); 
    float maxX = max(RectX1, RectX1 + W + 15*(W/abs(W))); 
    float minY = min(RectY1, RectY1 + H + 15*(H/abs(H))); 
    float maxY = max(RectY1, RectY1 + H + 15*(H/abs(H))); 
    if(x >= minX && x <= maxX && y >= minY && y <= maxY)
      return true;
    return false;
  }
  
  boolean CheckIntersection(float a, float b, float xpos, float ypos, float radius)
  {
    float a1 = a*a + 1, a2 = -(2*xpos - 2*a*(b - ypos)), a3 = xpos*xpos + (b - ypos)*(b - ypos) - radius*radius;
    float delta = a2*a2 - 4*a1*a3;
    if(delta >= 0)
    {
      float x1 = (-a2 + sqrt(delta))/(2*a1), x2 = (-a2 - sqrt(delta))/(2*a1);
      float y1 = a*x1 + b, y2 = a*x2 + b;
      if(CheckInside(x1, y1))
        return true;
      if(CheckInside(x2, y2))
        return true;
    }
    return false;
  }
  
  boolean Check(float x, float xpos, float ypos, float radius)
  {
    float a1 = 1, a2 = -2*ypos, a3 = ypos*ypos + (x - xpos)*(x - xpos) - radius*radius;
    float delta = a2*a2 - 4*a1*a3;
    if(delta >= 0)
    {
      float y1 = (-a2 + sqrt(delta))/(2*a1), y2 = (-a2 - sqrt(delta))/(2*a1);
      if(CheckInside(x, y1))
        return true;
      if(CheckInside(x, y2))
        return true;
    }
    
    return false;
  }
  
  boolean CheckCollision(float xpos, float ypos, float radius)
  {
    if(CheckInside(xpos, ypos))
      return true;
      
    // y = ax + b
    if(CheckIntersection(0, RectY1, xpos, ypos, radius))
      return true;
    if(CheckIntersection(0, RectY1 + H, xpos, ypos, radius)) 
      return true;
      
    // x = k
    if(Check(RectX1, xpos, ypos, radius))
      return true;
    if(Check(RectX1 + W, xpos, ypos, radius))
      return true;
    return false;
  }
  
}
