class HueSaturationBrightness{
  private float hue;
  private float saturation;
  private float brightness;
 
  public HueSaturationBrightness(float hue, float saturation, float brightness){
    this.hue = hue;
    this.saturation = saturation;
    this.brightness = brightness;
  }
  
  public float getHue(){
    return this.hue;
  }
  
  public float getSaturation(){
    return this.saturation;
  }
  
  public float getBrightness(){
    return this.brightness;
  }
  
  @Override
  public String toString(){
    return "HSB:"+this.hue + "-"+this.saturation+"-"+this.brightness;
  }
}