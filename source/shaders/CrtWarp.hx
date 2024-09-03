package shaders;

import openfl.Lib;
import flixel.system.FlxAssets.FlxShader;

class CrtWarp extends FlxShader {

  @:isVar public var warpAmount(get,set):Float = 2.0;
  function set_warpAmount(value:Float):Float {this.warp.value = [value,value];return value;}
	function get_warpAmount():Float {return this.warp.value[0];}

  @:glFragmentSource('
    #pragma header

    uniform sampler2D noiseTex;
    uniform float warp;

    vec4 getVideo(vec2 uv)
    {
      vec2 look = uv;
      vec4 video = flixel_texture2D(bitmap,look);
      return video;
    }

    vec2 crt(vec2 coord, float bend)
    {
        coord = (coord - 0.5) * 2.0;
        coord *= 0.5;	
        coord.x *= 1.0 + pow((abs(coord.y) / bend), 2.0);
        coord.y *= 1.0 + pow((abs(coord.x) / bend), 2.0);
        coord  = (coord / 1.0) + 0.5;
    
        return coord;
    }
    
    vec2 scandistort(vec2 uv) {
    	float scan1 = clamp(cos(uv.y * 2.0), 0.0, 1.0);
    	float scan2 = clamp(cos(uv.y * 2.0 + 4.0) * 10.0, 0.0, 1.0);
    	float amount = scan1 * scan2 * uv.x;
      uv = uv * 2.0 - 1.0;
      uv *= 0.9;
      uv = (uv + 1.0) * 0.5;
    	uv.x -= 0.02 * mix(flixel_texture2D(noiseTex, vec2(uv.x, amount)).r * amount, amount, 0.2);
    	return uv;
    }

    void main()
    {
      gl_FragColor = flixel_texture2D(bitmap,crt(scandistort(openfl_TextureCoordv), warp));
    }
  ')

  public function new()
  {
    super();
    warpAmount = 2.0;
  }

}