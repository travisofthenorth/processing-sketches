int [] ripple;
int index;
int lastIndex;

void setup()
{
  size(300,300);
  ripple = new int[width*height*2];
  background(255);
  
  index = 0;
  lastIndex = width*height;
  for(int i = 0; i < width*height*2; i++) {
    ripple[i] = 0;
  }
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
  color white = color(255);
  loadPixels();
  for(int x = 1; x < width-1; x++) {
    for(int y = 1; y < height-1; y++) {
      int i = y*width + x;
      int s = i + index;
      int delta = (ripple[s-1] - ripple[s+1]);
      
      if (delta != 0) {
        pixels[i] = blendColor(white, color(delta, delta, delta), SUBTRACT);
      } else {
        pixels[i] = white;
      }
    }
  }
  updatePixels();
}

void mouseMoved()
{
  createRipple(mouseX, mouseY);
}

void createRipple(int mx, int my)
{
  for(int x = mx - 2; x < mx + 3; x++) {
    for(int y = my - 2; y < my + 3; y++) {
      if(x > 0 && x < width && y > 0 && y < height)
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
