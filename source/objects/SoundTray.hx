package objects;

import openfl.text.TextFormatAlign;
import openfl.Lib;
import openfl.display.Bitmap;
import openfl.text.TextField;
import openfl.display.BitmapData;
import flixel.system.FlxAssets;
import flixel.system.FlxBGSprite;
import flixel.system.ui.FlxSoundTray;
import openfl.text.TextFormat;
import openfl.Assets;

class SoundTray extends FlxSoundTray {

    var topBar:Bitmap;
    var text:TextField;
    public function new() {
        super();
        this.removeChildren();

        topBar = new Bitmap(new BitmapData(1,1,false,FlxColor.BLACK));
        topBar.scaleY = 40;
        topBar.scaleX = FlxG.width;
        addChild(topBar);

        text = new TextField();
		text.width = topBar.scaleX;
		text.height = topBar.scaleY;
		text.multiline = true;
		text.wordWrap = true;
		text.selectable = false;

        var dtf= new TextFormat(Assets.getFont("assets/fonts/ARIAL.TTF").fontName, 30, FlxColor.WHITE);
		dtf.align = TextFormatAlign.CENTER;
		text.defaultTextFormat = dtf;
		addChild(text);
		text.text = "volume";


        y = 0;
        _defaultScale = 1;

        this.volumeUpSound = 'assets/shared/sounds/vol';
        this.volumeDownSound = 'assets/shared/sounds/vol';
    }

    override function show(up:Bool = false) {
		if (!silent)
        {
            var sound = FlxAssets.getSound(up ? volumeUpSound : volumeDownSound);
            if (sound != null)
                FlxG.sound.load(sound).play();
        }

        _timer = 1;
        visible = true;
        active = true;
        var globalVolume:Int = Math.round(FlxG.sound.volume * 10);


        if (FlxG.sound.muted)
        {
            globalVolume = 0;
        }
        
        text.text = 'volume: $globalVolume/10';

       // InitState.soundTray?.show(globalVolume);


    }

    override function update(MS:Float) {
		// Animate sound tray thing
		if (_timer > 0)
        {
            _timer -= (MS / 1000);
        }
        else
        {
            visible = false;
            active = false;
        }
    }

    override function screenCenter():Void
    {
        scaleX = _defaultScale;
        scaleY = _defaultScale;

        x = (0.5 * (Lib.current.stage.stageWidth - FlxG.width * _defaultScale) - FlxG.game.x);
    }
}

class PersistentText extends FlxText
{

    override function regenGraphic() {
        if (textField == null || !_regen)
			return;

		var oldWidth:Int = 0;
		var oldHeight:Int = FlxText.VERTICAL_GUTTER;

		if (graphic != null)
		{
			oldWidth = graphic.width;
			oldHeight = graphic.height;
		}

		var newWidth:Int = Math.ceil(textField.width);
		var textfieldHeight = _autoHeight ? textField.textHeight : textField.height;
		var vertGutter = _autoHeight ? FlxText.VERTICAL_GUTTER : 0;
		// Account for gutter
		var newHeight:Int = Math.ceil(textfieldHeight) + vertGutter;

		// prevent text height from shrinking on flash if text == ""
		if (textField.textHeight == 0)
		{
			newHeight = oldHeight;
		}

		if (oldWidth != newWidth || oldHeight != newHeight)
		{
			// Need to generate a new buffer to store the text graphic
			var key:String = FlxG.bitmap.getUniqueKey("PENIS PERSISTENT");
			makeGraphic(newWidth, newHeight, FlxColor.TRANSPARENT, false, key);

			if (_hasBorderAlpha)
				_borderPixels = graphic.bitmap.clone();

			if (_autoHeight)
				textField.height = newHeight;

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

		if (textField != null && textField.text != null)
		{
			// Now that we've cleared a buffer, we need to actually render the text to it
			copyTextFormat(_defaultFormat, _formatAdjusted);

			_matrix.identity();

			applyBorderStyle();
			applyBorderTransparency();
			applyFormats(_formatAdjusted, false);

			drawTextFieldTo(graphic.bitmap);
		}

		_regen = false;
		resetFrame();
    }
}