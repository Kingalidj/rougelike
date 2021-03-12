String [] types = {"0123", "01", "12", "23", "30", "02", "13", "0", "1", "2", "3"};

class room {
  String type = "";
  PImage roomImg;
  int w = 16;
  int h = 16;
  float dw = width / w;
  float dh = height / h;
  int [][] grid = new int[w][h];
  ArrayList<enemy> enemies = new ArrayList<enemy>();
  hitbox [][] hitboxes = new hitbox[w][h];

  room() {
    roomImg = loadImage("0123.png");
  }

  room(String s) {
    type = s;
    int turn = 0;
    if (s == "1" || s == "2" || s == "3") {
      turn = int(s);
      s = "0";
    } else if (s == "12" || s == "23" || s == "30") {
      turn = int(s.charAt(0));
      s = "01";
    } else if (s == "13") {
      turn = 1;
      s = "02";
    }
    roomImg = loadImage(s + ".png");
    for (int i = 0; i < w; i++) {
      for (int j = 0; j < h; j++) {
        color p = roomImg.get(i, j);
        if (red(p) + blue(p) + green(p) < 3 * 200) {
          grid[i][j] = 0;
        }
        else {
          grid[i][j] = 1;
        }    
      }
    }
    rotateRoom(turn);
    createHitboxes();
  }

  void addEnemy(float x, float y) {
    enemies.add(new enemy(x, y));
  }

  void loadRoom(String s) {
    type = s;
    for (int i = 0; i < w; i++) {
      for (int j = 0; j < h; j++) {
        color p = roomImg.get(i, j);
        if (red(p) + blue(p) + green(p) < 3 * 200) {
          grid[i][j] = 0;
        }
        else {
          grid[i][j] = 1;
        }    
      }
    }
    createHitboxes();
  }


  void createHitboxes() {
    for (int i = 0; i < w; i++) {
      for (int j = 0; j < h; j++) {
        if (grid[i][j] == 1) hitboxes[i][j] = null;
        else hitboxes[i][j] = new hitbox(i * dw, j * dh, dw, dh);
      }
    }
  }


  void rotateRoom(int n) {
    n = 4 - n;
    for (int x = 0; x < n; x++) {
      int[][] tempGrid = new int[h][w];
      for (int i = 0; i < w; i++) {
        for (int j = 0; j < h; j++) {
          tempGrid[j][w - 1 - i] = grid[i][j];
        }
      }
      grid = tempGrid;
    }
  }

  void show(PVector playerPos) {
    for (int i = 0; i < 16; i++) {
      for (int j = 0; j < 16; j++) {
        fill(grid[i][j] * 255);
        rect(i * dw, j * dw, dw, dh);
      }
    }

    for (enemy e : enemies) {
      e.show();
      PVector aim = playerPos.sub(e.pos).normalize();
      e.shoot(aim);
      for (int i = 0; i < e.bullets.size(); i++) {
        bullet b = e.bullets.get(i);
        if (b.pos.x > width || b.pos.y > height || b.pos.x < 0 || b.pos.y < 0) e.bullets.remove(i);
        if (isOverlapping(b.bulletHB, this.getHitboxes())) e.bullets.remove(i);
        b.update();
        b.show();
      }
    }
  }

  void show(float x, float y, float w, float h) {
    float dw = w / 16;
    float dh = h / 16;
    for (int i = 0; i < 16; i++) {
      for (int j = 0; j < 16; j++) {
        fill(grid[i][j] * 255);
        rect(x + i * dw, y + j * dw, dw, dh);
      }
    }
  }

  hitbox[] getHitboxes() {
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


room getMatchingRoom(String neighbors) {
  ArrayList <String> potential = new ArrayList<String>();
  for (String type : types) {
    boolean pickRoom = true;
    for (int i = 0; i < neighbors.length(); i++) {
      if (!type.contains("" + neighbors.charAt(i))) pickRoom = false;
    }
    if (pickRoom) potential.add(type);
  }
  String res = potential.get(floor(random(potential.size())));
  println(neighbors + ", " + res);
  return new room(res);
}
