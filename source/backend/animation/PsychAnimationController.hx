package backend.animation;

import flixel.animation.FlxAnimationController;

class PsychAnimationController extends FlxAnimationController {
    public var followGlobalSpeed:Bool = true;


    public override function update(elapsed:Float):Void {
		if (_curAnim != null) {
            var speed:Float = timeScale;
            if (followGlobalSpeed) speed *= FlxG.animationTimeScale;
			_curAnim.update(elapsed * speed);
		}
		else if (_prerotated != null) {
			_prerotated.angle = _sprite.angle;
		}
	}

	override function play(animName:String, force:Bool = false, reversed:Bool = false, frame:Int = 0) {
		super.play(animName, force, reversed, frame);

		if (_sprite is objects.FunkinSprite) {
			var spr:objects.FunkinSprite = cast _sprite;
			if (spr.offsets.exists(animName)) {
				spr.offset.x = spr.offsets[animName][0];
				spr.offset.y = spr.offsets[animName][1];
			}
		}
	}
}