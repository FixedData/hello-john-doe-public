import objects.PsychVideoSprite;
import flixel.FlxSprite;


var video;

function onCreate() {
    game.skipCountdown = true;

   
    video = new PsychVideoSprite();
    video.addCallback('onFormat',()->{
        video.setGraphicSize(FlxG.width);
        video.updateHitbox();
        insert(0,video);
        video.cameras = [camHUD];
    });
    video.load(Paths.video('video'),[PsychVideoSprite.muted]);
    PsychVideoSprite.cacheVid(Paths.video('video'));





}

function onCreatePost() {
    game.boyfriend.visible = false;
    game.dad.visible = false;
}


function onEvent(eventName,val1,val2,time) {
    switch (eventName) {
        case 'playawesomevid':
            video.play();
        case 'boo':
            game.camGame.visible = false;

    }
}
