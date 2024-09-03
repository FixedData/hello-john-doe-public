package objects.hud;

import flixel.math.FlxRect;
import flixel.FlxBasic;



class RobloxHUD extends FlxTypedContainer<FlxBasic> implements Ihud
{
	public var isScripted:Bool;

    public function onCharChange() {}

    public function onEventTrigger(eventName:String, val1:String, val2:String, strumtime:Float) {}

    public function onSectionHit() {}

    public function onBeatHit() {}

    public function onStepHit() {}

    public function onHealthChange() {
        if (hpClipRect == null) return;
        hpClipRect.height = FlxMath.remapToRange(PlayState.instance.health,0,2,0,250);
        hpClipRect.y = hpBar_over.height - hpClipRect.height;
        hpBar_over.clipRect = hpClipRect;
    }

    public function onUpdateScore() 
    {


    }

    public function onSongStart() {}

    var hpClipRect:FlxRect;
    var hpBar_under:FlxSprite;
    var hpBar_over:FlxSprite;
    var hpText:FlxText;

    var timeTxt:FlxText;


    public function new() {
        super();


        var topBar = new FunkinSprite().makeScaledGraphic(FlxG.width,40,FlxColor.BLACK);
        add(topBar);

        timeTxt = new FlxText(0,10,FlxG.width,'time: ',30);
        add(timeTxt);
        timeTxt.font = Paths.font('ARIAL.TTF');
        timeTxt.alignment = CENTER;
        retroText(timeTxt);

        hpBar_under = new FlxSprite().makeGraphic(20,250,FlxColor.RED);
        hpBar_under.screenCenter();
        hpBar_under.x = FlxG.width - hpBar_under.width - 50;
        add(hpBar_under);
    
        hpBar_over = new FlxSprite().makeGraphic(20,250,0xFF96FF00);
        hpBar_over.screenCenter();
        hpBar_over.x = FlxG.width - hpBar_over.width - 50;
        add(hpBar_over);

        hpClipRect = new FlxRect(0,0,20,125);

        hpText = new FlxText(0,0,0,'health',30);
        hpText.italic = true;
        hpText.color = FlxColor.BLUE;
        hpText.font = Paths.font('ArialCEItalic.ttf');
        hpText.centerOnSprite(hpBar_under,X);
        hpText.y = hpBar_under.y + hpBar_under.height + 10;
        add(hpText);
        




        onHealthChange();
    }
    


    function retroText(f:FlxText)
    {
        
        f.size = Std.int(f.size/2);
        f.scale.set(2,2);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        var currentTime = Conductor.songPosition - ClientPrefs.data.noteOffset;
        timeTxt.text = 'time: ' + Math.round((FlxG.sound.music.length - currentTime)/1000);
    }
}