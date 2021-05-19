/*********************************************

 つまんだところに即移動ではなくつまんだところに
 向かうようにした。瞬間移動はこれでできなくなった
 
*********************************************/



class Ship{
  float x, y;
  float velocitySize = 20;
  float velocityX,velocityY;
  float handArmX, handArmY;
  float tarretAngle;//旧mouse_armAngle
  int tarretTickness = 10;
  int tarretLength =100;
  // int shootSpeed = 10; 
  int hp = 10;           
  float picapica;
  int armedID;//装備した手のID、あとで、同じIDを認証してその手のpinchX,pinchYを追従するようにするための変数
  boolean armed = false;
  boolean alive = true;
  
  int noDamageTime = -3000;
  
  float bairitu = 1;//大きさ倍率 ゲームバランス調整用
  
  int playerno;
  
  Ship(){

  }
  
  public void move(){//あたりはんてい等
    for(int i=0; i<MAX_HANDS; i++){
        if(handManager.handArray[i] != null){//装備していない船、装備していない手どうしが近づいたら装備成立
            if( dist( x, y, handManager.handArray[i].handData.pinchX, handManager.handArray[i].handData.pinchY) < 100){
              if(armed == false && handManager.handArray[i].arming ==false){
                handManager.handArray[i].arming = true;
                armed = true;
                armedID = handManager.handArray[i].handData.id;
              }
            }   
            
            if(armed == true){
              
              if(armedID == handManager.handArray[i].handData.id){
                
                if(handManager.handArray[i].handData.handState == true){
                  velocityX = velocitySize*cos(atan2(handManager.handArray[i].handData.pinchY - y, handManager.handArray[i].handData.pinchX - x));
                  velocityY = velocitySize*sin(atan2(handManager.handArray[i].handData.pinchY - y, handManager.handArray[i].handData.pinchX - x));
                  handArmX = handManager.handArray[i].handData.armX;
                  handArmY = handManager.handArray[i].handData.armY;
                  
                    if(handManager.handArray[i].handData.handState == true){
                       tarretAngle = atan2(handManager.handArray[i].handData.pinchY - y, handManager.handArray[i].handData.pinchX - x);
                    }
                  
                  if( dist( x, y, handManager.handArray[i].handData.pinchX, handManager.handArray[i].handData.pinchY) > 100){
                    x +=velocityX;//ある程度離れてたら手の方に向かう
                    y +=velocityY;         
                  }
                }
                if ( handManager.handArray[i].handData.handState == false && handManager.handArray[i].prevHandData.handState == true ){
                  shootReleasedBall(handManager.handArray[i].handData, handManager.handArray[i].prevHandData);
                  beam.trigger();
                }
              }
            }          
        } //if null           
    }//for
    
    if(armed ==true){//armed==trueのとき全ての手のIDをみて一致するものがなかったらfalseにする
      for(int i=0; i<MAX_HANDS; i++ ){
        if(handManager.handArray[i]!=null){   
          if(handManager.handArray[i].handData.id == armedID){
            
           armed = true;
           break;
         
          }
           armed =false;
        }    
      }
    }
    for(int i = 0; i < bulletManager.maxBullets; i++){
      if(bulletManager.bulletArray[i] != null){
        if(bulletManager.bulletArray[i].handID != 0) continue;
        
        if(dist(bulletManager.bulletArray[i].x, bulletManager.bulletArray[i].y, x,y) < bairitu*80){     
          if(millis() - noDamageTime > 1500){
            hp --;
            bulletManager.bulletArray[i].hp=0;
            noDamageTime = millis();           
          }
         }
        for(int j=0; j<5; j++){
          if(bulletManager.bulletArray[i].handID != 0) continue;
          if(dist(x+bairitu*(55+10*j)*cos(tarretAngle),y+bairitu*(55+10*j)*sin(tarretAngle),bulletManager.bulletArray[i].x, bulletManager.bulletArray[i].y)<bairitu*15){            
            if(millis() - noDamageTime > 1500){
              hp--;            
              bulletManager.bulletArray[i].hp=0;
              noDamageTime = millis();
            }
          }
          //if(dist(x+bairitu*60*cos(tarretAngle+PI/2-PI/4+j*PI/8),y+bairitu*60*sin(tarretAngle+PI/2-PI/4+j*PI/8),bulletManager.bulletArray[i].x, bulletManager.bulletArray[i].y)<bairitu*15){
          //  bulletManager.bulletArray[i].hp=0;
          //}//盾
          //if(dist(x+bairitu*60*cos(tarretAngle-PI/2-PI/4+j*PI/8),y+bairitu*60*sin(tarretAngle-PI/2-PI/4+j*PI/8),bulletManager.bulletArray[i].x, bulletManager.bulletArray[i].y)<bairitu*15){
          //  bulletManager.bulletArray[i].hp=0;
          //}
        }
        
      }//!null
    }//for
    
    if(hp<0){
      for(int i=0; i<MAX_HANDS; i++){
        if(handManager.handArray[i]!=null){
          if(armedID==handManager.handArray[i].handData.id){
            handManager.handArray[i].arming=false;
          }
        }
      }
    }
    
    
  
  }//move
  
  public void render(){
    
      if(millis() - noDamageTime < 1500){
        picapica = 255 * abs(sin(radians(millis())));
      }else{
        picapica = 255;
      }
      stroke(2);
      fill(25, 149, 209, picapica);//点滅するように見える。
      ellipse(x, y, bairitu*50, bairitu*50);
      fill(255,255,255,picapica);
      ellipse(x, y, bairitu*40, bairitu*40);
      fill(0,255,0);
      rectMode(CORNER);
      rect(x-80,y-40,20,hp*10);//HPゲージ
      rectMode(CENTER);
      fill(255,255,255,picapica);
    
      pushMatrix();
        translate(x, y);//pushからpopまでで、別の座標系で、原点をmouseX,mouseYに持っていってそこで描いたものを元の座標系にそのまま重ねる処理を表す。
        rotate(tarretAngle + radians(-90));//ここから下に描いたものは一緒になって、回転する。
        //tarret部分
        //fill(#100940);
        beginShape();
          vertex(-bairitu*tarretTickness, 0);
          vertex(-bairitu*tarretTickness, bairitu*tarretLength);
          vertex(+bairitu*tarretTickness, bairitu*tarretLength);
          vertex(+bairitu*tarretTickness, 0);//ここで止まると、下がしまっていない状態となる
        endShape();
    
          //shield部分
        stroke(255,255,255,picapica);
        //fill(#100940);
        //arc(bairitu*tarretTickness * 12, 0, bairitu*tarretTickness * 15, bairitu*tarretTickness * 15, radians(150), radians(210));
        noStroke();
        fill(255);
        //ellipse(bairitu*tarretTickness * 12, 0, bairitu*tarretTickness * 12, bairitu*tarretTickness * 12);
    
        stroke(255,255,255,picapica);
        fill(#100940);
        //arc(- bairitu*tarretTickness * 12, 0, bairitu*tarretTickness * 15, bairitu*tarretTickness * 15, radians(330), radians(390));
        noStroke();
        fill(255);
        //ellipse(- bairitu*tarretTickness * 12, 0, bairitu*tarretTickness * 12, bairitu*tarretTickness * 12);
      popMatrix();
        stroke(0,0,0,picapica);
  
       for(int j=0; j<5; j++){//あたり判定の見える化
       //ellipse(x+bairitu*(55+10*j)*cos(tarretAngle),y+bairitu*(55+10*j)*sin(tarretAngle),bairitu*30,bairitu*30);
       ellipse(x+bairitu*60*cos(tarretAngle-PI/2-PI/4+j*PI/5),y+bairitu*60*sin(tarretAngle-PI/2-PI/4+j*PI/5),bairitu*30,bairitu*30);
       ellipse(x+bairitu*60*cos(tarretAngle+PI/2-PI/4+j*PI/5),y+bairitu*60*sin(tarretAngle+PI/2-PI/4+j*PI/5),bairitu*30,bairitu*30);       
        }
       
       fill(playerno*40,255-playerno*40,playerno*20);
       //text(playerno,x,y);//何らかの形で個体識別できるように
      
       stroke(0);
       fill(255);
  }
  
  public void shootReleasedBall(HandData handData , HandData prevHandData){
    
    //tarretAngle = atan2(y - handData.armY, x - handData.armX);
    
    bulletManager.shootBullet(handData.id, x  + bairitu*(30+tarretLength) * cos(tarretAngle), y  + bairitu*(30+tarretLength) * sin(tarretAngle),
      cos(tarretAngle)* shipBulletSpeed, sin(tarretAngle) * shipBulletSpeed,"ship");    // 注意: 放した瞬間からpinchX/pinchYが使えなくなるので、発射には前フレームのデータを使う
  //     shootSE.trigger();
  } // shootReleasedBall  
  

  
  
}