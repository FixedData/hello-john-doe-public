

import backend.InputFormatter;
import openfl.display.BlendMode;
import backend.ClientPrefs;
import states.editors.ChartingState.AttachedFlxText;
import flixel.text.FlxText;
import flixel.math.FlxRect;
import flixel.math.FlxMath;
import psychlua.CustomSubstate;
import substates.PauseSubState;
import backend.MusicBeatState;
import states.PlayMenu;
import backend.Controls;
import flixel.FlxG;
import states.PlayState;

// forgot how doing gameovers work so im just gonna do it like this and port it later
var black:FlxSprite;
var dead:Bool = false;
var ok:FlxText;
var awesome:FlxText;
var again:FlxText;
var dieForever:FlxText;
var canSelect:Bool = false;
var options:Array<FlxText> = [];
var deadTxts:Array<FlxText> = ['you F###ing Suck', 'well you died', 'good job\nyou died', 'youre what we used to call. a noob ok.', 'guest wouldnt be proud of you', 'k.', 'well hey', 'uhhhh hello?'];
var curSelected:Int = 0;
var time = 1.267;

function onCreatePost()
{
    for (i in game.unspawnNotes) 
    {
        i.copyAlpha = false;
        i.noteSplashData.a = 1;
        if (i.isSustainNote) 
        {
            i.alpha = 1;
            i.multAlpha = 1;
        }
        for (p in game.playerStrums) 
        {

            i.antialiasing = p.antialiasing = false;
             i.rgbShader.enabled = i.noteSplashData.useRGBShader = p.useRGBShader = false;
            
        }
    }


    var notes = ['note_left','note_down','note_up','note_right'];
    for (i in 0...game.playerStrums.length) {

        game.playerStrums.members[i].x += 10;
        if (i > 0) {
            game.playerStrums.members[i].x += -4.7 * i;
        }
        game.playerStrums.members[i].alpha = 0.8;

       var note = game.playerStrums.members[i];


       var t = new AttachedFlxText(0,0,0,InputFormatter.keyFormatting(ClientPrefs.keyBinds.get(notes[i])[0]),20);
       t.sprTracker = note;
       t.copyAlpha = false;
       t.font = Paths.font('ARIAL.TTF');
       t.updateHitbox();
       t.yAdd = note.height - t.height + 5;
   
       insert(members.indexOf(note) + 1,t);
       t.cameras = [camHUD];
    }


    // var t = new AttachedFlxText(0,0,0,InputFormatter.getKeyName(ClientPrefs.keyBinds.get('note_left')[0]),20);
    // t.sprTracker = game.playerStrums.members[0];
    // t.font = Paths.font('ARIAL.TTF');
    // t.updateHitbox();
    // t.yAdd = game.playerStrums.members[0].height - t.height + 5;

    // add(t);
    // t.cameras = [camHUD];


}

function onGameOver() {
    if (PlayState.SONG.song != 'iloveyou') {
        CustomSubstate.openCustomSubstate('g', true);
    }
    return Function_Stop;
}

function onCustomSubstateCreate(name)
{
    if (name == 'g') {
    FlxG.sound.music.volume = 0;
    for (i in [game.camHUD, game.camOther, game.camGame]) {
        FlxTween.tween(i, {alpha: 0}, time-1, {ease: FlxEase.quadOut});
    }
    canSelect = true;

    black = new FlxSprite().makeGraphic(1280, 720);
    black.color = FlxColor.BLACK;
    black.alpha = 0;
    
    ok = new FlxText(0, 0, 0, 'GAME OVER', 80);
    ok.color = FlxColor.RED;
    ok.font = Paths.font('ARIAL.TTF');
    ok.screenCenter();
    ok.y += -10;
    ok.alpha = 0;
    add(ok);

    awesome = new FlxText(0, 0, 0, 'you F###ing Suck' , 30);
    awesome.color = FlxColor.WHITE;
    awesome.text = deadTxts[FlxG.random.int(0,deadTxts.length-1)];   //FlxG.random.getObject probably doesnt wanna work cuz im either stupid or it doesnt feel like it
    awesome.font = Paths.font('ARIAL.TTF');
    awesome.screenCenter();
    awesome.y += 30;
    awesome.alpha = 0;
    add(awesome);

    again = new FlxText(0, 0, 0, 'again', 40);
    again.color = FlxColor.WHITE;
    again.screenCenter();
    again.font = Paths.font('ARIAL.TTF');
    again.y += 180;
    again.x -= 100;
    again.alpha = 0;
    options.push(again);
    add(again);

    dieForever = new FlxText(0, 0, 0, 'die forever', 40);
    dieForever.color = FlxColor.WHITE;
    dieForever.screenCenter();
    dieForever.font = Paths.font('ARIAL.TTF');
    dieForever.y += 180;
    dieForever.x += 120;    
    dieForever.alpha = 0;
    options.push(dieForever);
    add(dieForever);

    FlxTween.tween(black, {alpha: 1}, time, {ease: FlxEase.quadOut, onComplete: function(twn:FlxTween)
    {
        FlxG.sound.playMusic(Paths.music('gameOver'), 6);
    }});

    for (i in [black, ok, awesome, again, dieForever]) {
        i.cameras = [game.camGoodBye];
    }

    FlxTween.tween(ok, {alpha: 1},time, {ease: FlxEase.sineOut,startDelay: 2, onComplete: function(twn:FlxTween)
    {
        FlxTween.tween(ok, {y: 120}, time, {ease: FlxEase.quadOut});
        FlxTween.tween(awesome, {y: 200}, time, {ease: FlxEase.quadOut});
        FlxTween.tween(awesome, {alpha: 1}, time+0.2, {ease: FlxEase.quadOut, onComplete: function(twn:FlxTween)
        {
            new FlxTimer().start(time-0.2,Void->{
                for (i in [again, dieForever]) {
                    FlxTween.tween(i, {alpha: 1}, time, {ease: FlxEase.quadOut, onComplete: function(twn:FlxTween)
                    {
                        canSelect = true;
                    }});
                }
            });
        }});
    }});

    changeSelection(0);
}
}

function onCustomSubstateUpdatePost(name, elapsed) {
    if (name == 'g') {
        if (canSelect) {
            if (controls.UI_RIGHT_P) {
                changeSelection(1);
            }

            if (controls.UI_LEFT_P) {
                changeSelection(-1);
            }

            if (controls.ACCEPT) {
                FlxTween.tween(FlxG.sound.music, {pitch: 0}, 1.8, {ease: FlxEase.quadOut});
                for (i in [black, ok, awesome, again, dieForever]) {
                    new FlxTimer().start(0.4, (tmr:FlxTimer) -> {
                        FlxTween.tween(i, {alpha: 0}, time-0.8, {ease: FlxEase.quadOut});
                    });
                }
                canSelect = false;
                switch(curSelected) {
                    case 0:
                        FlxG.sound.play(Paths.sound('confirm'), 0.2);
                        new FlxTimer().start(2, (tmr:FlxTimer) -> {
                            PauseSubState.restartSong();
                        });
                    case 1:
                        exitToMenu();
                }
            }
        }
    }
}

function changeSelection(num) {
    curSelected = FlxMath.wrap(curSelected+num, 0, 1);
    for(i in 0...options.length) {
        if (i == curSelected)
            options[i].color = FlxColor.YELLOW;
        else
            options[i].color = FlxColor.WHITE;
    }
}

function exitToMenu() {
    FlxG.sound.play(Paths.sound('quit'), 0.5);
    new FlxTimer().start(2, (tmr:FlxTimer) -> {
        MusicBeatState.switchState(new states.PlayMenu());
    });
}
