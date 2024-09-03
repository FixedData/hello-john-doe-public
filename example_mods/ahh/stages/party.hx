import objects.PsychVideoSprite;
import flixel.FlxSprite;
import openfl.Lib;


var video;
var error;

function onCreate() {
    game.skipCountdown = true;
    for (i in [game.camHUD, game.camGame]) i.visible = false;

    error = new FlxSprite().loadGraphic(Paths.image('error'));
    error.cameras = [camOther];
    //error.scrollFactor.set();
    error.alpha = 0;
    error.screenCenter();
    error.scale.set(0.6,0.6);
    error.antialiasing = ClientPrefs.data.antialiasing;
    add(error);
   
    video = new PsychVideoSprite();
    video.addCallback('onFormat',()->{
        video.setGraphicSize(FlxG.width);
        video.updateHitbox();
        insert(0,video);
        video.cameras = [camOther];
    });
    video.addCallback('onEnd',()->{
        Lib.application.window.borderless = true;
    });
    video.load(Paths.video('video'),[PsychVideoSprite.muted]);
    PsychVideoSprite.cacheVid(Paths.video('video'));
}


function onEvent(eventName,val1,val2,time) {
    switch (eventName) {
        case 'playawesomevid':
            video.play();
        case 'boo':
            game.camGame.visible = false;

    }
}

function onEndSong() {
    new FlxTimer().start(3, (tmr:FlxTimer) -> { //arguhufha 
        FlxTween.tween(error,{alpha: 1},0.3,{ease:FlxEase.expoOut, onComplete: Void ->{
            new FlxTimer().start(3, (tmr:FlxTimer) -> {
                Sys.exit(1);
            });
        }});
    });
    return Function_Stop;
}
