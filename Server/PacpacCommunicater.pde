/*************************************************************
    PacPacデータ受信サンプル
    受信レート:
      カメラ側のデータ送信レートは約200fps前後。
      released()関数は200fpsで呼び出される(コールバックされる)が、
      draw()関数は60fpsでしかまわっていない。
    2016/07/02 by SATOToshiki@TokyoTech
    2016/07/03 Updated by SATOToshiki@TokyoTech
      1つ前のフレームデータを保存するようにした。
 *************************************************************/
/********
　　改変
*********/

import hypermedia.net.*;
UDP udpServer;
  
HandData[] handDataArray;        // 受け取った手データはHandData構造体に変換してこの配列に格納する

/* 定数値 */
int MAX_HANDS = 10;
int PORT_NO = 31416;
int UDP_RECEIVE_DATA_SIZE = 40;

/* 手データクラス */
class HandData{
  HandData(){
    id = 0;
  }
  public int id;                              // idが0: 未使用データ
  public float armSize;
  public float armX, armY;
  public float pinchSize;
  public float pinchX, pinchY;                // handStateがtrueの場合のみ有効
  public float pinchOriginX, pinchOriginY;    // handStateがtrueの場合のみ有効
  public boolean handState;                   // 1: pinched(手で輪っかを作っている状態), 0: released(手の輪っかに穴がある状態)
}

/* 初期化 */
void initialize(){//initializeはここで定義されたもの。
  
  udpServer = new UDP(this, PORT_NO);
  udpServer.setBuffer(UDP_RECEIVE_DATA_SIZE * MAX_HANDS);
  udpServer.setReceiveHandler("receive");
  udpServer.listen(true);

  /* HandData配列の初期化 */
  handDataArray = new HandData[MAX_HANDS];
  for (int i = 0; i < MAX_HANDS; i++){
    handDataArray[i] = new HandData();
  }
  
} // initialize

/* UDP receive callback function */
void receive(byte[] data, String hostIP, int portNo){
  
  for (int i = 0; i < MAX_HANDS; i++){    
    handDataArray[i].id = byteArrayToInt(data[(i * UDP_RECEIVE_DATA_SIZE) + 0], data[(i * UDP_RECEIVE_DATA_SIZE) + 1], data[(i * UDP_RECEIVE_DATA_SIZE) + 2], data[(i * UDP_RECEIVE_DATA_SIZE) + 3]);          // id    
    handDataArray[i].pinchSize = byteArrayToFloat(data[(i * UDP_RECEIVE_DATA_SIZE) + 4], data[(i * UDP_RECEIVE_DATA_SIZE) + 5], data[(i * UDP_RECEIVE_DATA_SIZE) + 6], data[(i * UDP_RECEIVE_DATA_SIZE) + 7]);      // pinch size    
    handDataArray[i].armSize = byteArrayToFloat(data[(i * UDP_RECEIVE_DATA_SIZE) + 8], data[(i * UDP_RECEIVE_DATA_SIZE) + 9], data[(i * UDP_RECEIVE_DATA_SIZE) + 10], data[(i * UDP_RECEIVE_DATA_SIZE) + 11]);      // arm size    
    handDataArray[i].handState = boolean(byteArrayToInt(data[(i * UDP_RECEIVE_DATA_SIZE) + 12], data[(i * UDP_RECEIVE_DATA_SIZE) + 13], data[(i * UDP_RECEIVE_DATA_SIZE) + 14], data[(i * UDP_RECEIVE_DATA_SIZE) + 15]));  // hand state    
    handDataArray[i].pinchX = -width/2 + byteArrayToFloat(data[(i * UDP_RECEIVE_DATA_SIZE) + 16], data[(i * UDP_RECEIVE_DATA_SIZE) + 17], data[(i * UDP_RECEIVE_DATA_SIZE) + 18], data[(i * UDP_RECEIVE_DATA_SIZE) + 19]);       // arm X
    handDataArray[i].pinchY = -height/2 + byteArrayToFloat(data[(i * UDP_RECEIVE_DATA_SIZE) + 20], data[(i * UDP_RECEIVE_DATA_SIZE) + 21], data[(i * UDP_RECEIVE_DATA_SIZE) + 22], data[(i * UDP_RECEIVE_DATA_SIZE) + 23]);       // arm Y    
    handDataArray[i].armX = -width/2 + byteArrayToFloat(data[(i * UDP_RECEIVE_DATA_SIZE) + 24], data[(i * UDP_RECEIVE_DATA_SIZE) + 25], data[(i * UDP_RECEIVE_DATA_SIZE) + 26], data[(i * UDP_RECEIVE_DATA_SIZE) + 27]);     // pinch Z
    handDataArray[i].armY = -height/2 + byteArrayToFloat(data[(i * UDP_RECEIVE_DATA_SIZE) + 28], data[(i * UDP_RECEIVE_DATA_SIZE) + 29], data[(i * UDP_RECEIVE_DATA_SIZE) + 30], data[(i * UDP_RECEIVE_DATA_SIZE) + 31]);     // pinch Y
    handDataArray[i].pinchOriginX = -width/2 + byteArrayToFloat(data[(i * UDP_RECEIVE_DATA_SIZE) + 32], data[(i * UDP_RECEIVE_DATA_SIZE) + 33], data[(i * UDP_RECEIVE_DATA_SIZE) + 34], data[(i * UDP_RECEIVE_DATA_SIZE) + 35]);        // pinch originX
    handDataArray[i].pinchOriginY = -height/2 + byteArrayToFloat(data[(i * UDP_RECEIVE_DATA_SIZE) + 36], data[(i * UDP_RECEIVE_DATA_SIZE) + 37], data[(i * UDP_RECEIVE_DATA_SIZE) + 38], data[(i * UDP_RECEIVE_DATA_SIZE) + 39]);        // pinch originY
  }  
  
} // receive

/* Spaceを推している間、デバッグ用の手がでる
   (armX/armYは画面中央、pinchX/pinchYはクリック位置になる) */
void sendHandData(){
  if (key == ' '){
    handDataArray[0].id = 31416; 
    handDataArray[0].armSize = 5000.0f;  
    handDataArray[0].armX = width / 2;
    handDataArray[0].armY = height / 2;
    if ( mousePressed && mouseButton == LEFT ){
      handDataArray[0].handState = true;    
      handDataArray[0].pinchSize = 5000.0f;  
    }else{
      handDataArray[0].handState = false;        
      handDataArray[0].pinchSize = 0.0f;   
    }
      handDataArray[0].pinchX = mouseX - width/2;    
      handDataArray[0].pinchY = mouseY - height/2;  
  }
} // keyPressed

/* コピーする(from source to destination) */
void copyHandDataArray(HandData[] src, HandData[] dst){
  for ( int i = 0; i < MAX_HANDS; i++ ){
    dst[i].id = src[i].id;
    dst[i].pinchSize = src[i].pinchSize;
    dst[i].armSize = src[i].armSize;
    dst[i].handState = src[i].handState;
    dst[i].pinchX = src[i].pinchX;
    dst[i].pinchY = src[i].pinchY;
    dst[i].armX = src[i].armX;
    dst[i].armY = src[i].armY;
    dst[i].pinchOriginX = src[i].pinchOriginX;
    dst[i].pinchOriginY = src[i].pinchOriginY;
  }
} // copyHandDataArray

/* HandDataのコピー */
void copyHandData(HandData src, HandData dst){
  dst.id = src.id;
  dst.pinchSize = src.pinchSize;
  dst.armSize = src.armSize;
  dst.handState = src.handState;
  dst.pinchX = src.pinchX;
  dst.pinchY = src.pinchY;
  dst.armX = src.armX;
  dst.armY = src.armY;
  dst.pinchOriginX = src.pinchOriginX;
  dst.pinchOriginY = src.pinchOriginY;
} // copyHandDataArray
 
/* 手の位置マーカ描画 */
void drawHandMarker(){
  
  for (int i=0; i<MAX_HANDS; i++) {
    if(handDataArray[i].id != 0){
      int tarretTickness = 10;
      int tarretSize = 100;
      ellipse(handDataArray[i].armX, handDataArray[i].armY, tarretTickness * 2, tarretTickness * 2 );
      if(handDataArray[i].handState == true){
        fill(#E8BF67);
        ellipse(handDataArray[i].armX, handDataArray[i].armY, 50, 50);
        fill(#407E0E);
        beginShape();
        vertex(handDataArray[i].armX - tarretTickness, handDataArray[i].armY);
        vertex(handDataArray[i].armX - tarretTickness, handDataArray[i].armY + tarretSize);
        vertex(handDataArray[i].armX + tarretTickness, handDataArray[i].armY + tarretSize);
        vertex(handDataArray[i].armX + tarretTickness, handDataArray[i].armY);
        endShape();
        
      }
    }
    
  }

  
  
  /* 手の位置に〇をおいてみる */
  for ( int i = 0; i < MAX_HANDS; i++ ) {//手の数分だけ、処理を行う

    if ( handDataArray[i].id != 0 ) {    // idが0じゃないデータは有効なデータ

      /* 腕の位置 */
      ellipse(handDataArray[i].armX, handDataArray[i].armY, 10, 10);    

      /* つまんだ位置 */
      if ( handDataArray[i].handState == true ) {
        ellipse(handDataArray[i].pinchX, handDataArray[i].pinchY, 50, 50);
      } 
    }
  }
} // drawHandMarker

/* byte[] to float */
float byteArrayToFloat(byte array0, byte array1, byte array2, byte array3){
  String hexInt = hex(array3) + hex(array2) + hex(array1) + hex(array0);
  return Float.intBitsToFloat( unhex(hexInt) );
} // byteArrayToFloat

/* byte[] to int */
int byteArrayToInt(byte array0, byte array1, byte array2, byte array3){
  return (array3 & 0xFF) | ((array2 & 0xFF) << 8) | ((array1 & 0xFF) << 16) | ((array0 & 0xFF) << 24);
} // byteArrayToFloat 