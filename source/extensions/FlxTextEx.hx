package extensions;

import openfl.display.BitmapData;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;

/**
 * Subclass of FlxText that incorporates a fix for
 * https://github.com/HaxeFlixel/flixel/issues/1025. Use this if text borders
 * appear clipped.
 */
class FlxTextEx extends FlxText
{
	public function new(x:Float = 0, y:Float = 0, fieldWidth:Float = 0, ?text:String, size:Int = 8, embeddedFont:Bool = true)
	{
		super(x, y, fieldWidth, text, size, embeddedFont);
	}

	// Copied from FlxText and modified.
	override private function regenGraphic():Void
	{
		if (textField == null || !_regen)
			return;

		var oldWidth:Int = 0;
		var oldHeight:Int = FlxText.VERTICAL_GUTTER;

		if (graphic != null)
		{
			oldWidth = graphic.width;
			oldHeight = graphic.height;
		}

		var newWidth:Float = textField.width;
		// Account for gutter
		var newHeight:Float = textField.textHeight + FlxText.VERTICAL_GUTTER;

		// BEGIN ADDITION
		switch (borderStyle)
		{
			case OUTLINE | OUTLINE_FAST:
				newWidth += borderSize;
				newHeight += borderSize;
			case SHADOW:
				newWidth += shadowOffset.x;
				newHeight += shadowOffset.y;
			case NONE:
		}
		// END ADDITION

		// prevent text height from shrinking on flash if text == ""
		if (textField.textHeight == 0)
		{
			newHeight = oldHeight;
		}

		if (oldWidth != newWidth || oldHeight != newHeight)
		{
			// Need to generate a new buffer to store the text graphic
			height = newHeight;
			var key:String = FlxG.bitmap.getUniqueKey("text");

			makeGraphic(Std.int(newWidth), Std.int(newHeight), FlxColor.TRANSPARENT, false, key);
			if (_hasBorderAlpha)
				_borderPixels = graphic.bitmap.clone();
			frameHeight = Std.int(height);
			textField.height = height * 1.2;
			_flashRect.x = 0;
			_flashRect.y = 0;
			_flashRect.width = newWidth;
			_flashRect.height = newHeight;
		}
		else // Else just clear the old buffer before redrawing the text
		{
			graphic.bitmap.fillRect(_flashRect, FlxColor.TRANSPARENT);
			if (_hasBorderAlpha)
			{
				if (_borderPixels == null)
					_borderPixels = new BitmapData(frameWidth, frameHeight, true);
				else
					_borderPixels.fillRect(_flashRect, FlxColor.TRANSPARENT);
			}
		}

		if (textField != null && textField.text != null && textField.text.length > 0)
		{
			// Now that we've cleared a buffer, we need to actually render the text to it
			copyTextFormat(_defaultFormat, _formatAdjusted);

			_matrix.identity();
			// BEGIN ADDITION
			_matrix.translate(0, FlxText.VERTICAL_GUTTER / 2);
			switch (borderStyle)
			{
				case OUTLINE | OUTLINE_FAST:
					_matrix.translate(borderSize, borderSize);
				case SHADOW:
					_matrix.translate(Math.max(0, -shadowOffset.x), Math.max(0, -shadowOffset.y));
				case NONE:
			}
			// END ADDITION

			applyBorderStyle();
			applyBorderTransparency();
			applyFormats(_formatAdjusted, false);

			drawTextFieldTo(graphic.bitmap);
		}

		_regen = false;
		resetFrame();
	}
}
