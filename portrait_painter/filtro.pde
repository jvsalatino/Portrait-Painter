
class HSBFilter {
  
    
  public HueSaturationBrightness applyRanges(HueSaturationBrightness initialHSB) {
    float hueInRange = -1;
    float[][] hueRanges = {{0.0, 10.0}, {10.0, 40.0}, {40.0, 70.0}, {70.0, 82.0}, {82.0, 130.0}, {130.0, 210.0}, {210.0, 255.0}, {255.0, 345.0}, {345.0, 360.0}};
    float[] hueValue = {0.0, //red 
                      35.0, //orange
                      50.0, // yellow
                      75.0, // yellow/green 
                      100.0, //green 
                      175.0, //cyan 
                      235.0, // blue
                      300.0, // magenta 
                      0.0    // red
                    };
    
    
    for(int i = 0; i < hueRanges.length; i ++){
      if(initialHSB.getHue() >= hueRanges[i][0] && initialHSB.getHue() < hueRanges[i][1]){
        hueInRange = hueValue[i];
        break;
      }
    }
    if(hueInRange == -1){
      throw new IllegalStateException("Hue cannot be calculated, review parameters");
    }
    
    int saturationInRange = -1;
    int[][] saturationRanges = {{0, 10}, {10, 45}, {45, 75}, {75, 85}, {85, 92}, {92, 101}};
    int[] saturationValue = {0, 20, 40, 60, 80, 100};
    
    for(int i = 0; i < saturationRanges.length; i ++){
      if(initialHSB.getSaturation() >= saturationRanges[i][0] && initialHSB.getSaturation() < saturationRanges[i][1]){
        saturationInRange = saturationValue[i];
        break;
      }
    }
    if(saturationInRange == -1){
      throw new IllegalStateException("Saturation cannot be calculated, review parameters");
    }
    int brightnessInRange = -1;
    int[][] brightnessRanges = {{0, 15}, {15, 25}, {25, 31}, {31, 40}, {40, 70}, {70, 101}};
    int[] brightnessValue = {0, 20, 40, 60, 80, 100};
    
    /*
    * This loop picks is in charge of selecting the brightness value based on the ranges defined in brightnessRanges
    */
    for(int i = 0; i < brightnessRanges.length; i ++){
      if(initialHSB.getBrightness() >= brightnessRanges[i][0] && initialHSB.getBrightness() < brightnessRanges[i][1]){
        brightnessInRange = brightnessValue[i];
        break;
      }
    }
    if(brightnessInRange == -1){
      throw new IllegalStateException("Brightness cannot be calculated, review parameters");
    }
    
    return new HueSaturationBrightness(hueInRange, saturationInRange, brightnessInRange);
  }
  
  public HueSaturationBrightness applyGreyscaleFilter(HueSaturationBrightness initialHSB) {
  
    int hueInGreyScale = -1;
    int[] hueValueGreyScale = {
                               1, //black
                               2, // 20% grey
                               3, // 40% grey
                               4, // 60% grey
                               5, // 80% grey
                               6 //  white
                             };
     if(initialHSB.getBrightness() == 0){
       hueInGreyScale = hueValueGreyScale[0]; 
     } else if( initialHSB.getBrightness() == 20 && initialHSB.getSaturation() == 0){
       hueInGreyScale = hueValueGreyScale[1]; 
     } else if( initialHSB.getBrightness() == 40 && initialHSB.getSaturation() == 0){
       hueInGreyScale = hueValueGreyScale[2];
     } else if( initialHSB.getBrightness() == 60 && initialHSB.getSaturation() == 0){
       hueInGreyScale = hueValueGreyScale[3];
     } else if( initialHSB.getBrightness() == 80 && initialHSB.getSaturation() == 0){
       hueInGreyScale = hueValueGreyScale[4];
     } else if( initialHSB.getBrightness() == 100 && initialHSB.getSaturation() == 0){
       hueInGreyScale = hueValueGreyScale[5];
     }
                             
    return new HueSaturationBrightness(hueInGreyScale, initialHSB.getSaturation(), initialHSB.getBrightness());
  } 
  
  
  
  
}