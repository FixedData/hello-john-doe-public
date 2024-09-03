import flixel.addons.display.FlxBackdrop;
var bathroom:FlxSprite;
var scaryworld:FlxSprite;
var normalbg:FlxSprite;
var evilbg:FlxSprite;
var bfbod:FlxSprite;
var runningBG:FlxSprite;
var vignette:FlxSprite;
var fg:FlxSprite;
var ok:FlxSprite;
var thing:FlxSprite;
var pt2:FlxSprite;
function onCreate() {
    game.skipCountdown = true;
    
    scaryworld = new FlxSprite(400, 200).loadGraphic(Paths.image('scaryworld'));
    addBehindGF(scaryworld);
    scaryworld.alpha= 1;

    bathroom = new FlxSprite(675, 300).loadGraphic(Paths.image('bathroom'));
    add(bathroom);
    bathroom.alpha= 1;

    normalbg = new FlxSprite(100, 0).loadGraphic(Paths.image('normalbg'));
    addBehindDad(normalbg);
    normalbg.alpha= 0;

    evilbg = new FlxSprite(100, 0).loadGraphic(Paths.image('evilbg'));
    addBehindDad(evilbg);
    evilbg.alpha= 0;

    vignette = new FlxSprite(0, 0).loadGraphic(Paths.image('vignette'));
    vignette.cameras = [camHUD];
    add(vignette);
    vignette.alpha= 1;

    runningBG = new FlxBackdrop(Paths.image('rockscroll'),0x01);
    runningBG.y = 100;
    addBehindGF(runningBG);
    runningBG.updateHitbox();
    runningBG.velocity.x = 2000;
    runningBG.alpha= 0;

    fg = new FlxSprite(100, 100);
    fg.frames = Paths.getSparrowAtlas('fg');
        addBehindBF(fg);
        fg.animation.addByPrefix('fg','fg',24);
        fg.alpha= 0;
        fg.animation.play('fg');
        fg.scale.set(0.5,0.5);
     ok = new FlxSprite(100, 500);
        ok.frames = Paths.getSparrowAtlas('ok');
            addBehindDad(ok);
            ok.animation.addByPrefix('ok','ok',24);
            ok.alpha= 0;
            ok.animation.play('ok');
            ok.scale.set(0.5,0.5);
            thing = new FlxSprite(1025, 535);
            thing.frames = Paths.getSparrowAtlas('thing');
                addBehindBF(thing);
                thing.animation.addByPrefix('thing','thing',24);
                thing.alpha= 0;
                thing.animation.play('thing');
                thing.scale.set(0.5,0.5);
    

    bfbod = new FlxSprite(1110, 660);
    bfbod.frames = Paths.getSparrowAtlas('bfbod');
        addBehindBF(bfbod);
        bfbod.animation.addByPrefix('bfbod','bfbod',24);
        bfbod.alpha= 0;
        bfbod.animation.play('bfbod');
    
        pt2 = new FlxSprite(300, -100).loadGraphic(Paths.image('pt2'));
    add(pt2);
    pt2.alpha= 0;
    



  game.camGame.alpha = 0;


}


function onEvent(ev,val1,val2,time) {
    switch (ev) {
        case 'bathroom': FlxTween.tween(bathroom, {alpha: 0},1, {ease: FlxEase.quadOut});

        
        case 'bf': FlxTween.tween(bf, {x: bf.x + -1100},(9.3), {ease: FlxEase.quadOut});
        case 'dad': FlxTween.tween(dad, {x: dad.x + -600},(0.3), {ease: FlxEase.quadOut});
        FlxTween.tween(dad, {y: dad.y + -40},(0.3), {ease: FlxEase.quadOut});
        
        case 'normappear':
            normalbg.alpha= 1;
            scaryworld.alpha= 0;
            case 'normbye':
                dad.alpha= 0;
                normalbg.alpha= 0;
                case 'rust':
                    evilbg.alpha= 1;
        case 'byerust':
         evilbg.alpha= 0;

         case 'poop':
            FlxTween.tween(dad, {alpha: 1}, 1, {ease: FlxEase.cubeOut, onComplete: function(twn:FlxTween)
                {

                }});
            FlxTween.tween(dad, {x: dad.x + -600},(1), {ease: FlxEase.quadOut});
                FlxTween.tween(dad, {y: dad.y + -40},(1), {ease: FlxEase.quadOut});

         case 'new':
            runningBG.alpha= 1;
            bfbod.alpha= 1;
        case 'final':
                thing.alpha= 1;
                ok.alpha= 1;
                fg.alpha= 1;

                case 'move':

             FlxTween.tween(dad, {x: dad.x + -400},(0.3), {ease: FlxEase.quadOut});
                    FlxTween.tween(dad, {y: dad.y + -100},(0.3), {ease: FlxEase.quadOut});
            case 'come back': game.camGame.alpha = 1;
            case 'die': game.camGame.alpha = 0;

            case 'fade':
            FlxG.camera.flash(0000000000, 1);
            case 'pt2':
                game.camHUD.alpha = 0;
                pt2.alpha= 1;
    
}
}