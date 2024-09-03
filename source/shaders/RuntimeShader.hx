package shaders;


import psychlua.LuaUtils;
import openfl.display.ShaderParameter;
import flixel.addons.display.FlxRuntimeShader;


class RuntimeShader extends FlxRuntimeShader
{
	

	public var tag:String = '';

	private var tweenMap:Map<String, FlxTween> = new Map();
    

	/**
	 * Tween a float parameter of the shader.
	 * @param name The name of the parameter to tween.
	 * @param toValue The new value to use.
	 * @param time time it takes to tween
	 * @param ease FlxEase to use
	 */
	public function tweenFloat(name:String, toValue:Float, time:Float, options:TweenOptions):Void
	{
	
		var prop:ShaderParameter<Float> = Reflect.field(this.data, name);
		
		if (prop == null)
		{
			trace('[WARN] Shader float property ${name} not found.');
			return;
		}
		if (prop.value == null) {
			setFloat(name,0);
			trace('[WARN] Shader float property ${name} not set. Setting to 0.');
			//return;
		}

		if (tweenMap.get(name) != null) {
			tweenMap.get(name).cancel();
			tweenMap.remove(name);
		}

        tweenMap.set(name,FlxTween.num(getFloat(name),toValue,time, {ease: options.ease, startDelay: options.startDelay,type: options.type, 
            onUpdate: (update:FlxTween)->{
                if (options.onUpdate != null) options.onUpdate(update);
            },
            onComplete:(complete:FlxTween)->{
                tweenMap.remove(name);
                if (options.onComplete != null) options.onComplete(complete);
            }}, (val:Float)->{
                setFloat(name,val);
            }));
		
	}

	public var updateiTime(default,set):Bool = false;
	private var iTimeIndex:Int = -1;

	private function set_updateiTime(value:Bool):Bool //data todo make itime removable
	{
        var curState:Dynamic = FlxG.state;

        if (curState is MusicBeatState) {
            curState = cast(curState,MusicBeatState);
        }
        else return false;

		if (value) {

            iTimeIndex = curState.iTimeUpdates.push(this);
			return true;
		}
		else {
			if (iTimeIndex != -1) {
                curState.iTimeUpdates.splice(0,iTimeIndex);
			}

			return false;
		}

	}



}