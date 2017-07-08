public class ImageArrays{
  
    private int width;
    private int height;
    private float[][] hueArray;
    private float[][] saturationArray; 
    private float[][] brightnessArray;
    
    public ImageArrays(int width, int height){
      this.width = width;
      this.height = height;
      this.hueArray = new float[width][height];
      this.saturationArray = new float[width][height];
      this.brightnessArray = new float[width][height];
    }
    
    public float[][] getHueArray(){
      return this.hueArray;
    }
  
   public float[][] getSaturationArray(){
      return this.saturationArray;
    }
    
    public float[][] getBrightnessArray(){
      return this.brightnessArray;
    }
    
    public int getHeight(){
      return this.height;
    }
    
    public int getWidth(){
      return this.width;
    }
    
}