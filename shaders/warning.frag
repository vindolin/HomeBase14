#version 460 core
precision mediump float;

layout(location=0) out vec4 fragColor;
layout(location=0) uniform float iTime;
layout(location=1) uniform vec2 iResolution;

vec2 fragCoord = gl_FragCoord.xy;

// Original Shadertoy code:
//  WARNING SIGN - https://www.shadertoy.com/view/Wl2fWV
/*************************************************************************************************/


void main() {
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord/iResolution.xy;

    //constructing stripe
    ivec2 stripe = ivec2(int(fragCoord.x + fragCoord.y), int(fragCoord.x - fragCoord.y));
    //moving speed
    float speed = 50.;
    vec2 move = vec2(iTime, -iTime) * speed;
    stripe += ivec2(move);
   	// stripe = abs(stripe);
    //lines width
    int width = 80;
    vec2 samples = mod(stripe, width);
	vec2 space = step(float(width) / 2., samples);

    // lines bound
    vec2 bound = vec2(step(.8, uv.y), step(uv.y, .2));
    float stripeBool = dot(space, bound);

    float border = step(.2, uv.y) * step(uv.y, .8);
    float line1 = step(uv.y, .80) * step(.76, uv.y) + step(uv.y, .24) * step(.20, uv.y);
    float line2 = step(uv.y, .76) * step(.72, uv.y) + step(uv.y, .28) * step(.24, uv.y);

    float flash = step(fract(iTime), .5);

    float lineBool = (line1 * flash + (0.8 - flash) * (0.8 - line1) +
                (line2 * (0.8 - flash) + flash * (0.8 - line2))) * (line1 + line2);

    float flash1 = (sin(iTime * 12.) + 1.) / 2.;
    vec3 c = vec3(1., 0.7, 0.) * (stripeBool + lineBool) * flash1;
    // Output to screen
    fragColor = vec4(c,1.0);
}
