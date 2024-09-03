package;

import objects.SoundTray;
import flixel.FlxBasic;
import states.MainMenuState;
import backend.Highscore;
import states.TitleState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.input.keyboard.FlxKey;
import openfl.display.Sprite;
import flixel.FlxState;
import openfl.display.BitmapData;
import openfl.Lib;

class InitState extends FlxState
{
    //for everything ud want to boot up before the game starts do in here
    
    public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
	public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
	public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS];

	//move out of init? maybe
	public static final sSeperators:Array<String> = [' - ', ' | '];

	override function create()
	{
        
		#if LUA_ALLOWED Lua.set_callbacks_function(cpp.Callable.fromStaticFunction(psychlua.CallbackHandler.call)); #end
		#if ACHIEVEMENTS_ALLOWED Achievements.load(); #end
		FlxG.mouse.visible = false;


		Controls.instance = new Controls();
		ClientPrefs.loadDefaultKeys();
		FlxG.save.bind('funkin', CoolUtil.getSavePath());
		ClientPrefs.loadPrefs();

		// FlxG.signals.postStateSwitch.add(()->{
		// 	FlxTransitionableState.skipNextTransIn = true;
		// 	FlxTransitionableState.skipNextTransOut = true;
		// });
		// FlxTransitionableState.skipNextTransIn = true;
		// FlxTransitionableState.skipNextTransOut = true;

		hxvlc.util.Handle.init();
		

		#if LUA_ALLOWED Mods.pushGlobalMods(); #end
		Mods.loadTopMod();

		FlxG.fixedTimestep = false;
		FlxG.game.focusLostFramerate = 60;
		FlxG.keys.preventDefaultKeys = [TAB];

		FlxG.signals.postStateSwitch.add(onStateSwitchPost);

		Highscore.load();
	
		FlxTransitionableState.skipNextTransIn = FlxTransitionableState.skipNextTransOut = true;
		
		FlxG.switchState(new MainMenuState());

		if(FlxG.save.data != null && FlxG.save.data.fullscreen) FlxG.fullscreen = FlxG.save.data.fullscreen;

		var uyeah = BitmapData.fromFile('assets/shared/images/mousemode.png');
		FlxG.mouse.load(uyeah,1,-5,-5);
		

		#if debug
		FlxG.plugins.addPlugin(new DebugUtil());
		#end

		super.create();
	}


	public static function resetSpriteCache(sprite:Sprite):Void
	{
		@:privateAccess {
			sprite.__cacheBitmap = null;
			sprite.__cacheBitmapData = null;
		}
	}

	public static function onStateSwitchPost()
	{
	}



	public static function getTaskList():String
	{
		var taskList = new Process('tasklist');
		var tasks:String = taskList.stdout.readAll().toString().toLowerCase();
		taskList.close(); //close because its done
		return tasks;
	}
		
	public static function isStreamer():Bool
	{
		var curRunningApps = getTaskList();
		var brokenList = curRunningApps.split('\n');
		for (i in brokenList) {
			if (i.contains('obs64')) return true;
		}
		return false;
	}

}




class DebugUtil extends FlxBasic
{
	override function update(elapsed:Float) {
		super.update(elapsed);

		if (FlxG.keys.justPressed.F2) {
			FlxG.camera.zoom -= 0.1;
		}
		if (FlxG.keys.justPressed.F3) {
			FlxG.camera.zoom += 0.1;
		}

		// if (FlxG.keys.justPressed.RIGHT) {
		// 	FlxG.camera.scroll.x += 100;
		// }
		// if (FlxG.keys.justPressed.LEFT) {
		// 	FlxG.camera.scroll.x -= 100;
		// }
	}
}