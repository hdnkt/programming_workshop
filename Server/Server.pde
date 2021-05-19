/**
 * --- 180324.10 Server ---
 **/


/***********************************************
    サーバプログラムテンプレート
    2018/03/10 by SATOToshiki
 ***********************************************/
 
 

 //サーバー側のみにあるもの以外はクライアント側と共通
 
 // 3/18 シューティングとがっちゃんこ
 // 3/20 コマンド（方向転換、レーザー、自爆）追加、リザルト追加、あたり判定改善など
 

import hypermedia.net.*;    // おまじない
import gifAnimation.*;
import ddf.minim.*;

Minim minim;
AudioSample beam,bomber,hit,worp,trumpet;
AudioPlayer bgm;

Mode currentMode;

UDP udp;
int portNo = 31417;
int RECEIVE_BUFFER_SIZE = 4096;
boolean flagReceived = false;

final int maxSpawn = 8;
final float enemyBulletSpeed = 50;
final float enemyLaserSpeed = 10;
final float shipBulletSpeed = 50;
final int enemyHP = 20;
final int gameTime = 300;


ArrayList<Character> characters = new ArrayList<Character>();
HandManager handManager;
BulletManager bulletManager;
ShipManager shipManager;
GifManager gifManager;

Gif myAnimation;
int score;
PImage bg_Game;

void setup(){ 
  size(1920,1080, P3D);   
  //size(3840, 2160, P3D);  
  initialize(); //Pacpaccommunicater初期化
  udp = new UDP(this, portNo);
  udp.setBuffer(RECEIVE_BUFFER_SIZE); 
  udp.setReceiveHandler("received");
  udp.listen(true); 
  handManager = new HandManager(MAX_HANDS);  
  
  gifManager = new GifManager();
  
  currentMode = new ScreenMode();
  currentMode.initialize();
  
  minim = new Minim(this);
  beam = minim.loadSample("laser1.mp3");
  bomber = minim.loadSample("explosion3.mp3");
  hit = minim.loadSample("punch-high1.mp3");
  worp = minim.loadSample("magic-worp1.mp3");
  trumpet = minim.loadSample("trumpet1.mp3");
  
  bgm = minim.loadFile("bgmGame.mp3");
  
  myAnimation = new Gif( this, "bomber.gif");

  bg_Game = loadImage("Space.png");
  // bg_Game.resize(width,height);
  hint(DISABLE_OPTIMIZED_STROKE);
}

void draw(){
  if(currentMode.run() == true){
    currentMode.finalize();
    if(currentMode.nextMode == "game"){
      currentMode = new GameMode();
      currentMode.initialize();
    }
    else if(currentMode.nextMode == "result"){
      currentMode = new ResultMode();
      currentMode.initialize();
    }
    else if(currentMode.nextMode == "screen"){
      currentMode = new ScreenMode();
      currentMode.initialize();
    }
  }
  if(keyPressed && key == 'c'){
    characters.clear();
  }
    /* 手の更新 */
  handManager.updateHands(handDataArray);
   /* 手の描画 */
  handManager.renderHands(); 
  gifManager.render();
  sendHandData();
  
}

  /* 受信したらCharacterを生成して追加する */
void received(byte[] data, String hostIP, int portNo){  
  int index = 2;
  int moveEventCount = data[0];
  int drawEventCount = data[1];
  
  println("MoveEventCount: " + moveEventCount + " DrawEventCount: " + drawEventCount);
    
  println("MoveEventByteCount: " + MoveEvent.getByteCount() 
  + " DrawEventByteCount: " + DrawEvent.getByteCount());
  
  /* MoveEvent追加 */
  ArrayList<MoveEvent> moveEventQueue = new ArrayList<MoveEvent>();
  for (int i = 0; i < moveEventCount; i++){
    byte[] tmp = new byte[MoveEvent.getByteCount()];
    for (int j = 0; j < MoveEvent.getByteCount(); j++, index++){
      tmp[j] = data[index];
    }
    MoveEvent newEvent = new MoveEvent();
    newEvent.setDataFromByteArray(tmp);
    moveEventQueue.add(newEvent); 
  }
    
  /* Characterの初期化 */
  //Character newCharacter = new Character(0,0);
  int margin = 100;
  int x = (int) random(-width/2 + margin, width/2 - margin);
  int y = (int) random(-height/2 + margin, height/2 - margin);
    
  Character newCharacter = new Character(x, y); //初期位置を引数に
  newCharacter.setMoveEvent(moveEventQueue);
  
  /* DrawEventを呼んでDrawEventを追加していく追加 */
  for (int i = 0; i < drawEventCount; i++){
    byte[] tmp = new byte[DrawEvent.getByteCount()];
    for (int j = 0; j < DrawEvent.getByteCount(); j++, index++){
      tmp[j] = data[index];
    }
    DrawEvent newEvent = new DrawEvent();
    newEvent.setDataFromByteArray(tmp);
    if (newEvent.type == -1){
      newCharacter.addNewFrame();    // type: -1はAddNewFrame命令
    }else{
      newCharacter.addDrawEvent(newEvent);
    }
  }
  
  /* キャラクターを追加 */
  println("Add Character: TotalMoveEvents: " + newCharacter.getMoveEventQueueCount() 
    + " TotalDrawFrames: " + newCharacter.getDrawEventsFrameCount() 
    + " TotalDrawCommands: " + newCharacter.getDrawEventsArrayTotalCommandCount());
  characters.add(newCharacter);
  //if(currentMode.status == "screen"){// 3/18 スクリーンモードの時のみキャラが送ったときに動くようにしている。ゲームモード時にどのようにキャラを出すかは未実装
    newCharacter.start();
  //}
    
  flagReceived = true;
}