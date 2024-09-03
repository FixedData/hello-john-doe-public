import objects.PsychVideoSprite;
import flixel.FlxSprite;


var video;
var crowd;

var fire;

var white;

function onCreate() {
    game.skipCountdown = true;

    var bg = new FlxSprite(-250, 0).loadGraphic(Paths.image('tree'));
    bg.scrollFactor.set(0.9,0.9);
    addBehindDad(bg);

    var floor = new FlxSprite(-600, 0).loadGraphic(Paths.image('floo'));
    addBehindDad(floor);

    video = new PsychVideoSprite();
    video.addCallback('onFormat',()->{
        video.setGraphicSize(FlxG.width);
        video.updateHitbox();
        insert(0,video);
        video.cameras = [camOther];
    });
    video.load(Paths.video('monster'),[PsychVideoSprite.muted]);
    PsychVideoSprite.cacheVid(Paths.video('monster'));


    crowd = new FlxSprite(0,1200);
    crowd.frames = Paths.getSparrowAtlas('bgs/fuck_you_guest');
    crowd.animation.addByPrefix('i','boo',24);
    crowd.animation.play('i');
    add(crowd);


    fire = new FlxSprite(0,300);
    fire.frames = Paths.getSparrowAtlas('menu/rolbox/sm/fire');
    fire.animation.addByPrefix('i','fire',24);
    fire.animation.play('i');
    fire.scale.set(3,2);
    add(fire);

    fire.alpha= 0;



}


function onCreatePost() {
    white = new FlxSprite().makeGraphic(1,1);
    white.setGraphicSize(FlxG.width,FlxG.height);
    white.updateHitbox();
    white.scrollFactor.set();
    
    addBehindDad(white);
    dad.color = FlxColor.BLACK;
    boyfriend.color = FlxColor.BLACK;
    camHUD.alpha = 0;


    camFollow.y -= 100;
    FlxG.camera.snapToTarget();
}


function onEvent(eventName,val1,val2,time) {
    switch (eventName) {
        case 'playawesomevid':
            video.play();
        case 'boo':
           if (crowd.y == 600) {
            FlxTween.tween(crowd, {y: 1200},2, {ease: FlxEase.bounceInOut});
           }
           else {
                FlxTween.tween(crowd, {y: 600},2, {ease: FlxEase.bounceInOut});
           }
            

        case 'fire':
            FlxTween.tween(fire, {alpha: Std.parseFloat(val1)},Std.parseFloat(val2));

        case '':
            if (val1 == 'p') {
                var time = 0.6;
                FlxTween.num(-255,0,time, {}, (f)->{
                    dad.setColorTransform(1,1,1,1,f,f,f);
                    boyfriend.setColorTransform(1,1,1,1,f,f,f);
                });
                FlxTween.tween(camHUD, {alpha: 1},time);
                FlxTween.tween(white, {alpha: 0},time);
            }

    }
}
