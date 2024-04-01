import com.hamoid.*;
VideoExport videoExport;

String VIDEO_FILE_NAME = "chanters_test_19.mp4";
int COUNT = 1400000;
boolean ANIMATE_CAMERA = true;
int IMAGE_COUNT = 193;
float ELLIPSE_R = 3000;

float ZOOM_START = 14.0;
float ZOOM_END = 0.15;
float WORLD_R = ELLIPSE_R/ZOOM_END;
float NOISE_DETAIL = 36; // higher number, finer noise

boolean JUST_TALLY = false; // draw the counter for the Humany video

float FADE_IN = 0.026;
float SCALE = 1.0;
int SLICE_COUNT = 20;

int frames = 0;
int PLAY_SPEED = 1;
int VIDEO_LENGTH = 816;
int START_SLOW = 576;
int SLOWED_BY = 48;


float EPS = 0.5;

float[] STEAKHOUSE_R = {55,30,80};
float STEAKHOUSE_M = 10;
float RC_R = 10;
float PENCIL_R = 20;
float NICKEL_R = 7.3;
float TB_R = 32;


float[][] locations = new float[COUNT][2];
int FPS = 24;


PImage[] images = new PImage[IMAGE_COUNT];
PImage[] pencil_images = new PImage[IMAGE_COUNT];

String[] steakhouse_image_names = {"steakhouse","steakhouse2","steakhouse_roof",
"steakhouse_fence","nickel","tennis_ball","awning","skybox0","skybox1","skybox2","skybox3"};
PImage[] steakhouse_images = new PImage[steakhouse_image_names.length];
PGraphics darken;

float rotZ = 0;
float rotX = 0;

PFont font;
void setup(){
  randomSeed(123);
  noiseSeed(126);
  font = createFont("sans",96);
  for(int c = 0; c < COUNT; c++){
    float x = random(-1,1);
    float y = random(-1,1);
    while(dist(0,0,x,y) >= 1 ||
    (abs(x)*WORLD_R <= STEAKHOUSE_R[0]+STEAKHOUSE_M &&
    y*WORLD_R <= STEAKHOUSE_R[1]+STEAKHOUSE_M && 
    y*WORLD_R >= -STEAKHOUSE_R[1]-STEAKHOUSE_R[0]*2-STEAKHOUSE_M) ||
    random(1-0.3*dist(0,0,x,y))*0.7-0.03 < noise((1+x)*NOISE_DETAIL,(1+y)*NOISE_DETAIL)){
      x = random(-1,1);
      y = random(-1,1);
    }
    locations[c][0] = x*WORLD_R;
    locations[c][1] = y*WORLD_R;
  }
  for(int i = 0; i < IMAGE_COUNT; i++){
    if(i%2 == 0){
      images[i] = loadImage("../RC_SEQUENCE_2000/CHARACTER GRID"+nf(i+1,4,0)+".png");
    }else{
      images[i] = images[i-1];
    }
    pencil_images[i] = loadImage("../PENCIL-SEQUENCE/pencil"+nf(i+1,4,0)+".png");
    println("Loaded images up to "+i+" / "+IMAGE_COUNT);
  }
  size(3840,2160,P3D);
  for(int i = 0; i < steakhouse_image_names.length; i++){
    steakhouse_images[i] = loadImage("../"+steakhouse_image_names[i]+".png");
  }
  noStroke();
  frameRate(FPS);
  
  videoExport = new VideoExport(this, VIDEO_FILE_NAME);
  videoExport.setFrameRate(FPS);
  videoExport.startMovie();
}
void drawSkyBox(){
  float z1 = -600/1080.0*height;
  float z2 = 1000/1080.0*height;
  pushMatrix();
  translate(width/2,height/2,0);
  float r = ELLIPSE_R*1.3;
  for(int z = 0; z < 80; z++){
    float x1 = r*cos(z*PI*2/80);
    float x2 = r*cos((z+1)*PI*2/80);
    float y1 = r*sin(z*PI*2/80);
    float y2 = r*sin((z+1)*PI*2/80);
    int ix = (200*z)%4000;
    
    beginShape();
    texture(steakhouse_images[7+(z/20)]);
    vertex(x1,y1,z1,ix,2400);
    vertex(x1,y1,z2,ix,0);
    vertex(x2,y2,z2,ix+200,0);
    vertex(x2,y2,z1,ix+200,2400);
    endShape();
  }
  popMatrix();
}
void drawBasics(){
  background(150,231,252);
  fill(96,206,30);
  ellipse(width/2,height/2,ELLIPSE_R*2,ELLIPSE_R*2);
  
  pushMatrix();
  translate(width/2,height/2,0);
  rotateZ(-rotZ);
  rotateX(-PI/2);
  rect(-ELLIPSE_R,0,ELLIPSE_R*2,height/2);
  popMatrix();
}
void drawRoof(float W, float L, float H){
  pushMatrix();
  translate(0,0,H*0.54);
  for(int s = 0; s < SLICE_COUNT; s++){
    beginShape();
    texture(steakhouse_images[2]);
    float x1 = -W+(2*W)*s/SLICE_COUNT;
    float x2 = -W+(2*W)*(s+1)/SLICE_COUNT;
    float ix1 = 1100*s/SLICE_COUNT;
    float ix2 = 1100*(s+1)/SLICE_COUNT;
    vertex(x1, -L, 0, ix1, 0);
    vertex(x2, -L, 0, ix2, 0);
    vertex(x2, L, H*0.25, ix2, 600);
    vertex(x1, L, H*0.25, ix1, 600);
    endShape();
  }
  popMatrix();
}
void drawAwning(float preW, float L, float H){
  float W = preW*0.91;
  float h2 = H*0.44;
  pushMatrix();
  translate(0,0,h2);
  int ASC = 13;
  for(int s = 0; s < ASC; s++){
    
    float x1 = -W+(2*W)*s/ASC;
    float x2 = -W+(2*W)*(s+1)/ASC;
    float ix1 = 1300*s/ASC;
    float ix2 = 1300*(s+1)/ASC;
    beginShape();
    texture(steakhouse_images[6]);
    vertex(x1, 2*L, 0, ix1, 500);
    vertex(x2, 2*L, 0, ix2, 500);
    vertex(x2, L, H*0.15, ix2, 0);
    vertex(x1, L, H*0.15, ix1, 0);
    endShape();
    
    beginShape();
    texture(steakhouse_images[6]);
    vertex(x1, 2*L, 0, ix1, 500);
    vertex(x2, 2*L, 0, ix2, 500);
    vertex(x2, 2*L, -H*0.10, ix2, 600);
    vertex(x1, 2*L, -H*0.10, ix1, 600);
    endShape();
  }
  popMatrix();
  fill(80);
  for(int i = 0; i < 2; i++){
    pushMatrix();
    translate(-W*0.966*(2*i-1),1.966*L,0);
    rotateX(-PI/2.0);
    rotateY(rotZ);
    rect(-W*0.01,-h2,W*0.02,h2);
    popMatrix();
  }
}
void drawSteakhouse(){
  float W = STEAKHOUSE_R[0]*SCALE;
  float L = STEAKHOUSE_R[1]*SCALE;
  float H = STEAKHOUSE_R[2]*SCALE;
  
  pushMatrix();
  translate(width/2,height/2);
  int[] starts = {0,600,1700,2300,3400};
  for(int w = 0; w < 4; w++){
    float W2 = W;
    float L2 = L;
    if(w%2 == 1){
      W2 = L;
      L2 = W;
    }
    pushMatrix();
    rotateZ(PI/2.0*w);
    translate(-W2,0);
    rotateY(-PI/2.0);
    int w2 = w;
    if(w%2 == 1){
      w2 = 4-w;
    }
    int u1 = starts[w2];
    int u2 = starts[w2+1];
    int copies = (w == 3) ? 2 : 1;
    for(int c = 0; c < copies; c++){
      beginShape();
      if(c == 1){
        translate(0,0,-EPS);
        texture(steakhouse_images[1]);
      }else{
        texture(steakhouse_images[0]);
      }
      vertex(0, L2, u2, 900);
      vertex(H, L2, u2, 0);
      vertex(H, -L2, u1, 0);
      vertex(0, -L2, u1, 900);
      endShape();
      noTint();
    }
    popMatrix();
  }
  drawRoof(W,L,H);
  drawAwning(W,L,H);
  
  float H2 = H*0.25;
  translate(0,-W-L);
  for(int wall = 0; wall < 3; wall++){
    pushMatrix();
    rotateZ(PI/2.0*wall);
    translate(-W,0);
    rotateY(-PI/2.0);
    
    beginShape();
    texture(steakhouse_images[3]);
    vertex(0, W, 0, 300);
    vertex(H2, W, 0, 0);
    vertex(H2, -W, 2000, 0);
    vertex(0, -W, 2000, 300);
    endShape();
    
    popMatrix();
  }
  popMatrix();
}
void moveCamera(){
  rotZ = (((float)mouseX)/width+1.0)*2*PI;
  rotX = ((float)mouseY)/width*2*PI;
  
  if(ANIMATE_CAMERA){
    float VS = VIDEO_LENGTH-SLOWED_BY;
    float preFac = ((float)frames)/VS;
    if(frames >= START_SLOW){
      preFac -= pow(((float)(frames-START_SLOW))/(VIDEO_LENGTH-START_SLOW),2.0)*SLOWED_BY/VS;
    }
    
    rotZ = ((preFac*VS/500)-0.11)*2*PI;
    float fac = 0.5+0.5*sin((preFac*VS/490-0.2)*2*PI);
    // https://www.google.com/search?q=0.5%2B0.5*sin%28%28x*24%2F490-0.2%29*2*pi%29&sca_esv=2513685c83e6abca&sca_upv=1&sxsrf=ACQVn08nac86UsnDyjXTrCeb37QucbLp7g%3A1709248476074&ei=3A_hZZqJBM2KwbkPgqSQ8A8&ved=0ahUKEwia5_7h1tGEAxVNRTABHQISBP4Q4dUDCBE&uact=5&oq=0.5%2B0.5*sin%28%28x*24%2F490-0.2%29*2*pi%29&gs_lp=Egxnd3Mtd2l6LXNlcnAiIDAuNSswLjUqc2luKCh4KjI0LzQ5MC0wLjIpKjIqcGkpSJ4WUJkEWIkVcAR4AJABAJgBxAGgAY0HqgEDMC42uAEDyAEA-AEBmAIBoAIEwgIKEAAYRxjWBBiwA5gDAIgGAZAGApIHATE&sclient=gws-wiz-serp
    rotX = PI*0.5-PI*0.175*pow(fac,1.1);
    
    float proggy = sinify(preFac,0.4,1.9);
    SCALE = ZOOM_START*pow(ZOOM_END/ZOOM_START,proggy);
  }
  float z_shift_factor = 0.5-0.5*cos(min(1.0,(float)frames/150)*PI);
  float z_shift = -RC_R*0.5-STEAKHOUSE_R[2]*0.7*(1-z_shift_factor);
  translate(width/2,height/2);
  rotateX(rotX);
  rotateZ(rotZ);
  translate(-width/2,-height/2,z_shift*SCALE);
  println("Done rendering frame "+frames);
  
  float cameraZ = ((height/2.0) / tan(PI*60.0/360.0));
  perspective(PI/3.0, ((float)width)/height, cameraZ/100.0, cameraZ*10.0);
}
float sinify(float x, float fac, float power){
  float alt = 0.5-0.5*cos(pow(x,power)*PI);
  return (1-fac)*x+(fac)*alt;
}
int drawCharacters(){
  darken.ellipseMode(RADIUS);
  darken.noStroke();
  int count = 0;
  for(int c = 0; c < COUNT; c++){
    float x = locations[c][0];
    float y = locations[c][1];
    float distFac = dist(0,0,x,y)*SCALE/ELLIPSE_R;
    if(distFac <= 1){
      if(!JUST_TALLY){
        int i = c%100;
        int ix = (i%10)*200;
        int iy = (i/10)*200;
        float alpha = 1-max((distFac-(1-FADE_IN))/FADE_IN,0);
        drawBasicImage(images[frames%IMAGE_COUNT],x,y,0,RC_R*SCALE,ix,iy,200,alpha,0.5);
      }
      
      count++;
      /*float ax = screenX(width/2+x*SCALE,height/2+y*SCALE,0);
      float ay = screenY(width/2+x*SCALE,height/2+y*SCALE,0);
      float M = 5;
      if(ax >= -M && ax < width+M && ay >= -M && ay < height+M){
        float cr = random(0,90);
        float cg = random(0,90);
        float cb = random(0,90);
        darken.fill(cr, cg, cb,50);
        darken.ellipse(ax,ay,M,M);
      }*/
      
    }
  }
  return count;
}
void drawBasicImage(PImage img, float x, float y, float z, float r, float ix, float iy, float ir, float alpha, float shadow){
  textureMode(IMAGE);
  pushMatrix();
  translate(width/2,height/2);
  translate(x*SCALE,y*SCALE, z*SCALE);
  
  rotateX(-PI/2.0);
  rotateY(rotZ);
  
  tint(255,255,255,255*alpha);
  beginShape();
  texture(img);
  vertex(-r, -r*2, ix, iy);
  vertex(r, -r*2, ix+ir, iy);
  vertex(r, 0, ix+ir, iy+ir);
  vertex(-r, 0, ix, iy+ir);
  endShape();
  popMatrix();
  noTint();
}
void drawSlicedImage(PImage img, float x, float y, float z, float r, float ix, float iy, float iw, float ih, float alpha){
  textureMode(IMAGE);
  pushMatrix();
  translate(width/2,height/2);
  translate(x*SCALE,y*SCALE, z*SCALE);
  rotateX(-PI/2.0);
  rotateY(rotZ);
  
  float rh = r/iw*ih;
  tint(255,255,255,255*alpha);
  for(int s = 0; s < SLICE_COUNT; s++){
    beginShape();
    texture(img);
    float x1 = -r+(2*r/SLICE_COUNT)*s;
    float x2 = -r+(2*r/SLICE_COUNT)*(s+1);
    float ix1 = ix+(iw/SLICE_COUNT)*s;
    float ix2 = ix+(iw/SLICE_COUNT)*(s+1);
    vertex(x1, -rh*2, ix1, iy);
    vertex(x2, -rh*2, ix2, iy);
    vertex(x2, 0, ix2, iy+ih);
    vertex(x1, 0, ix1, iy+ih);
    endShape();
  }
  popMatrix();
  noTint();
}
/*void drawRectImage(PImage img, float x, float y, float z, float r, float ix, float iy, float iw, float ih, float alpha){
  textureMode(IMAGE);
  pushMatrix();
  translate(width/2,height/2);
  translate(x*SCALE,y*SCALE, z*SCALE);
  rotateX(-PI/2.0);
  rotateY(rotZ);
  
  float rh = 2*r/iw*ih;
  tint(255,255,255,255*alpha);
  beginShape();
  texture(img);
  vertex(-r, -rh, ix, iy);
  vertex(r, -rh, ix+iw, iy);
  vertex(r, 0, ix+iw, iy+ih);
  vertex(-r, 0, ix, iy+ih);
  endShape();
  popMatrix();
  noTint();
}*/

void drawPencil(){
  float x = -STEAKHOUSE_R[0]*0.32;
  float y = STEAKHOUSE_R[1]*0.97;
  float z = STEAKHOUSE_R[2]*0.96;
  drawSlicedImage(pencil_images[frames%IMAGE_COUNT],x,y,z,PENCIL_R*SCALE,0,0,800,800,1.0);
}
void drawNickel(){
  float x = STEAKHOUSE_R[0]*0.56;
  float y = STEAKHOUSE_R[1]*0.50;
  float z = STEAKHOUSE_R[2]*0.73;
  drawSlicedImage(steakhouse_images[4],x,y,z,NICKEL_R*SCALE,0,0,400,400,1.0);
}
void drawTennisBall(){
  float x = STEAKHOUSE_R[0]*0.1;
  float y = -STEAKHOUSE_R[1]-STEAKHOUSE_R[0];
  float z = STEAKHOUSE_R[2]*0.73;
  drawSlicedImage(steakhouse_images[5],x,y,0,TB_R*SCALE,0,0,1000,400,1.0);
}


void drawCounter(int count){
  if(JUST_TALLY){
    PGraphics blah = createGraphics(2000,200);
    blah.beginDraw();
    blah.background(0);
    blah.fill(255);
    blah.textFont(font,96);
    blah.textAlign(LEFT);
    blah.text(commafy(count)+" RCs are within range.",50,140);
    blah.endDraw();
    blah.save("counter/counter"+nf(frames,4,0)+".png");
  }
}
String commafy(int n){
  String ns = n+"";
  String result = "";
  for(int i = 0; i < ns.length(); i++){
    result += ns.charAt(i);
    if((ns.length()-i)%3 == 1 && (ns.length()-i) >= 4){
      result += ",";
    }
  }
  return result;
}


void draw(){
  darken = createGraphics(3840,2160);
  darken.beginDraw();
  darken.background(255,255,255);
  hint(ENABLE_DEPTH_SORT);
  pushMatrix();
  moveCamera();
  
  drawBasics();
  drawSkyBox();
  drawSteakhouse();
  drawPencil();
  drawNickel();
  drawTennisBall();
  int count = drawCharacters();
  drawCounter(count);
  popMatrix();
  
  videoExport.saveFrame();
  darken.endDraw();
  //darken.save("shadows/shadows"+nf(frames,4,0)+".png");
  
  frames += PLAY_SPEED;
  if(frames >= VIDEO_LENGTH){
    videoExport.endMovie();
    exit();
  }
}
