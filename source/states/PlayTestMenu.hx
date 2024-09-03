package states;

import states.PlayMenu.PlayMenuState;
import flixel.input.mouse.FlxMouse;
import flixel.input.mouse.FlxMouseEvent;
import backend.CrossUtil;
import openfl.display.BitmapData;
import backend.Song;
import backend.Highscore;
import backend.WeekData;
import openfl.filters.ShaderFilter;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.display.FlxBackdrop;
import objects.SpriteFromSheet;
import objects.FunkinSprite;
import flixel.FlxObject;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import states.editors.MasterEditorMenu;
import options.OptionsState;

//not gonan eb used but i made this fast to quickly see what i need to hjave minimum for the transitions
class PlayTestMenu extends MusicBeatSubstate
{

	public static var finishCallback:Void->Void = null;

	var menuState:PlayMenuState;
	var door:FlxSprite;
	var elevator:FlxSprite;
	var overlay:FlxSprite;

	public function new(?state:PlayMenuState) {
		super();
		menuState = state;
	}

	override function create()
	{
		cameras = [CrossUtil.quickCreateCam()];
		persistentUpdate = persistentDraw = true;

		elevator = new FlxSprite().loadGraphic(Paths.image('menu/rolbox/song/elevator'));
		elevator.screenCenter();
		add(elevator);
		
		door = new FlxSprite().loadFrames('menu/rolbox/song/doors');
		door.addAnimByPrefix('closed','closed',24,false);
		door.addAnimByPrefix('open','open',24,false);
		door.addAnimByPrefix('transition','dooranim',24,false);
		door.playAnimation('closed');
		add(door);
		door.setPosition(elevator.x + 347,elevator.y + 146);

		overlay = new FlxSprite().loadImage('menu/rolbox/song/grad');
		add(overlay);
		overlay.screenCenter();

		FlxG.mouse.visible = true;
		camera.zoom += 0.5;

		trace('menuState: ' + menuState);
		if (menuState == IN) {
			door.playAnimation('closed');
			door.animation.play('transition'); 


		}
		if (menuState == OUT) {
			door.playAnimation('open');
			camera.zoom = 4;
			FlxTween.tween(camera, {zoom: 1.5},0.6,{onComplete: Void->{
				door.animation.play('transition',true,true); 
				// close();
				// if(finishCallback != null) finishCallback();
				// finishCallback = null;
			}});

		}

		door.animation.finishCallback = (f)->{
			if (f == 'transition') {
				if (menuState == IN) {
					FlxTween.tween(camera, {zoom: 5},0.6,{onComplete: Void->{
						close();
						if(finishCallback != null) finishCallback();
						finishCallback = null;
					}});
				}
				else {
					close();
					if(finishCallback != null) finishCallback();
					finishCallback = null;
				}

			}
		}

		super.create();
	}
	

	override function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.FOUR) FlxG.resetState();


		super.update(elapsed);
	}


}