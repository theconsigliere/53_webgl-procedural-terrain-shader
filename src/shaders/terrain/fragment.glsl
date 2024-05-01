uniform vec3 uColorWaterDeep;
uniform vec3 uColorWaterSurface;
uniform vec3 uColorSand;
uniform vec3 uColorGrass;
uniform vec3 uColorSnow;
uniform vec3 uColorRock;

varying vec3 vPosition;
varying float vUpDot;

#include ../includes/simplexNoise2d.glsl

void main()
 {

    // Color
    vec3 color = vec3(1.0);

    // Water
    // We want to mix between the uColorWaterDeep and the uColorWaterSurface when the vPosition.y goes from -1.0 to -0.1
    float surfaceWaterMix = smoothstep(- 1.0, - 0.1, vPosition.y);
    color = mix(uColorWaterDeep, uColorWaterSurface, surfaceWaterMix);


    // Sand
    // uase a step for a hard edge between the sand and the grass with a threshold of -0.1
    float sandMix = step(- 0.1, vPosition.y);
    color = mix(color, uColorSand, sandMix);


    // Grass
    float grassMix = step(- 0.06, vPosition.y);
    color = mix(color, uColorGrass, grassMix);

     // Rock
    float rockMix = vUpDot;
    rockMix = 1.0 - step(0.8, rockMix);
    // remove rock from water
    rockMix *= step(- 0.06, vPosition.y);
    color = mix(color, uColorRock, rockMix);

    // Snow
    // create qwavy snow border with simpled noise
    float snowThreshold = 0.45;
    snowThreshold += simplexNoise2d(vPosition.xz * 15.0) * 0.1;
    float snowMix = step(snowThreshold, vPosition.y);
    color = mix(color, uColorSnow, snowMix);

    // Final color
    csm_DiffuseColor = vec4(color, 1.0);
 }