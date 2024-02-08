class bomb
{
  int NumOfBombs = 3, B = -1, Num = -1, PocketBomb = 0; //B is number of bomb that has been shooted and Num is number of bomb in the array
  PImage[] bom;
  float[] xpos, ypos, alpha, time, circl, Ellapse, Wait;
  float speed = 8;
  Map map;
  bomb(Map m)
  {
    bom = new PImage[100];
    time = new float[100];
    Wait = new float[100];
    for(int i = 0; i <= 99; ++i)
    {  
      imageMode(CENTER);
      bom[i] = loadImage("Bomb.jpg"); 
      bom[i].resize(30, 30); 
      time[i] = 0;
    }
    
    xpos = new float[100];
    ypos = new float[100];
    alpha = new float[100]; 
    circl = new float[100]; 
    Ellapse = new float[100];
    
    for(int i = 0; i <= 3; ++i)
    {
      Ellapse[i] = 0;
      Wait[i] = 0;
    }
    map = m;
  }
  
  void display(float[] TriBound)
  {
    for(int i = 0; i <= Num; ++i)
    {
      image(bom[i], xpos[i], ypos[i]);
      /*if(time[i] > 50)
        circle(xpos[i], ypos[i], 400);*/
    }
    for(int i = 0; i <= 2; ++i)
      if(millis() < Ellapse[i])
      {
        fill(255);
        //CheckCollisionBetweenJetAndBom(TriBound, i);
        circle(circl[2*i], circl[2*i + 1], 200);
      }

  }
  
  void moving()
  {   
    int i = 0;
    while(i <= Num)
    {
      if(time[i] < 50)
      {
        xpos[i] += speed*cos(alpha[i]);
        ypos[i] += speed*sin(alpha[i]);
        //println(xpos[i], ypos[i]);
        if(Collision(i, 15))
        {
          i--;
        }
        else
        if(ypos[i] < 70 || ypos[i] > 930)
        {
          Explosion(i, 1000);
          i -= 1;
        }
        else
        if(xpos[i] < 70 || xpos[i] > 930)
        {
          Explosion(i, 1000);
          i -= 1;
        }
      }
      else 
      {
        if(Wait[i] < millis() && Wait[i] == 0)
          Wait[i] = millis() + 3000;
        else
          if(millis() >= Wait[i])
          {
            Wait[i] = 0;
            Explosion(i, 1000);
          }
      }
      if(i >= 0)
        time[i] += 1;
      i++;
    }
  }
  
  boolean CheckCollisionBetweenJetAndExplosion(float[] TriBound, int i)
  {
    float m1, m2;
    //print(Num);
    for(int j = 0; j <= 2; ++j)
    {
      if(Ellapse[i] > millis())
      {
        m1 = TriBound[2*j] - circl[2*i];
        m2 = TriBound[2*j + 1] - circl[2*i + 1];
        if(sqrt(m1*m1 + m2*m2) <= 100)
        {
          return true;
        }
      }
    }
    return false;
    
  }
  
  void CollideJet(float[] TriBound, int i)
  {
    float m1, m2;
    //print(Num);
    for(int j = 0; j <= 2; ++j)
    {
      if(time[i] <= 50)
      {
        m1 = TriBound[2*j] - xpos[i];
        m2 = TriBound[2*j + 1] - ypos[i];
        if(sqrt(m1*m1 + m2*m2) <= 30)
        {
          Explosion(i, 1000);
          return;
        }
      }
    }
  }
  
  boolean Collision(int i, float r)
  {
    boolean state = false;
    //for(int i = 0; i <= Num; ++i)
    if(map.DetectCollisionBetweenItemsAndBlock(xpos[i], ypos[i], r))
    {
      Explosion(i, 1000);
      state = true;
    }
    return state;
  }
  
  void Explosion(int i, int seconds)
  {
    time[i] = 51;
    circl[2*i] = xpos[i];
    circl[2*i + 1] = ypos[i];
    Ellapse[i] = millis() + seconds;
    Clean(i);
  }
  
  void Add(float x, float y, float angle)
  {
    B += 1;
    Num += 1;
    xpos[Num] = x;
    ypos[Num] = y;
    time[Num] = 0;
    alpha[Num] = angle;
  }
  
  void Pocket()
  {
    if(Num != -1)
      PocketBomb += 3;
    B = -1;
    for(int i = 0; i <= PocketBomb; ++i)
    {
      xpos[i] = 0;
      ypos[i] = 0;
      alpha[i] = 0;
      time[i] = 0;
    }
  }
  
  void Clean(int index)
  {    
    for(int i = index; i <= Num + 1; ++i)
    {
      xpos[i] = xpos[i + 1];
      ypos[i] = ypos[i + 1];
      alpha[i] = alpha[i + 1];
      time[i] = time[i + 1];
    }  
    //if(Num >= 0)
      Num -= 1;
  }
  
  int GetB()
  {
    return B;
  }
  
  int GetPocketBomb()
  {
    return PocketBomb;
  }
}
