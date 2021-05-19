/**
 * --- 180324.10 Client ---
 **/

/***********************************************************
    クライアントプログラムテンプレート
    2018/03/10 by SATOToshiki　
    2018/03/11 by SATOToshiki  アニメーション機能追加
 ***********************************************************/

static PApplet app;

static Character character;
static BulletManager bulletManager;
static int score;

void setup(){
  size(1280, 720, P3D);  
  app = this;
  
  app.ortho();
  app.ellipseMode(CENTER);
  app.rectMode(CENTER);
  
  character = new Character(0, 0);  // 引数で初期位置を指定  
  bulletManager = new BulletManager(10000);

  /*****************************************************************
        ここに動きのコマンドを書いてもらう
        (最後までいったらループする)
   *****************************************************************/
  
  Wait();
  Move(200,0);

  /*****************************************************************
        ここに絵のコマンドを書いてもらう
        (最後のフレームが終わったら先頭のフレームに戻る)
   *****************************************************************/

  Color(255, 0, 0);
  Circle(width/2,height/2,100,200);
  Color(0,255,0);
  Circle(width/2,height/2,200,100);
  Color(255,0,0,0);
  Circle(width/2,height/2-50,50,50);
  /*****************************************************************
                             ここまで
   *****************************************************************/
  app.hint(DISABLE_OPTIMIZED_STROKE);
}

void draw(){
  
  app.background(255);
  app.camera(0, 0, 1000, 0, 0, 0, 0, 1, 0);
  
  character.isDead = false;
  character.move();
  bulletManager.moveBullets();
  bulletManager.renderBullets();
  /* sで送信と同時に動作スタート */
  if ( keyPressed && key == ENTER && !character.getIsStarted() ){
    NetworkManager.sendToServer(character, this);
    character.start();
    println("Sent! ");
  }
  if ( keyPressed && key == 'm'){
    character.start();
  }
}