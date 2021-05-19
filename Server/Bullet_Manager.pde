/************************************************************
    弾丸管理クラス
    2017/07/11 by SATOToshiki    
 ************************************************************/
/**********
   改変
**********/

class BulletManager{

  protected Bullet[] bulletArray;
  public int maxBullets;
  
  BulletManager(int maxBullets){//ここで代入するのは、変更の必要がないものに限る。
    this.maxBullets = maxBullets;
    bulletArray = new Bullet[maxBullets];
  }
  
  /* 消滅処理 */
 // if( hp <= 0 ){
 //   if(bulletArray != null){
 // bulletArray = null;
//    }
//  }
    
  /* 動かす */
  public void moveBullets(){
    for ( int i = 0; i < maxBullets; i++ ){
      if ( bulletArray[i] != null ){
        Bullet b = bulletArray[i];
        b.move();
        
        if (b.x < -width/2 || width/2 <= b.x
            || b.y < -height/2 || height/2 <= b.y) {
           bulletArray[i] = null;
         }
        if( b.hp <= 0 ){        
            hit.trigger();
            gifManager.setBomb(b.x,b.y);
            bulletArray[i] = null;
         }
       }                  
    }
  } // moveBullets
  
  /* 描く */
  public void renderBullets(){
    for ( int i = 0; i < maxBullets; i++ ){
      if ( bulletArray[i] != null ){
        bulletArray[i].render();
      }
    }
  } // renderBullets  
  
  /* 飛ばす */
  public void shootBullet( int handID, float x, float y, float velocityX, float velocityY ){
    for ( int i = 0; i < maxBullets; i++ ){
      if ( bulletArray[i] == null ){
        bulletArray[i] = new Bullet(handID);                   // 空いてる箱を1つ探し、ボールを作る
        bulletArray[i].shoot(x, y, velocityX, velocityY);    // 発射する
        print("shoot ");
        break;
      }
    }
  } // shootBullet

    /* 飛ばす */
  public void shootBullet( int handID, float x, float y, float velocityX, float velocityY, String shootType ){
    for ( int i = 0; i < maxBullets; i++ ){
      if ( bulletArray[i] == null ){
        bulletArray[i] = new Bullet(handID);                   // 空いてる箱を1つ探し、ボールを作る
        bulletArray[i].shootType = shootType;
        bulletArray[i].shoot(x, y, velocityX, velocityY);    // 発射する
        print("shoot ");
        break;
      }
    }
  } // shootBullet
  
  public void boundBullet(){
    for ( int i = 0; i < maxBullets; i++ ){
      if (bulletArray[i] != null){
        bulletArray[i].bound(0,width,0,height);
      }
      
    }
  }
  
}