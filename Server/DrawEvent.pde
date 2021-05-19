/**
 * --- 180323.4 DrawEvent ---
 **/

/***********************************************
    描画イベント
    2018/03/10 by SATOToshiki
 ***********************************************/
 
static class DrawEvent{
  
  public byte type;         // 形状
  public int x, y, z;       // 位置のオフセット
  public int w, h;          // 大きさ
  public int r, g, b, a;    // 色
  public int n;             //多角形の角
    
  static protected int byteCount = 31;  // データの総バイト数  
  static public int getByteCount(){
    return byteCount;
  }
  
  /* 送信用にbyte配列に直したデータを渡す */
  public byte[] getByteArray(){
    
    byte[] byteArray = new byte[byteCount];
    
    byteArray[0] = type;
    
    /* x */
    byteArray[1] = (byte)(x >> 24 & 0xFF);
    byteArray[2] = (byte)(x >> 16 & 0xFF);
    byteArray[3] = (byte)(x >> 8 & 0xFF);
    byteArray[4] = (byte)(x & 0xFF);
    
    /* y */
    byteArray[5] = (byte)(y >> 24 & 0xFF);
    byteArray[6] = (byte)(y >> 16 & 0xFF);
    byteArray[7] = (byte)(y >> 8 & 0xFF);
    byteArray[8] = (byte)(y & 0xFF);
    
    /* w */
    byteArray[9] = (byte)(w >> 24 & 0xFF);
    byteArray[10] = (byte)(w >> 16 & 0xFF);
    byteArray[11] = (byte)(w >> 8 & 0xFF);
    byteArray[12] = (byte)(w & 0xFF);
    
    /* h */
    byteArray[13] = (byte)(h >> 24 & 0xFF);
    byteArray[14] = (byte)(h >> 16 & 0xFF);
    byteArray[15] = (byte)(h >> 8 & 0xFF);
    byteArray[16] = (byte)(h & 0xFF);
    
    /* R */
    byteArray[17] = (byte)(r >> 24 & 0xFF);
    byteArray[18] = (byte)(r >> 16 & 0xFF);
    byteArray[19] = (byte)(r >> 8 & 0xFF);
    byteArray[20] = (byte)(r & 0xFF);
    
    /* G */
    byteArray[21] = (byte)(g >> 24& 0xFF);
    byteArray[22] = (byte)(g >> 16& 0xFF);
    byteArray[23] = (byte)(g >> 8 & 0xFF);
    byteArray[24] = (byte)(g & 0xFF);
    
    /* B */
    byteArray[25] = (byte)(b >> 8 & 0xFF);
    byteArray[26] = (byte)(b & 0xFF);
   
    /* A */
    byteArray[27] = (byte)(a >> 8 & 0xFF);
    byteArray[28] = (byte)(a & 0xFF);
    
    /* n */
    byteArray[29] = (byte)(n >> 8 & 0xFF);
    byteArray[30] = (byte)(n & 0xFF);
    
    return byteArray;
  } // convertToByteArray
  
  /* Byte配列からデータを復元 */
  public void setDataFromByteArray(byte[] byteArray){
    type = byteArray[0];
    x = (byteArray[1] & 0xFF) << 24 | (byteArray[2] & 0xFF) << 16 | (byteArray[3] & 0xFF) << 8 | (byteArray[4] & 0xFF);
    y = (byteArray[5] & 0xFF) << 24 | (byteArray[6] & 0xFF) << 16 | (byteArray[7] & 0xFF) << 8 | (byteArray[8] & 0xFF);
    w = (byteArray[9] & 0xFF) << 24 | (byteArray[10] & 0xFF) << 16 | (byteArray[11] & 0xFF) << 8 | (byteArray[12] & 0xFF);
    h = (byteArray[13] & 0xFF) << 24 | (byteArray[14] & 0xFF) << 16 | (byteArray[15] & 0xFF) << 8 | (byteArray[16] & 0xFF);
    r = (byteArray[17] & 0xFF) << 24 | (byteArray[18] & 0xFF) << 16 | (byteArray[19] & 0xFF) << 8 | (byteArray[20] & 0xFF);
    g = (byteArray[21] & 0xFF) << 24 | (byteArray[22] & 0xFF) << 16 | (byteArray[23] & 0xFF) << 8 | (byteArray[24] & 0xFF);
    b = (byteArray[25] & 0xFF) << 8 | (byteArray[26] & 0xFF);
    a = (byteArray[27] & 0xFF) << 8 | (byteArray[28] & 0xFF);
    n = (byteArray[29] & 0xFF) << 8 | (byteArray[30] & 0xFF);
    println("DrawEvent: Type: " + type + " W: " + w + " H: " + h + "R: " + r + "G: " + g + "B: " + b + "A: " + a + "N: "+ n);  
  } // setDataFromByteArray  
}