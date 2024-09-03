package states;

import openfl.filters.ShaderFilter;
import shaders.CrtWarp;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.display.FlxBackdrop;
import backend.WeekData;
import backend.Highscore;

import flixel.input.keyboard.FlxKey;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.frames.FlxFrame;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import haxe.Json;

import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;

import shaders.ColorSwap;

import states.StoryMenuState;
import states.OutdatedState;
import states.MainMenuState;


class TitleState extends MusicBeatState
{

	public static var initialized:Bool = false;

	public static var updateVersion:String = '';
	var skippedIntro:Bool = false;

	var shaderCam:FlxCamera;
	var bgCam:FlxCamera;

	override public function create():Void
	{
		Paths.clearStoredMemory();
		super.create();

		bgCam = new FlxCamera();
		shaderCam = new FlxCamera(); //this sucks but flxbackdrop is weird wit shaders
		var ogCam = FlxG.camera;
		
		bgCam.bgColor.alpha = 0;
		shaderCam.bgColor.alpha = 0;
		ogCam.bgColor.alpha = 0;

        for(c in FlxG.cameras.list) FlxG.cameras.remove(c, false);

		FlxG.cameras.add(bgCam,false);
		FlxG.cameras.add(shaderCam,false);
		FlxG.cameras.add(ogCam,true);

		// IGNORE THIS!!!
		if(!initialized)
		{
			persistentUpdate = true;
			persistentDraw = true;
		}

		if (FlxG.save.data.weekCompleted != null)
		{
			StoryMenuState.weekCompleted = FlxG.save.data.weekCompleted;
		}

		FlxG.mouse.visible = false;
		startIntro();

	}

	var logoBl:FlxSprite;
	var ring:FlxSprite;
	var ringExplode:FlxSprite;
	var stars:FlxSprite;

	var titleText:FlxSprite;
	var bBar:FlxSprite;
	var tBar:FlxSprite;
	var white:FlxSprite;

	var logoScale:Float = 0.3;
	var allowedToBop:Bool = false;

	function startIntro()
	{
		if (!initialized)
		{
			if(FlxG.sound.music == null)  FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
		}

		Conductor.bpm = 122;
		persistentUpdate = true;

		var bg:FlxSprite = new FlxSprite().loadImage('menu/title/bg');
		bg.setGraphicSize(FlxG.width,FlxG.height);
		bg.updateHitbox();
		bg.cameras = [bgCam];
		add(bg);

		var crt = new CrtWarp();
		crt.warpAmount = 1.65;
		shaderCam.filters = [new ShaderFilter(crt)];

		var checkerBG = new FlxBackdrop(FlxGridOverlay.create(100, 100, 200, 200, FlxColor.RED, FlxColor.TRANSPARENT).graphic);
		checkerBG.velocity.set(50, 50);
		checkerBG.alpha = 0.1;
		checkerBG.cameras = [shaderCam]; // i fucking hate this setup
		add(checkerBG);

		white = new FlxSprite().makeGraphic(FlxG.width,FlxG.height);
		add(white);
		white.visible = false;

		ring = new FlxSprite().loadImage('menu/title/ring');

		ringExplode = new FlxSprite().loadImage('menu/title/ringexplode');

		logoBl = new FlxSprite().loadImage('menu/title/logotext');

		stars = new FlxSprite().loadImage('menu/title/stars');

		for (i in [ring,ringExplode,logoBl,stars]) {
			i.setScale(logoScale);
			i.screenCenter();
			add(i);
		}

		tBar = new FlxSprite().loadImage('menu/title/topb');
		tBar.graphicSize(FlxG.width);
		add(tBar);

		bBar = new FlxSprite().loadImage('menu/title/botb');
		bBar.graphicSize(FlxG.width);
		add(bBar);
		bBar.y = FlxG.height - bBar.height;
		tBar.antialiasing = bBar.antialiasing = true;

		titleText = new FlxSprite().loadFrames('menu/title/start');
		titleText.animation.addByPrefix('i','i',12);
		titleText.animation.play('i');
		titleText.setScale(0.75);
		add(titleText);
		titleText.screenCenter(X);
		titleText.y = FlxG.height - titleText.height - 150;

		playIntro();

		if (initialized) finishIntro();
		else initialized = true;

		Paths.clearUnusedMemory();
	}

	function playIntro() 
	{
		if (initialized) return;
		for (i in [stars,ringExplode,logoBl,titleText]) i.visible = false;

		white.visible = true;

		tBar.y = -tBar.height;
		bBar.y = FlxG.height;

		ring.scale.set(0,0);
		ring.angle = 360;
		ring.color = FlxColor.BLACK;

		FlxTween.tween(tBar, {y:0},1.25, {ease: FlxEase.cubeOut, startDelay: 0.5});
		FlxTween.tween(bBar, {y: FlxG.height - bBar.height},1.25, {ease: FlxEase.cubeOut, startDelay: 0.5, onComplete: Void -> {
			FlxTween.tween(ring, {'scale.x': logoScale, 'scale.y': logoScale, angle: 0},0.7, {ease: FlxEase.expoOut});
			FlxTween.tween(FlxG.cameras.list[FlxG.cameras.list.length-1], {zoom: 1.1},1, {ease: FlxEase.cubeIn, onComplete: Void -> {
				finishIntro();
			}});
		}});

	}

	function finishIntro() {

		skippedIntro = true;
		FlxTween.cancelTweensOf(this);
		for (i in FlxG.cameras.list) i.flash();


		allowedToBop = true;
		logoBl.color = FlxColor.WHITE;
		ring.color = FlxColor.WHITE;
		for (i in [logoBl,ringExplode,stars,titleText]) i.visible = true;
		ring.visible = false;
		white.visible = false;

		FlxTween.tween(FlxG.cameras.list[FlxG.cameras.list.length-1], {zoom: 1},0.3, {ease: FlxEase.circOut});

	}


	var transitioning:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

		var pressedEnter:Bool = FlxG.keys.justPressed.ENTER || controls.ACCEPT;

		#if mobile
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
			{
				pressedEnter = true;
			}
		}
		#end

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
		{
			if (gamepad.justPressed.START)
				pressedEnter = true;

			#if switch
			if (gamepad.justPressed.B)
				pressedEnter = true;
			#end
		}
		

		// EASTER EGG

		if (initialized && !transitioning && skippedIntro)
		{
			
			if(pressedEnter)
			{
				// FlxG.camera.flash(ClientPrefs.data.flashing ? FlxColor.WHITE : 0x4CFFFFFF, 1);
				white.color = 0xFFFD1648;
				white.alpha = 0.4;
				white.visible = true;
				FlxTween.tween(white,{alpha: 0},0.7, {ease: FlxEase.cubeOut});
			
				FlxG.sound.play(Paths.sound('bass'), 0.7);

				transitioning = true;


				new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					MusicBeatState.switchState(new MainMenuState());
					closedState = true;
				});
			}
		}

		if (initialized && pressedEnter && !skippedIntro)
		{
			finishIntro();
		}

		if (logoBl != null && allowedToBop) logoBl.scale.set(FlxMath.lerp(logoBl.scale.x,logoScale,elapsed * 3),FlxMath.lerp(logoBl.scale.y,logoScale,elapsed * 3));
		if (stars != null && allowedToBop) stars.scale.set(FlxMath.lerp(stars.scale.x,logoScale,elapsed * 3),FlxMath.lerp(stars.scale.y,logoScale,elapsed * 3));

		super.update(elapsed);
	}


	private var sickBeats:Int = 0; //Basically curBeat but won't be skipped if you hold the tab or resize the screen
	public static var closedState:Bool = false;
	var logoBop:Bool = false;
	override function beatHit()
	{
		super.beatHit();

		logoBop = !logoBop;
		if(logoBl != null && allowedToBop)  {
			if (logoBop) logoBl.scale.set(logoScale + 0.01,logoScale);
			else logoBl.scale.set(logoScale,logoScale + 0.01);
		}
		if (stars != null && logoBop) stars.scale.set(logoScale + 0.01,logoScale + 0.01);


		if(!closedState) {
			sickBeats++;
			switch (sickBeats)
			{
				case 1:
					FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
					FlxG.sound.music.fadeIn(4, 0, 0.7);
					//skipIntro();

				// case 17:
				// 	finishIntro();
			}
		}
	}


}
