public class Stroke{
  private HueSaturationBrightness hsb;
  
  private List<Line> lines = new CopyOnWriteArrayList<Line>();
  
  public Stroke(HueSaturationBrightness hsb){
    this.hsb = hsb;
  }
  
  public HueSaturationBrightness getHSB(){
    return this.hsb;
  }
  
  public void addLine(Line line){
    this.lines.add(line);
  }

  public List<Line> getLines(){
    return this.lines;
  }
  
   
  
  
}