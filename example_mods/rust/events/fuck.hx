import objects.PsychVideoSprite;
import flixel.FlxSprite;
import openfl.Lib;


var video;

function onCreate() {

    video = new PsychVideoSprite();
    video.addCallback('onFormat',()->{
        video.setGraphicSize(FlxG.width);
        video.updateHitbox();
        insert(0,video);
        video.cameras = [camOther];
    });
    video.addCallback('onEnd',()->{
        Lib.application.window.borderless = false;
    });
    video.load(Paths.video('poop'),[PsychVideoSprite.muted]);
    PsychVideoSprite.cacheVid(Paths.video('poop'));
}

function onEvent(eventName,val1,val2,time) {
    switch (eventName) {
        case 'fuck':
            video.play();
            Lib.application.window.borderless = true;
        
    }
}
