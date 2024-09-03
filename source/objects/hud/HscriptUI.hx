package objects.hud;

import tea.SScript.TeaCall;
import objects.hud.Ihud;
import flixel.addons.ui.FlxUIGroup;
import psychlua.HScript;
import flixel.group.FlxContainer;

@:access(states.PlayState)
class HscriptUI extends FlxContainer implements Ihud
{
    public var isScripted:Bool = true;


    static var exts:Array<String> = ['hx','hxs','hscript'];

    public var script:HScript;
    public function new(scriptContent:String) {
        super();

        script = new HScript(null,scriptContent);
        if(script.parsingException != null) {
            trace('PARSING ERROR: ${script.parsingException.message}');
        }
        setupScript();
        
        tryCall('createUI');
    }

    function setupScript() {
        script.set("add",this.add);
        script.set("remove",this.remove);
        script.set("insert",this.insert);
        script.set("members",this.members);
    }

    public function onSongStart() tryCall('onSongStart');
    public function onUpdateScore()tryCall('onUpdateScore');
    public function onHealthChange() tryCall('onHealthChange');
    public function onCharChange() tryCall('onCharChange');

    public function onStepHit() {
        script.set('curStep',PlayState.instance.curStep);
        tryCall('onStepHit');
    }
    public function onBeatHit() {
        script.set('curBeat',PlayState.instance.curBeat);
        tryCall('onBeatHit');
    }
    public function onSectionHit() {
        script.set('curSection',PlayState.instance.curSection);
        tryCall('onSectionHit');
    }

    public function onEventTrigger(eventName:String,val1:String,val2:String,strumtime:Float) {tryCall('onEventTrigger',[eventName,val1,val2,strumtime]);}

    override function update(elapsed:Float) {super.update(elapsed);tryCall('update',[elapsed]);}

    function tryCall(call:String, ?args:Array<Dynamic>) {
        if (script.exists(call)) checkCallValidity(script.call(call,args));
    }

    function checkCallValidity(call:TeaCall) {
        if(!call?.succeeded)
        {   var excep = call.exceptions[0];
            if (excep != null)  
            {
                var message = excep.message.replace('SScript:','');
                var func = call.calledFunction; 
                trace('ERROR: [$func - line: $message]');
            }
        }
    }

    public static function createUI(path:String)
    {
        for (i in exts) {
            var path = '$path.$i';
            if (Paths.fileExists(path,TEXT)) {
                return new HscriptUI(Paths.getTextFromFile(path));
                break;                
            }
        }
        return null;
    }


    override function destroy() {
        script?.destroy();
        super.destroy();
    }

}