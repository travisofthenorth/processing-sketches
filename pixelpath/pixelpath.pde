/* @pjs preload="bucky-small.png"; */
PImage img;
ArrayList<Pixel> movingPixels;
int lastMouseX, lastMouseY;

String [] directions = { "left", "right", "up", "down" };

void setup()
{
  img = loadImage("bucky-small.png");
  size(img.width, img.height);
  reset();
}

void draw()
{ 
  loadPixels();
  for (int i = movingPixels.size() - 1; i >= 0; i--) {
    Pixel pixel = movingPixels.get(i);
    pixel.update();
    
    if (pixel.dead()) {
      movingPixels.remove(i);
    }
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
      if (!outOfBounds(x, y)) {
        movingPixels.add(new Pixel(x, y));
      }
    }
  }
  
  lastMouseX = mouseX;
  lastMouseY = mouseY;
}

boolean outOfBounds(int px, int py) {
  if (px < 0 || px >= width)
    return true;
  if (py < 0 || py >= height)
    return true;
  return false;
}

String randomItem(ArrayList<String> list) {
  int rdmIndex = (int)random(list.size());
  return list.get(rdmIndex);
}

class Pixel { 
  private String direction;
  private int posx, posy;
  private int velocity;
  
  Pixel (int px, int py) {  
    posx = px;
    posy = py;
    velocity = 300;
    changeDirection();
  }
  
  void setVelocity(int v) {
    velocity = v;
  }
  
  void setDirection(String d) {
    direction = d;
  }
  
  void update() {
    for(int i = 0; i < int(velocity/100); i++) {
      move();
    }
    
    if (shouldMoveAgain()) {
      move();
    }

    velocity--;
  } 
  
  boolean dead() {
    return velocity == 0;
  }
  
  private boolean shouldMoveAgain() {
    int remainder = velocity % 100;
    
    if (remainder > 0) {
      return int(random(0, 100-remainder)) < 10;
    }
    
    return false;
  }
  
  private void move() {
    int newx = posx + dx();
    int newy = posy + dy();
    
    if (!outOfBounds(newx, newy) && !outOfBounds(posx, posy)) {
      color currentPixel = pixelAtPos(posx, posy);
      color newPixel = pixelAtPos(newx, newy);
      setPixelAtPos(posx, posy, newPixel);
      setPixelAtPos(newx, newy, currentPixel);
    }
   
    if ((int)random(100) == 1) {
      changeDirection();
    }
      
    posx = newx;
    posy = newy;
    fixPosX();
    fixPosY();
  }
  
  private void changeDirection() {
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
      posx = 0;
      changeDirection();
    } else if (posx >= width - 1 && direction == "right") {
      posx = width - 1;
      changeDirection();
    }
  }
  
  private void fixPosY() {
    if (posy <= 0 && direction == "up") {
      posy = 0;
      changeDirection();
    } else if (posy >= height - 1 && direction == "down") {
      posy = height - 1;
      changeDirection();
    }
  }
  
  private color pixelAtPos(int x, int y) {
    return pixels[y*width + x];
  }
  
  private void setPixelAtPos(int x, int y, color c) {
    pixels[y*width + x] = c;
  }
} 
