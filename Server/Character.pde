/** //<>//
 * --- 180324.10 Chara_Server ---
 **/


/***********************************************
    キャラクター
    2018/03/10 by SATOToshiki
 ***********************************************/
class Character{

  public int charaWidth,charaHeight;
  public int HP;
  
  protected float rotationTimer;
  protected float x, y, z;
  protected float cx, cy;//円運動の中心　ゆるして
  protected float rotation;
  
  protected boolean isFirstFrame = true;//一度だけやりたい処理があるときにどうぞ
  protected boolean isDead = true;
  protected boolean isStopped = false;          // 全ての移動イベントが終了したかどうか
  protected int currentMoveEventIndex = 0;      // 移動イベントカウンタ

 protected int frameInterval = 500;
  protected int frameTick;
  
  /* 移動イベント */
  ArrayList<MoveEvent> moveEventQueue = new ArrayList<MoveEvent>();  

  /* 描画イベント */
  ArrayList<ArrayList<DrawEvent>> drawEventsArray = new ArrayList<ArrayList<DrawEvent>>();
  int currentDrawEventsIndex;
  ArrayList<DrawEvent> currentDrawEvents;
  
  public boolean isStarted = false;     // 開始したかどうか  
  MoveEvent currentMoveEvent = null;    // 現在実行中の移動イベント
      
  Character(float x0, float y0){
    x = x0;    y = y0;
    moveEventQueue.clear();
    drawEventsArray.clear();
    currentDrawEvents = new ArrayList<DrawEvent>();
    drawEventsArray.add(currentDrawEvents);
    currentDrawEventsIndex = 0;
    frameTick = 0;
    isStarted = false;
    HP = enemyHP;
  }
  
  /* Moveイベント追加 */
  public int addMoveEvent(MoveEvent newEvent){
    moveEventQueue.add(newEvent);
    return moveEventQueue.size();
  } // addMoveEvent
  
  /* Drawイベント追加 */
  public int addDrawEvent(DrawEvent newEvent){
    currentDrawEvents.add(newEvent);
    return moveEventQueue.size();  
  } // addDrawEvent
  
  /* 現在のフレームを動かす */
  public int addNewFrame(){
    currentDrawEvents = new ArrayList<DrawEvent>();
    drawEventsArray.add(currentDrawEvents);
    return currentDrawEvents.size();
  } // addNewFrame
  
  /* アニメーションスピードの設定 */
  public void setFrameInterval(int interval){
    frameInterval = interval;
  } // setFrameInterval
  
  /* イベントキューのセット */
  public void setMoveEvent(ArrayList<MoveEvent> moveEventQueue){
    this.moveEventQueue = moveEventQueue;
  } // setMoveEvent
    
  /* イベントキューのセット */
  public void setDrawEvent(ArrayList<ArrayList<DrawEvent>> drawEventsArray){
    this.drawEventsArray = drawEventsArray;
  } // setDrawEvent
  
  /* イベント開始 */
  public void start(){
    isDead = false;
    isFirstFrame = true;
    HP = enemyHP;
    
    currentMoveEventIndex = 0;
    currentMoveEvent = getMoveEvent(currentMoveEventIndex);
    
    isStopped = false;
    isStarted = true;
    println("Started: " + moveEventQueue.size() + " move events.");
  } // start
  
  /***************************************************************************/
  
  /* MoveEventのバイト配列を返す */
  public byte[] getMoveEventQueueByteArray(){
    byte[] moveEventQueueByteArray = new byte[ getMoveEventQueueByteCount() ];
    int index = 0;    
    for (int i = 0; i < moveEventQueue.size(); i++){
      MoveEvent tmp = moveEventQueue.get(i);
      byte[] tmpByteArray = tmp.getByteArray();
      for (int j = 0; j < MoveEvent.getByteCount(); j++, index++){
        moveEventQueueByteArray[index] = tmpByteArray[j];
      }
    }    
    return moveEventQueueByteArray;
  } // getMoveEventByteArray
  
  /* 指定したフレームのDrawEventのバイト配列を返す */
  public byte[] getDrawEventsByteArray(int index){
    
    ArrayList<DrawEvent> tmpDrawEvents = drawEventsArray.get(index);
    
    byte[] drawEventsByteArray = new byte[ getDrawEventsByteCount(index) ];
    int counter = 0;
    for (int i = 0; i < tmpDrawEvents.size(); i++){
      DrawEvent tmp = tmpDrawEvents.get(i);
      byte[] tmpByteArray = tmp.getByteArray();
      for (int j = 0; j < DrawEvent.getByteCount(); j++, counter++){
        drawEventsByteArray[counter] = tmpByteArray[j];
      }
    }    
    return drawEventsByteArray;    
  } // getMoveEventQueueByteArray
  
  /* MoveEventQueueのバイトサイズを返す */
  public int getMoveEventQueueByteCount(){
    if (moveEventQueue.size() <= 0){
      return 0;
    }
    return moveEventQueue.size() * MoveEvent.getByteCount();
  } // getMoveEventQueueByteCount
  
  /* DrawEventの配列数 */
  public int getDrawEventsFrameCount(){
    return drawEventsArray.size();
  } // getDrawEventsFrameCount
  
  public int getDrawEventsCommandCount(int index){
    return drawEventsArray.get(index).size();
  } // getDrawEventsCount
  
  /* DrawEventsArrayの総コマンド数を返す */
  public int getDrawEventsArrayTotalCommandCount(){
    int count = 0;
    for (int i = 0; i < drawEventsArray.size(); i++){
      count += drawEventsArray.get(i).size();
    }
    return count;
  } // getDrawEventsArrayTotalCommandCount
  
  /* DrawEventsArrayの総バイトサイズを返す */
  public int getDrawEventsArrayTotalByteCount(){
    int count = 0;
    for (int i = 0; i < drawEventsArray.size(); i++){
      count += drawEventsArray.get(i).size() * DrawEvent.getByteCount();
    }
    return count;
  } // getDrawEventsArrayTotalByteCount
  
  /* DrawEventsのバイトサイズを返す */
  public int getDrawEventsByteCount(int index){
    if (drawEventsArray.get(index).size() <= 0){
      return 0;
    }
    //DrawEvent tmp = drawEventsArray.get(index).get(0);
    return drawEventsArray.get(index).size() * DrawEvent.getByteCount();
  } // getDrawEventsByteCount
  
  public int getMoveEventQueueCount(){
    return moveEventQueue.size();
  } // 
   public int getDrawEventsCount(int index){
    return drawEventsArray.get(index).size();
  } // 
  
  public boolean getIsStarted(){
    return isStarted;
  } // getIsStarted
 
  /***************************************************************************/
  
  /* 次のイベントを取り出す(取り出したイベントは削除) */
  protected MoveEvent getNextMoveEvent(){
    if (moveEventQueue.size() <= 0){
      println("MoveEventQueue is empty!");
      return null;
    }
    MoveEvent newEvent = moveEventQueue.get(0);
    moveEventQueue.remove(0);
    newEvent.startTick = millis();
    println("ExecuteEvent:" + newEvent.type + " (" + moveEventQueue.size() + "events left)");
    return newEvent;
  } // getNextMoveEvent
  
  /* index指定でイベントを取得(取り出したイベントは削除しない) */
  protected MoveEvent getMoveEvent(int index){
    if (moveEventQueue.size() <= index){
      println("Event[" + index + "] not found!");
      return null;
    }
    MoveEvent newEvent = moveEventQueue.get(index);
    newEvent.startTick = millis();
    return newEvent;
  } // getMoveEvent
  
  /* イベント実行 */
  protected void executeMoveEvent(){
    
    //println("/**********");
        
    /* 移動イベント */
    switch (currentMoveEvent.type){
      
      case 1:    // 移動イベント(速度指定)
      {
        int speed = currentMoveEvent.x;
        int direction = currentMoveEvent.y;
        
        float dx = (int)(speed*cos(radians(30*direction-90))); 
        float dy = (int)(speed*sin(radians(30*direction-90)));
        
        if (currentMoveEvent.useLocalAxis) {
         dx = speed * cos(radians(rotation+(30*direction-90)));
         dy = speed * sin(radians(rotation+(30*direction-90)));
        }
        x += dx;
        y += dy;
        
        if (currentMoveEvent.startTick + currentMoveEvent.duration < millis()){
          currentMoveEvent.flagFinished = true;
        }
        //println(currentEventIndex + " MoveVelicity: (" + moveEvent.x + ", " + moveEvent.y + ") " + (moveEvent.startTick + moveEvent.duration - app.millis()) + "mSec left");
        break;
      }
      case 2:    // 移動イベント(目的地へ移動)
      {
        x += (float)(currentMoveEvent.x - x) * 0.1f;
        y += (float)(currentMoveEvent.y - y) * 0.1f;
        
        /* 目的地に到着した or 時間が来たら */
        float distance = dist(x, y, currentMoveEvent.x, currentMoveEvent.y);
        if ( distance < 0.1f 
          || currentMoveEvent.startTick + currentMoveEvent.duration < millis()){
          currentMoveEvent.flagFinished = true;
        }
        println("x:" + x + " y:" + y + " dist:" + distance);
        //println(currentEventIndex + " MoveTo: (" + moveEvent.x + ", " + moveEvent.y + ") " + (moveEvent.startTick + moveEvent.duration - millis()) + "mSec left");
        break;
      }        
      case 3:    // 停止イベント
        // nop
        //println("Waiting: " + (currentMoveEvent.startTick + currentMoveEvent.duration - millis()) + "mSec left");
        if (currentMoveEvent.startTick + currentMoveEvent.duration < millis()){
          currentMoveEvent.flagFinished = true;
        }
        break;        
        
      case 4:    // 瞬間移動イベント
        float direction = currentMoveEvent.y;
        float dist = currentMoveEvent.x;
        x += dist * cos(radians(rotation+(30*direction-90)));
        y += dist * sin(radians(rotation+(30*direction-90)));
        worp.trigger();
        currentMoveEvent.flagFinished = true;      
        break;
        
      case 5:  //円運動イベント
        rotationTimer ++;
        float theta = rotationTimer/100 * currentMoveEvent.y;     

        if(isFirstFrame){   
        cx = x - currentMoveEvent.x*cos(theta);
        cy = y - currentMoveEvent.x*sin(theta);
        isFirstFrame = false;
        }
        
        x = cx + currentMoveEvent.x*cos(theta);
        y = cy + currentMoveEvent.x*sin(theta);
        
        if (currentMoveEvent.startTick + currentMoveEvent.duration < millis()){
          isFirstFrame = true;
          currentMoveEvent.flagFinished = true;
        }
        break;
      
      case 6: //方向転換イベント
      {
        if (currentMoveEvent.isFirstFrame) {
          if (currentMoveEvent.useLocalAxis) currentMoveEvent.memory0 = rotation + currentMoveEvent.shootAngle;
          else currentMoveEvent.memory0 = currentMoveEvent.shootAngle;
        }
        if(abs(currentMoveEvent.memory0-rotation)<=180) //近いほうに回る
          rotation += (float)(currentMoveEvent.memory0 - rotation) * 0.1f<=10f ?10f :(float)(currentMoveEvent.memory0 - rotation) * 0.1f;//素早い方向転換のため
        else
          rotation -= (float)(rotation - (currentMoveEvent.memory0-360)) * 0.1f <= 10f ?10f :(float)(rotation - (currentMoveEvent.memory0-360)) * 0.1f;//素早い方向転換のため       }
        // 目的地に到着した or 時間が来たら
        float distance = abs(currentMoveEvent.memory0-rotation)<=180 ? abs(currentMoveEvent.memory0 - rotation) :abs(rotation - (currentMoveEvent.memory0-360));
        if ( distance < 0.1f 
          || currentMoveEvent.startTick + currentMoveEvent.duration < millis()){
          currentMoveEvent.flagFinished = true;
        }
        break;
      }
      case 7:  // 攻撃イベント（ショット）
      {
        float angle = currentMoveEvent.useLocalAxis ? (currentMoveEvent.shootAngle + rotation) : currentMoveEvent.shootAngle;
        bulletManager.shootBullet(0,x+70*cos(radians(angle)),y+70*sin(radians(angle)),enemyBulletSpeed*cos(radians(angle)),enemyBulletSpeed*sin(radians(angle)));
        currentMoveEvent.flagFinished = true;
        break;
      }
      case 8:  //攻撃イベント　（レーザー）
        float angle = currentMoveEvent.useLocalAxis ? (currentMoveEvent.shootAngle + rotation) : currentMoveEvent.shootAngle;
        bulletManager.shootBullet(0,x+70*cos(radians(angle)),y+70*sin(radians(angle)),enemyLaserSpeed*cos(radians(angle)),enemyLaserSpeed*sin(radians(angle)),"laser");
        if (currentMoveEvent.startTick + currentMoveEvent.duration < millis()){
          currentMoveEvent.flagFinished = true;
        }
        break; 
        
      case 9:  //自爆イベント
        for(int i = 0;i<=23;i++){
          bulletManager.shootBullet(0,x+70*cos(radians(15*i)),y+70*sin(radians(15*i)),10*cos(radians(15*i)),10*sin(radians(15*i)),"bomb");
        }
        isDead = true;
        bomber.trigger();
        gifManager.setBomb(x,y);
        currentMoveEvent.flagFinished = true;
        isStopped = true;
        break;       
        
      case 100:   // Goto
        if (currentMoveEvent.x < moveEventQueue.size()){
          currentMoveEventIndex = currentMoveEvent.x;
          currentMoveEvent = getMoveEvent(currentMoveEventIndex);
        }else{
          println("Goto Error: index is out of range.");
        }
        break;
        
    } // switch
              
    currentMoveEvent.isFirstFrame = false;
  } // executeMoveEvent
  
  
  /* イベント実行 */    
  protected void executeDrawEvent() {
    fill(255);
    stroke(0);
    pushMatrix();
    translate(x, y, z);
    rotate(radians(rotation));
    executeDrawEvent2();
    
    popMatrix();
  }

  protected void executeDrawEvent2(){
    //println("/**********");
    
    /* フレームの遷移 */
    if (frameTick + frameInterval < millis()){
      currentDrawEventsIndex++;
      if (currentDrawEventsIndex >= drawEventsArray.size()){
        currentDrawEventsIndex = 0;
      }
      currentDrawEvents = drawEventsArray.get(currentDrawEventsIndex);
      frameTick = millis();
    }

    /* 描画イベント */
    for(int i = 0; i < currentDrawEvents.size(); i++){
      
      DrawEvent event = currentDrawEvents.get(i);
      
      switch (event.type){
        
        case 1:  // 1: Ellipse
          ellipse(event.x, event.y, event.w, event.h);
          //println("Ellipse: " + event.r + " " + event.g + " " + event.b + " " + event.a);
          break;
          
        case 2:  // 2: Rectangle
          rect(event.x, event.y, event.w, event.h);
          //println("Rect: " + event.r + " " + event.g + " " + event.b + " " + event.a);
          break;
          
        case 3:  // 3: Color
          fill(event.r, event.g, event.b, event.a);
          //println("Color: " + event.r + " " + event.g + " " + event.b);
          break;
          
        case 4:  // 4: Triangle
          triangle(event.x,event.y,event.w,event.h,event.r,event.g);
          break;
          
        case 5:  // 5: Line
          line(event.x,event.y,event.w,event.h);          
          break;
          
          case 8 : // 3/15　星
          beginShape();
            for(int j = 0; j <= 5; j++){
              vertex(event.x+event.r*cos(radians(18+144*j+180+event.h)),event.y+event.r*sin(radians(18+144*j+180+event.h)));
            }
          endShape();
          break;
          
        case 9: // 3/15 多角形
          //rotate(radians(event.a+180));
          if(event.n%4 == 0){
            beginShape();
              for(int j = 0; j <= event.n; j++){
                vertex(event.x+event.r*cos(radians(90.0*(event.n-4)/event.n+720.0/event.n*j+180+event.h)),event.y+event.r*sin(radians(90.0*(event.n-4)/event.n+720.0/event.n*j+180+event.h)));
              }
            endShape();
            beginShape();
              for(int j = 0; j <= event.n; j++){
                vertex(event.x+event.r*cos(radians(360.0/event.n+90.0*(event.n-4)/event.n+720.0/event.n*j-180-event.h)),event.y-event.r*sin(radians(360.0/event.n+90.0*(event.n-4)/event.n+720.0/event.n*j-180-event.h)));
              }
            endShape();
          }
          else if(event.n%2 == 0){
            beginShape();
              for(int j = 0; j <= event.n; j++){
                vertex(event.x+event.r*cos(radians(360.0/event.n+90.0*(event.n-4)/event.n+720.0/event.n*j+180+event.h)),event.y+event.r*sin(radians(360.0/event.n+90.0*(event.n-4)/event.n+720.0/event.n*j+180+event.h)));
              }
            endShape();
            beginShape();
              for(int j = 0; j <= event.n; j++){
                vertex(event.x-event.r*cos(radians(360.0/event.n+90.0*(event.n-4)/event.n+720.0/event.n*j+180+event.h)),event.y-event.r*sin(radians(360.0/event.n+90.0*(event.n-4)/event.n+720.0/event.n*j+180+event.h)));//180
              }
            endShape();
          }
          else{
            beginShape();
              for(int j = 0; j <= event.n; j++){
                vertex(event.x+event.r*cos(radians(90.0*(event.n-4)/event.n+720.0/event.n*j+180+event.h)),event.y+event.r*sin(radians(90.0*(event.n-4)/event.n+720.0/event.n*j+180+event.h)));
              }
            endShape();
          }
          break; 
          
        case 11:
          beginShape();
            for(int j = 0; j <= event.n; j++){
              vertex(event.x+event.r*cos(radians(90.0*(event.n-4)/event.n+360.0/event.n*j+180+event.h)), event.y+event.r*sin(radians(90.0*(event.n-4)/event.n+360.0/event.n*j+180+event.h)));
            }
          endShape();
        break;
          
        case 12:
          float startAngle = event.h;
          float endAngle = event.w;
          arc(event.x,event.y,event.r,event.r,radians(startAngle),radians(endAngle),PIE);  
        break;
         
          
          
        case 10:  // アニメーションスピード変更
          setFrameInterval(event.x);
          break;
          
      } // switch
            
    } // for
        
    //println("**********/");
    
  } // executeDrawEvent
    
  /* 動く */
  public void move(){
    if (isDead) return;
    
    if (isStopped){
      executeDrawEvent();
      return;
    }
    
    if ( currentMoveEvent != null ){
      executeMoveEvent();
    
      /* 時間が来た、もしくはイベント終了フラグが上がったら次のイベントへ */
      if ( currentMoveEvent.flagFinished ){
        
        currentMoveEvent.flagFinished = false;  // フラグを下す
        currentMoveEvent.isFirstFrame = true;
        println("CurrentEventIndex: " + currentMoveEventIndex);
        
        /* 1週限りの場合 */
        //currentMoveEvent = getNextMoveEvent();
        //currentEventIndex++;
        
        /* キューを繰り返す場合 */
        currentMoveEventIndex++;
        if (currentMoveEventIndex >= moveEventQueue.size()){
          currentMoveEventIndex = 0;
        }
        currentMoveEvent = getMoveEvent(currentMoveEventIndex);
      }
    
    }else{
      isStopped = true;
      isStarted = false;
      println("Stopped. CurrentMoveEvent is null");
    }
    
    executeDrawEvent();
    
    for (Bullet bullet: bulletManager.bulletArray) {//あたり判定 3/20
      if (bullet == null) continue;
      if (bullet.handID == 0) continue;
      
      if (isInside(bullet.x, bullet.y)) {
        HP --;
        bullet.hp = 0;
        score += 10;
      }
    }
    
    if(x<=-width/2)x=width/2-1;
    else if(x>=width/2)x=-width/2+1;
    else if(y<=-height/2)y=height/2-1;
    else if(y>=height/2)y=-height/2+1;  //画面内に収まるように
    
    if (HP <= 0) { //死んだとき
      bomber.trigger();
      gifManager.setBomb(x,y);
      isDead = true;
      score += 100;
    }
  } // move
  
  
  protected boolean isInside(float x, float y){//あたり判定 3/20
    x -= this.x;
    y -= this.y;

    float theta = radians(rotation);
    for(int i = 0; i < currentDrawEvents.size(); i++){
      DrawEvent event = currentDrawEvents.get(i);

      float theta2 = -(atan2(event.x, event.y) - PI/2);
      float er = dist(0, 0, event.x, event.y);
      float ex = er * cos(theta + theta2); float ey = er * sin(theta + theta2);

      // fill(0); ellipse(this.x + ex, this.y + ey, 200, 200); // あたり判定デバッグ用

      switch (event.type){
        case 1:  // 1: Ellipse
        case 2:  // 2: Rectangle
          if (ex - event.w/2 < x && x <= ex + event.w/2
              && ey - event.h/2 < y && y <= ey + event.h/2) return true;
          /*
          float theta = radians(rotation);
          float ltR = dist(0,0, event.x - event.w/2, event.y - event.h/2);
          float ltX = ltR * cos(theta); float ltY = ltR * sin(theta);
          float rbR = dist(0,0, event.x + event.w/2, event.y + event.h/2);
          float rbX = rbR * cos(theta); float rbY = rbR * sin(theta);
          
          if (ltX < x && x <= rbX
              && ltY < y && y <= rbY) return true;
          */
          break;
        case 4:  // 4: Triangle
          float er2 = dist(0, 0, event.w, event.h); float ex2 = er2 * cos(theta); float ey2 = er2 * sin(theta);
          float er3 = dist(0, 0, event.w, event.h); float ex3 = er3 * cos(theta); float ey3 = er3 * sin(theta);
          float minX = min(ex, ex2, ex3);
          float minY = min(ey, ey2, ey3);
          float maxX = max(ex, ex2, ex3);
          float maxY = max(ey, ey2, ey3);

          if (minX < x && x <= maxX
              && minY < y && y <= maxY) return true;
          break;
        case 5:  // 5: Line
          break;
        case 8:
        case 9:
        case 11:
          if (dist(x, y, ex, ey) < event.r) return true;
          break;
      }
    }
    return false;
  }
  
}