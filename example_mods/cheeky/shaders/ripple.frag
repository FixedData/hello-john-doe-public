#pragma header

uniform float ratio;
uniform float iTime;
// Based on Adrian Boeing's blog: Ripple effect in WebGL, published on February 07, 2011
// http://adrianboeing.blogspot.com/2011/02/ripple-effect-in-webgl.html
void main()
{
    vec2 oguv = openfl_TextureCoordv.xy;

    vec2 cp = -1.0 + 2.0 * openfl_TextureCoordv.xy;
    float cl = length(cp);
    vec2 uv = openfl_TextureCoordv.xy + (cp / cl) * cos(cl * 12.0 - iTime * 4.0) * 0.02;

    // uv.x = uv.x * 0.9;
    // uv.y = uv.y * 0.9;

    vec2 finaluv = mix(oguv,uv,ratio);
    gl_FragColor = flixel_texture2D(bitmap, finaluv);
}