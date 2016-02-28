PImage img;
ArrayList<Pixel> movingPixels;

void setup()
{
  img = loadImage("bucky.png");
  size(img.width, img.height);
  reset();
}

void draw()
{ 
  loadPixels();
  for (Pixel pixel: movingPixels) {
    pixel.update();
  }
  updatePixels();
}

void reset() {
  movingPixels = new ArrayList<Pixel>();
  image(img,0,0);
}

void keyPressed()
{
  if(key == ' ') {
    reset();
  }
}

void mouseMoved()
{
  movingPixels.add(new Pixel(mouseX, mouseY));
  
  for (int x = mouseX - 5; x <= mouseX + 5; x++) {
    for (int y = mouseY - 5; y <= mouseY + 5; y++) {
      createPixel(x, y);
    }
  }
}

void createPixel(int x, int y) {
  if (!outOfBounds(x, y)) {
    movingPixels.add(new Pixel(x, y));
  }
}

boolean outOfBounds(int px, int py) {
  if (px < 0 || px >= width)
    return true;
  if (py < 0 || py >= height)
    return true;
  return false;
}

class Pixel { 
  private final String [] directions = {"up", "down", "left", "right"};
  
  private String direction;
  private int posx, posy;
  
  Pixel (int px, int py) {  
    posx = px;
    posy = py;
    setDirection();
  }
  
  void update() { 
    int newx = posx + dx();
    int newy = posy + dy();
    
    if (!outOfBounds(newx, newy) && !outOfBounds(posx, posy)) {
      color currentPixel = pixelAtPos(posx, posy);
      color newPixel = pixelAtPos(newx, newy);
      setPixelAtPos(posx, posy, newPixel);
      setPixelAtPos(newx, newy, currentPixel);
    }
   
    if ((int)random(100) == 1) {
      setDirection();
    }
      
    posx = newx;
    posy = newy;
    fixPosX();
    fixPosY();
  } 
  
  private void setDirection() {
    String newDirection = direction;
    
    while (direction == newDirection) {
      int rdmIndex = (int) random(4);
      newDirection = directions[rdmIndex];
    }
    
    direction = newDirection;
  }
    
  private int dx() {
    if (direction == "left")
      return -1;
    if (direction == "right")
      return 1;
    return 0;
  }
  
  private int dy() {
    if (direction == "up")
      return -1;
    if (direction == "down")
      return 1;
    return 0;
  }
  
  private void fixPosX() {
    if (posx <= 0 && direction == "left") {
      posx = width - 1;
    } else if (posx >= width - 1 && direction == "right") {
      posx = 0;
    }
  }
  
  private void fixPosY() {
    if (posy <= 0 && direction == "up") {
      posy = height - 1;
    } else if (posy >= height - 1 && direction == "down") {
      posy = 0;
    }
  }
  
  private color pixelAtPos(int x, int y) {
    return pixels[y*width + x];
  }
  
  private void setPixelAtPos(int x, int y, color c) {
    pixels[y*width + x] = c;
  }
} 
