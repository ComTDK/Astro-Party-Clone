Jets jet1, jet2;
PImage galaxy, BlueJet, RedJet, winner;
boolean[] keys;
int i = 0;
Map[] map;
item I;
LaserBeam Laser;
float Wait = 0;

void setup()
{
  size(1000, 1000);
  BlueJet = loadImage("blue astro.png"); 
  RedJet = loadImage("red astro.png");
  map = new Map[10];
  for(int i = 0; i <= 2; ++i)
    map[i] = new Map();
  jet1 = new Jets(RIGHT, '0', 255, 100, 100, BlueJet, map[0]);
  jet2 = new Jets('a', ' ', #FF0303, 900, 900, RedJet, map[0]);
  keys = new boolean[10];
  galaxy = loadImage("Galaxy.jpg"); 
  galaxy.resize(1000, 1000); 
  winner = loadImage("WinningBackGround.jpg"); 
  winner.resize(1000, 1000); 
  Laser = new LaserBeam();
  for(int i = 0; i < 10; ++i)
    keys[i] = false;
  
  map[0].AddBlock(50, height/2 - 35, 250, 70);
  map[0].AddBlock(width - 50, height/2 - 35, -250, 70);
  map[0].AddBlock(width/2 - 35, 50, 70, 250);
  map[0].AddBlock(width/2 - 35, height - 50, 70, -250);
  
  I = new item(map[0]);
  I.Generate();
}

void draw()
{
  if(jet1.GetScore() == 0 && jet2.GetScore() == 0)
  {
    background(galaxy);
    noFill();
    
    //boundary
    stroke(204, 102, 0);
    strokeWeight(10);
    fill(255, 0, 0);
    line(50, 50, 50, 950);
    line(50, 50, 950, 50);
    line(950, 950, 950, 50);
    line(950, 950, 50, 950);
   
    map[0].display();
    jet1.Moving(jet2.GetAllTriBounds());
    jet1.display(jet2.GetAllTriBounds());
    
    jet2.Moving(jet1.GetAllTriBounds());
    jet2.display(jet1.GetAllTriBounds());
    
    if(jet2.GetOpponentScore() > 0)
      jet2.ChangeScore();
    if(jet1.GetOpponentScore() > 0)
      jet1.ChangeScore();
    //check collision between bullet and jets
    CollisionBetweenBulletAndJets();
    CollisionBetweenJetAndItems();
    
    //Generate Items
    if(I.GetNumberOfItems() < -1 && Wait == 0)
      Wait = millis() + 10000;
  
    if(I.GetNumberOfItems() < -1 && Wait < millis())
    {
      for(int i = 0; i < 1; ++i)
        I.Generate();
      Wait = 0;
    }
    
    for(int i = 0; i < 10; ++i)
      if(keys[i])
        keyPress(i);
        
    I.display();
    //Laser.display();
  }
  if(jet1.GetScore() > 0 || jet2.GetScore() > 0)  
    AnnounceWinner();
}

void AnnounceWinner()
{
  background(0);
  
  
  if(jet2.GetScore() > 0)  
  {
    fill(255, 0, 0);
    text("Winner red Jet", 300, 500);
  }
  if(jet1.GetScore() > 0)  
  {
    fill(#1F33DB);
    text("Winner blue Jet", 300, 500);
  }
}

void CollisionBetweenBulletAndJets()
{
  //Bullet 2 with Jet 1
  float[] BulletEquation;
  BulletEquation = new float[100];
  BulletEquation = jet2.Bl1.GetBulletEquation();
  for(int i = 0; i <= jet2.Bl1.GetNumOfBullets(); ++i)
    if(jet2.Bl1.GetRadius(i) > 0)
      if(jet1.CheckCollision1(BulletEquation, jet2.Bl1.GetXPositionOfBullet(i), jet2.Bl1.GetYPositionOfBullet(i)))
      {
        jet2.Bl1.ChangeRadius(i, 0);
        jet2.ChangeScore();
      }
  
  //Bullet 1 with Jet 2
  BulletEquation = jet1.Bl1.GetBulletEquation();
  for(int i = 0; i <= jet1.Bl1.GetNumOfBullets(); ++i)
    if(jet1.Bl1.GetRadius(i) > 0)
      if(jet2.CheckCollision1(BulletEquation, jet1.Bl1.GetXPositionOfBullet(i), jet1.Bl1.GetYPositionOfBullet(i)))
      {
        jet1.Bl1.ChangeRadius(i, 0);
        jet1.ChangeScore();
      }
}

/*void CollisionBetweenJetAndJet()
{
  //jet2 touch jet1
  float[] E;
  E = new float[6];
  E = jet2.GetAllTriBounds();
  if(jet1.CheckCollision2(E))
  {
    for(int i = 0; i <= 2; ++i)
      E[2*i] += jet2.GetSpeed()*cos(jet2.GetAlpha());
    if(jet1.CheckCollision2(E))
    {
      for(int i = 0; i <= 2; ++i)
      {
        E[2*i] -= jet2.GetSpeed()*cos(jet2.GetAlpha());
        E[2*i + 1] += jet2.GetSpeed()*sin(jet2.GetAlpha());
      }
      
      if(jet1.CheckCollision2(E))
        jet2.ChangePos(-jet2.GetSpeed()*cos(jet2.GetAlpha()), -jet2.GetSpeed()*sin(jet2.GetAlpha()));
      else jet2.ChangePos(0, jet2.GetSpeed()*sin(jet2.GetAlpha()));
    }
    else jet2.ChangePos(jet2.GetSpeed()*cos(jet2.GetAlpha()), 0);
    
  }
  
  //jet1 touch jet2
  E = jet1.GetAllTriBounds();
  if(jet2.CheckCollision2(E))
  {
    for(int i = 0; i <= 2; ++i)
      E[2*i] += jet1.GetSpeed()*cos(jet1.GetAlpha());
    if(jet2.CheckCollision2(E))
    {
      for(int i = 0; i <= 2; ++i)
      {
        E[2*i] -= jet1.GetSpeed()*cos(jet1.GetAlpha());
        E[2*i + 1] += jet1.GetSpeed()*sin(jet1.GetAlpha());
      }
      
      if(jet2.CheckCollision2(E))
        jet1.ChangePos(-jet1.GetSpeed()*cos(jet1.GetAlpha()), -jet1.GetSpeed()*sin(jet1.GetAlpha()));
      else jet1.ChangePos(0, jet1.GetSpeed()*sin(jet1.GetAlpha()));
    }
    else jet1.ChangePos(jet1.GetSpeed()*cos(jet1.GetAlpha()), 0);
  }
}*/

void CollisionBetweenJetAndItems()
{
  //Jet1 vs Item
  int n = I.Collision(jet1.GetAllTriBounds());
  if(n > -1)
  {
    I.Clean(n);
    if(n < 4)
      jet1.ChangeBulletType(1);
    if(n >= 4)
      jet1.ChangeBulletType(2);
  }
  //Jet2 vs Item
  n = I.Collision(jet2.GetAllTriBounds());
  if(n > -1)
  {
    I.Clean(n);
    if(n < 4)
      jet2.ChangeBulletType(1);
      println(n);
    if(n >= 4)
      jet2.ChangeBulletType(2);
  }
}

void keyPressed()
{
  if(keyCode == RIGHT)
    keys[0] = true;
  /*if(keyCode == '0')
    keys[1] = true;*/
  if(keyCode == 'a' || keyCode == 'A')
    keys[2] = true;
  /*if(keyCode == ' ')
    keys[3] = true;*/
}


void keyReleased()
{
  if(keyCode == RIGHT)
  {
    keys[0] = false;
    jet1.keyReleased();
    //println("RIGHT");
  }
  if(key == '0')
  {
    jet1.keyPressed(1);
    //jet1.keyReleased();
    //println(key);
  }
  if(key == 'a' || key == 'A')
  {
    keys[2] = false;
    jet2.keyReleased();
    //println(key);
  }
  if(key == ' ')
  {
    jet2.keyPressed(1);
    //jet2.keyReleased();
    //println(key);
  }
}

void keyPress(int i) 
{  
  if(i < 2)
    jet1.keyPressed(i);
  
  if(i >= 2)
    jet2.keyPressed(i%2);
}
