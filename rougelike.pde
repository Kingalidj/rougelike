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

class room {
  String type = "";
  PImage roomImg;
  float dw = width / 16;
  float dh = height / 16;
  int [][] grid = new int[16][16];
  hitbox [][] hitboxes = new hitbox[16][16];

  room() {
    roomImg = loadImage("0123.png");
  }

  room(String s) {
    roomImg = loadImage(s + ".png");
    type = s;
    for (int i = 0; i < 16; i++) {
      for (int j = 0; j < 16; j++) {
        color p = roomImg.get(i, j);
        if (red(p) + blue(p) + green(p) < 3 * 200) {
          grid[i][j] = 0;
          hitboxes[i][j] = new hitbox(i * dw, j * dh, dw, dh);
        }
        else {
          grid[i][j] = 1;
          hitboxes[i][j] = null;
        }    
      }
    }
  }

  void loadRoom(String s) {
    type = s;
    for (int i = 0; i < 16; i++) {
      for (int j = 0; j < 16; j++) {
        color p = roomImg.get(i, j);
        if (red(p) + blue(p) + green(p) < 3 * 200) {
          grid[i][j] = 0;
          hitboxes[i][j] = new hitbox(i * dw, j * dh, dw, dh);
        }
        else {
          grid[i][j] = 1;
          hitboxes[i][j] = null;
        }    
      }
    }
  }

  void show() {
    for (int i = 0; i < 16; i++) {
      for (int j = 0; j < 16; j++) {
        fill(grid[i][j] * 255);
        rect(i * dw, j * dw, dw, dh);
      }
    }
  }

  hitbox[]  getHitboxes() {
    hitbox[] ret = new hitbox[16 * 16];
    for (int i = 0; i < 16; i++) {
      for (int j = 0; j < 16; j++) {
        ret[j + i * 16] = hitboxes[i][j];
      }
    }
    return ret;
  }

  void showHitboxes() {
    for (int i = 0; i < 16; i++) {
      for (int j = 0; j < 16; j++) {
        if (hitboxes[i][j] != null) {
          hitboxes[i][j].show();
        }
      }
    }
  }
}

class game {
  player p1;
  level l1;

  game() {
    p1 = new player(width / 2, height / 2, 10, 10);
    //r1 = new room("0123");
    l1 = new level(20, 20);
  }

  void update() {

    //r1.show();
    //r1.showHitboxes();
    room currentRoom = l1.rooms[round(p1.currentRoom.x)][round(p1.currentRoom.y)];

    for (hitbox hb : currentRoom.getHitboxes()) {
      p1.hitboxes.add(hb);
    }
    currentRoom.show();
    p1.update();
    p1.show();
    p1.showHitbox();
    fill(255, 0, 0);
    text(round(p1.currentRoom.x) + ", " + round(p1.currentRoom.y), 10, 10, 100);

    p1.hitboxes = new ArrayList<hitbox>();
  }
}

class level {
  room[][] rooms;
  String[][] map;
  int w, h;
  int nRooms;

  level(int w, int h) {
    this.w = w;
    this.h = h;
    rooms = new room[w][h];
    map = new String[w][h];
    createRooms(10, 10, 5);
    for (int i = 0; i < w; i++) {
      for (int j = 0; j < h; j++) {
        if (map[i][j] == null)print(0);
        else print(1);
      }
      println();
    }
  }

  void createRooms(int x, int y, int n) {
    println(x + ", " + y);
    if (rooms[x][y] != null || n <= 0) return;
    println("yes");
    rooms[x][y] = new room("01");
    map[x][y] = "01";
    for (String s : rooms[x][y].type.split("")) {
      int dir = int(s);
      if (dir == 0) createRooms(x, y - 1, n - 1);
      else if (dir == 1) createRooms(x + 1, y, n - 1);
      else if (dir == 2) createRooms(x, y + 1, n - 1);
      else if (dir == 3) createRooms(x - 1, y, n - 1);
    }
  }

}

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
