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
        video.cameras = [camHUD];
    });
    video.addCallback('onEnd',()->{
    });
    video.load(Paths.video('intro'),[PsychVideoSprite.muted]);
    PsychVideoSprite.cacheVid(Paths.video('intro'));
}

function onEvent(eventName,val1,val2,time) {
    switch (eventName) {
        case 'intro':
            video.play();
        
    }
}