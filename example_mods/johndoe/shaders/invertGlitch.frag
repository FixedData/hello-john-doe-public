//https://www.shadertoy.com/view/mtsXz7

#pragma header

uniform float AMT;
uniform float SPEED;
uniform float iTime;
uniform bool isActive;

float random2d(vec2 n){
    return fract(sin(dot(n,vec2(12.9898,4.1414)))*43758.5453);
}

float randomRange(in vec2 seed,in float min,in float max){
    return min+random2d(seed)*(max-min);
}

float insideRange(float v,float bottom,float top){
    return step(bottom,v)-step(top,v);
}

void main()
{
    float time=floor(iTime*SPEED);

    vec2 uv = openfl_TextureCoordv;
    vec4 outCol=flixel_texture2D(bitmap,uv);

    
    float maxOffset=AMT/32.;
    for(float i=0.;i<10.*AMT;i+=.25){
        float sliceY=random2d(vec2(time,2345.+float(i)));
        float sliceH=random2d(vec2(time,925.+float(i)))*.075;
        float hOffset=randomRange(vec2(time,25.+float(i)),-maxOffset,maxOffset);
        vec2 uvOff=openfl_TextureCoordv.xy;
        uvOff.x+=hOffset;
        if(insideRange(openfl_TextureCoordv.y,sliceY,fract(sliceY+sliceH))==1.0){
            outCol=flixel_texture2D(bitmap,uvOff);
            //discard;
        }
        else {
            //outCol.rgba = 0.0;
            if (outCol.a != 0.0) {
                outCol.rgb = vec3(1.,1.,1.) - outCol.rgb;


            }
        }

        // if(insideRange(openfl_TextureCoordv.x,sliceH * 24.0,fract(sliceY + sliceH))==1.0){
        //     outCol.rgba = 0.0;
        // }


    }


    if (isActive) {
        if (outCol.rgba == vec4(0.0,0.0,0.0,0.0)) discard;
        gl_FragColor=outCol;
    }
    else {
        gl_FragColor = flixel_texture2D(bitmap,openfl_TextureCoordv);
    }

}

