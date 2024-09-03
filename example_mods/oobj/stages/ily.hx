import objects.PsychVideoSprite;
import openfl.Lib;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxTypedGroup;
//i got lazy and did this in an hour so this sucks im really sorry

var balls:FlxTypedGroup<FlxSprite>;

var colors:Array<String> = ['green', 'red', 'blue', 'yellow'];

var can:Bool = false;
var select:Bool = false;
var oob:Bool = true;

var red:Bool = false;
var yellow:Bool = false;
var green:Bool = false;
var blue:Bool = false;

var redV:PsychVideoSprite;
var yellowV:PsychVideoSprite;
var greenV:PsychVideoSprite;
var blueV:PsychVideoSprite;

var introTxt:FlxSprite;

function onCreate() {
    game.skipCountdown = true;
    for (i in [dadGroup, boyfriendGroup, game.camGame, game.camHUD]) i.visible = false;

    introTxt = new FlxSprite();
    introTxt.frames = Paths.getSparrowAtlas('intro/txts');
    introTxt.animation.addByPrefix('b','bBase',1);
    introTxt.animation.addByPrefix('p','pick',1);
    introTxt.animation.addByPrefix('s','sorry',1);

    introTxt.animation.addByPrefix('blue','blue',1);
    introTxt.animation.addByPrefix('green','green',1);
    introTxt.animation.addByPrefix('red','red',1);
    introTxt.animation.addByPrefix('yellow','yellow',1);

    introTxt.cameras = [game.camOther];
    introTxt.screenCenter();
    introTxt.y -= 350;
    introTxt.scale.set(0.6,0.6);
    introTxt.antialiasing = true;
    add(introTxt);

    yellowV = new PsychVideoSprite();
    yellowV.load(Paths.video('yellow'),[PsychVideoSprite.muted]);
    PsychVideoSprite.cacheVid(Paths.video('yellow'));

    redV = new PsychVideoSprite();
    redV.load(Paths.video('red'),[PsychVideoSprite.muted]);
    PsychVideoSprite.cacheVid(Paths.video('red'));

    greenV = new PsychVideoSprite();
    greenV.load(Paths.video('green'),[PsychVideoSprite.muted]);
    PsychVideoSprite.cacheVid(Paths.video('green'));

    blueV = new PsychVideoSprite();
    blueV.load(Paths.video('blue'),[PsychVideoSprite.muted]);
    PsychVideoSprite.cacheVid(Paths.video('blue'));

    for (i in [blueV, yellowV, redV, greenV]) {
        i.addCallback('onFormat',()->{
            i.setGraphicSize(FlxG.width, FlxG.height);
            i.updateHitbox();
            i.antialiasing = ClientPrefs.data.antialiasing;
            insert(0,i);
            i.cameras = [game.camOther];
        });
    }

    balls = new FlxTypedGroup<FlxSprite>();
    for (i in 0...colors.length)
    {
        var okay = new FlxSprite().loadGraphic(Paths.image('balls/ball-' + colors[i]));
        okay.antialiasing = ClientPrefs.data.antialiasing;
        okay.ID = i;
        okay.cameras = [game.camGame];
        okay.scale.set(0.5,0.5);
        okay.x = (200 * (i - (colors.length / 2))) + 800;
        okay.y += 440;
        okay.updateHitbox();
        balls.add(okay);
    }
    add(balls);
    balls.members[0].y += 200;
    balls.members[0].x = balls.members[1].x;
    balls.members[3].y += 200;
    balls.members[3].x = balls.members[2].x;
}

function onStartCountdown() {
    if(oob){
        FlxG.sound.playMusic(Paths.music('bg'), 5);
        FlxG.sound.play(Paths.sound('pick'), 12);
        introTxt.animation.play('p');
        new FlxTimer().start(1.48, Void -> {
            introTxt.animation.play('s');
        });
        new FlxTimer().start(4.3, Void -> {
            can = game.camGame.visible = true;
            introTxt.animation.play('b');
        });
        return Function_Stop;
    }
}

function onUpdatePost() {
    if (balls != null) {
        for(i in balls.members){ 
            if(can && FlxG.mouse.overlaps(i)){
                select = true;
                if(FlxG.mouse.justPressed && select) decide(i.ID);
            }else{
                select = true;
            }
        }
    }
}

//i should just die 
function decide(id:Int){
    select = can = game.camGame.visible = FlxG.mouse.visible = false;
    switch(colors[id]){
        case 'green': 
            introTxt.animation.play('green');
            FlxG.sound.play(Paths.sound('green'), 12);
            green = true;
        case 'red':
            introTxt.animation.play('red');
            FlxG.sound.play(Paths.sound('red'), 12);
            red = true;
        case 'blue':
            introTxt.animation.play('blue');
            FlxG.sound.play(Paths.sound('blue'), 12);
            blue = true;
        case 'yellow':
            introTxt.animation.play('yellow');
            FlxG.sound.play(Paths.sound('yellow'), 12);
            yellow = true;
    }
    new FlxTimer().start(3.3, Void -> {
        helloOobja();
    });
}

function helloOobja() {
    oob = false;
    game.startCountdown();
    introTxt.destroy();
    if (green) greenV.play();
    else if (yellow) yellowV.play();
    else if (red) redV.play();
    else if (blue) blueV.play();
}

function onDestroy() {
    FlxG.mouse.visible = true;
    for (i in [blueV, yellowV, redV, greenV]) {
        if (i != null) i.destroy();
    }
}
