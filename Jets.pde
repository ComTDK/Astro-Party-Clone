class Jets
{
  float xpos, ypos, alpha, OriginalX, OriginalY;
  Bullet Bl1;
  PImage Jet;
  int NumOfBullets = -1, OutOfBullets = 0, Time = 0;
  float speed;
  int move, shoot, colo, y, score = 0, TypeOfBullet = 0, OpponentScore = 0;
  boolean[] keys;
  float[] TriangleBoundary; //x1, y1, x2, y2, x3, y3
  float[] Blocks;
  bomb Bom;
  LaserBeam Laser;
  Map map;
  /*
    Idea for Collision between Jet and Bullet
    draw the jet boundary as a triangle since the shape of the jet is technically triangle
    find the intersection of the line equation of the path of bullet and 3 line making up the triangle
    if the bullet locate between two intersection point --> the bullet is inside the jet
    otherwise, the bullet is outside  
  */
  
  Jets(int moving, int shooting, int colorr, int x, int y, PImage grap, Map m)
  {
    OriginalX = xpos = x;
    OriginalY = ypos = y;
    alpha = PI/2;
    speed = 5;
    keys = new boolean[2];
    TriangleBoundary = new float[6];
    Blocks = new float[100];
    move = moving;
    shoot = shooting;
    colo = colorr;
    keys[0] = keys[1] = false;
    map = new Map();
    map = m;
    imageMode(CENTER);
    Jet = grap; 
    Jet.resize(80, 80); 
    
    
    //Triangular Boundary of the Jet
    TriangleBoundary[0] = xpos + 24*cos(alpha);
    TriangleBoundary[1] = ypos + 24*sin(alpha);
    TriangleBoundary[2] = xpos - 28.5*cos(alpha - 0.9);
    TriangleBoundary[3] = ypos - 28.5*sin(alpha - 0.9);
    TriangleBoundary[4] = xpos - 28.5*cos(alpha + 0.9);
    TriangleBoundary[5] = ypos - 28.5*sin(alpha + 0.9);
    
    //Create Bullet
    Bl1 = new Bullet(colorr, map);
    Bom = new bomb(map);
    Laser = new LaserBeam();
  }
  
  void display(float[] TriBound)
  {
    
    fill(colo, 0, 0);
    stroke(255);
    strokeWeight(0);
    
    
   pushMatrix();
      imageMode(CENTER); 
      translate(xpos, ypos);
      rotate(PI/2 + alpha);
      image(Jet, 0, 0);
    popMatrix();
    //image(Jet, (xpos + speed*cos(alpha)), (ypos + speed*sin(alpha)));
    //if(TypeOfBullet == 0)
    {
      Bl1.Moving();
      Bl1.display();
    }
    
    //if(Bom.GetB() <= 1)

    for(int i = 0; i <= 2; ++i)
      if(Bom.CheckCollisionBetweenJetAndExplosion(TriBound, i))
        OpponentScore = 1;

            
    Bom.display(TriBound);
    Bom.moving();
    for(int i = 0; i <= 2; ++i)
      Bom.CollideJet(TriBound, i);
    
    Laser.display();
    if(Laser.CollideJet(TriBound))
      OpponentScore = 1;

            
    if(Laser.GetTime() == 6)
      speed = -speed/2.8;
  
    fill(colo, 0, 0);
    textSize(50);
    text(score, OriginalX, 50);
    //triangle(TriangleBoundary[0], TriangleBoundary[1], TriangleBoundary[2], TriangleBoundary[3], TriangleBoundary[4], TriangleBoundary[5]);
  }
  
  float[] CheckCollision(float[] TriBound, float[] TriangleBoundary)
  {
    float[] SideJetEquation;
    SideJetEquation = new float[6];
    for(int i = 0; i <= 2; ++i)
    {
      SideJetEquation[2*i] = (TriBound[(2*i + 1)%6] - TriBound[(2*(i + 1) + 1)%6])/(TriBound[(2*i)%6] - TriBound[(2*(i + 1))%6]);
      SideJetEquation[2*i + 1] = TriBound[(2*i + 1)%6] - TriBound[2*(i)%6]*SideJetEquation[2*i];
      
      for(int j = 0; j <= 2; ++j)
      {
         //equation of the triangle line of this Jet
         float a = (TriangleBoundary[(2*j + 1)%6] - TriangleBoundary[(2*(j + 1) + 1)%6])/(TriangleBoundary[(2*j)%6] - TriangleBoundary[(2*(j + 1))%6]);
         float b = TriangleBoundary[(2*j + 1)%6] - TriangleBoundary[2*(j)%6]*a;
  
         //intersection
         float X = (b - SideJetEquation[2*i + 1])/(SideJetEquation[2*i] - a);
         float Y = a*X + b;
  
         //check if the intersection is on the line
         float BoundaryXmin = min((TriangleBoundary[(2*j)%6]), TriangleBoundary[(2*(j + 1))%6]);
         float BoundaryXmax = max((TriangleBoundary[(2*j)%6]), TriangleBoundary[(2*(j + 1))%6]);
         float BoundaryYmin = min((TriangleBoundary[(2*j + 1)%6]), TriangleBoundary[(2*(j + 1) + 1)%6]);
         float BoundaryYmax = max((TriangleBoundary[(2*j + 1)%6]), TriangleBoundary[(2*(j + 1) + 1)%6]);
         if((X >= BoundaryXmin && X <= BoundaryXmax) && (Y >= BoundaryYmin && Y <= BoundaryYmax))
         {
           BoundaryXmin = min((TriBound[(2*i)%6]), TriBound[(2*(i + 1))%6]);
           BoundaryXmax = max((TriBound[(2*i)%6]), TriBound[(2*(i + 1))%6]);
           BoundaryYmin = min((TriBound[(2*i + 1)%6]), TriBound[(2*(i + 1) + 1)%6]);
           BoundaryYmax = max((TriBound[(2*i + 1)%6]), TriBound[(2*(i + 1) + 1)%6]);
           if((X >= BoundaryXmin && X <= BoundaryXmax) && (Y >= BoundaryYmin && Y <= BoundaryYmax))
             return new float[] {atan(SideJetEquation[2*i]), i};
        }
      }
    }
    return new float[] {-1, -1};
  }
  
  void MotionAfterCollision(float[] TriBound)
  {
    int state = 0;
    if(ypos + speed*sin(alpha) > 70 && ypos + speed*sin(alpha) < 930)
    {
        float[] D;
        D = new float[10];
        D = TriangleBoundary;
        D[1] += speed*sin(alpha);
        D[3] += speed*sin(alpha);
        D[5] += speed*sin(alpha);
        float[] n;
        n = new float[2];
        n = CheckCollision(TriBound, D);
        if(n[1] > -1)
        {       
          D[1] -= 2*speed*sin(alpha);
          D[3] -= 2*speed*sin(alpha);
          D[5] -= 2*speed*sin(alpha);
          n = CheckCollision(TriBound, D);
          if(n[1] == -1)
          {
            ypos -= speed*sin(alpha);
            state += 10;
          }
          else state += 1;
          D[1] += 3*speed*sin(alpha);
          D[3] += 3*speed*sin(alpha);
          D[5] += 3*speed*sin(alpha);
        }
        else
        {
          ypos += speed*sin(alpha);
          int num = map.DetectCollisionBetweenJetAndBlock(xpos + 4*speed*cos(alpha), ypos + 4*speed*sin(alpha));        
          if(num != -1)
            ypos -= speed*sin(alpha);
        }
        D[1] -= speed*sin(alpha);
        D[3] -= speed*sin(alpha);
        D[5] -= speed*sin(alpha);
    }
    if(xpos + speed*cos(alpha) > 70 && xpos + speed*cos(alpha) < 930)
    {
        float[] D;
        D = new float[10];
        D = TriangleBoundary;
        D[0] += speed*cos(alpha);
        D[2] += speed*cos(alpha);
        D[4] += speed*cos(alpha);
        float[] n;
        n = new float[2];
        n = CheckCollision(TriBound, D);
        if(n[1] > -1)
        {
          D[0] -= 2*speed*cos(alpha);
          D[2] -= 2*speed*cos(alpha);
          D[4] -= 2*speed*cos(alpha);
          n = CheckCollision(TriBound, D);
          if(n[1] == -1)
          {
            xpos -= speed*cos(alpha);
            state += 12;
          }
          else state += 1;
        }
        else
        {
          xpos += speed*cos(alpha);
          int num = map.DetectCollisionBetweenJetAndBlock(xpos + 4*speed*cos(alpha), ypos + 4*speed*sin(alpha));      
          if(num != -1)
            xpos -= speed*cos(alpha);
        }
    }
    
     if(state == 21)
     {
       xpos += speed*cos(alpha); 
       ypos += speed*sin(alpha);
       xpos -= 3*speed*cos(alpha);
       int num = map.DetectCollisionBetweenJetAndBlock(xpos, ypos);      
       if(num != -1)
        xpos += 3*speed*cos(alpha);
        
     }
     else
     if(state == 2)
     {
       ypos += speed*sin(alpha);
       xpos += speed*cos(alpha);
       int num = map.DetectCollisionBetweenJetAndBlock(xpos, ypos);      
       if(num != -1)
       {
          xpos -= speed*cos(alpha);
          ypos -= speed*sin(alpha);
       }
     }
     else
     {
       int num = map.DetectCollisionBetweenJetAndBlock(xpos, ypos);      
       if(num != -1)
       if(state == 12)
         xpos += speed*cos(alpha);
       else if(state == 10)
         ypos += speed*cos(alpha);
     }
  }
  
  void Moving(float[] TriBound)
  {
    float slope = 0, x = 0, y = 0;
    
    MotionAfterCollision(TriBound);
    
    //update TriangleBoundary
    float C = 0.7;
    TriangleBoundary[0] = xpos + 26*cos(alpha);
    TriangleBoundary[1] = ypos + 26*sin(alpha);
    TriangleBoundary[2] = xpos - 30.5*cos(alpha - C);
    TriangleBoundary[3] = ypos - 30.5*sin(alpha - C);
    TriangleBoundary[4] = xpos - 30.5*cos(alpha + C);
    TriangleBoundary[5] = ypos - 30.5*sin(alpha + C);
    

    
    
    //println(TriangleBoundary);
    //moving out of the screen
    if(ypos < 0 || ypos >= 1000)
    {
      if(cos(alpha) == 0)
        ypos = 1000 - ypos;  
       else 
       {
           x = 0;
           slope = ypos + tan(alpha)*(x - xpos);
           if(slope > 0 && slope < 1000)
           {
             ypos = slope;
             xpos = 0;
           }
           else
           {
             x = 999;
             slope = ypos + tan(alpha)*(x - xpos);
             if(slope > 0 && slope < 1000)
             {
               ypos = slope;
               xpos = 999;
             }
             else
             {       
               xpos += (1000 - speed*ypos)/tan(alpha);
               ypos = 1000 - ypos;
             }
           }           
       }       
    }
    
    if(xpos < 0 || xpos >= 1000)
    {
      if(sin(alpha) == 0)
        xpos = 1000 - xpos;  
       else 
       {
           y = 0;
           slope = xpos + 1/tan(alpha)*(y - ypos);
           if(slope > 0 && slope < 1000)
           {
             xpos = slope;
             ypos = 0;
           }
           else
           {
             y = 999;
             slope = xpos + 1/tan(alpha)*(y - ypos);
             if(slope > 0 && slope < 1000)
             {
               xpos = slope;
               ypos = 999;
             }
             else
             {       
               ypos += (1000 - speed*xpos)*tan(alpha);
               xpos = 1000 - xpos;
             }
           }           
       }
    }    
  }
  
  void Shooting()
  {
    if(TypeOfBullet == 0)
      Bl1.AddBullets(NumOfBullets, xpos, ypos, alpha, 10);
      
    if(TypeOfBullet == 1)
    {
        Bom.Add(xpos, ypos, alpha);
        if(Bom.GetB() > Bom.GetPocketBomb() - 1)
          TypeOfBullet = 0;      
    }

    if(TypeOfBullet == 2)
    {
      Laser.Add(xpos, ypos, alpha);
      speed = -2.8*speed;
      TypeOfBullet = 0;
    }
  }
  
  //Collision between Jet and Jet
  
  
  void keyPressed(int i) 
  {
    //keys[i] = true;
    
    if(i == 0)
    {
      alpha -= PI/20;
      //translate(50, 50);      
    }
    
    if(i == 1)
    {
      NumOfBullets = Bl1.GetNumOfBullets();
      if(NumOfBullets < Bl1.GetBulletInPocket() && TypeOfBullet == 0) 
      {
        NumOfBullets += 1;
        Shooting();
      }      
      
      if(TypeOfBullet == 1)
      {
        Shooting();
      }
      
      if(TypeOfBullet == 2)
      {
        Shooting();
      }
      //println("shoot " + keys[1]);
    }
  }
  
  void keyReleased()
  {
    if(key == char(move))
      keys[0] = false;
      
    if(key == CODED)
    if(keyCode == move) 
      keys[0] = false;       
    
    if(key == char(shoot))
    {
      keys[1] = false;
      //println(key + " Released " + keys[1]);
    }
  }
  
  //Collision between opponent Jet and bomb
  
  
  //Collision between bullet and Jet
  boolean CheckCollision1(float[] Bull, float BulletX, float BulletY)
  {
     float[] BulletEquation;
     BulletEquation = new float[100];
     BulletEquation = Bull;
     float[] Xinter, Yinter;
     Xinter = new float[3];
     Yinter = new float[3];
     int NumOfIntersect = -1;
     //Check the intersection between equation of bullet and equation of each line of the triangle boundary

     for(int j = 0; j <= 2; ++j)
     {
       //equation of the triangle line
       float a = (TriangleBoundary[(2*j + 1)%6] - TriangleBoundary[(2*(j + 1) + 1)%6])/(TriangleBoundary[(2*j)%6] - TriangleBoundary[(2*(j + 1))%6]);
       float b = TriangleBoundary[(2*j + 1)%6] - TriangleBoundary[2*(j)%6]*a;

       //intersection
       float X = (b - BulletEquation[2*i + 1])/(BulletEquation[2*i] - a);
       float Y = a*X + b;

       //check if the intersection is on the line
       float BoundaryXmin = min((TriangleBoundary[(2*j)%6]), TriangleBoundary[(2*(j + 1))%6]);
       float BoundaryXmax = max((TriangleBoundary[(2*j)%6]), TriangleBoundary[(2*(j + 1))%6]);
       float BoundaryYmin = min((TriangleBoundary[(2*j + 1)%6]), TriangleBoundary[(2*(j + 1) + 1)%6]);
       float BoundaryYmax = max((TriangleBoundary[(2*j + 1)%6]), TriangleBoundary[(2*(j + 1) + 1)%6]);
       if((X >= BoundaryXmin && X <= BoundaryXmax) && (Y >= BoundaryYmin && Y <= BoundaryYmax))
       {
           Xinter[++NumOfIntersect] = X;
           Yinter[NumOfIntersect] = Y;
           
       }
       
     }
     
     //Check if the bullet is inside the jet
     if(NumOfIntersect >= 1)
     {
       float BoundInterXmin = min(Xinter[0], Xinter[1]);
       float BoundInterXmax = max(Xinter[0], Xinter[1]);
       float BoundInterYmin = min(Yinter[0], Yinter[1]);
       float BoundInterYmax = max(Yinter[0], Yinter[1]);
       
       if(BulletX >= BoundInterXmin && BulletX <= BoundInterXmax && BulletY >= BoundInterYmin && BulletY <= BoundInterYmax)
       {
         //score += 1;
         return true;
       }
     }
     return false;
  }
  
  boolean CheckCollision2(float[] TriBound) //y = ax + b
  {
    float[] SideJetEquation;
    SideJetEquation = new float[6];
    for(int i = 0; i <= 2; ++i)
    {
      SideJetEquation[2*i] = (TriBound[(2*i + 1)%6] - TriBound[(2*(i + 1) + 1)%6])/(TriBound[(2*i)%6] - TriBound[(2*(i + 1))%6]);
      SideJetEquation[2*i + 1] = TriBound[(2*i + 1)%6] - TriBound[2*(i)%6]*SideJetEquation[2*i];
      
      for(int j = 0; j <= 2; ++j)
      {
         //equation of the triangle line of this Jet
         float a = (TriangleBoundary[(2*j + 1)%6] - TriangleBoundary[(2*(j + 1) + 1)%6])/(TriangleBoundary[(2*j)%6] - TriangleBoundary[(2*(j + 1))%6]);
         float b = TriangleBoundary[(2*j + 1)%6] - TriangleBoundary[2*(j)%6]*a;
  
         //intersection
         float X = (b - SideJetEquation[2*i + 1])/(SideJetEquation[2*i] - a);
         float Y = a*X + b;
  
         //check if the intersection is on the line
         float BoundaryXmin = min((TriangleBoundary[(2*j)%6]), TriangleBoundary[(2*(j + 1))%6]);
         float BoundaryXmax = max((TriangleBoundary[(2*j)%6]), TriangleBoundary[(2*(j + 1))%6]);
         float BoundaryYmin = min((TriangleBoundary[(2*j + 1)%6]), TriangleBoundary[(2*(j + 1) + 1)%6]);
         float BoundaryYmax = max((TriangleBoundary[(2*j + 1)%6]), TriangleBoundary[(2*(j + 1) + 1)%6]);
         if((X >= BoundaryXmin && X <= BoundaryXmax) && (Y >= BoundaryYmin && Y <= BoundaryYmax))
         {
           BoundaryXmin = min((TriBound[(2*i)%6]), TriBound[(2*(i + 1))%6]);
           BoundaryXmax = max((TriBound[(2*i)%6]), TriBound[(2*(i + 1))%6]);
           BoundaryYmin = min((TriBound[(2*i + 1)%6]), TriBound[(2*(i + 1) + 1)%6]);
           BoundaryYmax = max((TriBound[(2*i + 1)%6]), TriBound[(2*(i + 1) + 1)%6]);
           if((X >= BoundaryXmin && X <= BoundaryXmax) && (Y >= BoundaryYmin && Y <= BoundaryYmax))
             return true;
        }
         
      }
    }  
    return false;
  }
  
  
  void ChangeScore()
  {
    score += 1;
  }
  
  float GetAlpha()
  {
    return alpha;
  }
  
  float GetXpos()
  {
    return xpos;
  }
  
  float GetYpos()
  {
    return ypos;
  }
  
  float GetSpeed()
  {
    return speed;
  }
  
  float GetTriBound(int i)
  {
    return TriangleBoundary[i];  
  }
  
  float[] GetAllTriBounds()
  {
    return TriangleBoundary;
  }
  
  void ChangeBulletType(int x)
  {
    TypeOfBullet = x;
    if(x == 1)
      Bom.Pocket();
    if(x == 2)
      Laser.Pocket();
  }
  
  int GetOpponentScore()
  {
    int temp = OpponentScore;
    OpponentScore = 2;
    if(temp == 1)
      return temp;
    else return 0;
  }
  
  int GetScore()
  {
    return score;
  }
}
