package objects;

class CheckboxThingie extends FlxSprite
{
	public var sprTracker:FlxSprite;
	public var daValue(default, set):Bool;
	public var offsetX:Float = 0;
	public var offsetY:Float = 0;
	public function new(x:Float = 0, y:Float = 0, ?checked = false) {
		super(x, y);

		frames = Paths.getSparrowAtlas('k');
		animation.addByPrefix('yes', 'yes', 1, false);
		animation.addByPrefix('no', 'no', 1, false);
		updateHitbox();
		daValue = checked;
	}

	override function update(elapsed:Float) {
		if (sprTracker != null) {
			setPosition(sprTracker.x + sprTracker.width + offsetX, sprTracker.y + 9 + offsetY);
		}
		super.update(elapsed);
	}

	private function set_daValue(check:Bool):Bool {
		if(check) animation.play('yes', true);
		else animation.play('no', true);
		return check;
	}
}
