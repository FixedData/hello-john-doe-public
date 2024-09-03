import objects.PsychVideoSprite;
import psychlua.LuaUtils;

import backend.InputFormatter;
import states.editors.ChartingState.AttachedFlxText;

var video:PsychVideoSprite;
var penisend:PsychVideoSprite;
var burgerVid;
var oofVid;
var pizzaVid;
var trainVid;
var bg;

var allow = false;



var dadPosIDX = [
    [-400,-50], //0
    [-500,0], //1
    [-200,-100], //2
    [-75,-125], //3
    [125,-150], //4
    [170,-150], //5
    [125,-150], //6
];

var bfPosIDX = [
    [400,-100], //0
    [300,-100], //1
    [600,-100], //2
    [700,-100], //3
    [900,-100], //4
    [1000,-100], //5
    [1200,-100], //6
];



var gray;
var popupText;
var timer = 20;

var _prevMessage:String = '';
var funnyTexts = ['pens','fuic', 'im hacking u', 'dud', 'john doe hello', 'ok well lets play', 'my powersn', 'DIE', 'hacked', 'funktastic', 'follow me on twitter', 'ok ur hacked and dead', 'send password', '123 for bf'];
var textTimer;

function initAllVideos() {
    // PsychVideoSprite.cacheVid(Paths.video('intro'));
    // PsychVideoSprite.cacheVid(Paths.video('train'));
    // PsychVideoSprite.cacheVid(Paths.video('pizza'));
    // PsychVideoSprite.cacheVid(Paths.video('oof'));
    // PsychVideoSprite.cacheVid(Paths.video('burger'));
    // PsychVideoSprite.cacheVid(Paths.video('outro'));

    trainVid = new PsychVideoSprite();
    formatVid(trainVid,true);
    trainVid.load(Paths.video('train'),[PsychVideoSprite.muted]);

    pizzaVid = new PsychVideoSprite();
    formatVid(pizzaVid,true);
    pizzaVid.load(Paths.video('pizza'),[PsychVideoSprite.muted]);

    oofVid = new PsychVideoSprite();
    formatVid(oofVid,true);
    oofVid.load(Paths.video('oof'),[PsychVideoSprite.muted]);

    burgerVid = new PsychVideoSprite();
    formatVid(burgerVid,true);
    burgerVid.load(Paths.video('burger'),[PsychVideoSprite.muted]);


    video = new PsychVideoSprite();
    formatVid(video,false);
    video.load(Paths.video('intro'),[PsychVideoSprite.muted]);
    video.addCallback('onFormat',()->{
        new FlxTimer().start(0.1,()->{
        camOther._fxFadeAlpha = 0;
        });
    });
    
    penisend = new PsychVideoSprite();
    formatVid(penisend,false);
    penisend.load(Paths.video('outro'),[PsychVideoSprite.muted]);


}

function formatVid(vid,hud) {
    vid.addCallback('onFormat',()->{
        vid.setGraphicSize(FlxG.width);
        vid.updateHitbox();
        if (hud) {
            vid.cameras = [camHUD];
            insert(0,vid);
        }
        else {
            vid.cameras = [camOther];
            add(vid);
        }

        killMessage();
    });


}


function onCreate() {
    game.isCameraOnForcedPos = true;

    initAllVideos();

    
    bg = new FlxSprite(-210,-150);
    bg.frames = Paths.getSparrowAtlas('1x1bg');
    bg.animation.addByPrefix('bf','bgbf',6,false);
    bg.animation.addByPrefix('dad','bgdad',6,false);
    bg.animation.play('dad');
    bg.scrollFactor.set();
    addBehindDad(bg);



    camOther._fxFadeAlpha = 1;
    camOther._fxFadeColor = FlxColor.BLACK;


    gray = new FlxSprite().makeGraphic(1,1,FlxColor.GRAY);
    gray.scale.set(FlxG.width,FlxG.height);
    gray.updateHitbox();
    gray.alpha = 0;
    add(gray);
    gray.cameras = [camOther];

    popupText = new FlxText(0,0,FlxG.width,'',40);
    popupText.alignment = 'center';
    popupText.font = Paths.font('ARIAL.TTF');
    add(popupText);
    popupText.cameras = [camOther];
    popupText.color = FlxColor.BLACK;
    popupText.alpha = 0;
}

function spawnFunnyMessage() 
{
    timer = FlxG.random.int(15,30);

    gray.alpha = 0.6;
    var newMessage = funnyTexts[FlxG.random.int(0,funnyTexts.length-1)];
    while (newMessage == _prevMessage) newMessage = funnyTexts[FlxG.random.int(0,funnyTexts.length-1)];

    _prevMessage = newMessage;

    popupText.text = newMessage;

    popupText.alpha = 1;
    popupText.screenCenter(FlxAxes.Y);


    textTimer = new FlxTimer().start(5,Void->{
        gray.alpha = 0;
        popupText.alpha = 0;
    });
}

function killMessage() {
    if (textTimer != null) textTimer.cancel();
    gray.alpha = 0;
    popupText.alpha = 0;
    timer = FlxG.random.int(10,20);
}

function initIntro() {
    video = new PsychVideoSprite();
    formatVid(video,false);
    video.load(Paths.video('intro'),[PsychVideoSprite.muted]);
}

function onStartCountdown() {

   if (!allow) {
        new FlxTimer().start(0.5,Void->{
            if (video == null) {
                initIntro();
            }
            
            if (!video.load(Paths.video('intro'),[PsychVideoSprite.muted])) {
                game.startCountdown();
                return;
            }
                
            allow = true;
            game.skipCountdown = true;
            game.startCountdown();

    
            new FlxTimer().start(0.2,Void->{
                var notes = ['note_left','note_down','note_up','note_right'];
                for (i in 0...game.playerStrums.length) {
                                
                   var note = game.playerStrums.members[i];
            
                   note.x += 10;
                    if (i > 0) {
                        note.x += -4.7 * i;
                    }
                    note.alpha = 0.8;


            
    
                   var t = new AttachedFlxText(0,0,0,InputFormatter.keyFormatting(ClientPrefs.keyBinds.get(notes[i])[0]),20);
                   t.sprTracker = note;
                   t.copyAlpha = false;
                   t.font = Paths.font('ARIAL.TTF');
                   t.updateHitbox();
                   t.yAdd = note.height - t.height + 5;
               
                   insert(members.indexOf(note) + 1,t);
                   t.cameras = [camHUD];
                }
            });
        });
   } 


    return (allow) ? LuaUtils.Function_Continue : LuaUtils.Function_Stop;
}

function onCreatePost() {
    for (i in game.dadGroup) i.scrollFactor.set();
    for (i in game.boyfriendGroup) i.scrollFactor.set();

    dadGroup.x = 125;
    dadGroup.y = -100;
}

function onSongStart() {
    if (video == null) {
        initIntro();
    }
    else
        video.play();
}

function onUpdatePost(elapsed) 
{

    if (timer > 0) {
        timer -= elapsed;
        
    }
    else spawnFunnyMessage();
    if (bg == null && bg.animation.curAnim == null) return;

    var bgIDX = (curSection > 0 && mustHitSection) ? 6 - bg.animation.curAnim.curFrame : bg.animation.curAnim.curFrame;

    // trace(bgIDX);

    if (dadPosIDX[bgIDX] != null) {
        dadGroup.x = dadPosIDX[bgIDX][0];
        dadGroup.y = dadPosIDX[bgIDX][1];
    }

    if (bfPosIDX[bgIDX] != null) {
        boyfriendGroup.x = bfPosIDX[bgIDX][0];
        boyfriendGroup.y = bfPosIDX[bgIDX][1];
    }

}

function onSectionHit() {
    if (mustHitSection) {
        if (bg.animation.curAnim.name != 'bf')
        bg.animation.play('bf');

    }
    else {
        if (bg.animation.curAnim.name != 'dad')
            bg.animation.play('dad');
    }
}

function onEvent(ev,v1,v2) {
    switch (ev) {
        case 'black': 
            game.camHUD.visible = false;
            game.camGame.visible = false;
        case 'outro': 
            penisend.play();
        case 'pizza':
            pizzaVid.play();
        case 'oof':
            oofVid.play();
        case 'train':
            trainVid.play();
        case 'burger':
            burgerVid.play();
    }
}
