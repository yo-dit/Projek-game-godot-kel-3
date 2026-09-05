shader_type canvas_item;

// =====================================================
// DUSAT-OUT HORROR CRT OVERLAY
// ColorRect transparan
// =====================================================


// =====================================================
// VIGNETTE
// =====================================================

// Kekuatan gelap di pinggir
uniform float vignette_strength : hint_range(0.0, 2.0) = 0.75;

// Seberapa luas area tengah yang tetap terang
uniform float vignette_size : hint_range(0.1, 1.0) = 0.30;


// =====================================================
// CRT SCANLINES
// =====================================================

uniform float scanline_size : hint_range(1.0, 15.0) = 4.0;

uniform float scanline_strength : hint_range(0.0, 1.0) = 0.35;


// =====================================================
// CRT CURVATURE
// =====================================================

uniform float curvature : hint_range(0.0, 0.3) = 0.04;


// =====================================================
// VHS DISTORTION
// =====================================================

uniform float distortion_strength : hint_range(0.0, 0.05) = 0.004;

uniform float distortion_speed : hint_range(0.0, 20.0) = 5.0;


// =====================================================
// FILM GRAIN
// =====================================================

uniform float grain_strength : hint_range(0.0, 0.2) = 0.02;

uniform float grain_speed : hint_range(1.0, 60.0) = 15.0;


// =====================================================
// FLICKER
// =====================================================

uniform float flicker_strength : hint_range(0.0, 0.3) = 0.04;

uniform float flicker_speed : hint_range(1.0, 30.0) = 8.0;


// =====================================================
// FOG
// =====================================================

uniform float fog_strength : hint_range(0.0, 0.5) = 0.08;

uniform float fog_speed : hint_range(0.0, 1.0) = 0.025;

uniform float fog_scale : hint_range(0.5, 10.0) = 2.5;


// =====================================================
// RANDOM
// =====================================================

float random(vec2 p)
{
    return fract(
        sin(
            dot(
                p,
                vec2(12.9898, 78.233)
            )
        ) * 43758.5453
    );
}


// =====================================================
// NOISE
// =====================================================

float noise(vec2 p)
{
    vec2 i = floor(p);
    vec2 f = fract(p);

    f = f * f * (3.0 - 2.0 * f);

    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    return mix(
        mix(a, b, f.x),
        mix(c, d, f.x),
        f.y
    );
}


// =====================================================
// MAIN
// =====================================================

void fragment()
{
    vec2 uv = UV;


    // =================================================
    // CRT CURVATURE
    // =================================================

    vec2 centered = uv - vec2(0.5);

    float curve = dot(centered, centered);

    uv += centered * curve * curvature;


    // =================================================
    // VHS HORIZONTAL DISTORTION
    // =================================================

    float line = floor(uv.y * 150.0);

    float distortion = random(
        vec2(
            line,
            floor(TIME * distortion_speed)
        )
    );

    distortion =
        (distortion - 0.5)
        * distortion_strength;

    uv.x += distortion;


    // =================================================
    // CRT SCANLINES
    // =================================================

    float scanline_pattern = sin(
        uv.y *
        (500.0 / scanline_size) *
        3.14159
    );

    scanline_pattern =
        scanline_pattern * 0.5 + 0.5;


    // =================================================
    // FOG
    // =================================================

    vec2 fog_uv = uv * fog_scale;

    fog_uv.x += TIME * fog_speed;

    fog_uv.y +=
        sin(TIME * 0.2) * 0.05;

    float fog1 = noise(fog_uv);

    float fog2 = noise(
        fog_uv * 2.0 +
        TIME * 0.01
    );

    float fog =
        fog1 * 0.7 +
        fog2 * 0.3;

    fog = smoothstep(
        0.30,
        0.75,
        fog
    );


    // =================================================
    // STRONG VIGNETTE
    // =================================================

    vec2 vignette_center =
        uv - vec2(0.5);

    float distance_from_center =
        length(vignette_center);

    // Tengah terang
    // Pinggir gelap kuat
    float vignette = smoothstep(
        vignette_size,
        0.78,
        distance_from_center
    );


    // =================================================
    // FILM GRAIN
    // =================================================

    float grain = random(
        uv * 1000.0 +
        floor(TIME * grain_speed)
    );

    float grain_effect =
        (grain - 0.5) *
        grain_strength;


    // =================================================
    // FLICKER
    // =================================================

    float flicker_time =
        floor(TIME * flicker_speed);

    float flicker_random =
        random(vec2(flicker_time));

    float flicker = 0.0;


    // Kedipan ringan
    if (flicker_random > 0.82)
    {
        flicker =
            flicker_strength;
    }


    // Kedipan kuat sesekali
    if (flicker_random > 0.96)
    {
        flicker =
            flicker_strength * 2.5;
    }


    // =================================================
    // BUILD TRANSPARENT OVERLAY
    // =================================================

    float alpha = 0.0;


    // VIGNETTE KUAT
    alpha +=
        vignette *
        vignette_strength;


    // CRT SCANLINES
    alpha +=
        scanline_pattern *
        scanline_strength *
        0.45;


    // FOG
    alpha +=
        fog *
        fog_strength;


    // GRAIN
    alpha +=
        abs(grain_effect);


    // FLICKER
    alpha +=
        flicker;


    // Batas transparansi
    alpha = clamp(
        alpha,
        0.0,
        0.75
    );


    // =================================================
    // FINAL
    // =================================================

    COLOR = vec4(
        0.0,
        0.0,
        0.0,
        alpha
    );
}