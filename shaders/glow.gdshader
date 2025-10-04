shader_type canvas_item;

uniform float outerRadius : hint_range(0.0, 5.0) = 1.0;
uniform float MainAlpha : hint_range(0.0, 1.0) = 1.0;
uniform vec4 glow_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

void fragment() {
    float x = abs(UV.x - 0.5) * 2.0;
    float y = abs(UV.y - 0.5) * 2.0;
    
    // Distance from center
    float dist = sqrt((x * x) + (y * y));
    
    // Invert the vignette: 1.0 at center, fades to 0 at outerRadius
    float v = 1.0 - (dist / outerRadius);
    v = clamp(v, 0.0, 1.0); // keep it in [0,1]
    
    COLOR = vec4(glow_color.rgb, v * MainAlpha);
}
