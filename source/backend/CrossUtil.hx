package backend;

import flixel.FlxObject;
import openfl.filters.ShaderFilter;
import flixel.system.FlxAssets.FlxShader;
@:access(flixel)
class CrossUtil 
{
	public static inline function distanceBetween(p1:FlxPoint, p2:FlxPoint):Float
	{
		var dx:Float = p1.x - p2.x;
		var dy:Float = p1.y - p2.y;
		return FlxMath.vectorLength(dx, dy);
	}

	//convenient
	public static inline function quickCreateCam(defDraw:Bool = false):FlxCamera
	{
		var camera = new FlxCamera();
		camera.bgColor = 0x0;
		FlxG.cameras.add(camera,defDraw);
		return camera;
	}

	//maybe works idk
	public static inline function getMapObjects<T>(map:Map<T,Dynamic>) 
	{
		var objs = [];
		for (i in map.keys()) objs.push(map.get(i));
		return objs;
	}

	//idk amybe i want this in the future but here inserting functionality to cameras
	public static function insertFlxCamera(idx:Int,camera:FlxCamera,defDraw:Bool = false) 
	{
		var cameras = [
			for (i in FlxG.cameras.list) {
				cam: i,
				defaultDraw: FlxG.cameras.defaults.contains(i)
			}
		];

        for(i in cameras) FlxG.cameras.remove(i.cam, false);

		cameras.insert(idx, {cam: camera,defaultDraw: defDraw});

		for (i in cameras) FlxG.cameras.add(i.cam,i.defaultDraw);
	}

	inline public static function betterLerp(val:Float,desiredVal:Float,ratio:Float,constantRatio:Bool = false) {
		if (constantRatio) return FlxMath.lerp(val,desiredVal,ratio);
		else return FlxMath.lerp(val,desiredVal,ratio * 60 * FlxG.elapsed);
	}

    public static function addShader(shader:FlxShader,?camera:FlxCamera,forced:Bool = false)
    {
        if (!ClientPrefs.data.shaders && !forced) return;
        if (camera == null) camera = FlxG.camera;

        var filter:ShaderFilter = new ShaderFilter(shader);
        if (camera.filters == null) camera.filters = [];
        camera.filters.push(filter);
    }

    public static function removeShader(shader:FlxShader,?camera:FlxCamera):Bool
    {
        if (camera == null) camera = FlxG.camera;
        if (camera.filters == null) return false;

        for (i in camera.filters) {
            if (i is ShaderFilter) {
                var filter:ShaderFilter = cast i;
                if (filter.shader == shader) {camera.filters.remove(i); return true;}
            }
        }
        return false;
    }

	public static function addShaderFilter(shader:ShaderFilter,?camera:FlxCamera,forced:Bool = false)
	{
		if (!ClientPrefs.data.shaders && !forced) return;
		if (camera == null) camera = FlxG.camera;

		if (camera.filters == null) camera.filters = [];
		camera.filters.push(shader);
	}

	public static function removeShaderFilter(shader:ShaderFilter,?camera:FlxCamera):Bool
	{
		if (camera == null) camera = FlxG.camera;
		if (camera.filters == null) return false;

		for (i in camera.filters) {
			if (i is ShaderFilter) {
				if (i == shader) {camera.filters.remove(i); return true;}
			}
		}
		return false;
	}
}
