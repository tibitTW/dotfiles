// --- SDF Base Functions ---
float getSdfRectangle(in vec2 p, in vec2 xy, in vec2 b) {
    vec2 d = abs(p - xy) - b;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

float seg(in vec2 p, in vec2 a, in vec2 b, inout float s, float d) {
    vec2 e = b - a;
    vec2 w = p - a;
    vec2 proj = a + e * clamp(dot(w, e) / dot(e, e), 0.0, 1.0);
    float segd = dot(p - proj, p - proj);
    d = min(d, segd);

    float c0 = step(0.0, p.y - a.y);
    float c1 = 1.0 - step(0.0, p.y - b.y);
    float c2 = 1.0 - step(0.0, e.x * w.y - e.y * w.x);
    float allCond = c0 * c1 * c2;
    float noneCond = (1.0 - c0) * (1.0 - c1) * (1.0 - c2);
    float flip = mix(1.0, -1.0, step(0.5, allCond + noneCond));
    s *= flip;
    return d;
}

float getSdfParallelogram(in vec2 p, in vec2 v0, in vec2 v1, in vec2 v2, in vec2 v3) {
    float s = 1.0;
    float d = dot(p - v0, p - v0);
    d = seg(p, v0, v3, s, d);
    d = seg(p, v1, v0, s, d);
    d = seg(p, v2, v1, s, d);
    d = seg(p, v3, v2, s, d);
    return s * sqrt(d);
}

// --- Utility Functions ---
vec2 norm(vec2 value, float isPosition) {
    return (value * 2.0 - (iResolution.xy * isPosition)) / iResolution.y;
}

float determineStartVertexFactor(vec2 c, vec2 p) {
    float condition1 = step(p.x, c.x) * step(c.y, p.y);
    float condition2 = step(c.x, p.x) * step(p.y, c.y);
    return 1.0 - max(condition1, condition2);
}

float isLess(float c, float p) {
    return 1.0 - step(p, c);
}

vec2 getRectangleCenter(vec4 rectangle) {
    return vec2(rectangle.x + (rectangle.z / 2.), rectangle.y - (rectangle.w / 2.));
}

float ease(float x) {
    return pow(1.0 - x, 3.0);
}

// --- Independent Color and Duration Definitions ---
// Color Set 1 (Reverted to Cyan/Blue)
const vec4 T1_COLOR = vec4(1.0, 0.725, 0.161, 1.0);
const vec4 T1_ACCENT = vec4(1.0, 0., 0., 1.0);
const float DURATION_1 = 0.3;

// Color Set 2 (Reverted to Orange/Red)
const vec4 T2_COLOR = vec4(.502, 0.98, 1., 1.0);
const vec4 T2_ACCENT = vec4(.0, 0., 1., 1.0);
const float DURATION_2 = 0.35; // Longer duration creates a lingering delay effect

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    // Sample background texture
    vec4 bg = texture(iChannel0, fragCoord.xy / iResolution.xy);
    vec2 vu = norm(fragCoord, 1.);
    vec2 offsetFactor = vec2(-.5, 0.5);

    // Normalize cursor positions and sizes
    vec4 currentCursor = vec4(norm(iCurrentCursor.xy, 1.), norm(iCurrentCursor.zw, 0.));
    vec4 previousCursor = vec4(norm(iPreviousCursor.xy, 1.), norm(iPreviousCursor.zw, 0.));

    vec2 centerCC = getRectangleCenter(currentCursor);
    vec2 centerCP = getRectangleCenter(previousCursor);
    
    float vertexFactor = determineStartVertexFactor(currentCursor.xy, previousCursor.xy);
    float invVF = 1.0 - vertexFactor;
    float xFactor = isLess(previousCursor.x, currentCursor.x);
    float yFactor = isLess(currentCursor.y, previousCursor.y);

    // Vertex calculation for Trail 1 (Point-to-center logic)
    vec2 t1_v0 = vec2(currentCursor.x + currentCursor.z * vertexFactor, currentCursor.y - currentCursor.w);
    vec2 t1_v1 = vec2(currentCursor.x + currentCursor.z * xFactor, currentCursor.y - currentCursor.w * yFactor);
    vec2 t1_v2 = vec2(currentCursor.x + currentCursor.z * invVF, currentCursor.y);
    vec2 t1_v3 = centerCP;

    // Vertex calculation for Trail 2 (Full parallelogram logic)
    vec2 t2_v0 = vec2(currentCursor.x + currentCursor.z * vertexFactor, currentCursor.y - currentCursor.w);
    vec2 t2_v1 = vec2(currentCursor.x + currentCursor.z * invVF, currentCursor.y);
    vec2 t2_v2 = vec2(previousCursor.x + currentCursor.z * invVF, previousCursor.y);
    vec2 t2_v3 = vec2(previousCursor.x + currentCursor.z * vertexFactor, previousCursor.y - previousCursor.w);

    // Calculate SDFs for shapes
    float sdfCursor = getSdfRectangle(vu, currentCursor.xy - (currentCursor.zw * offsetFactor), currentCursor.zw * 0.5);
    float sdfT1 = getSdfParallelogram(vu, t1_v0, t1_v1, t1_v2, t1_v3);
    float sdfT2 = getSdfParallelogram(vu, t2_v0, t2_v1, t2_v2, t2_v3);

    // Independent progress calculations for each color layer
    float p1 = clamp((iTime - iTimeCursorChange) / DURATION_1, 0.0, 1.0);
    float p2 = clamp((iTime - iTimeCursorChange) / DURATION_2, 0.0, 1.0);
    
    float lineLength = distance(centerCC, centerCP);
    float mod = .007;

    // 1. Build Trail 2 (Orange-red)
    vec4 trail2Col = mix(T2_ACCENT, bg, 1. - smoothstep(0., sdfT2 + mod, 0.007));
    trail2Col = mix(T2_COLOR, trail2Col, 1. - smoothstep(0., sdfT2 + mod, 0.006));
    trail2Col = mix(trail2Col, T2_COLOR, step(sdfT2 + mod, 0.));

    // 2. Build Trail 1 (Cyan-blue) layered on top of Trail 2
    vec4 trail1Col = mix(T1_ACCENT, trail2Col, 1. - smoothstep(0., sdfT1 + mod, 0.007));
    trail1Col = mix(T1_COLOR, trail1Col, 1. - smoothstep(0., sdfT1 + mod, 0.006));
    trail1Col = mix(trail1Col, T1_COLOR, step(sdfT1 + mod, 0.));

    // 3. Handle Cursor core glow
    vec4 cursorEffect = trail1Col;
    cursorEffect = mix(T2_ACCENT, cursorEffect, 1. - smoothstep(0., sdfCursor + .002, 0.004));
    cursorEffect = mix(T1_COLOR, cursorEffect, 1. - smoothstep(0., sdfCursor + .002, 0.004));

    // 4. Final compositing with different duration fades
    // First, blend Trail 2 with the background based on p2
    vec4 finalT2 = mix(trail2Col, bg, 1. - smoothstep(0., sdfCursor, ease(p2) * lineLength));
    // Then, overlay Trail 1 and Cursor core based on p1
    fragColor = mix(cursorEffect, finalT2, 1. - smoothstep(0., sdfCursor, ease(p1) * lineLength));
}