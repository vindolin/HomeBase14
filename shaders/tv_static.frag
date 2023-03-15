precision mediump float;
layout(location=0) out vec4 fragColor;
layout(location=0) uniform float iTime;
layout(location=1) uniform vec2 iResolution;

vec2 fragCoord = gl_FragCoord.xy;

// Original Shadertoy code:
//  TV / VHS noise static - https://www.shadertoy.com/view/tsX3RN

float maxStrength = 0.7;
float minStrength = 0.525;

float speed = 10.00;

float random (vec2 noise)
{
    //--- Noise: Low Static (X axis) ---
    //return fract(sin(dot(noise.yx,vec2(0.000128,0.233)))*804818480.159265359);

    //--- Noise: Low Static (Y axis) ---
    //return fract(sin(dot(noise.xy,vec2(0.000128,0.233)))*804818480.159265359);

  	//--- Noise: Low Static Scanlines (X axis) ---
    //return fract(sin(dot(noise.xy,vec2(98.233,0.0001)))*925895933.14159265359);

   	//--- Noise: Low Static Scanlines (Y axis) ---
    //return fract(sin(dot(noise.xy,vec2(0.0001,98.233)))*925895933.14159265359);

    //--- Noise: High Static Scanlines (X axis) ---
    //return fract(sin(dot(noise.xy,vec2(0.0001,98.233)))*12073103.285);

    //--- Noise: High Static Scanlines (Y axis) ---
    //return fract(sin(dot(noise.xy,vec2(98.233,0.0001)))*12073103.285);

    //--- Noise: Full Static ---
    return fract(sin(dot(noise.xy,vec2(10.998,98.233)))*12433.14159265359);
}

void main() {
    vec2 uv2 = fract(fragCoord.xy/iResolution.xy*fract(sin(iTime*speed)));

    //--- Strength animate ---
    maxStrength = clamp(sin(iTime/2.0),minStrength,maxStrength);
    //-----------------------

    //--- Black and white ---
    vec3 color = vec3(random(uv2.xy))*maxStrength;
    //-----------------------

    /*
    //--- Color ---
    color.r *= random_color(sin(iTime*speed));
    color.g *= random_color(cos(iTime*speed));
    color.b *= random_color(tan(iTime*speed));
    //--------------
    */

    //--- Background ---
    // vec3 background = vec3(texture(iChannel0, uv));
    //--------------

    fragColor = vec4(color, 1.0);
}
