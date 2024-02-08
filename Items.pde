class item
{
  int type, NumOfB = -1, NumOfLs = -1, NumOfItems = 0;
  float[] Bposition, Lsposition;
  PImage[] bom, Laser;
  Map m;
  bomb[] B;
  
  item(Map map) 
  {
    Bposition = new float[10];
    Lsposition = new float[10];
    for(int i = 0; i < 10; ++i)
    {
      Bposition[i] = 0;
      Lsposition[i] = 0;
    }
    bom = new PImage[4];
    Laser = new PImage[4];
    m = new Map();
    m = map;
  }
  
  void display()
  {
    for(int i = 0; i <= NumOfB; ++i)
    {
      image(bom[i], Bposition[2*i], Bposition[2*i + 1]);    
    }
    for(int i = 0; i <= NumOfLs; ++i)
    {
      image(Laser[i], Lsposition[2*i], Lsposition[2*i + 1]);
    }
  }
  
  void Generate()
  {
    if(NumOfB < 3)
    {
      NumOfB += 1;
      bom[NumOfB] = loadImage("Bomb icon.jpg");
      bom[NumOfB].resize(30, 30);
      Bposition[2*NumOfB] = random(800)%900 + 70;
      Bposition[2*NumOfB + 1] = random(800)%900 + 70;
      while(m.DetectCollisionBetweenItemsAndBlock(Bposition[2*NumOfB], Bposition[2*NumOfB + 1], 16))
      {
        Bposition[2*NumOfB] = random(800)%900 + 70;
        Bposition[2*NumOfB + 1] = random(800)%900 + 70;
      }
    }
    
    if(NumOfLs < 3)
    {
      NumOfLs += 1;
      Laser[NumOfLs] = loadImage("Laser Icon.jpg");
      Laser[NumOfLs].resize(30, 45);
      Lsposition[2*NumOfLs] = random(800)%900 + 70;
      Lsposition[2*NumOfLs + 1] = random(800)%900 + 70;
      while(m.DetectCollisionBetweenItemsAndBlock(Lsposition[2*NumOfLs], Lsposition[2*NumOfLs + 1], 16))
      {
        Lsposition[2*NumOfLs] = random(800)%900 + 70;
        Lsposition[2*NumOfLs + 1] = random(800)%900 + 70;
      }
    }
    
  }
  
  //Collision between Jet and Item
  int Collision(float[] TriBound)
  {
    float[] SideJetEquation;
    SideJetEquation = new float[6];
    //Jet and Bomb Icon
    for(int i = 0; i <= 2; ++i)
    for(int j = 0; j <= NumOfB; ++j)
    {
      SideJetEquation[2*i] = (TriBound[(2*i + 1)%6] - TriBound[(2*(i + 1) + 1)%6])/(TriBound[(2*i)%6] - TriBound[(2*(i + 1))%6]);//a
      SideJetEquation[2*i + 1] = TriBound[(2*i + 1)%6] - TriBound[2*(i)%6]*SideJetEquation[2*i];//b
      
      //Intersection
      float a1 = SideJetEquation[2*i]*SideJetEquation[2*i] + 1;
      float a2 = -(2*Bposition[2*j] - 2*SideJetEquation[2*i]*(SideJetEquation[2*i + 1] - Bposition[2*j + 1]));
      float a3 = Bposition[2*j]*Bposition[2*j] + (SideJetEquation[2*i + 1] - Bposition[2*j + 1])*(SideJetEquation[2*i + 1] - Bposition[2*j + 1]) - 15*15;
      float delta = a2*a2 - 4*a1*a3;
      if(delta >= 0)
      {
        float x1 = (-a2 + sqrt(delta))/(2*a1), x2 = (-a2 - sqrt(delta))/(2*a1);
        float y1 = SideJetEquation[2*i]*x1 + SideJetEquation[2*i + 1], y2 = SideJetEquation[2*i]*x2 + SideJetEquation[2*i + 1];
        
        //Chech if the intersection is on the line
        float BoundaryXmin = min((TriBound[(2*i)%6]), TriBound[(2*(i + 1))%6]);
        float BoundaryXmax = max((TriBound[(2*i)%6]), TriBound[(2*(i + 1))%6]);
        float BoundaryYmin = min((TriBound[(2*i + 1)%6]), TriBound[(2*(i + 1) + 1)%6]);
        float BoundaryYmax = max((TriBound[(2*i + 1)%6]), TriBound[(2*(i + 1) + 1)%6]);
        if((x1 >= BoundaryXmin && x1 <= BoundaryXmax) && (y1 >= BoundaryYmin && y1 <= BoundaryYmax))
        {
          return j;
        }
        if((x2 >= BoundaryXmin && x2 <= BoundaryXmax) && (y2 >= BoundaryYmin && y2 <= BoundaryYmax))
        {
          return j;
        }
      }
    }
    
    //Jet and Laser Icon
    
      //float[] SideJetEquation;
      //SideJetEquation = new float[6];
      //Jet and Bomb Icon
      for(int i = 0; i <= 2; ++i)
      for(int j = 0; j <= NumOfLs; ++j)
      {
        SideJetEquation[2*i] = (TriBound[(2*i + 1)%6] - TriBound[(2*(i + 1) + 1)%6])/(TriBound[(2*i)%6] - TriBound[(2*(i + 1))%6]);//a
        SideJetEquation[2*i + 1] = TriBound[(2*i + 1)%6] - TriBound[2*(i)%6]*SideJetEquation[2*i];//b
        
        //Intersection
        float a1 = SideJetEquation[2*i]*SideJetEquation[2*i] + 1;
        float a2 = -(2*Lsposition[2*j] - 2*SideJetEquation[2*i]*(SideJetEquation[2*i + 1] - Lsposition[2*j + 1]));
        float a3 = Lsposition[2*j]*Lsposition[2*j] + (SideJetEquation[2*i + 1] - Lsposition[2*j + 1])*(SideJetEquation[2*i + 1] - Lsposition[2*j + 1]) - 18*18;
        float delta = a2*a2 - 4*a1*a3;
        if(delta >= 0)
        {
          float x1 = (-a2 + sqrt(delta))/(2*a1), x2 = (-a2 - sqrt(delta))/(2*a1);
          float y1 = SideJetEquation[2*i]*x1 + SideJetEquation[2*i + 1], y2 = SideJetEquation[2*i]*x2 + SideJetEquation[2*i + 1];
          
          //Chech if the intersection is on the line
          float BoundaryXmin = min((TriBound[(2*i)%6]), TriBound[(2*(i + 1))%6]);
          float BoundaryXmax = max((TriBound[(2*i)%6]), TriBound[(2*(i + 1))%6]);
          float BoundaryYmin = min((TriBound[(2*i + 1)%6]), TriBound[(2*(i + 1) + 1)%6]);
          float BoundaryYmax = max((TriBound[(2*i + 1)%6]), TriBound[(2*(i + 1) + 1)%6]);
          if((x1 >= BoundaryXmin && x1 <= BoundaryXmax) && (y1 >= BoundaryYmin && y1 <= BoundaryYmax))
          {
            return j + 4;
          }
          if((x2 >= BoundaryXmin && x2 <= BoundaryXmax) && (y2 >= BoundaryYmin && y2 <= BoundaryYmax))
          {
            return j + 4;
          }
        }
      }
    
    return -1;
  }
  
  void Clean(int index)
  {
    if(index < 4)
    {
      for(int i = index; i <= NumOfB + 1; ++i)
      {
        Bposition[2*i] = Bposition[2*(i + 1)];
        Bposition[2*i + 1] = Bposition[2*(i + 1) + 1];
      }
      NumOfB -= 1;
    }
    
    if(index >= 4)
    {
      index -= 4;
      for(int i = index; i <= NumOfB + 1; ++i)
      {
        Lsposition[2*i] = Lsposition[2*(i + 1)];
        Lsposition[2*i + 1] = Lsposition[2*(i + 1) + 1];
      }
      NumOfLs -= 1;
    }
  }
  
  int GetNumberOfItems()
  {
    return NumOfB + NumOfLs;
  }
}
