import flixel.FlxSprite;
import flixel.addons.display.FlxBackdrop;
import psychlua.LuaUtils;
var forest:FlxSprite;
var fire;
var white:FlxSprite;
var ice:FlxSprite;
var computer:FlxSprite;
var green:FlxSprite;

function onCreate() {
    game.skipCountdown = true;

    forest = new FlxSprite(-128, 0).loadGraphic(Paths.image('forest'));
    addBehindDad(forest);
     forest.alpha= 1;
     ice = new FlxSprite(-128, 0).loadGraphic(Paths.image('ice'));
    addBehindDad(ice);
     ice.alpha= 0;
    white = new FlxSprite(-300, 900).loadGraphic(Paths.image('floorshiny'));
    addBehindDad(white);
     white.alpha = 0;
     computer = new FlxSprite(-128, 0).loadGraphic(Paths.image('computer'));
     addBehindDad(computer);
     computer.alpha= 0;
    green = new FlxSprite(-128, 0).loadGraphic(Paths.image('green'));
     add(green);
     green.alpha= 0;
     green.blend = LuaUtils.blendModeFromString('multiply');
    fire = new FlxSprite(0,300);
    fire.frames = Paths.getSparrowAtlas('menu/rolbox/sm/fire');
    fire.animation.addByPrefix('i','fire',24);
    fire.animation.play('i');
    fire.scale.set(3,2);
    add(fire);

    fire.alpha= 0;




}



function onEvent(eventName,val1,val2,time) {
    switch (eventName) {

        case 'white':
    white.alpha= 1;
    forest.alpha= 0;


      FlxTween.tween(boyfriend, {alpha: 0},0.1, {ease: FlxEase.quadInOut, onComplete: function(twn:FlxTween)
        {
        
       }}); 
       case 'computer':
        computer.alpha= 1;
        green.alpha= 1;
        ice.alpha= 0;

          
        case 'ice':
    ice.alpha= 1;
    white.alpha= 0;

      FlxTween.tween(boyfriend, {alpha: 1},0.1, {ease: FlxEase.quadInOut, onComplete: function(twn:FlxTween)
        {
           
       }}); 
      
        case 'fire':
            FlxTween.tween(fire, {alpha: Std.parseFloat(val1)},Std.parseFloat(val2));

        case 'farm':
            FlxTween.tween(forest, {alpha: Std.parseFloat(val1)},Std.parseFloat(val2));

        case 'come':
             FlxTween.tween(camGame, {alpha: 1},3, {ease: FlxEase.quadIn, onComplete: function(twn:FlxTween) 
                    
                    {
                        
                    }}); 
                    FlxTween.tween(camHUD, {alpha: 1},3, {ease: FlxEase.quadIn, onComplete: function(twn:FlxTween) 
                    
                        {
                            
                        }}); 

        case 'poop':
             FlxTween.tween(camGame, {alpha: 0},3, {ease: FlxEase.quadIn, onComplete: function(twn:FlxTween) 
                    
                    {
                        
                    }}); 
         case 'okno':
             FlxTween.tween(camGame, {alpha: 1},3, {ease: FlxEase.quadIn, onComplete: function(twn:FlxTween) 
                    
                    {
                        
                    }}); 

            FlxG.camera.flash(0000000000, 8);
         case 'goodnight':
            game.camGame.visible = false;
         case 'goodmorningsweetcheeks':
            game.camGame.visible = true;

            case 'bye': 
                FlxTween.tween(camGame, {alpha: 0},1, {ease: FlxEase.quadIn, onComplete: function(twn:FlxTween) 
                    
                    {
                        
                    }}); 
                    FlxTween.tween(camHUD, {alpha: 0},1, {ease: FlxEase.quadIn, onComplete: function(twn:FlxTween) 
                    
                        {
                            
                        }}); 


    }
}
