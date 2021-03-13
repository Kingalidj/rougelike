class player {
  PVector pos = new PVector(0, 0);
  PVector vel = new PVector(0, 0);
  PVector dir = new PVector(1, 0);
  PVector currentRoom = new PVector(0, 0);
  PVector acc = new PVector(0, 0);
  float radius = 70;
  hitbox playerHB = null;
  hitbox interactHB = null;
  ArrayList <hitbox> hitboxes = new ArrayList<hitbox>();
  ArrayList <bullet> bullets = new ArrayList<bullet>();

  player(float x, float y) {
    pos = new PVector(x, y);
    playerHB = new hitbox(pos.x - radius / 2, pos.y - radius / 2, radius, radius);
    interactHB = new hitbox(pos.x - radius, pos.y - radius, radius * 2, radius * 2);
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
    this.dir = new PVector(dir.x, dir.y);
    //acc.add(dir.mult(3));
    vel.add(dir.mult(1));
  }

  void shoot() {
    PVector dir = new PVector(mouseX - pos.x, mouseY - pos.y).normalize();
    bullets.add(new bullet(pos.x, pos.y, 20, dir, 15, "player"));
  }
}

class bullet {
  String team = "";
  hitbox bulletHB;
  int radius = 0;
  PVector vel = new PVector(0, 0);
  PVector pos = new PVector(0, 0);

  bullet(float x, float y, int r, PVector dir, float speed, String team) {
    this.team = team;
    pos = new PVector(x, y);
    vel = new PVector(dir.x, dir.y).mult(speed);
    this.radius = r;
    bulletHB = new hitbox(pos.x - radius / 2, pos.y - radius / 2, radius, radius);
  }

  bullet() {

  }

  void update() {
    pos.add(vel);
    bulletHB.updatePos(pos.x - radius / 2, pos.y - radius / 2);
  }

  void show() {
    fill(200, 200, 0);
    circle(pos.x, pos.y, radius);
  }
}

class enemy {
  PVector pos = new PVector(0, 0);
  hitbox enemyHB = null;
  ArrayList <bullet> bullets = new ArrayList<bullet>();
  float w, h;

  enemy(float x, float y) {
    pos = new PVector(x, y);
    w = 100;
    h = 100;
    enemyHB = new hitbox(pos.x, pos.y, w, h);
  }

  void shoot(PVector aim) {
    bullets.add(new bullet(pos.x + w / 2, pos.y + h / 2, 20, aim, 15, "enemy"));
  }

  void update() {
    pos.add(PVector.random2D().mult(2));
  }

  void show() {
    fill(200, 0, 0);
    rect(pos.x, pos.y, w, h);
  }
}
