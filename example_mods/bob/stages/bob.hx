import flixel.addons.transition.FlxTransitionableState;
import flixel.FlxSprite;


var video;
var fire;

function onCreate() {
    game.skipCountdown = true;
    FlxG.camera.visible=false;
    camHUD.visible=false;

    video = new PsychVideoSprite();
    video.addCallback('onFormat',()->{

        video.setGraphicSize(FlxG.width);
        video.updateHitbox();
        insert(0,video);
        video.cameras = [camOther];
    });
    video.addCallback('onEnd',()->{
        FlxG.camera.visible=true;
        camHUD.visible=true;
    });

    video.load(Paths.video('intro'),[PsychVideoSprite.muted]);

    fire = new FlxSprite(200,300);
    fire.frames = Paths.getSparrowAtlas('menu/rolbox/sm/fire');
    fire.animation.addByPrefix('i','fire',24);
    fire.animation.play('i');
    fire.scale.set(2,2);
    add(fire);

    fire.alpha= 0;

    game.camZooming=true;

}


function onEvent(eventName,val1,val2,time) {
    switch (eventName) {
        case 'playawesomevid':
            video.play();

        case 'fire':
            FlxTween.tween(fire, {alpha: Std.parseFloat(val1)},Std.parseFloat(val2));
    }
}



function onCreatePost() {
    remove(dadGroup);
    insert(game.members.indexOf(boyfriendGroup) + 1, dadGroup);

}

function onSongStart() {
    for (i in game.playerStrums) i.x += 200;

    for (i in 0...game.opponentStrums.length){
        var note = game.opponentStrums.members[i];
        note.x = (game.dad.x + 125) + ((38.5 *i)) * (0.15/0.25);
        note.y = 425;
        note.alpha = 1;
        note.cameras = [FlxG.camera];
        note.scrollFactor.set(1,1);
        note.scale.set(0.15,0.15);
        note.useRGBShader = false;
        note.updateHitbox();
   }


}

function onSpawnNote(n) {
    if (!n.mustPress) {
        n.scale.x = 0.15;
        if (!n.isSustainNote) {
            n.scale.y = 0.15;
        }
        else {
            n.offsetX = 7;
            n.offsetY = -42;
        }

        n.updateHitbox();
        n.cameras = [FlxG.camera];
        n.scrollFactor.set(1,1);
    }
}

function onUpdatePost(elapsed) {
    game.isCameraOnForcedPos = true;
    game.camZooming = false;
}

function onSectionHit() {
    var zoom = 3;
    if (mustHitSection) {
        zoom = 1.5;
    }

    FlxG.camera.zoom = zoom;


    snapToChar(mustHitSection);

}


function snapToChar(must) {
    var x = 0;
    var y = 0;
    if (must) {
        for (i in 0...game.opponentStrums.length){
            var note = game.opponentStrums.members[i];
            note.x = (game.dad.x + 125) + ((38.5 *i)) * (0.15/0.25);
        }

        fire.visible = false;
        x = boyfriend.getMidpoint().x - 100;
        x -= boyfriend.cameraPosition[0] - game.boyfriendCameraOffset[0];

        y = boyfriend.getMidpoint().y - 100;
        y += boyfriend.cameraPosition[1] + game.boyfriendCameraOffset[1];


    }
    else {
        for (i in 0...game.opponentStrums.length){
            var note = game.opponentStrums.members[i];
            note.x = (game.dad.x + 50) + ((38.5 *i)) * (0.15/0.25);
        }

        fire.visible = true;
        x = dad.getMidpoint().x + 150;
        x += dad.cameraPosition[0] + game.opponentCameraOffset[0];

        y = dad.getMidpoint().y - 100;
        y += dad.cameraPosition[1] + game.opponentCameraOffset[1];
    }


    game.camFollow.setPosition(x,y);
    FlxG.camera.snapToTarget();
}
