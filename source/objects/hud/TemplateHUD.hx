package objects.hud;

import flixel.FlxBasic;



class TemplateHUD extends FlxTypedContainer<FlxBasic> implements Ihud
{
	public var isScripted:Bool;

    public function onCharChange() {}

    public function onEventTrigger(eventName:String, val1:String, val2:String, strumtime:Float) {}

    public function onSectionHit() {}

    public function onBeatHit() {}

    public function onStepHit() {}

    public function onHealthChange() {}

    public function onUpdateScore() {}

    public function onSongStart() {}


    public function new() {
        super();
    }
    
}