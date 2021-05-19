class Mode{
  
  protected boolean flagExit = false;
  public String nextMode;
  public String status;
  /* Sceneの中身 */
  protected void move(){}          // 移動関数
  protected void render(){}        // 描画関数
     
  public void initialize(){
    for(int i = 0;i < characters.size(); i++){
      Character tmp = characters.get(i);
      tmp.isDead = true;
    }
    
  }    // 初期化関数
  public void finalize(){}      // 解放関数
  
  
  public boolean run(){
    move();
    render();
    return flagExit;
  }
}