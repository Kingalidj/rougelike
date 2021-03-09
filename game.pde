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
    if (mousePressed) l1.drawRooms(currentRoom);
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
    createRooms();

    for (int i = 0; i < w; i++) {
      for (int j = 0; j < h; j++) {
        if (map[i][j] == null)print("     ,");
        else print(map[i][j] + ", ");
      }
      println();
    }
  }

  void drawRooms(room currentRoom) {
    background(0);
    float dw = width / w;
    float dh = height / h;
    for (int i = 0; i < w; i++) {
      for (int j = 0; j < h; j++) {
        if (rooms[i][j] != null) rooms[i][j].show(i * dw, j * dh, dw, dh);
        fill(200, 0, 0);
        if (rooms[i][j] == currentRoom) circle((i + 0.5) * dw, (j + 0.5) * dh, dw / 5);
      }
    }
  }


  void createRooms() {
    int n = 10;
    int x = 10;
    int y = 10;
    rooms[x][y] = new room("1");
    map[x][y] = "1";
    int prevDir = -1;
    int dir = -1;
    for (int i = 0; i < n; i++) {
      String roomType = rooms[x][y].type;
      while (dir == prevDir)
        dir = int("" + roomType.charAt(floor(random(roomType.length()))));
      println(dir);
      if (dir == 0) {
        y -= 1;
      } else if (dir == 1) {
        x += 1;
      } else if(dir == 2) {
        y += 1;
      } else if(dir == 3) {
        x -= 1;
      }
      String newType = getNeighbors(x, y, dir);
      rooms[x][y] = getMatchingRoom(newType);
      map[x][y] = rooms[x][y].type;
      prevDir = dir;
    }
  }

  String getNeighbors(int x, int y, int dir) {
    String optionalDir = "";
    if (y - 1 >= 0) if (rooms[x][y - 1] == null) optionalDir += "0";
    if (x + 1 < w) if (rooms[x + 1][y] == null) optionalDir += "1";
    if (y + 1 < h) if (rooms[x][y + 1] == null) optionalDir += "2";
    if (x - 1 >= 0) if (rooms[x - 1][y] == null) optionalDir += "3";
    return optionalDir + ((dir + 3) % 4);
  }
}
