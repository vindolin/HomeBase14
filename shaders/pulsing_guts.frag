#version 460 core
precision mediump float;

layout(location=0) out vec4 fragColor;
layout(location=0) uniform float iTime;
layout(location=1) uniform vec2 iResolution;

// parameters
layout(location=2) uniform vec3 color;

vec2 fragCoord = gl_FragCoord.xy;

// Original Shadertoy code:
// Pulsing Guts - https://www.shadertoy.com/view/clXXDl
/*************************************************************************************************/

mat2 rotate2D(float r) {
    return mat2(cos(r), sin(r), -sin(r), cos(r));
}

void main()
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = (fragCoord-.5*iResolution.xy)/iResolution.y;
    vec3 col = vec3(0);
    float t = iTime;

    vec2 n = vec2(0);
    vec2 q = vec2(0);
    vec2 p = uv;
    float d = dot(p,p);
    float S = 12.;
    float a = 0.0;
    mat2 m = rotate2D(5.);

    for (float j = 0.; j < 20.; j++) {
        p *= m;
        n *= m;
        q = p * S + t * 4. + sin(t * 4. - d * 6.) * .8 + j + n; // wtf???
        a += dot(cos(q)/S, vec2(.2));
        n -= sin(q);
        S *= 1.2;
    }

    col = color * (a + .2) + a + a - d;


    // Output to screen
    fragColor = vec4(col,1.0);
}
