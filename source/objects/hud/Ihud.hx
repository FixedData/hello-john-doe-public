package objects.hud;

interface Ihud
{
    public function onSongStart():Void;
    public function onUpdateScore():Void;
    public function onHealthChange():Void;
    public function onStepHit():Void;
    public function onBeatHit():Void;
    public function onSectionHit():Void;
    public function onEventTrigger(eventName:String,val1:String,val2:String,strumtime:Float):Void;
    public function onCharChange():Void;
    public var isScripted:Bool;
}