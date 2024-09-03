
import psychlua.LuaUtils;

var tween;
function onEvent(ev,v1,v2,time) {
    if (ev == 'awesomeZoom') {
        var values = v1.split(',');

        var desiredZoom = Std.parseFloat(values[0]);
        if (Math.isNaN(desiredZoom)) desiredZoom = 1;

        var desiredTime = Std.parseFloat(values[1]);
        if (Math.isNaN(desiredZoom)) desiredTime = 0.5;
        
        if (tween != null) tween.cancel();

        tween = FlxTween.num(FlxG.camera.zoom,desiredZoom,desiredTime, {ease: LuaUtils.getTweenEaseByString(v2)}, (f)->{
            FlxG.camera.zoom = f;
            game.defaultCamZoom = f;
        });

        
    }

}