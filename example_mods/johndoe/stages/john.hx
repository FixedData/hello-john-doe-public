
var sky:FlxSprite;
var floor:FlxSprite;
var home:FlxSprite;
var oh:PsychVideoSprite;
var time = 1.67;
var penisThx:Bool = false;

var codeBG;

var skyShader;

function onCreate() {
    game.skipCountdown = true;
    for (i in [game.camHUD, game.camGame]) i.alpha = 0;
    game.addCharacterToList('jd',1);

    

    sky = new FlxSprite(-228, 0).loadGraphic(Paths.image('bgs/sky'));
    addBehindDad(sky);

    codeBG = new CodeBG(0,100,FlxG.width * 1.5,FlxG.height * 1.2);
   
    codeBG.active = true;
    codeBG.visible = false;
    codeBG.alpha = 0;
    

     home = new FlxSprite(100, 200).loadGraphic(Paths.image('bgs/home'));
    home.setGraphicSize(1600);
    addBehindDad(home);
    home.alpha = 0;
    addBehindDad(codeBG);

    skyShader = makeShader('invertGlitch');
    skyShader.setFloat('AMT',0.7);
    skyShader.setFloat('SPEED',8);
    skyShader.setBool('isActive',false);
    sky.shader = skyShader;

    floor = new FlxSprite(130, 700).loadGraphic(Paths.image('bgs/floor'));
    addBehindDad(floor);

    
    
}

function onStartCountdown() {


    if(!penisThx){
        oh = new PsychVideoSprite();
         oh.addCallback('onFormat',()->{
             oh.setGraphicSize(FlxG.width);
             oh.updateHitbox();
             oh.cameras = [camOther];
         });
         oh.load(Paths.video('oh'));
         oh.antialiasing = true;
         oh.play();
         add(oh);
         oh.addCallback('onEnd',()->{
             noMorePenis();
         });
         return Function_Stop;
    }

}

function noMorePenis() {
    penisThx = true;
    game.startCountdown();
    trace('hiii ^_^');
    oh.stop();
    oh.destroy();
}

var iTime = 0;

function onUpdatePost(elapsed:Float) //temp
{
    iTime+=elapsed;
    skyShader.setFloat('iTime',iTime);
    if (FlxG.keys.justPressed.ENTER && !penisThx) {
        penisThx = true;
        FlxTween.tween(oh, {alpha: 0},time, {ease: FlxEase.sineOut, onComplete: Void->{
            noMorePenis();
        }});
    }
}
    

function onSongStart() {
    FlxTween.tween(game.camGame, {alpha: 1},time -0.25, {ease: FlxEase.sineOut});
    FlxG.camera.fade(FlxColor.BLACK,time,true);
    FlxTween.tween(game.camHUD, {alpha: 1},time -0.25, {ease: FlxEase.sineOut,startDelay: 0.25});
    var awesome = FlxTween.tween(FlxG.camera, {zoom: FlxG.camera.zoom - 0.1},time, {ease: FlxEase.quadInOut}); //circin looks better // no it doesnt kys im sorry that was rude // we're not friends anymore ok
}

function goodNoteHit(note){} function opponentNoteHit(note){ if (note.noteType == 'Alt Animation') {if(game.health >= 0.1) game.health -= note.hitHealth * 2.6; } }

function onEvent(eventName,val1,val2,time) {
    if(eventName == "woah"){
    switch (val1) {
        case 'codeWall':
            codeBG.visible = true;
            codeBG.active = true;

        case 'woah':
            FlxTween.tween(home, {alpha: 1},7, {ease: FlxEase.quadInOut, onComplete: function(twn:FlxTween) 
            {
                
            }}); 
            FlxTween.tween(floor, {alpha: 0},7, {ease: FlxEase.quadInOut, onComplete: function(twn:FlxTween) 
                {
                    
                }}); 
        
             case 'bye': 
              FlxTween.tween(home, {alpha: 0},3, {ease: FlxEase.quadInOut, onComplete: function(twn:FlxTween) 
            {
                
            }});
            FlxTween.tween(floor, {alpha: 1},3, {ease: FlxEase.quadInOut, onComplete: function(twn:FlxTween) 
                {
                    
                }});
            case 'glitch': 
            skyShader.setBool('isActive',true);

            case 'noglitch': 
                skyShader.setBool('isActive',false);
                case 'nowall': 
                    codeBG.visible = false;
            codeBG.active = false;
            case 'fade': 
                    FlxTween.tween(codeBG, {alpha: 0},1, {ease: FlxEase.cubeInOut, onComplete: function(twn:FlxTween) 
                        {
                            
                        }}); 
            case 'welcome': 
             
                    FlxTween.tween(codeBG, {alpha: 1},4, {ease: FlxEase.cubeOut, onComplete: function(twn:FlxTween) 
                        {
                            
                        }}); 
            


    }

}
}
