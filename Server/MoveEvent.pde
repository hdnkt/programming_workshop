/***********************************************
    移動イベント
    2018/03/10 by SATOToshiki
 ***********************************************/

static class MoveEvent{
  
  public byte type;        // イベントの種類  
  public int duration;     // 継続時間  
  public int startTick;    // 開始時刻  
  public int x, y;         // 移動パラメータ(移動量・目的座標)
  public int shootAngle; //撃つ方向
  public boolean useLocalAxis; // キャラクタの座標軸で計算する

  public float memory0;
  public boolean isFirstFrame = true; // 最初の1回だけtrueのフラグ
  public boolean flagFinished;    // イベント終了フラグ
  
  /* サイズ */
  protected static int byteCount = 18;  // データの総バイト数 
  static public int getByteCount(){
    return byteCount;
  }
  
  /* 送信用にbyte配列に直したデータを渡す */
  public byte[] getByteArray(){
    byte[] byteArray = new byte[byteCount];
    
    byteArray[0] = type;
    
    /* duration */
    byteArray[1] = (byte)(duration >> 24 & 0xFF);
    byteArray[2] = (byte)((duration >> 16) & 0xFF);
    byteArray[3] = (byte)((duration >> 8) & 0xFF);
    byteArray[4] = (byte)(duration & 0xFF);
        
    /* x */
    byteArray[5] = (byte)(x >> 24 & 0xFF);
    byteArray[6] = (byte)((x >> 16) & 0xFF);
    byteArray[7] = (byte)((x >> 8) & 0xFF);
    byteArray[8] = (byte)(x & 0xFF);
    
    /* y */
    byteArray[9] = (byte)(y >> 24 & 0xFF);
    byteArray[10] = (byte)((y >> 16) & 0xFF);
    byteArray[11] = (byte)((y >> 8) & 0xFF);
    byteArray[12] = (byte)(y & 0xFF);
    
    /* shootAngle */
    byteArray[13] = (byte)(shootAngle >> 24 & 0xFF);
    byteArray[14] = (byte)((shootAngle >> 16) & 0xFF);
    byteArray[15] = (byte)((shootAngle >> 8) & 0xFF);
    byteArray[16] = (byte)(shootAngle & 0xFF);

    byteArray[17] = (byte)((useLocalAxis ? 1 : 0) & 0xFF);
    
    return byteArray;
  } // getByteArray
  
  /* Byte配列からデータを復元 */
  public void setDataFromByteArray(byte[] byteArray){
    type = byteArray[0];
    duration = ((byteArray[1] & 0xFF) << 24) | ((byteArray[2] & 0xFF) << 16) | ((byteArray[3] & 0xFF) << 8) | ((byteArray[4] & 0xFF));
    x = ((byteArray[5] & 0xFF) << 24) | ((byteArray[6] & 0xFF) << 16) | ((byteArray[7] & 0xFF) << 8) | ((byteArray[8] & 0xFF));
    y = ((byteArray[9] & 0xFF) << 24) | ((byteArray[10] & 0xFF) << 16) | ((byteArray[11] & 0xFF) << 8) | ((byteArray[12] & 0xFF));
    shootAngle = ((byteArray[13] & 0xFF) << 24) | ((byteArray[14] & 0xFF) << 16) | ((byteArray[15] & 0xFF) << 8) | ((byteArray[16] & 0xFF));
    useLocalAxis = (byteArray[17] & 0xFF) == 1;
    println("MoveEvent: Type: " + type + " Duration: " + duration + " X: " + x + " Y: " + y + " shootAngle: "+ shootAngle + " useLocalAxis: "+ useLocalAxis);
  } // setDataFromByteArray 
}