
import processing.core.*;
import processing.video.*;
import processing.opengl.PGraphics2D;
import com.thomasdiewald.pixelflow.java.DwPixelFlow;
import com.thomasdiewald.pixelflow.java.imageprocessing.DwOpticalFlow;
import com.thomasdiewald.pixelflow.java.imageprocessing.filter.DwFilter;

Movie railLogo;
Movie iconYear;
Movie ruby;

PImage gray;

Capture cam;
DwPixelFlow context;  
DwOpticalFlow opticalflow;

PGraphics2D pg_oflow;
PGraphics2D pg_render;
PGraphics2D pg_cam;

int cam_w = 640;
int cam_h = 480;
int scale_view = 2;
int view_w = cam_w * scale_view;
int view_h = int(view_w * cam_h/(float)cam_w);

int cellSize = 4;
int cols, rows;
//char[] asciiChars = {'@', '#', 'S', '%', '?', '*', '+', ';', ':', ',', '.'};
char[] asciiChars = {'R', 'A', 'I', 'L', 'S','W', 'O', 'R', 'L', 'D', '2', '0', '2', '4' };
char[] edgeChars = {'|', '/', '-', '\\', '|', '/', '-', '\\'};
float[] bright;
float[][] sobelX, sobelY;
float threshold = 0.5;

color[] colors  = {
    #000000,
    #3B1D62, #3B1D62,
    #6A8D48, #6A8D48,
    #CB0C1C, #CB0C1C,
    #71A0FF, #71A0FF, 
    #9DBD59, #9DBD59, 
    #FFFFFF
};

public void settings() {
  size(view_w, view_h, P2D);
  smooth(8);
}

public void setup() {
   
    // main library context
    context = new DwPixelFlow(this);
    context.print();
    context.printGL();
    
    //railLogo = new Movie(this, "02.mov");
    //railLogo.loop();
    //iconYear = new Movie(this, "rails.mov");
    //iconYear.loop();
    //ruby = new Movie(this, "rails.mov");
    //ruby.loop();
    
    gray = loadImage("gray2.png");

    opticalflow = new DwOpticalFlow(context, cam_w, cam_h);

    cam = new Capture(this, 640, 480, "pipeline:autovideosrc" );
    cam.start();
    cols = int(cam.width/cellSize);
    rows = int(cam.height/cellSize);
    
    pg_cam = (PGraphics2D) createGraphics(cam_w, cam_h, P2D);
    pg_cam.noSmooth();
    
    pg_oflow = (PGraphics2D) createGraphics(width, height, P2D);
    pg_oflow.smooth(4);
    
    pg_render = (PGraphics2D) createGraphics(width, height, P2D);
    pg_render.smooth(4);
    
    bright = new float[cols*rows];
    for (int i = 0; i < cols*rows; i++) {
      bright[i] = 0.5;
    }    
    
    sobelX = new float[cols][rows];
    sobelY = new float[cols][rows];        
    
    background(0);
    frameRate(60);
    textAlign(CENTER, CENTER);
    noStroke();
  }
  

  public void draw() {
    
    //if(railLogo.available()){
    //  railLogo.read();
    //}
    //if(iconYear.available()){
    //  iconYear.read();
    //}
    //if(ruby.available()){
    //  ruby.read();
    //}
    
    if( cam.available() ){
      cam.read();
     
     
      // render to offscreenbuffer
      pg_cam.beginDraw();
      pg_cam.image(cam, 0, 0);
      pg_cam.endDraw();
      
      // update Optical Flow
      opticalflow.update(pg_cam); 
    }
    
    // rgba -> grayscale 
    DwFilter.get(context).luminance.apply(pg_cam, pg_cam);
    
    pg_oflow.beginDraw();
    pg_oflow.clear();
    //pg_oflow.image(ruby, 0, 0, width, height);
    pg_oflow.endDraw();
    pg_render.beginDraw();
    pg_render.clear();
    pg_render.image(pg_cam,0,0,width,height);
    pg_render.fill(0,160);
    pg_render.rect(0,0,width,height);
    pg_render.image(gray, 0,-80,width/2, height/2);
    //pg_render.filter(255,255);
    //pg_render.image(ruby, 0, 0, width, height);
    pg_render.endDraw();
    
    // flow visualizations
    opticalflow.param.display_mode = 1;
    opticalflow.renderVelocityShading(pg_render);
    opticalflow.renderVelocityStreams(pg_render, 5);
    
    background(0);
    asciiRender(pg_render);
    
  }


void asciiRender(PGraphics2D pg){
    pg.loadPixels();
    applySobelFilter(pg);
    applyAscii(pg);
}

void applyAscii(PGraphics2D pg){
  for(int j = 0; j < rows-1; j++){
    for(int i = 0; i < cols; i++){
      int x = int(i * cellSize * scale_view);
      int y = int(j * cellSize * scale_view);
      int id = j * cols + i;
      color c = pg.pixels[y*pg.width+x];
      float luminance =  brightness(c)/255.;
      color render = colors[floor(luminance * (colors.length-1))];
      //float diff = luminance - bright[id];
      //bright[id] += diff * 0.2;
      
      pushMatrix();
      translate((x+cellSize/2), (y+cellSize/2));
      fill(render);
      
      float edgeIntensity = sqrt(sobelX[i][j]*sobelX[i][j] + sobelY[i][j]*sobelY[i][j]);
      if (edgeIntensity > threshold) {
        float angle = atan2(sobelY[i][j], sobelX[i][j]);
        int edgeIndex = int(map(angle, -PI, PI, 0, 8)) % 8;
        text(edgeChars[edgeIndex], 0, 0);
      } else {
        int charIndex = int(map(1.-bright[id], 0, 1, 0, asciiChars.length - 1));
        char asciiChar = asciiChars[charIndex];
        text(asciiChar, 0, 0);
      }
      
      popMatrix();
    }
  }
}

void applySobelFilter(PGraphics2D pg) {
  float[][] kernelX = {{-1, 0, 1}, {-2, 0, 2}, {-1, 0, 1}};
  float[][] kernelY = {{-1, -2, -1}, {0, 0, 0}, {1, 2, 1}};
  
  for (int y = 1; y < rows - 1; y++) {
    for (int x = 1; x < cols - 1; x++) {
      float sumX = 0, sumY = 0;
      for (int ky = -1; ky <= 1; ky++) {
        for (int kx = -1; kx <= 1; kx++) {
          int px = (x + kx) * cellSize * scale_view;
          int py = (y + ky) * cellSize * scale_view;
          int idx = py * pg.width + px;
          float val = brightness(pg.pixels[idx])/255.;
          
          sumX += val * kernelX[ky+1][kx+1];
          sumY += val * kernelY[ky+1][kx+1];
        }
      }
      sobelX[x][y] = sumX;
      sobelY[x][y] = sumY;
    }
  }
}
