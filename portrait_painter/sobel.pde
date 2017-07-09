import java.util.*;

// *******************************************
// Sobel Edge Detection
// Credits to: http://www.pages.drexel.edu/~weg22/edge.html for description and source
// *******************************************
class SobelEdgeDetection {

  public final float[] HUE_BASE_LIST =
                     {0.0, //red 
                      35.0, //orange
                      50.0, // yellow
                      75.0, // yellow/green 
                      100.0, //green 
                      175.0, //cyan 
                      235.0, // blue
                      300.0, // magenta 
                      2.0, // gray 20%
                      3.0, // gray 40%
                      4.0, // gray 60%
                      5.0, // gray 80%
                      6.0,  // White
                      1.0 // Black
                    };
  
  
  public final int grid = 5;
  
  public float factor = 3; // Line Segment Lenght Factor
  public int amountOfSegments = 3;
 
  public int offset_x = int(1 * scale);
  public int offset_y = int(1 * scale);
  public int ventana_x = int(100 * scale); // posicion real en la imagen . Coordenada x del angulo superior izquierdo de la ventana
  public int ventana_y = int(100 * scale);//posicion real en la imagen. Coordenada y del angulo superior izquierdo de la ventana
 
  
  public int ancho = int( 100 * scale); // cantidad de pixels en x
  public int alto = int( 100 * scale);// cantidad de pixels en y
 
  public int direction = 0; // Line Direction
   
  private HSBFilter hsbFilter; 
  
  public SobelEdgeDetection() {
    this.hsbFilter = new HSBFilter();
  }

  
  public ImageArrays calculatePixelRanges(PImage img) {
    //PImage buf = createImage( img.width, img.height, HSB );
    //buf.filter( BLUR, BLUR_PARAM);
    int totalPixels = img.width * img.height;
    int pixelsCounter = 0;
    ImageArrays imageArray = new ImageArrays(img.width, img.height);
    
    
    //buf.loadPixels(); 
    println("\t > Total Pixels to Process: " + totalPixels);
    
    // X & Y Pixels
    for (int x = 0; x < img.width; x++) {
      for (int y = 0; y < img.height; y++) {
      
        color col =  img.get(x, y);
        
        HueSaturationBrightness hsb = new HueSaturationBrightness(hue(col), saturation(col), brightness(col) );

        HueSaturationBrightness hsbInRange = hsbFilter.applyRanges(hsb);
        //print("HSB in range: " + hsbInRange.getHue() + " - " + hsbInRange.getSaturation() + " - " +  hsbInRange.getBrightness());
        //print("-H:" + hsbInRange.getHue());
         //<>//
        imageArray.getHueArray()[x][y] = hsbInRange.getHue();
        imageArray.getSaturationArray()[x][y] = hsbInRange.getSaturation();
        imageArray.getBrightnessArray()[x][y] = hsbInRange.getBrightness();
        
        pixelsCounter++;   
      }
    }
   
    //buf.updatePixels();
    //buf.save("output.jpg");
    return imageArray;
  }
  
  public PImage createImageFromArray(ImageArrays imageArrays, String name, boolean saveToDisk){
    PImage buf = createImage( imageArrays.getWidth(), imageArrays.getHeight(), HSB );
      // X & Y Pixels
    for (int x = 0; x < imageArrays.getWidth(); x++) {
      for (int y = 0; y < imageArrays.getHeight(); y++) {
        buf.pixels[x +  y * imageArrays.getWidth()]= color(imageArrays.getHueArray()[x][y],
                                                        imageArrays.getSaturationArray()[x][y], 
                                                        imageArrays.getBrightnessArray()[x][y]);
      }
    }
    buf.updatePixels();
    if(saveToDisk){
      buf.save(name);
    }
    return buf;
  }
  
  public List<Stroke> calculateGradients(PImage originalImage, ImageArrays rangesImage, List<Stroke> strokes) {
    println("\t > Calculating Gradients");
    
       // println("\t X: " + x + " - Y: " + y); 
        for (int brightness = 0; brightness <=100; brightness+=20) {
         // println("\t \t > Calculating Gradients Brightness: "+ brightness + "%");
           for (int hueIndex = 0; hueIndex < HUE_BASE_LIST.length; hueIndex++) { 
           //  println("\t \t > Calculating Gradients HUE: "+ HUE_BASE_LIST[hueIndex]);
              for (int saturation = 100; saturation >=0; saturation-=20) { 
             //   println("\t \t > Calculating Gradients Saturation: "+ saturation + "%");
             //   for (int y = 0; y < originalImage.height; y+=grid) {
               //    for (int x = 0; x < originalImage.width; x+=grid) {
                     ////////////////////
       // for(int y = 1; y < img.height-1; y+=grid)   // /// recorre todos los pixeles de la imagen por filas
       int lim_inf_x = offset_x;
       int lim_sup_x = int(offset_x + (210 * scale)); // 210 para portrait - 297 para landscape
       if (lim_sup_x > originalImage.width)
       {
         lim_sup_x = originalImage.width;
       }
        int lim_inf_y = offset_y;    
        int lim_sup_y = int(offset_y +(297*scale)); // 297 para portrait - 210 para landscape
        
       if (lim_sup_y > originalImage.height)
       {
         lim_sup_y = originalImage.height;
       }
       if(ventana_x != 0 && ventana_y != 0)
       {
        lim_inf_x = ventana_x;
        lim_inf_y = ventana_y;
        lim_sup_x = ventana_x + ancho;
        lim_sup_y = ventana_y + alto;
       }
       
      /////////////////////////////////////   
             for (int y = lim_inf_y; y < lim_sup_y; y+=grid) {
                   for (int x = lim_inf_x; x < lim_sup_x; x+=grid) {
                  
                  
                  
                  
                  calculateGradientForPixel(hueIndex, saturation, brightness, x, y, originalImage, rangesImage , strokes);
              }
          }
        }
      }
    }
    println("\t > Calculating Gradients Done!");
    return strokes;
  }
  

  public void calculateGradientForPixel(int hue, float saturation, float brightness, int x, int y, 
                            PImage originalImage, ImageArrays rangesImage, List<Stroke> strokes) {
    
    int sumHx = 0;
    int sumSx = 0;
    int sumBx = 0;
    int sumHy = 0;
    int sumSy = 0;
    int sumBy = 0;
    int finalSumB = 0;
    int finalSumH = 0;
    int finalSumS = 0;
    
    int GX[][] = new int[3][3];
    int GY[][] = new int[3][3];
    // 3x3 Sobel Mask for X
    GX[0][0] = -1;
    GX[0][1] = 0;
    GX[0][2] = 1;
    GX[1][0] = -2;
    GX[1][1] = 0;
    GX[1][2] = 2;
    GX[2][0] = -1;
    GX[2][1] = 0;
    GX[2][2] = 1;

    // 3x3 Sobel Mask for Y
    GY[0][0] =  -1;
    GY[0][1] =  -2;
    GY[0][2] =  -1;
    GY[1][0] =  0;
    GY[1][1] =  0;
    GY[1][2] =  0;
    GY[2][0] = 1;
    GY[2][1] = 2;
    GY[2][2] = 1;
    
    int copx = x;
    int copy = y;

    float initialHue = 0.0;
    float initialSaturation = 0.0;
    float initialBrightness = 0.0;
    
    
    //color colorInRange =  rangesImage.pixels[x+(y*rangesImage.width)];
     
     float hueInRange=  rangesImage.getHueArray()[x][y];
     float saturationInRange = rangesImage.getSaturationArray()[x][y];
     float brightnessInRange = rangesImage.getBrightnessArray()[x][y];
     //    print("-H:" + (int)hueInRange);
    // For each segment in the stroke
    for (int segment = 0; segment < amountOfSegments; segment++) {
     
      for (int i = -1; i <= 1; i++) {
        for (int j = -1; j <= 1; j++) {
          color col =  originalImage.get(copx + i, copy + j);
          int hu1=  int(hue(col));
          int sa1 = int(saturation(col));
          int br1 = int(brightness(col));         
          sumHx += hu1 * GX[ i + 1][ j + 1];
          sumSx += sa1 * GX[ i + 1][ j + 1];
          sumBx += br1 * GX[ i + 1][ j + 1];
          sumHy += hu1 * GY[ i + 1][ j + 1];
          sumSy += sa1 * GY[ i + 1][ j + 1];
          sumBy += br1 * GY[ i + 1][ j + 1];
        }
      }
      
      finalSumH = abs(sumHx) + abs(sumHy);
      finalSumS = abs(sumSx) + abs(sumSy);
      finalSumB = abs(sumBx) + abs(sumBy);
      int suma= int(finalSumB);
      int grad = int(map (suma, 0, 100, 0, 360));
      if (grad > 360) {
        grad = grad % 360;
      }
      if (grad >90 && grad < 180) {
        direction = -1;
      } else { //<>//
        direction = 1;
      }

      int plusx = int(factor*cos(radians(grad+90)));
      int plusy = int(factor*sin(radians(grad+90)));

      Stroke stroke = null;
      
      if (brightnessInRange == brightness && hueInRange == HUE_BASE_LIST[hue] && saturationInRange == saturation) {  
        stroke = new Stroke(new HueSaturationBrightness(HUE_BASE_LIST[hue], saturation, brightness));
        if (segment == 0) {
          //println("HSB: " + HUE_BASE_LIST[hue] + " - " + saturation + " - " +  brightness);
          
          initialHue = HUE_BASE_LIST[hue];
          initialSaturation = saturation;
          initialBrightness = brightness;
        }
        
        if (copx >= 0 && copy >= 0 && copx <= originalImage.width && copy <= originalImage.height && copx+plusx >= 0  
              && copy+plusy >=0 && copx+plusx <= originalImage.width && copy+plusy <= originalImage.height  ) {          
              if (HUE_BASE_LIST[hue] == initialHue && abs(saturation-initialSaturation) <= 20 && abs(brightness-initialBrightness) <= 20) {
                if(stroke != null){ //<>//
                  stroke.addLine(new Line(int(copx/scale), int(copy/scale),int((copx+plusx)/scale),int( (copy+plusy)/scale ))); //<>//
                }
          }
        }
        
      }  
      
      if(stroke != null){
        strokes.add(stroke);
      }
      copx = copx+plusx;
      copy = copy+plusy;
      sumHx=0;
      sumSx=0;
      sumBx=0;
      sumHy=0;
      sumSy=0;
      sumBy=0;
      finalSumH = 0;
      finalSumS = 0;
      finalSumB = 0;
    }
  }

  
}