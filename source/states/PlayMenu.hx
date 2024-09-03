package states;

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

//this a mess

class PlayMenu extends MusicBeatSubstate
{
	public static final hiddenTexts = ['nuhh uh', 'licky lee', 'well this is a little secret haha', 'i just lost my dawggg', 'dingalingaling', 'rofl copter', 'loltastic!', 'food more food!','okwell i cant fucking do thius anymore what the fuck is wrong with this god damn fucking mod adn funky is being a fuckingf annoying little bitch in vc asnd crying about every little god damned thing', 'dinalingaling', 'tophat guy', 'gf with a big butt', 'well... i think fnf gf is bad', 'ok well u have to beat the other sons', 'locked haha', 'penis', 'chubby heros', 'funktastic 2', 'slenderman', 'funny minion gif', 'goofy ahh mod who gets it', '???', 'ego monster', 'dingaling2', 'john doe', 'wanna see my powers', 'follow infry', 'DINGALING DEMON', 'hotbox central', 'wello k', 'ur never gonna fucking see me again after this please know i love you ok?', 'hawk tuah'];

	public static final loadingTexts = ['loadingg;', 'lo adoin', 'load     ?', 'loaing', 'give me a moment', 'ok wait', 'hi', 'okay', 'uhhhh hello?', 'its like watching paint dry', 'k', 'well hey', 'viva la twitter'];
	public static final completeTexts = ['cmm plete', 'd one' , 'goe goe', 'goodbye', 'complete', 'have fun', 'thanks data', 'woah ohoh', 'lets get funkin!', 'bye', 'tophat guy', 'lets play'];


	//hardcoded weekdata //could of actually been the meta instead of anon but whatever
	static final weekShit:Array<{modDir:String,song:String,lockReqs:Array<String>}> = [
		//main songs
		{modDir: 'johndoe', song: 'johndoe',lockReqs: []},
		{modDir: 'devilish', song: 'devilish',lockReqs: []},
		{modDir: '1x', song: '1',lockReqs: []},
		{modDir: 'bloxwatch', song: 'bloxwatch',lockReqs: []},

		//final
		{modDir: 'rust', song: 'joy',lockReqs: ['johndoe','devilish','1','bloxwatch']},

		//bonus
		{modDir: 'cheeky', song: 'rockhard',lockReqs: ['joy']},
		{modDir: 'noli', song: 'noli',lockReqs: ['joy']},
		{modDir: 'bloxpin', song: 'bloxpin',lockReqs: ['joy']},
		{modDir: 'bloxpin', song: 'bloxpin-scary',lockReqs: ['joy']},
		{modDir: 'bloody', song: 'bloody-mary',lockReqs: ['joy']},

		//dumb bonus
		{modDir: 'bob', song: 'strawberry',lockReqs: ['rockhard','noli','bloxpin','bloody-mary']},
		{modDir: 'p', song: 'obby-for-succ',lockReqs: ['rockhard','noli','bloxpin','bloody-mary']},
		{modDir: 'ahh', song: 'party-time',lockReqs: ['rockhard','noli','bloxpin','bloody-mary']},
		{modDir: 'oobj', song: 'iloveyou',lockReqs: ['rockhard','noli','bloxpin','bloody-mary']}
	];
	
	public static var finishCallback:Void->Void = null;

	static var previousSong:String = '';

	//bg assets
	var elevator:FlxSprite;
	var door:FlxSprite;
	var bar:FlxSprite;
	var cButton:FlxSprite;
	var overlay:FlxSprite;
	var monitor:FlxSprite;

	var lock:FlxSprite;

	var fcStar:FlxSprite;

	var score:FlxText;
	var ssong:FlxText;
	var k:FlxText;
	var songName:FlxText;
	var songArrowL:FlxSprite;
	var songArrowR:FlxSprite;
	var enterSongButton:FlxSprite;

	//logic
	var curMenuSong:String = '';
	var menuState:PlayMenuState;
	var songs:Array<RobloxMeta> = [];
	static var curSelected:Int = 0;
	public function new(?state:PlayMenuState) {
		super();
		menuState = state ?? MENU;
	}

	override function startOutro(onOutroComplete:() -> Void) {
		if (FlxG.sound.music.onComplete != null) FlxG.sound.music.onComplete = null;
		super.startOutro(onOutroComplete);
	}



	//to help minimize spikes but also i think assets get music does cache on its own so the value might not be there but whatever
	var songCache:Map<String,openfl.media.Sound> = [];
	function playMusic(path:String) {
		var sound:openfl.media.Sound = null;

		if (songCache.exists(path)) 
			sound = songCache.get(path);
		else {
			final formattedDir = 'assets/shared/music/' + path + '.ogg';
			if (openfl.Assets.exists(formattedDir)) {
				var s = openfl.Assets.getMusic(formattedDir);
				songCache.set(path,s);
				sound = s;
			}
		}

		if (sound != null) {
			FlxG.sound.playMusic(sound,1,false);
			FlxG.sound.music.play(true);
			FlxG.sound.music.onComplete = ()->{
				curMenuSong = getSong();
				new FlxTimer().start(0.1,Void->{
					playMusic(curMenuSong);
				});

				updateK();
			}
		}


	}




	function getSong(){
		var path = 'free';
		var files:Array<String> = FileSystem.readDirectory('assets/shared/music/free');

		if (ClientPrefs.data.copyrightMusic) {
			path = 'copyright';
			files = FileSystem.readDirectory('assets/shared/music/copyright');
		}

		var song = FlxG.random.getObject(files);
		trace(song);
		trace(path + '/' + song.substr(0,song.length-4));

		//prevents the same
		while (song == previousSong) song = FlxG.random.getObject(files);
		previousSong = song;

		return path + '/' + song.substr(0,song.length-4);
	}


	function generateList() {

		// WeekData.reloadWeekFiles(false);

		for (i in 0...weekShit.length) {
			var data:RobloxMeta = {
				songName: weekShit[i].song,
				week: i,
				modFolder: weekShit[i].modDir,
				lockReqs: weekShit[i].lockReqs
				
			}

			songs.push(data);
		}
		//Mods.loadTopMod();
	}

	var isStreamer = false;
	function checkIfStreamer() {
		if (FlxG.save.data.hasToggledStreamer == null && InitState.isStreamer()) return true;
		return false;
	}



	function buildBG() {
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

		songArrowL = new FlxSprite(elevator.x + 615, elevator.y + 250).loadFrames('menu/rolbox/song/diffbutton');
		songArrowL.addAnimByPrefix('i','bidle');
		songArrowL.addAnimByPrefix('s','bpress');
		songArrowL.playAnimation('i');
		songArrowL.flipY = true;
		add(songArrowL);


		songArrowR = new FlxSprite(elevator.x + 615, elevator.y + 220).loadFrames('menu/rolbox/song/diffbutton');
		songArrowR.addAnimByPrefix('i','bidle');
		songArrowR.addAnimByPrefix('s','bpress');
		songArrowR.playAnimation('i');
		add(songArrowR);


		enterSongButton = new FlxSprite(elevator.x + 280, elevator.y + 220).loadFrames('menu/rolbox/song/play');
		enterSongButton.addAnimByPrefix('i','pidle');
		enterSongButton.addAnimByPrefix('s','ppress');
		enterSongButton.playAnimation('i');
		add(enterSongButton);


		monitor = new FlxSprite().loadFrames('menu/rolbox/song/tv');
		monitor.addAndPlay('static','static',24,false);
		monitor.addAnimByPrefix('staticlooped','static',24,true);
		monitor.addAnimByPrefix('tv','tv',24,false);
		monitor.animation.finishCallback = (s:String)->{if (s == 'static') {monitor.playAnimation('tv');}}
		add(monitor);
		monitor.scale.set(0.95, 0.95);
		monitor.x = elevator.x + 150 * elevator.scale.x;
		monitor.y = elevator.y;

		songName = createTxt(18);
		songName.text = FlxG.random.getObject(loadingTexts);
		songName.fieldWidth = FlxG.width;
		songName.alignment = CENTER;
		songName.y = elevator.y + 112;
		add(songName);

		score = createTxt(20);
		score.text = 'penisSocre';
		add(score);
		score.centerOnSprite(monitor);
		score.y += 30;

		overlay = new FlxSprite().loadImage('menu/rolbox/song/grad');
		add(overlay);
		overlay.screenCenter();

		bar = new FlxSprite().makeGraphic(1300, 141, FlxColor.BLACK);
		bar.screenCenter();
        bar.setGraphicSize(400);
		bar.y = 80;
		bar.alpha = 0.6;
		add(bar);

		ssong = new FlxText(0,0,0,'now playing:',14);
		ssong.font = Paths.font('ARIAL.TTF');
		ssong.color = FlxColor.LIME;
		add(ssong);
		ssong.centerOnSprite(bar);
		ssong.y += -13;

		k = new FlxText(0,0,0,' ',16);
		k.font = Paths.font('ARIAL.TTF');
		add(k);
		updateK();

		cButton = new FlxSprite().loadFrames('menu/rolbox/song/copyrightbutton');
		cButton.addAnimByPrefix('copyright','c',24,false);
		cButton.addAnimByPrefix('nocopyright','nc',24,false);
		cButton.centerOnSprite(bar);
		cButton.scale.set(0.75, 0.75);
		cButton.x += 170;
		add(cButton);
		updatecButton();


		fcStar = new FlxSprite(elevator.x + 613,elevator.y + 186).loadFrames('menu/rolbox/song/i_just_lost_my_dawggg');
		fcStar.addAnimByPrefix('none','outline',24);
		fcStar.addAnimByPrefix('complete','bronze',24);
		fcStar.addAnimByPrefix('fc','silver',24);
		fcStar.addAnimByPrefix('pfc','golden',24);
		fcStar.setGraphicSize(30);
		fcStar.updateHitbox();
		fcStar.playAnimation('none');
		add(fcStar);
		fcStar.visible = false;



		lock = new FlxSprite().loadImage('menu/rolbox/song/360');
		lock.scale.set(0.5,0.5);
		lock.updateHitbox();
		lock.centerOnSprite(door);
		add(lock);

		lock.visible = false;


	}

	//handlle the shit in here
	function setupMouseLogic() {

		FlxMouseEvent.add(songArrowL,(o)->{
			o.animation.play('s');
			changeItem(1,true);
		},(o)->o.animation.play('i'),(o)->o.scale.set(1.1,1.1),(o)->o.scale.set(1,1),false,true,false);


		FlxMouseEvent.add(songArrowR,(o)->{
			o.animation.play('s');
			changeItem(-1,true);
		},(o)->o.animation.play('i'),(o)->o.scale.set(1.1,1.1),(o)->o.scale.set(1,1),false,true,false);


		FlxMouseEvent.add(enterSongButton,(o)->{
			o.animation.play('s');
			loadSong();
			//wip
		},(o)->o.animation.play('i'),(o)->o.scale.set(1.1,1.1),(o)->o.scale.set(1,1),false,true,false);
		
		FlxMouseEvent.add(cButton,(o)->{
			updateCopyrightSave();
		},null,(o)->o.scale.set(0.8,0.8),(o)->o.scale.set(0.75,0.75));
	}


	override function create()
	{
		cameras = [CrossUtil.quickCreateCam()];
		//menuState = IN;

		camera.zoom = 1.5;
		persistentUpdate = persistentDraw = true;
		FlxG.mouse.visible = true;

		//dont do it if its a transtion
		isStreamer = menuState == MENU && checkIfStreamer();

		if (menuState == MENU) {
			FlxG.sound.music.stop();
			curMenuSong = getSong();
			playMusic(curMenuSong);
			if (isStreamer) FlxG.sound.music.volume = 0;

			generateList();

			Difficulty.resetList();
		}

		buildBG();


		if (menuState == MENU) {
			setupMouseLogic();

			changeItem();
		}


		if (menuState == IN) transIn();
		if (menuState == OUT) transOut();

		if (isStreamer) {
			var promptCam = CrossUtil.quickCreateCam();
			promptCam.zoom = 1.25;
			@:privateAccess 
			FlxG.camera._fxFadeColor = FlxColor.BLACK;
			FlxTween.tween(FlxG.camera, {_fxFadeAlpha: 0.5},0.7);

			selectedSomethin = true;
			var promtp = new StreamPrompt(this);
			add(promtp);
			promtp.cameras =[promptCam];

			promtp.scrollFactor.set();
			promtp.screenCenter();
			promtp.x -= 106/2.5;
		}


		super.create();
	}

	function transIn() {
		killControls();
		monitor.playAnimation('staticlooped');
		score.visible = false;
		songName.text = FlxG.random.getObject(completeTexts);
		door.playAnimation('closed');
		door.animation.play('transition');
		door.animation.finishCallback = (s)->{
			if (s == 'transition') {
				FlxTween.tween(camera, {zoom: 5},0.6,{onComplete: Void->{
					finish();
				}});
			}
		} 
	}

	function transOut() {
		killControls();
		monitor.playAnimation('staticlooped');
		score.visible = false;
		door.playAnimation('open');
		camera.zoom = 4;
		FlxTween.tween(camera, {zoom: 1.5},0.6,{onComplete: Void->{
			door.animation.play('transition',true,true); 
		}});

		door.animation.finishCallback = (s)->{
			if (s == 'transition') {
				finish();
			}
		} 
	}

	function killControls() {
		FlxMouseEvent.removeAll();
		selectedSomethin = true;
	}

	function finish() {
		close();
		if(finishCallback != null) finishCallback();
		finishCallback = null;
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.FOUR) FlxG.resetState();
		if (!selectedSomethin && menuState == MENU)
		{
			if (controls.UI_LEFT_P || controls.UI_RIGHT_P || controls.UI_DOWN_P || controls.UI_UP_P) changeItem((controls.UI_LEFT_P || controls.UI_DOWN_P) ? -1 : 1);

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				FlxTransitionableState.skipNextTransIn = FlxTransitionableState.skipNextTransOut = true;
				MusicBeatState.switchState(new MainMenuState());
				FlxG.mouse.visible = false;
			}

			if (controls.ACCEPT)
			{

				loadSong();

				// door.animation.finishCallback = (penis:String)->{
				// 	if (penis == 'transition') {
				// 		loadSong()
				// 		// door.playAnimation('open');
				// 		// FlxG.sound.play(Paths.sound('walking'));
				// 		// FlxTween.tween(camera, {zoom: 12},(3.2), {ease: FlxEase.quadIn});
				// 		// FlxTween.tween(overlay, {alpha: 0}, 2.6, {ease: FlxEase.linear});
				// 	}
				// }
			}
		}

		super.update(elapsed);
	}



	function loadSong() {
		if (selectedSomethin) return;

		#if !debug
		if (lock.visible) {
			camera.shake(0.01,0.1);
			FlxG.sound.play(Paths.sound('lockSound'));

			return;
		}
		#end


		trace('im dying');
		songName.text = FlxG.random.getObject(loadingTexts);
		selectedSomethin = true;
		var sound = FlxG.sound.play(Paths.sound('letsgo'));
		sound.persist = true;
		sound.autoDestroy = true;

		door.animation.play('transition');
		FlxG.sound.music.stop();

		FlxTransitionableState.skipNextTransIn = true;
		persistentUpdate = false;

		var songLowercase:String = Paths.formatToSongPath(songs[curSelected].songName);
		var poop:String = Highscore.formatSong(songLowercase, 1);
		trace(poop);

		try
		{
			PlayState.SONG = Song.loadFromJson(poop, songLowercase);
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = 1;

			trace('CURRENT WEEK: ' + WeekData.getWeekFileName());
		}
		catch(e:Dynamic)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			selectedSomethin = false;
			update(FlxG.elapsed);
			return;
		}
		killControls();
		LoadingState.loadAndSwitchState(new PlayState());
				
		#if (MODS_ALLOWED && DISCORD_ALLOWED)
		DiscordClient.loadModRPC();
		#end
	}

	function changeItem(huh:Int = 0,mouse:Bool = false)
	{
		if (huh != 0)
			FlxG.sound.play(Paths.sound('click'));

		if (!mouse && huh != 0) {
			var obj = huh == 1 ? songArrowR : songArrowL;
			obj.animation.play('s');
			new FlxTimer().start(0.1,Void->{
				obj.animation.play('i');
			});
		}



		curSelected = FlxMath.wrap(curSelected + huh,0,songs.length-1);

		monitor.animation.play('static',true);
		score.text = 'score ' + Std.string(Highscore.getSongData(songs[curSelected].songName, 1).songScore);
		Mods.currentModDirectory = songs[curSelected].modFolder;

		trace('is "${songs[curSelected].songName}" Locked? ' + songs[curSelected].isLocked + ' and what are the requirements? ' + songs[curSelected].lockReqs);

		var isLocked = songs[curSelected].isLocked;
		

		songName.text = #if !debug isLocked ? FlxG.random.getObject(hiddenTexts) : #end songs[curSelected].songName;

		lock.visible = isLocked;

		updateStar();

	}
	function updateStar() {
		var data = Highscore.getSongData(songs[curSelected].songName, 1);
		fcStar.visible = !lock.visible;
		if (data.songScore > 0) {
			switch (data.songFC) {
				case SDCB: fcStar.animation.play('complete',true,false,fcStar.animation.curAnim.curFrame);
				case FC: fcStar.animation.play('fc',true,false,fcStar.animation.curAnim.curFrame);	
				case PFC: fcStar.animation.play('pfc',true,false,fcStar.animation.curAnim.curFrame);
			}
		}
		else {
			fcStar.animation.play('none',true,false,fcStar.animation.curAnim.curFrame);
		}
	

	}

	function updateCopyrightSave() {
		FlxG.sound.play(Paths.sound('click'));
		var prev = ClientPrefs.data.copyrightMusic;
		ClientPrefs.data.copyrightMusic = !ClientPrefs.data.copyrightMusic;
		ClientPrefs.saveSettings();

		if (!ClientPrefs.data.copyrightMusic && prev) {

			curMenuSong = getSong();
			playMusic(curMenuSong);
			updateK();
		}
		updatecButton();
	}	

	function updateK() {
		k.text = curMenuSong.substr(curMenuSong.lastIndexOf('/') + 1);
		k.centerOnSprite(bar);
		k.y += 6;
	}
	function updatecButton() {
		cButton.animation.play(ClientPrefs.data.copyrightMusic ? 'copyright' : 'nocopyright');
		cButton.offset.x = ClientPrefs.data.copyrightMusic ? 0 : 2.5;
	}

	function createTxt(size:Int):FlxText
	{
		var txt = new FlxText(0,0,0,'',20);
		txt.font = Paths.font('ARIAL.TTF');
		var retro = FlxG.random.int(1,2);
		txt.size = Std.int(txt.size/retro);
		txt.setScale(retro);
		return txt;
	}


}


@:structInit class RobloxMeta {
	public var songName:String = '';
	public var week:Int = 0;
	public var modFolder:String = null;

	public var lockReqs:Array<String> = [];

	public var isLocked(get,never):Bool;
	function get_isLocked() {
		if (lockReqs.length == 0) return false;

		var bools:Array<Bool> = [];
		for (i in lockReqs) {
			if (Highscore.getSongData(i,1).songScore > 0) bools.push(true);
			else bools.push(false);
		}
		return (bools.contains(false));

	}
}

enum abstract PlayMenuState(Int) from Int to Int {
	var IN = 1;
	var OUT = 2;
	var MENU = 0;
}


//this sucks but im lazy
@:access(states.PlayMenu)
class StreamPrompt extends FlxTypedSpriteGroup<FlxSprite> {

	var parent:PlayMenu;

	var qna:FlxSprite;
	var questionButton:FlxSprite;
	var xButton:FlxSprite;
	

	var yes:FlxSprite;
	var no:FlxSprite;
	public function new(parent) {
		this.parent = parent;
		super();

		final p = 'menu/rolbox/obs/';

		qna = new FlxSprite().loadGraphic(Paths.image(p + 'QNA'));
		add(qna);
		qna.visible = false;

		var prompt = new FlxSprite().loadGraphic(Paths.image(p + 'prompt'));
		add(prompt);
		prompt.x = qna.width;

		xButton = new FlxSprite(0,5).loadGraphic(Paths.image(p + 'xbutton'));
		add(xButton);
		xButton.x = prompt.x + prompt.width - xButton.width - 5;
		FlxMouseEvent.add(xButton,(s)->{
			FlxG.sound.play(Paths.sound('click'));
			destroy();
		},null,null,null,false,true,false);

		questionButton = new FlxSprite(0,5).loadGraphic(Paths.image(p + 'questionbutton'));
		add(questionButton);
		questionButton.x = prompt.x;
		FlxMouseEvent.add(questionButton,(h)->{
			qna.visible = !qna.visible;
			FlxG.sound.play(Paths.sound('click'));
		},null,null,null,false,true,false);

		yes = new FlxSprite(prompt.x + 15,169).loadGraphic(Paths.image(p + 'yes'));
		add(yes);
		FlxMouseEvent.add(yes,updateCopyrioght);

		no = new FlxSprite(0,169).loadGraphic(Paths.image(p + 'no'));
		add(no);
		no.x = prompt.x + prompt.width - no.width - 15;
		FlxMouseEvent.add(no,updateCopyrioght);

	}


	override function destroy() {
		FlxMouseEvent.remove(questionButton);
		FlxMouseEvent.remove(xButton);
		FlxMouseEvent.remove(no);
		FlxMouseEvent.remove(yes);
		@:privateAccess FlxG.camera._fxFadeAlpha = 0;

		parent.selectedSomethin = false;
		super.destroy();
	}


	function updateCopyrioght(objkec:FlxSprite) {
		FlxG.sound.play(Paths.sound('click'));
		FlxG.save.data.hasToggledStreamer = true;

		var prevCopyright = ClientPrefs.data.copyrightMusic;
		//trace('prev' + ' ' + prevCopyright);
		
		var copyRight:Bool = (objkec != yes);
		ClientPrefs.data.copyrightMusic = copyRight;
		ClientPrefs.saveSettings();

		parent.updatecButton();

		if (prevCopyright != copyRight) {
			// trace('doesntMacthc load a new song');
			var newSong = parent.getSong();
			parent.playMusic(newSong);
			parent.k.text = newSong.substr(newSong.lastIndexOf('/') + 1);
			parent.k.centerOnSprite(parent.bar);
			parent.k.y += 6;
		}
		else {
			FlxG.sound.music.volume = 1;
		}


		destroy();




	}
}
