

import backend.Controls;
import flixel.effects.FlxFlicker;
import objects.Character;
import backend.Conductor;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

var isEvil = false;

var bg:FlxSprite;


//fire shit
var fire;
var fireTimer;
var fireSound;
var fireShader;
var fireTween;

//fling
var baseX = 0;
var baseY = 0;

//smite
var beam;

//explosion
var explosion;


var bighead;
var smallhead;

var currentHead = null;

var flickerBF;
var flickerSmall;
var flickerBig;
var flickerTimer;





var banTime = 0;
var banPopup;
var eventPopup;
var sounds = [];


var randomEVInterval = 15;


var isDisco = false;
var prevColor = -1;
var discoColors = [FlxColor.LIME,FlxColor.MAGENTA,FlxColor.RED,FlxColor.BLUE];



function onCreate() {
    game.skipCountdown = true;
}

function onCreatePost() {

    var scary = (game.dad.curCharacter.indexOf('evil') != -1 ? 'evilteddybg' : 'teddybg');
    var bg = new FlxSprite(-250, 0).loadGraphic(Paths.image(scary));
    bg.scrollFactor.set(1,1);
    addBehindDad(bg);

    isEvil = (scary == 'evilteddybg');

    if (isEvil) game.playbackRate = 0.8;


    if (!isEvil) {

        //game.addCharacterToList('burnt',0);

        eventPopup = new FlxSprite();
        eventPopup.frames = Paths.getSparrowAtlas('textbox');
        eventPopup.animation.addByPrefix('bighead','bighead',24,false);
        eventPopup.animation.addByPrefix('explode','explode',24,false);
        eventPopup.animation.addByPrefix('fire','fire',24,false);
        eventPopup.animation.addByPrefix('fling','fling',24,false);
        eventPopup.animation.addByPrefix('smallhead','smallhead',24,false);
        eventPopup.animation.addByPrefix('smite','smite',24,false);
        // eventPopup.animation.addByPrefix('trip','trip',24,false);
        // eventPopup.animation.addByPrefix('visible','visible',24,false);
        eventPopup.animation.addByPrefix('ban','ban',24,false);
        eventPopup.alpha = 0;
        add(eventPopup);



        boyfriend.color = FlxColor.WHITE;

        fireShader = makeShader('burnt');
        fireShader.setFloat('ratio',0.0);
        boyfriend.shader = fireShader;

        fire = new FlxSprite();
        fire.frames = Paths.getSparrowAtlas('fire');
        addBehindBF(fire);
        fire.animation.addByPrefix('start','start',7,false);
        fire.animation.addByIndices('end','start',[7,6,5,4,3,2,1,0],'',7,false);
        fire.animation.addByPrefix('loop','fire',48);
        fire.visible = false;
        fire.animation.finishCallback = (f)->{
            switch (f) {
                case 'start':
  
                    fire.animation.play('loop');
    
                    fireTimer = new FlxTimer().start(1,Void->{
                        if (game.health > 0.2) game.health-= 0.1;
                        if (fireTimer.loopsLeft == 0 || game.health <= 0.2 ) {
                            endFire();
                        }
    
                    },10);
                case 'end':
                    fire.visible = false;
            }
        }


        beam = new FlxSprite();
        beam.frames = Paths.getSparrowAtlas('beam');
        beam.animation.addByPrefix('i','beam instance 1',17,false);
        beam.animation.finishCallback = (s)->{
            beam.visible = false;
        }
        beam.visible = false;
        add(beam);

        baseX = boyfriend.x;
        baseY = boyfriend.y;



        explosion = new FlxSprite();
        explosion.frames = Paths.getSparrowAtlas('explosion');
        explosion.animation.addByPrefix('explosion','explosion',30,false);
        explosion.animation.finishCallback = (s)->{explosion.visible = false;}
        explosion.visible = false;
        explosion.scale.set(2,2);
        explosion.updateHitbox();
        add(explosion);



        bighead = new Character(0,0,'rbf-bighead',true);
        add(bighead);
        bighead.shader = boyfriend.shader;
        bighead.visible = false;

        smallhead = new Character(0,0,'rbf-smallhead',true);
        add(smallhead);
        smallhead.shader = boyfriend.shader;
        smallhead.visible = false;

        banPopup = new FlxSprite().loadGraphic(Paths.image('banned'));
        add(banPopup);
        banPopup.cameras = [camOther];
        banPopup.screenCenter();
        banPopup.visible = false;






    }



}

function onUpdatePost(elapsed) {

    if (!isEvil) {
        fire.x = boyfriend.x + (boyfriend.width - fire.width)/2 - 10;
        fire.y = boyfriend.y + boyfriend.height - fire.height - 50;
        fire.angle = boyfriend.angle;


        beam.x = boyfriend.x + (boyfriend.width - beam.width)/2;
        beam.y = boyfriend.y + boyfriend.height - beam.height + 10;
        beam.angle = boyfriend.angle;

        //fuck
        eventPopup.x = dad.x + ((eventPopup.width - dad.width)/2) + 50;
        eventPopup.y = dad.y - eventPopup.height + 175;



        bighead.x = boyfriend.x;
        bighead.y = boyfriend.y;
        bighead.angle = boyfriend.angle;

        smallhead.x = boyfriend.x;
        smallhead.y = boyfriend.y;
        smallhead.angle = boyfriend.angle;

        if (boyfriend.animation.curAnim != null) {
            if (bighead.visible) {
                bighead.playAnim(boyfriend.getAnimationName());
                bighead.animation.curAnim.curFrame = boyfriend.animation.curAnim.curFrame;
            }
            if (smallhead.visible) {
                smallhead.playAnim(boyfriend.getAnimationName());
                smallhead.animation.curAnim.curFrame = boyfriend.animation.curAnim.curFrame; 
            }
        }


        updateFireOffsets();

        if (banPopup.visible) {
            game.setSongTime(banTime);
            if (Controls.instance.ACCEPT || (FlxG.mouse.overlaps(banPopup,game.camOther) && FlxG.mouse.justPressed)) {
                game.endSong();
            }
        }
        else {
            randomEVInterval -= elapsed;

            if (randomEVInterval <= 0) {
                randomEVInterval = FlxG.random.int(10,20);
                initEvent();
            }
        }


        if (isDisco) {
            robloxHUD.timeTxt.text = 'party';
        }


        
    }
}


function onBeatHit() {
    if (!isEvil) {
        if (isDisco) {
            if (curBeat % 2 == 0) 
            {
                var id = FlxG.random.int(0,discoColors.length-1,[prevColor]);
        
                
    
                FlxG.camera._fxFadeColor = discoColors[id];
                FlxG.camera._fxFadeAlpha = 0.1;
                prevColor = id;
            }

            game.triggerEvent('Add Camera Zoom','','',Conductor.songPosition);

        }

    }
}

function onEvent(ev,v1,v2,time) {
    if (ev == '' && v1 == 'disco') {
        isDisco = !isDisco;
        if (!isDisco) {
            FlxG.camera._fxFadeAlpha = 0;
        }
    }
}

function onPause() {
    for (i in sounds) {
        if (i != null) i.pause();
    }
}

function onResume() {
    for (i in sounds) {
        if (i != null) i.resume();
    }
}
function onDestroy() {
    for (i in sounds) {
        if (i != null) i.destroy();
    }
}
function initEvent(?overrideEv) {

    var anims = [];
    for (i in eventPopup.animation._animations.keys()) //grab the anim keys and get a random
    {
        if (i != 'ban')
            anims.push(i);
    }
    var anim = anims[FlxG.random.int(0,anims.length-1)];
    
    if (FlxG.random.int(0,100000) == 500) anim = 'ban';

    if (overrideEv != null) anim = overrideEv;

    eventPopup.animation.play(anim);

    eventPopup.alpha = 0;
    FlxTween.cancelTweensOf(eventPopup, ['alpha']);
    FlxTween.tween(eventPopup, {alpha: 1},0.1).then(FlxTween.tween(eventPopup, {alpha: 0},1, {startDelay: 1.5}));
    dad.playAnim('tex');
    dad.specialAnim = true;

    for (i in game.notes) {
        if (!i.mustPress && i.strumTime - Conductor.songPosition < 1000) i.noAnimation = true;
    }
    
    switch (anim) {
        case 'fire':
            initFire();
        case 'fling':
            initFling();
        case 'smite':   
            initSmite();
        case 'explode':
            initExplosion();
        case 'smallhead':
            initSmall();
        case 'bighead':
            initBig();
        case 'ban':
            banPlayer();
    }


}

function initBig() {
    if (flickerTimer != null){
        flickerTimer.cancel();
        flickerTimer = null;
    }

    killFlicker(flickerBF);
    killFlicker(flickerBig);
    killFlicker(flickerSmall);

    smallhead.visible = false;

    var sound = FlxG.sound.play(Paths.sound('powerup'));
    sounds.push(sound);

    flickerBF = FlxFlicker.flicker(boyfriend,0.5,0.08,false);
    flickerBig = FlxFlicker.flicker(bighead,0.5,0.08,true);

    flickerTimer = new FlxTimer().start(6,Void->{
        flickerBig = FlxFlicker.flicker(bighead,0.5,0.08,false);
        flickerBF = FlxFlicker.flicker(boyfriend,0.5,0.08,true);
        FlxG.sound.play(Paths.sound('down'));
    });  
}


function killFlicker(flciker) {
    if (flciker == null) return;
    
    if (flciker.timer != null) flciker.timer.cancel();
    if (flciker.object != null) flciker.object.visible = true;
    flciker.release();
    flciker = null;
}

function initSmall() 
{
    if (flickerTimer != null){
        flickerTimer.cancel();
        flickerTimer = null;
    }
    killFlicker(flickerBF);
    killFlicker(flickerBig);
    killFlicker(flickerSmall);
    bighead.visible = false;

    var sound = FlxG.sound.play(Paths.sound('down'));
    sounds.push(sound);

    flickerBF = FlxFlicker.flicker(boyfriend,0.5,0.08,false);
    flickerSmall = FlxFlicker.flicker(smallhead,0.5,0.08,true);

    flickerTimer = new FlxTimer().start(6,Void->{
        flickerSmall = FlxFlicker.flicker(smallhead,0.5,0.08,false);
        flickerBF = FlxFlicker.flicker(boyfriend,0.5,0.08,true);
        FlxG.sound.play(Paths.sound('powerup'));
    });
}

function initExplosion() {

    var sound = FlxG.sound.play(Paths.sound('explode'));
    sound.time = 300;
    sounds.push(sound);
    
    explosion.visible = true;
    explosion.animation.play('explosion');

    explosion.x = boyfriend.x + ((boyfriend.width - explosion.width)/2) - 100;
    explosion.y = boyfriend.y + (boyfriend.height - explosion.height)/2;

    game.freezeCamera = true;
    var newY = boyfriend.y + -1200;
    FlxTween.cancelTweensOf(boyfriend, ['y']);
    FlxTween.tween(boyfriend, {y: newY},0.3, {ease: FlxEase.sineOut,onComplete: Void->{
        FlxTween.tween(boyfriend, {y: baseY}, 1, {ease: FlxEase.bounceOut,onComplete: Void->{
            game.freezeCamera = false;
        }});
        
    }});


    if (game.health > 0.5) game.health -= 0.4;
}

function initFling() {

    var sound = FlxG.sound.play(Paths.sound('fling'));
    sounds.push(sound);


    var left = FlxG.random.bool(50);
    var newX = boyfriend.x + (left ? -1400 : 1400);
    var newY = boyfriend.y + -1600;
    var newAngle = FlxG.random.int(40,150);
    var time = FlxG.random.float(0.2,0.5);
    if (left) newAngle = -newAngle;

    game.freezeCamera = true;

    FlxTween.cancelTweensOf(boyfriend, ['x','y','angle']);
    FlxTween.tween(boyfriend, {x: newX},time, {ease: FlxEase.sineIn});
    FlxTween.tween(boyfriend, {y: newY},time, {ease: FlxEase.sineOut});

    FlxTween.tween(boyfriend, {angle: newAngle},time, {ease: FlxEase.circOut,onComplete: Void->{
        new FlxTimer().start(1,Void->{
            var sound = FlxG.sound.play(Paths.sound('landing'));
            sounds.push(sound);
        });

        FlxTween.tween(boyfriend, {x: baseX,y: baseY},1,{ease: FlxEase.bounceOut,startDelay: 1,onComplete: Void->{
            FlxTween.tween(boyfriend, {angle: 0},1, {ease: FlxEase.circInOut});
            var sound = FlxG.sound.play(Paths.sound('scrape'));
            sound.pitch = 4;
            sounds.push(sound);

            game.freezeCamera = false;
        }});
    }});
}

function initSmite() {
    var sound = FlxG.sound.play(Paths.sound('lightning'));
    sound.time = 500;
    sounds.push(sound);

    boyfriend.playAnim('struck');
    boyfriend.specialAnim = true;
    for (i in game.notes) {
        if (i.mustPress && i.strumTime - Conductor.songPosition < 1000) i.noAnimation = true;
    }


    beam.visible = true;
    beam.animation.play('i');

    if (game.health > 0.3) game.health -= 0.2;
}

function initFire() {

    fireSound = FlxG.sound.play(Paths.sound('fire'));
    sounds.push(fireSound);
    
    fire.visible = true;
    fire.animation.play('start');

    if (fireTween != null) fireTween.cancel();

    fireTween = FlxTween.num(0,1,0.5,{},(f)->{
        fireShader.setFloat('ratio',f);
    });
}


function updateFireOffsets() {
    var x = 0;
    var y = 0;
    if (fire.animation.curAnim != null) {
        switch (fire.animation.curAnim.name) {
            case 'end', 'start':
                
                x = -10;
                y = 4;
            case 'loop':
        }
    }

    fire.offset.x = ((fire.frameWidth - fire.width) * 0.5) + x;
    fire.offset.y = ((fire.frameHeight - fire.height) * 0.5) + y;
}

function endFire() {
    if (fireTimer != null)
        fireTimer.cancel();

    fireSound.fadeOut();

    fire.animation.play('end');

    
    if (fireTween != null) fireTween.cancel();
    fireTween = FlxTween.num(1,0,0.5,{},(f)->{
        fireShader.setFloat('ratio',f);
    });
}


function banPlayer() {
    banPopup.visible = true;
    FlxG.sound.music.volume = 0;
    game.vocals.volume = 0;
    FlxG.sound.music.pause();
    game.vocals.pause();
    banTime = Conductor.songPosition;


    game.canPause = false;
    // game.endingSong = true;
    game.camZooming = false;
    game.inCutscene = true;
    game.updateTime = false;

}

