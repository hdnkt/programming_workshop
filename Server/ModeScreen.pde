class ScreenMode extends Mode{
  void initialize(){
    super.initialize();
    
    status = "screen";
    bulletManager = new BulletManager(1000);
    ortho();
    ellipseMode(CENTER);
    rectMode(CENTER);
    imageMode(CENTER);
  
  }
  
  void move(){
    bulletManager.moveBullets();
    if(keyPressed && key == 'r'){
      nextMode = "result";
      for(int i = 0;i < characters.size(); i++){
        Character tmp = characters.get(i);
        tmp.isDead = true;
      }
      flagExit = true;
    }else if(keyPressed && key == 'g'){
      nextMode = "game";
      for(int i = 0;i < characters.size(); i++){
        Character tmp = characters.get(i);
        tmp.isDead = true;
      }
      flagExit = true;
    }
  }
  
  void render(){
    camera(0, 0, 1000, 0, 0, 0, 0, 1, 0);
    image(bg_Game, 0, 0, width, height);
    
    /* 全てのキャラクターを動かす */
    for (int i= 0; i < characters.size(); i++){
      Character tmp = characters.get(i);
      tmp.move();
    }
    
    bulletManager.renderBullets();
  }
  
  void finalize(){
    handManager = new HandManager(MAX_HANDS);
  }
}