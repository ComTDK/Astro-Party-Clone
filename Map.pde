class Map
{
  Blocks[] block;
  int NumOfBlocks = -1;
  Map()
  {
    block = new Blocks[100];
  }
  
  void AddBlock(float x1, float y1, float x2, float y2)
  {
    NumOfBlocks += 1;
    block[NumOfBlocks] = new Blocks(x1, y1, x2, y2);
  }
  
  void display()
  {
    for(int i = 0; i <= NumOfBlocks; ++i)
      block[i].display();
  }
  
  int DetectCollisionBetweenJetAndBlock(float xpos, float ypos)
  {
    for(int i = 0; i <= NumOfBlocks; ++i)
      if(block[i].CheckInside(xpos, ypos))
        return i;
    return -1;
  }
  
  boolean DetectCollisionBetweenItemsAndBlock(float xpos, float ypos, float radius)
  {
    for(int i = 0; i <= NumOfBlocks; ++i)
      if(block[i].CheckCollision(xpos, ypos, radius))
        return true;
    return false;
  }
}
