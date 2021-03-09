class player {
  PVector pos = new PVector(0, 0);
  PVector vel = new PVector(0, 0);
  PVector currentRoom = new PVector(0, 0);
  PVector acc = new PVector(0, 0);
  float radius = 70;
  hitbox playerHB = null;
  ArrayList <hitbox> hitboxes = new ArrayList<hitbox>();

  player(float x, float y) {
    pos = new PVector(x, y);
    playerHB = new hitbox(pos.x - radius / 2, pos.y - radius / 2, radius, radius);
  }

  player(float x, float y, int cx, int cy) {
    pos = new PVector(x, y);
    currentRoom = new PVector(cx, cy);
    playerHB = new hitbox(pos.x - radius / 2, pos.y - radius / 2, radius, radius);
  }

  void show() {
    noStroke();
    fill(0);
    circle(pos.x, pos.y, radius);
  }

  void showHitbox() {
    playerHB.show();
  }

  void update() {
    vel.add(acc);
    vel.sub(PVector.mult(vel, 0.1));
    acc = new PVector(0, 0);
    PVector tempPos = new PVector(pos.x, pos.y);
    tempPos.add(vel);
    playerHB.updatePos(tempPos.x - radius / 2, tempPos.y - radius / 2);
    if (doesHit()) {
      vel = new PVector(0, 0);
    } else {
      pos = new PVector(tempPos.x, tempPos.y);
    }

    if (pos.x > width) {
      pos.x = 0;
      currentRoom.x += 1;
    }

    if (pos.x < 0) {
      pos.x = width;
      currentRoom.x -= 1;
    }

    if (pos.y < 0) {
      pos.y = width;
      currentRoom.y -= 1;
    }

    if (pos.y > height) {
      pos.y = 0;
      currentRoom.y += 1;
    }

  }

  boolean doesHit() {
    for (hitbox hb : hitboxes)
      if (isOverlapping(playerHB, hb)) return true;
    return false;
  }

  void move(PVector dir) {
    acc.add(dir.normalize().mult(3));
  }
}
