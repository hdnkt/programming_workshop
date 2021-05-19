//3/19スポーン部分

class GameMode extends Mode{
  protected int timer;
  protected int GAME_TIME = gameTime;
  
  public void initialize(){
    super.initialize();
    ortho();
    ellipseMode(CENTER);
    rectMode(CENTER);
    imageMode(CENTER);
    textAlign(CENTER);
    PFont pf = createFont("Yu Gothic", 64f, true);
    textFont(pf);
    /* ShipManager初期化　*/
    shipManager = new ShipManager();
    bulletManager = new BulletManager(1000);
    score = 0;
    status = "game";
    timer = millis();
    
    bgm.play();
  }
  
  public void move(){

    bulletManager.moveBullets();
    shipManager.moveShip();
    charaSpawn();
    // println(countcharas());
    
    if(keyPressed && key == 'r'||GAME_TIME-((millis()-timer)/1000)<=0||countShips()==0){
      nextMode = "result";
      trumpet.trigger();
      flagExit = true;
     }     
     if(keyPressed && key == 's'){
      nextMode = "screen";
      flagExit = true;
     }  
  }//move     
  
  public void render(){
    camera(0, 0, 1000, 0, 0, 0, 0, 1, 0);
    image(bg_Game, 0, 0, width, height);
        /* 全てのキャラクターを動かす */
    for (int i= 0; i < characters.size(); i++){
      Character tmp = characters.get(i);
      tmp.move();
    }
    bulletManager.renderBullets();
    shipManager.renderShip();
    fill(0,255,0);
    textSize(50);
    text("のこりじかん: "+(int)(GAME_TIME-((millis()-timer)/1000)),0,-height/2+100);
    textSize(100);
    text("スコア: " + score, 0, -height/2+200);
  }//render
  
  public void finalize(){
    bgm.close();
    handManager = new HandManager(MAX_HANDS);
  }
  
}

int countCharas(){//画面上で動いてるキャラの数
  int cnt = 0;
  for(int i=0; i<characters.size(); i++) {
    if(! characters.get(i).isDead){
      cnt++;
    }
  }
  return cnt;
}
int countShips(){
  int cnt = 0;
  for(int i = 0; i<shipManager.maxShips;i++){
    if(shipManager.shipArray[i]!=null) cnt++;
  }
  return cnt;
}

void charaSpawn(){//エンドレスで出現
  int nChara = characters.size();
  if (nChara == 0) return ;
  
  int nAlive = countCharas();
  
  int nDead = nChara - nAlive;
  if (nDead == 0) return ;
  
  int[] deadIDList = new int[nDead];
  for (int i=0, c=0; i<nChara; ++i) {
    if (characters.get(i).isDead) deadIDList[c++] = i; // nonnull
  }
  
  int nSpawn = max(maxSpawn - nAlive, 0);
  for (int i=0; i<nSpawn; ++i) {
    Character chara = characters.get(deadIDList[(int) random(0, nDead)]);
    
    int margin = 100;
    chara.x = random(-width/2 + margin, width/2 - margin);
    chara.y = random(-height/2 + margin, height/2 - margin);
    chara.start();
  }
  
}