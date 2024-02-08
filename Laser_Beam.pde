class LaserBeam
{
  PImage Laser;
  int NumOfLs = -1, displaytime = 0;
  float xpos = 0, ypos = 0, alpha;
  
  LaserBeam()
  {
    Laser = loadImage("Laser_Beam.png");
    //imageMode(CENTER);
    Laser.resize(1200, 190);
  }
  
  void display()
  {
    if(NumOfLs == 0)
    {
      displaytime++;
      pushMatrix();
        //imageMode(CENTER); 
        translate(xpos + 600*cos(alpha), ypos + 600*sin(alpha));
        rotate(PI + alpha);
        //Laser.resize(1200, int(9.5*displaytime));
        image(Laser, 0, 0);
      popMatrix();
      if(displaytime > 20)
        NumOfLs = -1;
    }
    
    /*image(Laser, 500, 300);
    circle(500, 300, 10);
    fill(255, 0, 0);
    strokeWeight(10);
    line(500, 290, 0, 290);*/
  }
  
  void Pocket()
  {
    NumOfLs = -1;
  }
  
  int GetTime()
  {
    return displaytime;
  }
  
  void Add(float x, float y, float angle)
  {
    displaytime = 0;
    NumOfLs += 1;
    xpos = x;
    ypos = y;
    alpha = angle;
  }
  
  boolean CollideJet(float[] TriBound)
  {
    if(NumOfLs == 0)
    {
      float x = xpos + 20*cos(alpha) - 30, y = ypos + 20*sin(alpha) - 30;
      float a1 = tan(alpha), b1 = y - a1*x; //line equation going through (x, y) and (x + 600*cos(alpha), y + 600*sin(alpha))
      x += 60;
      y += 60;
      float a2 = tan(alpha), b2 = y - a2*x; //line equation going through (x, y) and (x + 600*cos(alpha), y + 600*sin(alpha))
      
      for(int i = 0; i <= 2; ++i)
      {
        if(abs(a1*TriBound[2*i] - TriBound[2*i + 1] + b1)/(sqrt(a1*a1 + 1)) <= 60 && abs(a2*TriBound[2*i] - TriBound[2*i + 1] + b2)/(sqrt(a2*a2 + 1)) <= 60)
        {
          return true;
        }
      }
    }
      return false;
  }
}
