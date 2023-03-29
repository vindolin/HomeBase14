// void mainImage( out vec4 fragColor, in vec2 fragCoord )
// {
//     // Normalized pixel coordinates (from 0 to 1)
//     vec2 uv = fragCoord/iResolution.xy;
//     uv -= 0.5;
//     uv.x *= iResolution.x / iResolution.y;
//     uv += 0.5;

//     // Draw a growing black circle with a white stroke
//     float r = mod(iTime, 2.5) / 2.5;
//     float d = length(uv - vec2(0.5));
//     float thickness = 0.01;
//     float col = smoothstep(0.0, thickness, abs(r-d));

//     // Output to screen
//     fragColor = vec4(col);
// }
