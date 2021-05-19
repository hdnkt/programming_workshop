/**
 * --- 180324.10 MoveCommands ---
 **/

/***********************************************
    移動コマンド
    2018/03/10 by SATOToshiki
 ***********************************************/

 
public static MoveEvent GoFor(float direction, int speed, float duration){
  MoveEvent newEvent = new MoveEvent();
  newEvent.type = 1;
  newEvent.x = speed;
  newEvent.y = (int)direction;
  newEvent.duration = (int)(duration * 1000);
  newEvent.useLocalAxis = true;
  println("NewEvent: Gofor");
  character.addMoveEvent(newEvent);
  return newEvent;
} // left

public static void Left(){GoFor(9,5,1);}
public static void Right(){GoFor(3,5,1);}
public static void Up(){GoFor(0,5,1);}
public static void Down(){GoFor(6,5,1);}


public static void Left(int speed, float duration){
  GoFor(9,speed,duration);
}

public static void Right(int speed, float duration){
  GoFor(3,speed,duration);
}

public static void Up(int speed, float duration){
  GoFor(0,speed,duration);
}

public static void Down(int speed, float duration){
  GoFor(6,speed,duration);
}

/* 指定した位置に移動(瞬間移動) */
public static MoveEvent Move(int distance, int direction){
  MoveEvent newEvent = new MoveEvent();
  newEvent.type = 4;
  newEvent.x = distance;
  newEvent.y = (int)direction;
  newEvent.useLocalAxis = true;
  println("NewEvent: Move");
  character.addMoveEvent(newEvent);
  return newEvent;
} // Move

/* 指定した位置に滑らかに移動 */
public static MoveEvent MoveTo(int x, int y, float duration){
  MoveEvent newEvent = new MoveEvent();
  newEvent.type = 2;
  newEvent.x = x;
  newEvent.y = y;
  newEvent.duration = (int)(duration * 1000);
  println("NewEvent: MoveTo");
  character.addMoveEvent(newEvent);
  return newEvent;
} // MoveTo

public static MoveEvent Goto(int index){
  MoveEvent newEvent = new MoveEvent();
  newEvent.type = 100;
  if (index < 0){
    println("Goto Error: index must be >= 0");
    return null;
  }
  newEvent.x = index;
  println("NewEvent: Goto");
  character.addMoveEvent(newEvent);
  return newEvent;
} // Goto

public static MoveEvent Wait(float duration){
  MoveEvent newEvent = new MoveEvent();
  newEvent.type = 3;
  newEvent.duration = (int)(duration * 1000);
  println("NewEvent: Wait");
  character.addMoveEvent(newEvent);
  return newEvent;
} // Wait

public static void Wait(){Wait(1);};


public static MoveEvent Rotate(int r,int speed,float duration){ // 3/20
  MoveEvent newEvent = new MoveEvent();
  newEvent.type = 5;
  newEvent.duration = (int)(duration * 1000);
  newEvent.x = r;
  newEvent.y = speed;
  println("NewEvent: Guruguru");
  character.addMoveEvent(newEvent);
  return newEvent;
}

public static MoveEvent LookIn(float direction, float duration){
  MoveEvent newEvent = new MoveEvent();
  newEvent.type = 6;
  newEvent.shootAngle = (int) ((direction)*30);
  newEvent.duration = (int)(duration * 1000);
  newEvent.useLocalAxis = true;
  println("NewEvent: LookFor");
  character.addMoveEvent(newEvent);
  return newEvent;
}

public static MoveEvent LookIn(float direction){
  MoveEvent newEvent = new MoveEvent();
  newEvent.type = 6;
  newEvent.shootAngle = (int) ((direction)*30);
  newEvent.duration = (int)(1 * 1000);
  newEvent.useLocalAxis = true;
  println("NewEvent: LookFor");
  character.addMoveEvent(newEvent);
  return newEvent;
}

/*攻撃イベント*/

public static MoveEvent Shoot(){
  return Shoot(0);
}

public static MoveEvent Shoot(float shootAngle){// 3/15 角度と時計の針を対応
  MoveEvent newEvent = new MoveEvent();
  newEvent.type = 7;
  newEvent.shootAngle = (int) ((shootAngle-3)*30);
  newEvent.useLocalAxis = true;
  println("NewEvent: Shoot");
  character.addMoveEvent(newEvent);
  return newEvent;
}

public static void Shoot3(){  //3/20
  Shoot3(0);
}

public static void Shoot3(int shootAngle){  //3/20
  Shoot(shootAngle);
  Shoot(shootAngle-1);
  Shoot(shootAngle+1);
}

public static MoveEvent Laser(float duration){
  return Laser(0, duration);
}

public static MoveEvent Laser(float shootAngle,float duration){  //3/20
  MoveEvent newEvent = new MoveEvent();
  newEvent.type = 8;
  newEvent.duration = (int)(duration * 1000);
  newEvent.shootAngle = (int) ((shootAngle-3)*30);
  newEvent.useLocalAxis = true;
  println("NewEvent: Laser");
  character.addMoveEvent(newEvent);
  return newEvent;
}

public static MoveEvent Bomb(){  //3/20
  MoveEvent newEvent = new MoveEvent();
  newEvent.type = 9;
  println("NewEvent: Bomb");
  character.addMoveEvent(newEvent);
  return newEvent;
}