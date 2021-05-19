/****************************************************
    手クラス
    2016/07/09 by SATOToshiki
 ****************************************************/
/********
   改変
*********/

class Hand{

  protected HandData handData;
  protected HandData prevHandData;
  
  protected int lastUpdatedTime;
  
  int velocityX = 20;
  int velocityY = 20;
  
  float tarretAngle;
  int tarretLength = 100;
  
  boolean arming = false;
  
  public Hand(){
    handData = new HandData();
    prevHandData = new HandData();
  }

  /* 手データを更新 */
  public void update(HandData srcHandData){
    
    copyHandData(handData, prevHandData);
    copyHandData(srcHandData, handData);
    lastUpdatedTime = millis();    
    
    /* つまんだ瞬間にボールを発射 */
    //if ( handData.handState == true && prevHandData.handState == false ){
      //shootPinchedBall();
    
    /* 放した瞬間にもボールを発射 */
    //}else if ( handData.handState == false && prevHandData.handState == true ){
    //  shootReleasedBall();
    //}
    
  } // update
  
  /* 描画 */
  public void render(){
    
    fill(handData.id);    // IDで色を変える
    
    //ellipse(handData.armX, handData.armY, 300, 300);
  
    /* つまんでいる間は○を表示 */
    if ( handData.handState == true ){
      ellipse(handData.pinchX, handData.pinchY, 100, 100);
   }
    
  } // render
  
  ///* ボールを撃つ */
  //public void shootPinchedBall(){
    
  //  tarretAngle = atan2(handData.pinchY - handData.armY, handData.pinchX - handData.armX);
    
  //  bulletManager.shootBullet(handData.id, handData.pinchX + tarretLength * cos(tarretAngle), handData.pinchY + tarretLength * sin(tarretAngle),
  //     cos(tarretAngle) * velocityX, sin(tarretAngle) * velocityY);    // 5で割ってるのは適当に遅くしている感じ
  //     shootSE.trigger();
  //} // shootPinchedBall

  public void shootReleasedBall(){
    if(!arming){
      if(!handData.handState&&prevHandData.handState){
        tarretAngle = atan2(prevHandData.pinchY - handData.armY, prevHandData.pinchX - handData.armX);
        bulletManager.shootBullet(handData.id, prevHandData.pinchX  + tarretLength * cos(tarretAngle), prevHandData.pinchY  + tarretLength * sin(tarretAngle),
        cos(tarretAngle)* velocityX, sin(tarretAngle) * velocityY,"free");    // 注意: 放した瞬間からpinchX/pinchYが使えなくなるので、発射には前フレームのデータを使う
        beam.trigger();
      }
    }
  } // shootReleasedBall  
  
  /* ID取得 */
  public int getID(){
    return handData.id;
  } // getID
  
  /* 更新時刻を得る */
  public int getLastUpdatedTime(){
    return lastUpdatedTime;
  } // getLastUpdatedTime

}