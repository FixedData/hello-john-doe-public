package backend;

import openfl.filters.BitmapFilter;

//adds a single filter to prevent memory leak when removing filters
//scrollangle support from troll engine thx you
class ManiaCamera extends FlxCamera
{

	public var scrollAngle(default, set):Float = 0;
    public var positionMovesSprite:Bool = true;
    function set_scrollAngle(newAngle:Float):Float
    {
        scrollAngle = newAngle;
        updateFlashSpritePosition();
        return newAngle;
    }

    override public function new(x:Int=0,y:Int=0,width:Int=0,height:Int=0,zoom:Float=1) 
    {
        super(x,y,width,height,zoom);
        filters = [new BitmapFilter()];
    }

    override function updateInternalSpritePositions():Void
    {
        if (FlxG.renderBlit)
        {
            if (_flashBitmap != null)
            {
                _flashBitmap.x = 0;
                _flashBitmap.y = 0;
            }
        }
        else
        {
            if (canvas != null)
            {
                canvas.x = -0.5 * width * (scaleX - initialZoom) * FlxG.scaleMode.scale.x;
                canvas.y = -0.5 * height * (scaleY - initialZoom) * FlxG.scaleMode.scale.y;

                canvas.scaleX = totalScaleX;
                canvas.scaleY = totalScaleY;

                _helperMatrix.identity();
				_helperMatrix.translate(-width * 0.5, -height * 0.5);
				_helperMatrix.scale(scaleX, scaleY);
				_helperMatrix.rotateWithTrig(FlxMath.fastCos(scrollAngle * 0.0174533), FlxMath.fastSin(scrollAngle * 0.0174533));
				_helperMatrix.translate(width * 0.5, height * 0.5);
				if (!positionMovesSprite) _helperMatrix.translate(x, y);
				_helperMatrix.scale(FlxG.scaleMode.scale.x, FlxG.scaleMode.scale.y);

                @:privateAccess{
                    canvas.__transform.a = _helperMatrix.a;
                    canvas.__transform.b = _helperMatrix.b;
                    canvas.__transform.c = _helperMatrix.c;
                    canvas.__transform.d = _helperMatrix.d;
                    canvas.__transform.tx = _helperMatrix.tx;
                    canvas.__transform.ty = _helperMatrix.ty;
                }

                #if FLX_DEBUG
                if (debugLayer != null)
                {
                    debugLayer.x = canvas.x;
                    debugLayer.y = canvas.y;

                    debugLayer.scaleX = totalScaleX;
                    debugLayer.scaleY = totalScaleY;
                }
                #end
            }
        }
    }

    override function updateFlashSpritePosition():Void
    {
        if (canvas != null){
            if (flashSprite != null)
            {
                if (positionMovesSprite)
                {
                    flashSprite.x = x * FlxG.scaleMode.scale.x + _flashOffset.x;
                    flashSprite.y = y * FlxG.scaleMode.scale.y + _flashOffset.y;
                }
                else
                {
                    flashSprite.x = _flashOffset.x;
                    flashSprite.y = _flashOffset.y;
                }
            }
            updateInternalSpritePositions();
        }else{
            if (flashSprite != null)
            {
                flashSprite.x = x * FlxG.scaleMode.scale.x + _flashOffset.x;
                flashSprite.y = y * FlxG.scaleMode.scale.y + _flashOffset.y;
            }
        }
    }



}