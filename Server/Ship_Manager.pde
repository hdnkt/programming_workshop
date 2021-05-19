
class ShipManager{
  GifAnime[] bombers;
  Ship[] shipArray;
  int maxShips = 6;
  
  ShipManager(){
    shipArray = new Ship[maxShips];
    bombers = new GifAnime[maxShips];
    
    for(int i = 0; i < maxShips; i++){
      shipArray[i] = new Ship();
      shipArray[i].playerno = i+1; 
    }
    shipArray[0].x =-width/2 + 100;
    shipArray[0].y =0;
    
    shipArray[1].x = width/2 - 100;
    shipArray[1].y = 0;
    
    shipArray[2].x = width/4;
    shipArray[2].y = height/2-100;
    
    shipArray[3].x = width/4;
    shipArray[3].y = -height/2+100;
    
    shipArray[4].x = -width/4;
    shipArray[4].y = height/2-100;
    
    shipArray[5].x = -width/4;
    shipArray[5].y = -height/2+100;
    
    for(int i = 0; i < maxShips; i++){
      shipArray[i].tarretAngle = atan2(-shipArray[i].x,shipArray[i].y);
    }
  }
  
  public void moveShip(){
    for ( int i = 0; i < maxShips; i++ ){
      if ( shipArray[i] != null ){        

         shipArray[i].move();  
         
         if(shipArray[i].hp < 0){
           bombers[i] = new GifAnime(shipArray[i].x,shipArray[i].y,myAnimation);
           shipArray[i] = null;
           bomber.trigger();
           
         }

      }  
      if(bombers[i] != null){
           if(millis() - bombers[i].time > 900){
             bombers[i] = null;
           }
         }
    }
  } // moveShip 
  
  public void renderShip(){
    for ( int i = 0; i < maxShips; i++ ){
      if ( shipArray[i] != null ){
        shipArray[i].render();
      }
      
      if(bombers[i] != null){
        bombers[i].render();
      }
    }
  } // renderShips 
}

class GifAnime{
   float x;
   float y;
   public int time;
   
   Gif gif;
  
   GifAnime(float x, float y, Gif gif){
     this.x = x;
     this.y = y;
     this.gif = gif;
     gif.play();
     
     time = millis();
   }
   
   void instantiate(){
   }
   
   void render(){
      image(gif,x,y);
   }
}
class GifManager{
  GifAnime[] bombers;
  GifAnime[] hitAnimes;
  int maxgifs = 10;
  GifManager(){
     bombers = new GifAnime[maxgifs];
     hitAnimes = new GifAnime[maxgifs];
  }
  void setBomb(float x, float y){
     for(int i = 0; i < maxgifs; i++){
       if(bombers[i] == null){
         bombers[i] = new GifAnime(x,y,myAnimation);
       }
     }
  }
  
  //void setHitAnime(float x, float y){
  //   for(int i = 0; i < maxgifs; i++){
  //     if(hitAnimes[i] == null){
  //       hitAnimes[i] = new GifAnime(x,y,hitAnimation);
  //     }
  //   }
  //}
  
  void render(){
    for(int i = 0; i < maxgifs; i++){
      if(bombers[i]!=null){
        bombers[i].render();
        if(millis() - bombers[i].time > 900){
          bombers[i]=null;
        }
        if(hitAnimes[i]!=null){
        hitAnimes[i].render();
        if(millis() - hitAnimes[i].time > 900){
          hitAnimes[i]=null;
        }
      }
    }
  }
}
}