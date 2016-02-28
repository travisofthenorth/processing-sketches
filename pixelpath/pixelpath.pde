PImage img;
ArrayList<Pixel> movingPixels;
int lastMouseX, lastMouseY;

//final ArrayList<String> directions = new ArrayList<String>() {{
//  add("n"); add("s"); add("e"); add("w"); add("ne"); add("nw"); add("se"); add("sw");
//}};
final ArrayList<String> directions = new ArrayList<String>() {{
  add("n"); add("s"); add("e"); add("w");
}};
final ArrayList<String> left = new ArrayList<String>() {{
  add("e"); add("ne"); add("se");
}};
final ArrayList<String> right = new ArrayList<String>() {{
  add("w"); add("nw"); add("sw");
}};
final ArrayList<String> up = new ArrayList<String>() {{
  add("n"); add("ne"); add("nw");
}};
final ArrayList<String> down = new ArrayList<String>() {{
  add("s"); add("se"); add("sw");
}};

void setup()
{
  img = loadImage("bucky.png");
  size(img.width, img.height);
  reset();
}

void draw()
{ 
  loadPixels();
  for (int i = movingPixels.size() - 1; i >= 0; i--) {
    Pixel pixel = movingPixels.get(i);
    pixel.update(millis());
    
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
        Pixel pixel = new Pixel(x, y);
//        
//        if (mouseX != 0 && mouseY != 0) {
//          int dx = mouseX - lastMouseX;
//          int dy = mouseY - lastMouseY;
//          
//          int velocity = int(sqrt(dx*dx + dy*dy));
//          velocity = min(velocity, 4);
//          pixel.setVelocity(velocity*100);
//          
//          if (abs(dx) > abs(dy)) {
//            if (dx < 0) {
//              pixel.setDirection(randomItem(left));
//            } else {
//              pixel.setDirection(randomItem(right));
//            }
//          } else if (abs(dy) > abs(dx)) {
//            if (dy < 0) {
//              pixel.setDirection(randomItem(up));
//            } else {
//              pixel.setDirection(randomItem(down));
//            }
//          }
//        }
        
        movingPixels.add(pixel);
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
  
  void update(int currentTime) {
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
      newDirection = randomItem(directions);
    }
    
    direction = newDirection;
  }
    
  private int dx() {
    if (left.contains(direction))
      return -1;
    if (right.contains(direction))
      return 1;
    return 0;
  }
  
  private int dy() {
    if (up.contains(direction))
      return -1;
    if (down.contains(direction))
      return 1;
    return 0;
  }
  
  private void fixPosX() {
    if (posx <= 0 && left.contains(direction)) {
      posx = 0;
      changeDirection();
    } else if (posx >= width - 1 && right.contains(direction)) {
      posx = width - 1;
      changeDirection();
    }
  }
  
  private void fixPosY() {
    if (posy <= 0 && up.contains(direction)) {
      posy = 0;
      changeDirection();
    } else if (posy >= height - 1 && down.contains(direction)) {
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
