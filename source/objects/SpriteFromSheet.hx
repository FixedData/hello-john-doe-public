package objects;


class SpriteFromSheet extends FunkinSprite
{
    public var debugging:Bool = false;

    var currentAnim:String = '';
    public function new(x:Float = 0,y:Float = 0,source:String,anim:String) {
        super(x,y);
        frames = Paths.getSparrowAtlas(source);
        animation.addByPrefix(anim,anim);
        animation.play(anim);
        currentAnim = anim;
        antialiasing = ClientPrefs.data.antialiasing;
    }

    public function adjust(fps:Int = 24,loop:Bool = true,playNow:Bool=true) {
        animation.remove(currentAnim);
        animation.addByPrefix(currentAnim,currentAnim,fps,loop);
        if (playNow) animation.play(currentAnim,true);
    }

    public function play(forced:Bool = false,reversed:Bool = false,frame:Int = 0) {
        animation.play(currentAnim,reversed,frame);
    }


    override function update(elapsed:Float) {
        super.update(elapsed);

        if (debugging) {
            if (FlxG.keys.justPressed.LEFT) x += FlxG.keys.pressed.SHIFT ? -10 : -1;
            if (FlxG.keys.justPressed.RIGHT) x += FlxG.keys.pressed.SHIFT ? 10 : 1;
            if (FlxG.keys.justPressed.UP) y += FlxG.keys.pressed.SHIFT ? -10 : -1;
            if (FlxG.keys.justPressed.DOWN) y += FlxG.keys.pressed.SHIFT ? 10 : 1;


            if (FlxG.keys.justPressed.SPACE) {
                trace('$currentAnim X: ' + x + '$currentAnim Y: ' + y);
            }
        }
    }
}