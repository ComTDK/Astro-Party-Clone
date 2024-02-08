class Bullet
{
  float[] xpos, ypos, alpha, c_xpos, c_ypos, radius;
  int NumOfBullets = -1, OutOfBullets = 0, BulletInPocket = 3, colo;
  float speed, ReloadTime, Time = 0;
  Map map;
  
  Bullet(int colorr, Map m)
  {
    xpos = new float[100];
    ypos = new float[100];
    c_xpos = new float[100];
    c_ypos = new float[100];
    alpha = new float[100];
    radius = new float[100];
    speed = 8;
    ReloadTime = 400;
    colo = colorr;
    map = new Map();
    map = m;
  }
  
  //Display
  void Moving()
  {
    int i = 0;
    while(i <= NumOfBullets)
    {
      ypos[i] += speed*sin(alpha[i]);
      xpos[i] += speed*cos(alpha[i]);
      if(CollideBlock(i))
        ChangeRadius(i, 0);
      if(ypos[i] > 950 || ypos[i] < 50 || xpos[i] < 50 || xpos[i] > 950)
      {
        Clean(i);
        i--;
      }
      i++;
      
    }
  }
  
  void display()
  {
    fill(colo);
    for(int i = 0; i <= NumOfBullets; ++i)
      circle(xpos[i], ypos[i], radius[i]);
      
    if(millis() > Time && OutOfBullets == 1)
    {
      OutOfBullets = 0;
      if(NumOfBullets >= 2)
        ExtendBullets();
    }
  }
  
  //Collision between Bullet and Block
  boolean CollideBlock(int i)
  {
    int n = map.DetectCollisionBetweenJetAndBlock(xpos[i], ypos[i]);
    if(n != -1)
      return true;
    return false;
  }
  
  
  //Add and Get
  void AddBullets(int index, float x, float y, float angle, float radii)
  {
    if(index < BulletInPocket && OutOfBullets == 0)
    {
      NumOfBullets = index;
      c_xpos[index] = xpos[index] = x;
      c_ypos[index] = ypos[index] = y;
      alpha[index] = angle;
      radius[index] = radii;
    }
    else 
    {
      if(OutOfBullets == 0)
          Time = millis() + ReloadTime;
      OutOfBullets = 1;
    }
  }
  
  void Clean(int index)
  {
    int n = NumOfBullets + 1;
    for(int i = index; i <= n; ++i)
    {
      ypos[i] = ypos[i + 1];
      xpos[i] = xpos[i + 1];
      c_ypos[i] = c_ypos[i + 1];
      c_xpos[i] = c_xpos[i + 1];
      alpha[i] = alpha[i + 1];
      radius[i] = radius[i + 1];
    }
    NumOfBullets -= 1;
    BulletInPocket = max(3, BulletInPocket - 1);
  }
  
  void ExtendBullets()
  {
    BulletInPocket += 3;
  }
  
  int GetBulletInPocket()
  {
    return BulletInPocket;
  }
  
  int GetNumOfBullets()
  {
    return NumOfBullets;
  }
  
  float[] GetBulletEquation()
  {
    float[] VarAB;
    VarAB = new float[100];
    for(int i = 0; i <= NumOfBullets; ++i)
    {
      VarAB[2*i] = tan(alpha[i]);
      VarAB[2*i + 1] = c_ypos[i] - c_xpos[i]*tan(alpha[i]);
    }
    return VarAB;
  }
  
  float GetXPositionOfBullet(int index)
  {
    return xpos[index];
  }
  
  float GetYPositionOfBullet(int index)
  {
    return ypos[index];
  }
  
  //Change radius
  void ChangeRadius(int index, int r)
  {
    radius[index] = r;
  }
  
  //Get Radius
  float GetRadius(int index)
  {
    return radius[index];
  }
}
