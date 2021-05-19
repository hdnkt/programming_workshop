/**
 * --- 180324.10 NetworkManager ---
 **/

/***********************************************
    送信クラス
    2018/03/11 by SATOToshiki
 ***********************************************/
 
import hypermedia.net.*;

static class NetworkManager{

  static UDP udpClient;
  static int SEND_BUFFER_SIZE = 1024;
  static byte[] sendBuffer;
  
    /* サーバ情報 */
  static String ipAddress = "192.168.0.12";
  static int portNo = 31417;

  /* 送信 */
  static void sendToServer(Character characterToSend, Object thisPtr){
    int moveEventQueueTotalByteCount;
    int drawEventsArrayTotalByteCount;
    int sendBufferSize;

    /* 送信バッファサイズの計算 */
    moveEventQueueTotalByteCount = characterToSend.getMoveEventQueueByteCount();
    drawEventsArrayTotalByteCount = characterToSend.getDrawEventsArrayTotalByteCount();
    sendBufferSize 
      = moveEventQueueTotalByteCount          // MoveEventQueueのデータサイズ
      + drawEventsArrayTotalByteCount         // DrawEventsArrayのデータサイズ
      + DrawEvent.getByteCount() * (characterToSend.getDrawEventsFrameCount() - 1)   // AddFrameの代わりに挿入されるDrawEventのデータサイズ
      + 2;    // MoveEventQueueの個数データとDrawEventsArray内の総フレーム数(AddFrame命令を含む)を格納する2byteのヘッダ
    println("MoveEvent DataSize: " + MoveEvent.getByteCount() + " DrawEvent DataSize: " + DrawEvent.getByteCount());
    println("TotalSendBufferSize: " + sendBufferSize + "bytes (MoveEventByteCount: " + moveEventQueueTotalByteCount + " DrawEventByteCount:" + drawEventsArrayTotalByteCount + ")");
    
    /* ネットワークの初期化 */
    sendBuffer = new byte[sendBufferSize];  
    udpClient = new UDP(thisPtr);
    udpClient.setBuffer(sendBufferSize);   // set Packet Size  
    
    int index = 0;
    
    /* 0. MoveEventQueue内のコマンド個数 */
    sendBuffer[0] = (byte)characterToSend.getMoveEventQueueCount();
    index++;
  
    /* 1. DrawEventsArray内の総フレーム数(AddFrame命令を含む) */   
    int maxDrawEventCountToSend 
      = characterToSend.getDrawEventsArrayTotalCommandCount()    // コマンドの個数
      + characterToSend.getDrawEventsFrameCount() - 1;           // AddFrame()命令の個数
    sendBuffer[1] = (byte)maxDrawEventCountToSend;
    index++;
        
    /* 2. MoveEventQueue内の全コマンドデータのバイト配列を格納 */
    byte[] moveEventByteArray = characterToSend.getMoveEventQueueByteArray();
    for (int i = 0; i < moveEventQueueTotalByteCount; i++, index++){
      sendBuffer[index] = moveEventByteArray[i];
    }
    
    /* DrawEventsArray内のそれぞれのDrawEvents内の全コマンドデータのバイト配列を格納 */ 
    for (int j = 0; j < characterToSend.getDrawEventsFrameCount(); j++){
      
      /* まず各フレームのDrawEventsのバイト配列を入れる */
      byte[] drawEventsByteArray = characterToSend.getDrawEventsByteArray(j);  
      int drawEventsByteCount = characterToSend.getDrawEventsByteCount(j);
      for (int i = 0; i < drawEventsByteCount; i++, index++){
        sendBuffer[index] = drawEventsByteArray[i];
      }
      
      /* フレームの区切りとして、AddFrameコマンドのEventDataのバイト配列も挿入 */
      if (j < characterToSend.getDrawEventsFrameCount() - 1){    // 最後のフレームの後にはAddFrameは必要ない
        DrawEvent addFrameEvent = new DrawEvent();
        addFrameEvent.type = -1;  // AddFrameコマンド
        byte [] addFrameCommandByteArray = addFrameEvent.getByteArray();
        for (int i = 0; i < DrawEvent.getByteCount(); i++, index++){
          sendBuffer[index] = addFrameCommandByteArray[i];
        }
      }
    }
    
    /* 送信 */
    udpClient.send(sendBuffer, ipAddress, portNo);
    
    /* ネットワークの解放 */
    udpClient.close();
    udpClient = null;
    
  } // sendToServer
}