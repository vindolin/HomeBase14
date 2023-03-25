#version 460 core
precision mediump float;

layout(location=0) out vec4 fragColor;
layout(location=0) uniform float iTime;
layout(location=1) uniform vec2 iResolution;

// parameters
layout(location=2) uniform vec3 light1;
layout(location=3) uniform vec3 light2;

vec2 fragCoord = gl_FragCoord.xy;


// original from 𝚛𝚘𝚒𝚙𝚎𝚔𝚎
// https://twitter.com/roipekr/status/1527026419649454081
/*************************************************************************************************/

/// bigger iterations = blob sharpness, can't be passed as uniform, Skia requires
/// a const for loops.
//#define ITERATIONS 13.0
#define ITERATIONS 10.0
mat2 m(float a) {
  float c=cos(a), s=sin(a);
  return mat2(c,-s,s,c);
}
float map(vec3 p){
    p.xz *= m( iTime * 3.9 );
    p.xy *= m( iTime * 2.8 );
    vec3 q = p * 2.5 + iTime;
    return length( p + vec3( sin(iTime*0.7)))*log(length(p)+1.) + sin(q.x+sin(q.z+sin(q.y)))*0.5 - 1.;
}
void main() {
    vec2 p = gl_FragCoord.xy / iResolution.y - vec2(.5,.5);
    vec3 cl = vec3(0.);
    float d = .1;
    for(float i=0.0; i<=ITERATIONS; i++)	{
        /// size variance for the blob
        vec3 p = vec3( -0.5, 0, 5.) + normalize( vec3(p, -1.) ) * d;
        float rz = map(p);
        float f =  clamp((rz - map( p + .1)) * .5, -.1, .9 );
        vec3 l = light1 + light2 * f;
        /// smoothstep will change the outter "glow", adjust with ITERATIONS.
        cl = cl * l + smoothstep( 5.2, .15, rz ) * .9 * l;
        d += min( rz, 1. );
    }
    fragColor = vec4(0.25+cl, 1.);
}
