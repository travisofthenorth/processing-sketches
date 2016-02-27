int [] ripple;
int index;
int lastIndex;

void setup()
{
  size(500,500);
  ripple = new int[width*height*2];
  background(255);
  
  index = 0;
  lastIndex = width*height;
  for(int i = 0; i < width*height*2; i++)
    ripple[i] = 0;
}

void draw()
{
  int i = index;
  index = lastIndex;
  lastIndex = i;
  updateRipples(lastIndex, index);
  drawRipples();
}

void drawRipples()
{
  color white = color(255, 255, 255);
  loadPixels();
  for(int x = 1; x < width-1; x++) {
    for(int y = 1; y < height-1; y++) {
      int i = y*width + x;
      int s = i + index;
      int dx = (ripple[s-1] - ripple[s+1]) / 4;
      int dy = (ripple[s-width] - ripple[s+width]) / 4;
      pixels[i] = blendColor(white,color(4*dx,4*dx,4*dx),SUBTRACT);
    }
  }
  updatePixels();
}

void mouseReleased()
{
  createRipple(mouseX, mouseY);
}

void mouseDragged()
{
  createRipple(mouseX, mouseY);
}

void createRipple(int mx, int my)
{
  for(int y = 0; y < height; y++) {
    for(int x = 0; x < width; x++) {
      if(x > mx-3 && x < mx+3 && y > my-3 && y < my+3)
        ripple[y*width + x + index] = 512;
    }
  }
}

void updateRipples(int src, int dest)
{
  for(int x = 1; x < width-1; x++) {
    for(int y = 1; y < height-1; y++) {
      int i = y*width + x;
      int s = i + src;
      int d = i + dest;
      ripple[d] = ((ripple[s-1] + ripple[s+1] + ripple[s-width] + ripple[s+width]) >> 1) - ripple[d];
      ripple[d] -= ripple[d] >> 5;
    }
  }
}
