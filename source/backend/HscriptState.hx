package backend;

import tea.SScript.Tea;
import states.MainMenuState;
import psychlua.HScript;

class HscriptState extends MusicBeatState
{
    var script:HScript;
    public function new(scriptName:String) 
    {
        super();
        if (Paths.fileExists('states/$scriptName.hx',TEXT)) {
            script = new HScript(null,Paths.getTextFromFile(scriptName));
            

        }
        else {
            trace('couldnt find ${scriptName} !! returning to main menu');
            FlxG.switchState(new MainMenuState());
        }
    }

    override function create() {
        tryCall('create');
        super.create();
        tryCall('createPost');
    }

    override function update(elapsed:Float) {
        tryCall('update');
        super.update(elapsed);
        tryCall('updatePost');
    }

    override function sectionHit() {
        tryCall('sectionHit');
        super.sectionHit();
    }

    override function beatHit() {
        tryCall('beatHit');
        super.beatHit();
    }

    override function stepHit() {
        tryCall('beatHit');
        super.stepHit();
    }
    // override function closeSubState() {
    //     tryCall('closeSubState');
    //     super.closeSubState();
    //     tryCall('closeSubStatePost');
    // }




    function tryCall(call:String, ?args:Array<Dynamic>) {
        // #if target.threaded
        // if (ClientPrefs.data.multiThreaded) thread.events.run(()->if (script.exists(call)) checkCallValidity(script.call(call,args)));
        // else if  #end 
        
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
}