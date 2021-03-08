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
    createRooms("0123", 10, 10, 3);

    for (int i = 0; i < w; i++) {
      for (int j = 0; j < h; j++) {
        if (map[i][j] == null)print("     ,");
        else print(map[i][j] + ", ");
      }
      println();
    }
  }

  void createRooms(String type, int x, int y, int n) {
    if (rooms[x][y] != null || n <= 0) return;
    rooms[x][y] = new room(type);
    map[x][y] = type;
    for (String s : rooms[x][y].type.split("")) {
      int dir = int(s);
      if (dir == 0) createRooms(getMatchingRoom(getNeighbors(x, y, dir, n)), x, y + 1, n - 1);
      else if (dir == 1) createRooms(getMatchingRoom(getNeighbors(x, y, dir, n)), x + 1, y, n - 1);
      else if (dir == 2) createRooms(getMatchingRoom(getNeighbors(x, y, dir, n)), x, y - 1, n - 1);
      else if (dir == 3) createRooms(getMatchingRoom(getNeighbors(x, y, dir, n)), x - 1, y, n - 1);
    }
  }

  String getNeighbors(int x, int y, int dir, int n) {
    String neighbors = "";
    int offX = x;
    int offY = y;
    if (dir == 0) offY += 1;
    else if (dir == 1) offX += 1;
    else if (dir == 2) offY -= 1;
    else if (dir == 3) offX -= 1;
    if (n - 1 > 1) {
      if (rooms[offX + 1][offY] != null)neighbors += "0";
      if (rooms[offX][offY + 1] != null)neighbors += "1";
      if (rooms[offX - 1][offY] != null)neighbors += "2";
      if (rooms[offX][offY - 1] != null)neighbors += "3";
    }
    String res = "";
    for (int i = 0; i < neighbors.length(); i++) {
      res += neighbors.charAt(i);
      println("hello");
    }
    println(res);
    res += ((dir + 3) % 4);
    return res;
  }
}
