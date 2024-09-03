package substates;

import states.PlayMenu;
import objects.FunkinSprite;
import tea.SScript.TeaCall;
import psychlua.HScript;
import backend.CrossUtil;
import objects.SpriteFromSheet;
import flixel.system.FlxAssets.FlxShader;
import flixel.addons.transition.FlxTransitionableState;
import states.StoryMenuState;
import states.FreeplayState;
import options.OptionsState;

class PauseSubState extends MusicBeatSubstate
{
	var curSelected:Int = 0;
	var options:Array<String> = ['resume','restart','setting','leave'];
	var pauseMusic:FlxSound;
	var cam:FlxCamera;

	public static var songName:String = null;

	var basePauseThing:FlxSprite;
	var black:FlxSprite;

	final time = 0.1;

	static var instance:PauseSubState = null;

	public static function cacheMenu()
	{
		Paths.image('menu/pause/im_pausing');
		Paths.image('menu/pause/my_penis_is_difficult');
	}

	override function create()
	{
		cam = CrossUtil.quickCreateCam();

		pauseMusic = new FlxSound();

		instance = this;

		black = new FlxSprite().generateGraphic(FlxG.width,FlxG.height,FlxColor.BLACK);
		black.alpha = 0;
		add(black);
		FlxTween.tween(black, {alpha: 0.5},time);

		basePauseThing = new FlxSprite().loadFrames('menu/pause/im_pausing');
		for (i in 0...options.length) {
			basePauseThing.addAnimByPrefix('$i',options[i]);
		}
		basePauseThing.animation.play('0');
		basePauseThing.y = -basePauseThing.height;
		basePauseThing.screenCenter(X);
		add(basePauseThing);
		FlxTween.tween(basePauseThing, {y: (FlxG.height-basePauseThing.height)/2},time);

		cameras = [cam];

		changeSelection();

		super.create();
	}
	
	function getPauseSong()
	{
		var formattedSongName:String = (songName != null ? Paths.formatToSongPath(songName) : '');
		var formattedPauseMusic:String = Paths.formatToSongPath(ClientPrefs.data.pauseMusic);
		if(formattedSongName == 'none' || (formattedSongName != 'none' && formattedPauseMusic == 'none')) return null;

		return (formattedSongName != '') ? formattedSongName : formattedPauseMusic;
	}

	function quit() {
		cantUnpause = 111111;

		returnToMenu();

		// @:privateAccess FlxTween.tween(camera,{_fxFadeAlpha: 1},time,{ease: FlxEase.quadOut, onComplete: Void->{
		// 	for (i in FlxG.cameras.list) i.visible=false;

		// }});
	}

	function returnToMenu() {
		#if DISCORD_ALLOWED DiscordClient.resetClientID(); #end
		PlayState.deathCounter = 0;
		PlayState.seenCutscene = false;

		Mods.loadTopMod();
		openSubState(new PlayMenu(OUT));
		PlayMenu.finishCallback = ()->FlxG.switchState(()->new PlayMenu());
		// if(PlayState.isStoryMode)
		// 	MusicBeatState.switchState(new StoryMenuState());
		// else 
		// 	MusicBeatState.switchState(new FreeplayState());

		//FlxG.sound.playMusic(Paths.music('freakyMenu'));
		PlayState.changedDifficulty = false;
		PlayState.chartingMode = false;
		FlxG.camera.followLerp = 0;
	}

	function resume() {
		cantUnpause = 111111;
		FlxTween.tween(basePauseThing, {y: FlxG.height},time,{onComplete: Void->{close();}});
	}


	var holdTime:Float = 0;
	var cantUnpause:Float = 0.1;
	override function update(elapsed:Float)
	{

		if (FlxG.keys.justPressed.NINE) {
			FlxG.resetState();
		}

		cantUnpause -= elapsed;

		if (pauseMusic.volume < 0.5) pauseMusic.volume += 0.01 * elapsed;

		super.update(elapsed);

		if(controls.BACK)
		{
			close();
			return;
		}

		if (controls.UI_UP_P)
		{
			changeSelection(-1);
		}
		if (controls.UI_DOWN_P)
		{
			changeSelection(1);
		}

		if (controls.ACCEPT && (cantUnpause <= 0 || !controls.controllerMode))
		{
			switch (options[curSelected])
			{
				case "resume":
					resume();
				case "restart":
					restartSong();
				case 'setting':
					loadOptions();
				case "leave":
					quit();

			}
		}


	}

	public function loadOptions() 
	{
		PlayState.instance.paused = true; // For lua
		PlayState.instance.vocals.volume = 0;
		MusicBeatState.switchState(new OptionsState());
		if(ClientPrefs.data.pauseMusic != 'None')
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'), pauseMusic.volume);
			FlxTween.tween(FlxG.sound.music, {volume: 1}, 0.8);
			FlxG.sound.music.time = pauseMusic.time;
		}
		OptionsState.onPlayState = true;
	}

	public static function restartSong(noTrans:Bool = false)
	{
		PlayState.instance.paused = true; // For lua
		FlxG.sound.music.volume = 0;
		PlayState.instance.vocals.volume = 0;

		if(noTrans)
		{
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
		}
		MusicBeatState.resetState();
	}

	override function destroy()
	{
		FlxTween.cancelTweensOf(this);

		
		pauseMusic.destroy();
		
		instance = null;

		FlxG.cameras.remove(cam);

		super.destroy();
	}

	function changeSelection(change:Int = 0):Void
	{
		FlxG.sound.play(Paths.sound('click'), 0.4);

		curSelected = FlxMath.wrap(curSelected + change, 0, options.length-1);

		basePauseThing.animation.play('$curSelected');

	}
}
