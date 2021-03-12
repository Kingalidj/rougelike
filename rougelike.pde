game g;
void setup() {
  size(1200, 1200);
  g = new game();
  background(255);
}

void draw() {
  background(255);
  g.update();

}

void keyPressed() {
  if (key == 'W' || key == 'w') {
    g.p1.move(new PVector(0, -1));
  } else if (key == 'S' || key == 's') {
    g.p1.move(new PVector(0, 1));
  } else if (key == 'A' || key == 'a') {
    g.p1.move(new PVector(-1, 0));
  } else if (key == 'D' || key == 'd') {
    g.p1.move(new PVector(1, 0));
  } 

}




class hitbox {
  PVector pos;
  float w, h;

  hitbox(float x, float y, float w, float h) {
    this.w = w;
    this.h = h;
    pos = new PVector(x, y);
  }

  void updatePos(float x, float y) {
    pos = new PVector(x, y);
  }

  void show() {
    fill(0, 0, 255, 90);
    rect(pos.x, pos.y, w, h);
  }

}

boolean isOverlapping(hitbox h1, hitbox h2) {
  if (h1 == null || h2 == null) return false;
  return (abs((h1.pos.x + h1.w/2) - (h2.pos.x + h2.w/2)) * 2 < (h1.w + h2.w)) &&
    (abs((h1.pos.y + h1.h/2) - (h2.pos.y + h2.h/2)) * 2 < (h1.h + h2.h));
}

boolean isOverlapping(hitbox h1, hitbox [] hArr) {
  for (hitbox h : hArr) {
    if (isOverlapping(h1, h))return true;
  }
  return false;
}
