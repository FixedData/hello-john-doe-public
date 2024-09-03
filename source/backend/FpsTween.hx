package backend;


@:access(flixel.tweens)
@:access(flixel.tweens.FlxTween)
class FpsTween extends flixel.tweens.FlxTween.FlxTweenManager
{
    public static var m30:FpsTween;
    public static var m24:FpsTween;
    public static var m12:FpsTween;
    public static var m8:FpsTween;
    
    public var fps(default, set):Float;
    public var delay:Float;
    var tmr:Float = 0;
	public function new(fps:Float = 24):Void
	{
		super();


        this.fps = fps;
	}

    function set_fps(v:Float):Float {
        delay = 1/v;
        return fps = v;
    }



	override public function update(elapsed:Float):Void
	{
        tmr += elapsed;
        while(tmr > delay) {
            tmr -= delay;

            super.update(delay);
        }
	}
}