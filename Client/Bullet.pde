/**
 * --- 180324.10 Bullet ---
 **/

/************************************************************
    弾丸クラス
    2017/07/11    
 ************************************************************/
/********
   改変
*********/

static class Bullet{
  protected float x, y;
  protected float velocityX, velocityY;
  protected int startTime;
  protected String shootType;
  protected float boundminX;
  protected float boundmaxX;
  protected float boundminY;
  protected float boundmaxY;
  protected int hp = 4;
    
  int diameter = 40;//弾丸の半径
  
  int handID;    // 発射元の手のID
  
  Bullet(int handID){
    this.handID = handID;
  }
  
  /* 消滅か生存か */
 // protected void deadoralive(){
  //  if( hp <= 0 ){
  //    if(bulletArray != null){
  //      bulletArray = null;
 //     }
 //   }
//  }
  
  /* 移動 */
  protected void move(){
    x += velocityX;
    y += velocityY;
    for ( int i = 0; i < bulletManager.maxBullets; i++ ){
      if ( bulletManager.bulletArray[i] != null ){
        Bullet b = bulletManager.bulletArray[i];        
        if (dist(x,y,b.x,b.y)<=diameter/2&&b.handID!=handID) hp = 0;
      }                  
    }
  } // move
  
  /* 描画 */
  protected void render(){
    if(handID!=0){
      app.fill(0,0,255);
    }else{
      if(shootType == "laser") {
        app.fill(255,255,0);
        app.noStroke();
      }
      else if(shootType == "bomb")app.fill(255,0,0);
      else app.fill(0);
    }
    app.ellipse(x, y, diameter, diameter);
    app.stroke(0);
  } // render
  
  /* 飛ぶ */
  protected void shoot(float x, float y, float velocityX, float velocityY){
    this.x = x;
    this.y = y;
    this.velocityX = velocityX;
    this.velocityY = velocityY;
    startTime = app.millis();//processing内での時間の単位はms（ミリ秒）である。
  } // shoot
  
  protected void bound(float boundminX, float boundmaxX, float boundminY, float boundmaxY){
    this.boundminX = boundminX;
    this.boundmaxX = boundmaxX;
    this.boundminY = boundminY;
    this.boundmaxY = boundmaxY;
    
    
    if(y < boundminY || boundmaxY < y){
      y -= velocityY;
      velocityY = -velocityY;
      hp -= 1;
    }//縦の壁と跳ね返る
    
  }
}