/**
 * 
 * PixelFlow | Copyright (C) 2016 Thomas Diewald - http://thomasdiewald.com
 * 
 * A Processing/Java library for high performance GPU-Computing (GLSL).
 * MIT License: https://opensource.org/licenses/MIT
 * 



import com.thomasdiewald.pixelflow.java.DwPixelFlow;
import com.thomasdiewald.pixelflow.java.imageprocessing.DwOpticalFlow;
import com.thomasdiewald.pixelflow.java.imageprocessing.filter.DwFilter;

import processing.core.*;
import processing.opengl.PGraphics2D;
import processing.video.Capture;


  // Example, Optical Flow for Webcam capture.
  
  DwPixelFlow context;
  
  DwOpticalFlow opticalflow;
  
  PGraphics2D pg_cam;
  PGraphics2D pg_oflow;
  
  PShader shader;
  
  int cam_w = 640;
  int cam_h = 480;
  
  int view_w = 1000;
  int view_h = (int)(view_w * cam_h/(float)cam_w);
  
  Capture cam;
  
  public void settings() {
    size(view_w, view_h, P2D);
    smooth(4);
  }

  public void setup() {
   
    // main library context
    context = new DwPixelFlow(this);
    context.print();
    context.printGL();
    
    // optical flow
    opticalflow = new DwOpticalFlow(context, cam_w, cam_h);

//    String[] cameras = Capture.list();
//    printArray(cameras);
//    cam = new Capture(this, cameras[0]);
    
    // Capture, video library
    cam = new Capture(this, cam_w, cam_h, 30);
    cam.start();
    
    pg_cam = (PGraphics2D) createGraphics(cam_w, cam_h, P2D);
    pg_cam.noSmooth();
    
    pg_oflow = (PGraphics2D) createGraphics(width, height, P2D);
    pg_oflow.smooth(4);
        
    shader = loadShader("shader.glsl");    
        
    background(0);
    frameRate(60);
  }
  

  public void draw() {
    
    if( cam.available() ){
      cam.read();
      
      // render to offscreenbuffer
      pg_cam.beginDraw();
      pg_cam.image(cam, 0, 0);
      pg_cam.endDraw();
      
      // update Optical Flow
      opticalflow.update(pg_cam); 
    }
    
    // rgba -> luminance (just for display)
    DwFilter.get(context).luminance.apply(pg_cam, pg_cam);
    
    // render Optical Flow
    pg_oflow.beginDraw();
    pg_oflow.clear();
    //pg_oflow.image(pg_cam, 0, 0, width, height);
    pg_oflow.endDraw();
    
    // flow visualizations
    opticalflow.param.display_mode = 0;
    opticalflow.renderVelocityShading(pg_oflow);
    opticalflow.renderVelocityStreams(pg_oflow, 5);
    
    // display result
    background(0);
    shader(shader); // Use the shader
    shader.set("tex", pg_oflow); // Pass the image as a texture
    rect(0, 0, width, height);
    //image(pg_oflow, 0, 0);
 
  }
   */
   
   //import com.thomasdiewald.pixelflow.java.DwPixelFlow;
//import com.thomasdiewald.pixelflow.java.imageprocessing.DwOpticalFlow;
//import com.thomasdiewald.pixelflow.java.imageprocessing.filter.DwFilter;
//import processing.core.*;
//import processing.opengl.PGraphics2D;
//import processing.video.Capture;

//DwPixelFlow context;
//DwOpticalFlow opticalflow;
//PGraphics2D pg_cam;
//PGraphics2D pg_oflow;
//PShader shader;

//int cam_w = 640;
//int cam_h = 480;
//int view_w = 1000;
//int view_h = (int)(view_w * cam_h/(float)cam_w);

//Capture cam;

//// ASCII effect parameters
//int cellSize = 10;
//int cols, rows;
//char[] asciiChars = {'@', '#', 'S', '%', '?', '*', '+', ';', ':', ',', '.'};

//public void settings() {
//  size(view_w,view_w, P2D);
//  smooth(4);
//}

//public void setup() {
//  // Initialize PixelFlow context
//  context = new DwPixelFlow(this);
//  //context.print();
//  //context.printGL();
  
//  // Initialize optical flow
//  //opticalflow = new DwOpticalFlow(context, cam_w, cam_h);
  
//  // Initialize camera
//  cam = new Capture(this, cam_w, cam_h, 30);
//  cam.start();
  
//  // Create graphics buffers
//  pg_cam = (PGraphics2D) createGraphics(width, height, P2D);
//  pg_cam.noSmooth();
  
//  pg_oflow = (PGraphics2D) createGraphics(width, height, P2D);
//  pg_oflow.smooth(4);
  
//  // Calculate grid dimensions
//  cols = width / cellSize;
//  rows = height / cellSize;
  
//  // Set text properties
//  textAlign(CENTER, CENTER);
//  textSize(cellSize);
  
//  background(0);
//  frameRate(30);
//}

//public void draw() {
//  if (cam.available()) {
//    cam.read();
    
//    // Render camera feed to offscreen buffer
//    pg_cam.beginDraw();
//    pg_cam.image(cam, 0, 0,pg_cam.width,pg_cam.height);
//    pg_cam.endDraw();
    
//    // Update optical flow
//    //opticalflow.update(pg_cam);
  
  
//  // Clear the background
//  background(0);
//  //image(pg_cam,0,0);
//  // Iterate through the grid
//  for (int y = 0; y < rows; y++) {
//    for (int x = 0; x < cols; x++) {
//      // Calculate the position in the video
//      int vidX = int(map(x, 0, cols, 0, width));
//      int vidY = int(map(y, 0, rows, 0, height));
      
//      // Get the color from the video feed
//      color c = pg_cam.get(vidX, vidY);
//      /*
//      // Calculate luminance
//      float luminance = (red(c) * 0.299 + green(c) * 0.587 + blue(c) * 0.114) / 255.0;
      
//      // Map luminance to ASCII character
//      int charIndex = int(map(luminance, 0, 1, 0, asciiChars.length - 1));
//      char asciiChar = asciiChars[charIndex];
//      */
//      // Draw the ASCII character
//      fill(c);
//      rect(x * cellSize + cellSize/2,y * cellSize + cellSize/2,cellSize,cellSize);
//      //text(asciiChar, x * cellSize + cellSize/2, y * cellSize + cellSize/2);
//    }
//  }
//  }
//}
/*
import processing.video.*;

Capture cam;


int cam_w = 640;
int cam_h = 480;

int scale_view = 2;
int view_w = cam_w * scale_view;
int view_h = cam_h * scale_view;

PGraphics pg_cam;

int cellSize = 6;
int cols, rows;
char[] asciiChars = {'@', '#', 'S', '%', '?', '*', '+', ';', ':', ',', '.'};
float[] bright;
public void settings() {
  size(view_w,view_h, P2D);
  smooth(4);
}

void setup() {
  
  
  String[] cameras = Capture.list();
  
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }
    
    // The camera can be initialized directly using an 
    // element from the array returned by list():
    cam = new Capture(this, cameras[0]);
    cols = int(cam.width/cellSize);
    rows = int(cam.height/cellSize);
    
  }
    pg_cam = createGraphics(width,height, P2D);
    cam.start();
    
    bright = new float[cols*rows];
    for (int i = 0; i < cols*rows; i++) {
    // set each brightness at the midpoint to start
    bright[i] = 0.5;
    }
    textAlign(CENTER, CENTER);
    noStroke();
    //noLoop();
}

void draw() {
  
  background(0);
  if (cam.available() == true) {
    cam.read();
    
    pg_cam.beginDraw();
    pg_cam.image(cam,0,0, width, height);
    pg_cam.endDraw();
    
    //image(pg_cam, 0, 0);
  }
  
    
    cam.loadPixels();
    for(int j = 0; j<rows; j++){
    for(int i = 0; i<cols; i++){
       int x = int(i * cellSize );
       int y = int(j * cellSize );
       int id = j * cols + i;
       color c = cam.pixels[y*cam.width+x];
       float luminance = (red(c) * 0.299 + green(c) * 0.587 + blue(c) * 0.114) / 255.0;
       float diff = luminance - bright[id];
       bright[id] += diff * 0.05;
       int charIndex = int(map(1-bright[id], 0, 1, 0, asciiChars.length - 1));
       char asciiChar = asciiChars[charIndex];
       pushMatrix();
       translate((x+ cellSize/2)*2,(y+ cellSize/2)*2);
       fill(255);
       //rect(0,0,cellSize,cellSize);
       text(asciiChar,0,0);
       popMatrix();
       
    }
  }
}
*/
