#version 460 core
precision mediump float;

layout(location=0) out vec4 fragColor;
layout(location=0) uniform float iTime;
layout(location=1) uniform vec2 iResolution;
layout(location=2) uniform vec3 light1;
layout(location=3) uniform vec3 light2;

vec2 fragCoord = gl_FragCoord.xy;

#define RADIANS 0.017453292519943295

const int zoom = 10;
const float brightness = 0.975;
float fScale = 1.25;

float cosRange(float degrees, float range, float minimum) {
	return (((1.5 + cos(degrees * RADIANS)) * 0.8) * range) + minimum;
}

void main()
{
	float time = iTime * 5.5;
	vec2 uv = fragCoord.xy / iResolution.xy;
	vec2 p  = (2.0*fragCoord.xy-iResolution.xy)/max(iResolution.x,iResolution.y);
	float ct = cosRange(time*5.0, 3.0, 1.1);
	float xBoost = cosRange(time*0.2, 10.0, 5.0);
	float yBoost = cosRange(time*0.1, 10.0, 5.0);

	fScale = cosRange(time * 15.5, 1.25, 0.5);

	for(int i=1;i<zoom;i++) {
		float _i = float(i);
		vec2 newp=p;
		newp.x+=0.25/_i*sin(_i*p.y+time*cos(ct)*0.5/20.0+0.005*_i)*fScale+xBoost;
		newp.y+=0.25/_i*sin(_i*p.x+time*ct*0.3/40.0+0.03*float(i+15))*fScale+yBoost;
		p=newp;
	}

	// vec3 col=vec3(0.5*sin(3.0*p.x)+0.5,0.5*sin(3.0*p.y)+0.5,sin(p.x+p.y));
	vec3 col=vec3(0.5*sin(3.0*p.x)+0.5,0.5*sin(3.0*p.y)+0.5,sin(p.x+p.y));
	col *= brightness;

    // Add border
    float vigAmt = 5.0;
    float vignette = (1.-vigAmt*(uv.y-.5)*(uv.y-.5))*(1.-vigAmt*(uv.x-.5)*(uv.x-.5));
	float extrusion = (col.x + col.y + col.z) / 4.0;
    extrusion *= 1.5;
    extrusion *= vignette;

	fragColor = vec4(col, extrusion);
}
