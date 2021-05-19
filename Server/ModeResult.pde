class ResultMode extends Mode{ //3/20
      
  public void initialize(){
    super.initialize();
    
    ortho();
    ellipseMode(CENTER);
    rectMode(CENTER);
    imageMode(CENTER);
    textAlign(CENTER);
    PFont pf = createFont("Yu Gothic", 64f, true);
    textFont(pf);
    status = "result";
  }    // 初期化関数
  protected void move(){
    bulletManager.moveBullets();
    if(keyPressed && key == 's'){
      nextMode = "screen";
      flagExit = true;
    }else if(keyPressed && key == 'g'){
      nextMode = "game";
      flagExit = true;
    }
    for(int i = 0; i<MAX_HANDS; i++){
       if ( handManager.handArray[i]!=null){//ゲーム開始ボタン
        if ( handManager.handArray[i].handData.handState == true 
             &&handManager.handArray[i].prevHandData.handState == false ){
          if(dist(handManager.handArray[i].handData.pinchX,handManager.handArray[i].handData.pinchY,0,200)<=100){
            nextMode = "game";
            flagExit = true; 
          }
        }
       }
     }
  }          // 移動関数
  protected void render(){
    camera(0, 0, 1000, 0, 0, 0, 0, 1, 0);
    image(bg_Game, 0, 0, width, height);
    textSize(50);
    fill(0,255,0);
    text("ゲーム終了！！",0,0);
    text("スコア　：　"+score,0,300);
    fill(255,0,0);
    ellipse(0,200,100,100);
  }        // 描画関数

  public void finalize(){
    handManager = new HandManager(MAX_HANDS);
  }      // 解放関数
}