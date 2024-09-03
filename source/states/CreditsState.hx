package states;

import flixel.addons.transition.FlxTransitionableState;

class CreditsState extends MusicBeatState
{
	var curSelected:Int = 0;

        //im super lazy
	final list:Array<Array<String>> = [
        ['infry - did literally all the art and coded',                                   'https://x.com/Infry20'],
        ['data - coded a bunch',                                                          'https://x.com/_data5'],
        ['staticfyre -  also coded stuff',                                                'https://x.com/staticfyre'],
        ['funkypop - songs and mac build',                                                'https://x.com/funkypoppp'],
        ['vladosikos17 - songs and chart.',                                               'https://x.com/vladosikos16'],
        ['bubu - john doe',                                                               'https://x.com/bubureal__'],
        ['ahloof - 1x song hello thx',                                                    'https://x.com/ahhhloof'],
        ['checkty - noli',                                                                'https://x.com/checkty_'],
        ['grave - bloxpin',                                                               'https://x.com/konn_artist'],
        ['punkett - let us have bloxpin ty',                                              'https://x.com/_punkett'],
        ['fidy50 - charted almost everything',                                            'https://x.com/50Fidy'],
        ['estrogenStorm - va and charted devilish',                                       'https://x.com/Estrogen_Storm'],
        ['ciphieVA - well. va',                                                           'https://x.com/CiphieVA'],
        ['headdzo - bloody mary yes',                                                     'https://x.com/WhoUsedHeaddzo'],
		['grace - chart bloody mary thx',                                                 'https://x.com/graceusamaa']
	];
	private var ohio:FlxTypedGroup<FlxText>;
	var bg:FlxSprite;
	var line:FlxSprite;

	override function create()
	{
		#if DISCORD_ALLOWED
		// Updating Discord Rich Presence
		DiscordClient.changePresence("ohio friends", null);
		#end

		persistentUpdate = true;
		bg = new FlxSprite().loadGraphic(Paths.image('menu/cock'));
		bg.antialiasing = ClientPrefs.data.antialiasing;
		bg.updateHitbox();
		add(bg);
		bg.screenCenter();
	
		ohio = new FlxTypedGroup<FlxText>();
		for (i in 0...list.length)
		{
			var text = new FlxText(325,0,0,list[i][0]);
			text.setFormat(Paths.font("ArialCEItalic.ttf"),40, FlxColor.BLACK, LEFT);
			text.scale.set(0.34,0.34);
			text.antialiasing = ClientPrefs.data.antialiasing;
		    text.y += (20.5 * (i - (list.length / 2)) + 420);
			text.updateHitbox();
			ohio.add(text);
		}
		add(ohio);

		line = new FlxSprite();
		line.makeGraphic(310, 3, FlxColor.BLACK);
		add(line);

		changeSelection();
		super.create();
		FlxG.camera.zoom += 0.15;
	}

	var holdTime:Float = 0;
	override function update(elapsed:Float)
	{
		var shiftMult:Int = 1;
		if(FlxG.keys.pressed.SHIFT) shiftMult = 3;
		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;

		if (upP)
		{
			changeSelection(-shiftMult);
			holdTime = 0;
		}
		if (downP)
		{
			changeSelection(shiftMult);
			holdTime = 0;
		}

		if(controls.UI_DOWN || controls.UI_UP)
		{
			var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
			holdTime += elapsed;
			var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);

			if(holdTime > 0.5 && checkNewHold - checkLastHold > 0)
			{
				changeSelection((checkNewHold - checkLastHold) * (controls.UI_UP ? -shiftMult : shiftMult));
			}
		}

		if(controls.ACCEPT) CoolUtil.browserLoad(list[curSelected][1]); 
		if (controls.BACK)
		{
			FlxTransitionableState.skipNextTransIn = FlxTransitionableState.skipNextTransOut = true;
			MusicBeatState.switchState(new states.MainMenuState());
		}
		
		super.update(elapsed);
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('click'));
	
		curSelected = FlxMath.wrap(curSelected + change, 0, list.length - 1);
		line.x = ohio.members[curSelected].x;
		line.y = ohio.members[curSelected].y+15;
	}
}
