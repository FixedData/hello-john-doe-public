var eyes:FlxSprite;
var bubble:FlxSprite;
var spotlight:FlxSprite;
var healthd:Bool = false;

function onCreate() {
    game.addCharacterToList('bw2',1);
    game.skipCountdown = true;
    for (i in [game.camGame, game.camHUD]) i.visible = false;

    spotlight = new FlxSprite(boyfriendGroup.x-110, boyfriendGroup.y-80).loadGraphic(Paths.image('s/spotlight'));


    eyes = new FlxSprite(-155,210);
    eyes.frames = Paths.getSparrowAtlas('s/eyes');
    eyes.animation.addByPrefix('i','eyes',24);
    eyes.animation.addByPrefix('h','eyeappear',17);
    addBehindDad(eyes);

    bubble = new FlxSprite(boyfriendGroup.x-260, boyfriendGroup.y+300);
    bubble.frames = Paths.getSparrowAtlas('s/bubble');
    bubble.animation.addByPrefix('i','bubble0000',24);
    bubble.animation.addByPrefix('h','bubbleappear',12);
    bubble.cameras = [game.camHUD];
    bubble.scale.set(0.9,0.9);
    add(bubble);

    eyes.alpha = 0;
    bubble.alpha = 0;

}

function onEvent(eventName,val1,val2,time) {
    if(eventName == "evil"){
    switch (val1) {
        case 'turn evil':
            FlxTween.tween(boyfriend, {alpha: 0},1.5, {ease: FlxEase.quadInOut, onComplete: function(twn:FlxTween) 
            {
                boyfriend.cameras = [game.camHUD]; 
            }}); 
            FlxTween.tween(spotlight, {x: spotlight.x + 700},(3.2), {ease: FlxEase.quadInOut});
            game.triggerEvent('Change Character','dad','bw2',Conductor.songPosition);
            game.triggerEvent('Play Animation','ok','dad');
            game.healthGain *= 0.7;
            new FlxTimer().start(2.2, function(tmr:FlxTimer){
                eyes.alpha = 1;
                eyes.animation.play('h');
                FlxTween.tween(eyes, {alpha: 0}, 1.4, {ease: FlxEase.cubeOut, onComplete: function(twn:FlxTween)
                {
                    eyes.animation.play('i');
                }});
                new FlxTimer().start(2.4,Void->FlxTween.tween(eyes, {alpha: 1},0.7, {ease: FlxEase.cubeOut}));
            });
        case 'k':    
            FlxG.camera.flash();
            for (i in [game.camGame, game.camHUD]) i.visible = true;
        case 'hello':    
            add(spotlight);
        case 'bye':    
            remove(spotlight);
        case 'well':
            game.camGame.visible = false;
        case 'well2':
            for (i in [game.camGame, game.camHUD]) i.visible = false;
            FlxG.camera.flash();
        case 'd': healthd = true;
        case 'outro': 
        FlxTween.tween(eyes, {alpha: 0},1, {ease: FlxEase.quadIn, onComplete: function(twn:FlxTween) 
            {
                
            }}); 
        healthd = true;
        case 'bfk':
            bubble.animation.play('h');
            FlxTween.tween(bubble, {alpha: 1}, 1, {ease: FlxEase.cubeOut, onComplete: function(twn:FlxTween)
            {
                bubble.animation.play('i');
                FlxTween.tween(boyfriend, {alpha: 1},0.4, {ease: FlxEase.quadInOut});
            }});
            boyfriend.x = 710;
            for (i in [boyfriend, bubble]) {
                i.y += -65;
            }
    }

    switch (val2) {
        case 'comeback':
            game.camGame.visible = true;
            FlxG.camera.flash(0000000000, 2.4);
    }
}
}
function goodNoteHit(daNote){} function opponentNoteHit(daNote){ if (healthd) { if(game.health >= 0.1) game.health -= daNote.hitHealth * 0.7; } }
