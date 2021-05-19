/**
 * --- 180324.10 DrawCommands ---
 **/

/***********************************************
    描画コマンド
    2018/03/10 by SATOToshiki
 ***********************************************/
 
/**************************************************
                  形状コマンド
 **************************************************/
 
public static DrawEvent Circle(){ return Circle(app.width/2,app.height/2,200,200); }
public static DrawEvent circle(int x, int y, int w, int h){ return Circle(x,y,w,h); }
public static DrawEvent CIRCLE(int x, int y, int w, int h){ return Circle(x,y,w,h); }
public static DrawEvent MARU(int x, int y, int w, int h){ return Circle(x,y,w,h); }
public static DrawEvent maru(int x, int y, int w, int h){ return Circle(x,y,w,h); }
 
/* 形状(円) */
public static DrawEvent Circle(int x, int y, int w, int h){
  DrawEvent newEvent = new DrawEvent();
  newEvent.type = 1;
  newEvent.x = x-app.width/2;  newEvent.y = y-app.height/2;
  newEvent.w = w;  newEvent.h = h;
  newEvent.r = 255;  newEvent.g = 255;  newEvent.b = 255;  newEvent.a = 255;
  character.addDrawEvent(newEvent);
  return newEvent;
} // Circle

/* 形状(矩形) */
public static DrawEvent Rect(){return Rect(app.width/2,app.height/2,200,200);}
public static DrawEvent RECT(int x, int y, int w, int h){return Rect(x,y,w,h);}
public static DrawEvent SIKAKU(int x, int y, int w, int h){return Rect(x,y,w,h);}
public static DrawEvent sikaku(int x, int y, int w, int h){return Rect(x,y,w,h);}


public static DrawEvent Rect(int x, int y, int w, int h){
  DrawEvent newEvent = new DrawEvent();
  newEvent.type = 2;
  newEvent.x = x-app.width/2;  newEvent.y = y-app.height/2;
  newEvent.w = w;  newEvent.h = h;
  newEvent.r = 255;  newEvent.g = 255;  newEvent.b = 255;  newEvent.a = 255;
  character.addDrawEvent(newEvent);
  return newEvent;
} // Rect


public static DrawEvent TRI(int x0, int y0, int x1, int y1, int x2, int y2){return Triangle(x0, y0, x1, y1, x2, y2);}
public static DrawEvent tri(int x0, int y0, int x1, int y1, int x2, int y2){return Triangle(x0, y0, x1, y1, x2, y2);}
public static DrawEvent SANKAKU(int x0, int y0, int x1, int y1, int x2, int y2){return Triangle(x0, y0, x1, y1, x2, y2);}
public static DrawEvent sankaku(int x0, int y0, int x1, int y1, int x2, int y2){return Triangle(x0, y0, x1, y1, x2, y2);}

/* 形状(三角形) */
public static DrawEvent Triangle(int x0, int y0, int x1, int y1, int x2, int y2){
  DrawEvent newEvent = new DrawEvent();
  newEvent.type = 4;
  newEvent.x = x0-app.width/2;  newEvent.y = y0-app.height/2;
  newEvent.w = x1-app.width/2;  newEvent.h = y1-app.height/2;
  newEvent.r = x2-app.width/2;  newEvent.g = y2-app.height/2;
  character.addDrawEvent(newEvent);
  return newEvent;
} // Rect

public static DrawEvent LINE(int x0, int y0, int x1, int y1){return Line(x0, y0, x1,y1);}
public static DrawEvent sen(int x0, int y0, int x1, int y1){return Line(x0, y0, x1,y1);}
public static DrawEvent SEN(int x0, int y0, int x1, int y1){return Line(x0, y0, x1,y1);}


/* 形状(ライン) */
public static DrawEvent Line(int x0, int y0, int x1, int y1){
  DrawEvent newEvent = new DrawEvent();
  newEvent.type = 5;
  newEvent.x = x0-app.width/2;  newEvent.y = y0-app.height/2;
  newEvent.w = x1-app.width/2;  newEvent.h = y1-app.height/2;
  character.addDrawEvent(newEvent);
  return newEvent;
} // Rect

public static DrawEvent star(int x0, int y0,int n, int r, int a){return STAR(x0, y0,n, r, a);}
public static DrawEvent Star(int x0, int y0,int n, int r, int a){return STAR(x0, y0,n, r, a);}
public static DrawEvent hosi(int x0, int y0,int n, int r, int a){return STAR(x0, y0,n, r, a);}
public static DrawEvent HOSI(int x0, int y0,int n, int r, int a){return STAR(x0, y0,n, r, a);}


public static DrawEvent STAR(int x0, int y0, int r, int a){// 3/15　星
  DrawEvent newEvent = new DrawEvent();
  newEvent.type = 8;
  newEvent.x = x0-app.width/2; newEvent.y = y0-app.height/2;
  newEvent.r = r; newEvent.h = 30*(a-3);
  character.addDrawEvent(newEvent);
  return newEvent;
}

public static DrawEvent STAR(int x0, int y0, int n, int r, int a){ // 3/15 多角形
  DrawEvent newEvent = new DrawEvent();
  newEvent.type = 9;
  newEvent.x = x0-app.width/2; newEvent.y = y0-app.height/2;
  newEvent.n = n; newEvent.r = r;
  newEvent.h = 30*(a-3);
  character.addDrawEvent(newEvent);
  return newEvent;
}

public static DrawEvent takakukei(int x0, int y0, int n, int r, int a){return POLYGON(x0, y0, n, r, a);}
public static DrawEvent TAKAKUKEI(int x0, int y0, int n, int r, int a){return POLYGON(x0, y0, n, r, a);}
public static DrawEvent polygon(int x0, int y0, int n, int r, int a){return POLYGON(x0, y0, n, r, a);}
public static DrawEvent Polygon(int x0, int y0, int n, int r, int a){return POLYGON(x0, y0, n, r, a);}

public static DrawEvent POLYGON(int x0, int y0, int n, int r, int a){ // 3/15 多角形
  DrawEvent newEvent = new DrawEvent();
  newEvent.type = 11;
  newEvent.x = x0-app.width/2; newEvent.y = y0-app.height/2;
  newEvent.n = n; newEvent.r = r;
  newEvent.h = 30*(a-3);
  character.addDrawEvent(newEvent);
  return newEvent;
}


public static DrawEvent ARC(int x0, int y0, int r, int startAngle, int endAngle){return Arc(x0,y0,r,startAngle,endAngle);}
public static DrawEvent Arc(int x0, int y0, int r, int startAngle, int endAngle){ // 3/15 多角形
  DrawEvent newEvent = new DrawEvent();
  newEvent.type = 12;
  newEvent.x = x0-app.width/2; newEvent.y = y0-app.height/2;
  newEvent.r = r;
  newEvent.h = 30*(startAngle-3);
  newEvent.w = 30*(endAngle-3);
  character.addDrawEvent(newEvent);
  return newEvent;
}


/**************************************************
              フレーム制御コマンド
 **************************************************/
 
/* 新しいフレームを追加 */
public static void AddNewFrame(){
  character.addNewFrame();  // このコマンドはDrawEventではないが、送信時はtype:-1のDrawEventとする)
} // SwtichFrame

/* アニメーションスピードの設定 */
public static DrawEvent SetAnimationSpeed(int interval){
  DrawEvent newEvent = new DrawEvent();
  newEvent.type = 10;
  newEvent.r = interval;
  character.addDrawEvent(newEvent);
  return newEvent;  
} // SetAnimationSpeed
 
/**************************************************
                  色コマンド
 **************************************************/

/* 色 */
public static DrawEvent Color(int r, int g, int b){
  DrawEvent newEvent = new DrawEvent();
  newEvent.type = 3;
  newEvent.r = r;  newEvent.g = g;  newEvent.b = b;  newEvent.a = 255;
  character.addDrawEvent(newEvent);
  return newEvent;
} // Color

public static DrawEvent Color(int r, int g, int b, int a){
  DrawEvent newEvent = new DrawEvent();
  newEvent.type = 3;
  newEvent.r = r;  newEvent.g = g;  newEvent.b = b;  newEvent.a = a;
  character.addDrawEvent(newEvent);
  return newEvent;
} // Color

public static void Red(){Color(255,0,0);}
public static void Green(){Color(0,255,0);}
public static void Blue(){Color(0,0,255);}
public static void Yellow(){Color(255,255,0);}
public static void White(){Color(255,255,255);}
public static void Cyan(){Color(0,255,255);}
public static void Purple(){Color(255,0,255);}
public static void Black(){Color(0,0,0);}


/**************************************************
               図形描画(上級者向け)
 **************************************************/

/* 開始 */
public static DrawEvent BeginShape(int mode){
  DrawEvent newEvent = new DrawEvent();
  newEvent.type = 100;
  newEvent.x = mode;
  character.addDrawEvent(newEvent);
  return newEvent;
} // BeginShape
 
/* 終了 */
public static DrawEvent EndShape(){
  DrawEvent newEvent = new DrawEvent();
  newEvent.type = 101;
  character.addDrawEvent(newEvent);
  return newEvent;
} // EndShape

/* 頂点 */
public static DrawEvent Vertex(int x, int y, int z){
  DrawEvent newEvent = new DrawEvent();
  newEvent.type = 102;
  newEvent.x = x;    newEvent.y = y;    newEvent.z = z;
  character.addDrawEvent(newEvent);
  return newEvent;
} // Vertex

/**************************************************
                  その他コマンド
 **************************************************/

/* 線の色 */
public static DrawEvent LineColor(int r, int g, int b){
  DrawEvent newEvent = new DrawEvent();
  newEvent.type = 6;
  newEvent.r = r;  newEvent.g = g;  newEvent.b = b;
  character.addDrawEvent(newEvent);
  return newEvent;
} // LineColor

/* 線の太さ */
public static DrawEvent LineSize(int size){
  DrawEvent newEvent = new DrawEvent();
  newEvent.type = 7;
  newEvent.r = size;
  character.addDrawEvent(newEvent);
  return newEvent;
} // Color