/***************************************************
    手管理クラス
      2016/07/09 by SATOToshiki    
 ***************************************************/
/********
   改変
*********/

//handクラスはここで用いる。大本で用いるのはhand_managerクラスのみ

class HandManager{

  Hand[] handArray;
  int maxHands;
  
  HandManager(int maxHands){
    this.maxHands = maxHands;
    handArray = new Hand[maxHands];
    for (int i = 0; i < maxHands; i++){
      handArray[i] = null;    // 最初はnull(空っぽ)
    }
  }
  
  /* 手データの更新 */
  void updateHands(HandData[] srcHandDataArray){
    
    /* 全てのHandDataについて */
    for ( int i = 0; i < maxHands; i++ ){
      
      /* 空っぽのデータは無視 */
      if ( srcHandDataArray[i].id == 0 ){
        continue;
      }
            
      /* 全てのHandについて */
      boolean isUpdated = false;    // 更新されたかフラグ
      for ( int j = 0; j < maxHands; j++ ){

        /* 同じIDがあれば更新 */
        if ( handArray[j] != null ){
          if ( srcHandDataArray[i].id == handArray[j].getID() ){
            handArray[j].update( srcHandDataArray[i] );
            isUpdated = true;
            break;    // 見つかれば、次のデータに行く
          }        
        }
      } 
      
      /* 更新されていれば次へ */
      if ( isUpdated ){
        continue;
      }
      
      /* 更新がなければ新規追加 */
      for (int j = 0; j < maxHands; j++){
        if ( handArray[j] == null ){
          handArray[j] = new Hand();
          handArray[j].update( srcHandDataArray[i] );
          println("Added: " + srcHandDataArray[i].id);
          break;    // 見つかれば、次のデータに行く
        }
      }
      
    } // for
    
    /* 更新されてなければ削除 */
    for (int j = 0; j < maxHands; j++){
      if ( handArray[j] != null ){
        handArray[j].shootReleasedBall();
        if ( millis() - handArray[j].getLastUpdatedTime() > 100 ){
          println("Deleted: " + handArray[j].getID() + "(" + (millis() - handArray[j].getLastUpdatedTime()));
          handArray[j] = null;    // 消す
        }
      }
    }
  
  } // updateHands
  
  /* 手の描画 */
  void renderHands(){
    for (int j = 0; j < maxHands; j++){
      if ( handArray[j] != null ){
        handArray[j].render();
      }
    }  
  } // renderHands

}