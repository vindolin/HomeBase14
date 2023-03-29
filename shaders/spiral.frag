#version 460 core
precision mediump float;

layout(location=0) out vec4 fragColor;
layout(location=0) uniform float iTime;
layout(location=1) uniform vec2 iResolution;

// Original Shadertoy code:
// Spiral #6 - https://www.shadertoy.com/view/dddGWB
/*************************************************************************************************/

vec2 fragCoord = gl_FragCoord.xy;

#define bpm 120.
#define speed .5

#define AA 4.

#define pi 3.14159265359
#define time (speed*(bpm/60.)*iTime)
//#define time (mod(speed*(bpm/60.)*iTime, 2.)) // 2s loop with default settings

// https://lospec.com/palette-list/1bit-monitor-glow
vec3 col1 = vec3(.133, .137, .137);
vec3 col2 = vec3(.941, .965, .941);

void main()
{
    vec2 uv = (fragCoord - .5 * iResolution.xy) / iResolution.y;

    float aa_falloff = 12. * pow(1.3 - length(uv), 2.);

    float angle = atan(uv.y, uv.x) / (pi * .5);
    float len = log(length(uv));

    float t1 = fract(time * .25);
    uv = vec2(angle, len - t1);

    float tiling = 4.;
    vec2 flip = step(.5, fract(uv * tiling * .5)) * 2. - 1.;
    uv = fract(uv * tiling);

    float t2 = fract(time * .5);
    if (uv.x > uv.y) {
        uv += flip.x * flip.y * t2;
    } else {
        uv -= flip.x * flip.y * t2;
    }

    uv = fract(uv + .5) - .5;
    uv = abs(uv);
    float mask = smoothstep(0., aa_falloff * AA / iResolution.x, uv.y - uv.x - .03);
    vec3 col = mix(col1, col2, mask);

    fragColor = vec4(col, 1.0);
}