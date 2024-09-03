package options;

import flixel.addons.transition.FlxTransitionableState;
import states.PlayMenu;
import backend.StageData;

class OptionsState extends MusicBeatState
{
    var options:Array<String> = ['buttons', 'visuals', 'gaemplay'];
	private var penis:FlxTypedGroup<FlxText>;
	private static var curSelected:Int = 0;
	public static var menuBG:FlxSprite;
	public static var onPlayState:Bool = false;

	function openSelectedSubstate(label:Int) {
		switch(label) {
			case 0:
                openSubState(new options.ControlsSubState());
			case 1:
                openSubState(new options.VisualsUISubState());
			case 2:
                openSubState(new options.GameplaySettingsSubState());


		}
	}


	override function create() {
		#if desktop
		DiscordClient.changePresence("Options Menu", null);
		#end

		penis = new FlxTypedGroup<FlxText>();
		add(penis);
		var temp = [];
		for (i in options) {
			var split = i.split('');
			var newWord:String = '';
			for (k=>i in split) {
				if (FlxG.random.bool(10)) {
					newWord+= ' ';
				}
				newWord+= i;
				
			}
			temp.push(newWord);

		}
		options = temp;

		
		var whatthefuck = FlxG.random.int(100,650);
		for (i in 0...options.length)
		{
			var optionstxt = new FlxText(0,0,0,options[i]);
			optionstxt.setFormat(Paths.font("ARIAL.ttf"), 40, FlxColor.WHITE, CENTER);
			optionstxt.screenCenter(Y);
			optionstxt.y += (60 * (i - (options.length / 2))) + 50;
			optionstxt.x += whatthefuck;
			
			penis.add(optionstxt);
		}
		

		changeSelection();
		ClientPrefs.saveSettings();

		super.create();
	}

	override function closeSubState() {
		super.closeSubState();
		ClientPrefs.saveSettings();
	}

    override function update(elapsed:Float) {
        super.update(elapsed);
        if (FlxG.keys.justPressed.FOUR) FlxG.resetState();

        if (controls.UI_UP_P) {
            changeSelection(-1);
        }
        if (controls.UI_DOWN_P) {
            changeSelection(1);
        }

        if (controls.BACK) {
            FlxG.sound.play(Paths.sound('cancelMenu'));
            if(onPlayState)
            {
                StageData.loadDirectory(PlayState.SONG);
                LoadingState.loadAndSwitchState(new PlayState());
                FlxG.sound.music.volume = 0;
            }
            else  {
				FlxTransitionableState.skipNextTransIn = FlxTransitionableState.skipNextTransOut = true;
				MusicBeatState.switchState(new states.MainMenuState());
			}
        }
        else if (controls.ACCEPT) openSelectedSubstate(curSelected);
    }
		
	function changeSelection(change:Int = 0) {
		penis.members[curSelected].color = FlxColor.WHITE;
		curSelected += change;
		if (curSelected < 0)
			curSelected = options.length - 1;
		if (curSelected >= options.length)
			curSelected = 0;
		penis.members[curSelected].color = FlxColor.YELLOW;
		FlxG.sound.play(Paths.sound('click'));
	}
}
