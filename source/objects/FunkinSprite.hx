package objects;

import flixel.graphics.FlxGraphic;
import backend.animation.PsychAnimationController;


//convenient
class FunkinSprite extends FlxSprite
{
    public var offsets:Map<String,Array<Float>> = new Map();

    public function new(x:Float = 0,y:Float = 0,?newGraphic:FlxGraphic) {
        super(x,y,newGraphic);
        animation = new PsychAnimationController(this);

    }

    public function setScale(scaleX:Float,?scaleY:Float,updateHitbox:Bool = true) 
    {
        scaleY ??= scaleX;
        scale.set(scaleX,scaleY);
        if (updateHitbox) this.updateHitbox();
    }

    public function updateGraphicSize(width:Float,height:Float,updateHitbox:Bool = true) 
    {
        super.setGraphicSize(width,height);
        if (updateHitbox) this.updateHitbox();
    }

    public function loadImage(path:String,?library:String,animated:Bool = false,frameWidth:Int = 0,frameHeight:Int = 0,unique:Bool = false,?key:String) 
    {
        //idk why i  gotta cast this but whatever
        return cast(this.loadGraphic(Paths.image(path,library),animated,frameWidth,frameHeight,unique,key),FunkinSprite);
    }

    public function loadFrames(path:String,?library:String) 
    {
        this.frames = Paths.getSparrowAtlas(path,library);
        return this;

    }

    public function makeScaledGraphic(width:Float,height:Float,color:FlxColor = FlxColor.WHITE,unique:Bool = false,?key:String) 
    {
        this.makeGraphic(1,1,color,unique,key);
        scale.set(width,height);
        updateHitbox();
        return this;
    }

    public function hide() 
    {
        alpha = 0.0000000001;
    }

    public function addOffset(name:String,x:Float,y:Float) {
        offsets[name] = [x,y];
    }

    public function addAnimAndPlay(anim:String) {
        
    }


}