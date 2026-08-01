// Flutter FragmentProgram Shader Examples
// These GLSL files compile with Flutter 3.7+ FragmentProgram
// Place in assets/shaders/ and reference in pubspec.yaml:
// flutter:
//   shaders:
//     - assets/shaders/aurora.frag

// ============================================================
// 1. AURORA BOREALIS EFFECT
// ============================================================
// assets/shaders/aurora.frag
#version 460 core
#include <flutter/runtime_effect.glsl>

uniform float u_time;
uniform vec2 u_resolution;

out vec4 fragColor;

// Simplex noise helper
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    f = f * f * (3.0 - 2.0 * f);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

float fbm(vec2 p) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        value += amplitude * noise(p);
        p *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

void main() {
    vec2 uv = FlutterFragCoord().xy / u_resolution;
    float t = u_time * 0.3;

    // Aurora bands
    float y = uv.y;
    float aurora = fbm(vec2(uv.x * 3.0 + t * 0.5, y * 2.0 + t * 0.3));
    aurora *= smoothstep(0.2, 0.5, y) * smoothstep(0.9, 0.6, y);

    // Color bands
    vec3 green = vec3(0.1, 0.8, 0.4);
    vec3 cyan = vec3(0.1, 0.6, 0.8);
    vec3 purple = vec3(0.5, 0.1, 0.8);
    vec3 color = mix(green, cyan, sin(aurora * 3.14 + t) * 0.5 + 0.5);
    color = mix(color, purple, aurora * 0.3);

    float alpha = aurora * 0.6;
    fragColor = vec4(color * alpha, alpha);
}

// ============================================================
// 2. GRADIENT WAVE BACKGROUND
// ============================================================
// assets/shaders/wave_gradient.frag
#version 460 core
#include <flutter/runtime_effect.glsl>

uniform float u_time;
uniform vec2 u_resolution;

out vec4 fragColor;

void main() {
    vec2 uv = FlutterFragCoord().xy / u_resolution;

    // Wave distortion
    float wave1 = sin(uv.x * 6.28 + u_time) * 0.1;
    float wave2 = cos(uv.x * 4.0 - u_time * 0.7) * 0.05;

    // Gradient based on distorted y
    float y = uv.y + wave1 + wave2;
    vec3 color1 = vec3(0.02, 0.02, 0.06);  // Near-black
    vec3 color2 = vec3(0.1, 0.0, 0.3);     // Deep purple
    vec3 color3 = vec3(0.0, 0.3, 0.2);     // Teal
    vec3 color = mix(color1, color2, smoothstep(0.0, 0.5, y));
    color = mix(color, color3, smoothstep(0.5, 1.0, y));

    fragColor = vec4(color, 1.0);
}

// ============================================================
// 3. NOISE/GRAIN TEXTURE
// ============================================================
// assets/shaders/noise_grain.frag
#version 460 core
#include <flutter/runtime_effect.glsl>

uniform float u_time;
uniform vec2 u_resolution;
uniform float u_opacity;

out vec4 fragColor;

float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

void main() {
    vec2 uv = FlutterFragCoord().xy / u_resolution;
    float grain = random(uv * u_resolution + u_time * 100.0);
    fragColor = vec4(vec3(grain), u_opacity * 0.15);
}

// ============================================================
// 4. GLASSMORPHISM BORDER GLOW
// ============================================================
// assets/shaders/glow_border.frag
#version 460 core
#include <flutter/runtime_effect.glsl>

uniform float u_time;
uniform vec2 u_resolution;
uniform vec2 u_center;
uniform float u_radius;

out vec4 fragColor;

void main() {
    vec2 uv = FlutterFragCoord().xy / u_resolution;
    vec2 center = u_center / u_resolution;

    float dist = distance(uv, center);
    float glow = smoothstep(u_radius, u_radius * 0.6, dist);
    float pulse = sin(u_time * 2.0) * 0.1 + 0.9;

    vec3 color = vec3(0.3, 0.6, 1.0) * glow * pulse;
    float alpha = glow * 0.5;

    fragColor = vec4(color, alpha);
}

// ============================================================
// 5. RIPPLE EFFECT
// ============================================================
// assets/shaders/ripple.frag
#version 460 core
#include <flutter/runtime_effect.glsl>

uniform float u_time;
uniform vec2 u_resolution;
uniform vec2 u_center;

out vec4 fragColor;

void main() {
    vec2 uv = FlutterFragCoord().xy / u_resolution;
    vec2 center = u_center / u_resolution;

    float dist = distance(uv, center);
    float ripple = sin(dist * 40.0 - u_time * 5.0) * 0.5 + 0.5;
    ripple *= smoothstep(0.5, 0.0, dist);

    vec3 color = vec3(0.4, 0.7, 1.0) * ripple;
    float alpha = ripple * 0.6;

    fragColor = vec4(color, alpha);
}

// ============================================================
// USAGE IN DART:
// ============================================================
// import 'dart:ui' as ui;
//
// class AuroraShader extends StatefulWidget {
//   @override
//   _AuroraShaderState createState() => _AuroraShaderState();
// }
//
// class _AuroraShaderState extends State<AuroraShader>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   ui.FragmentShader? _shader;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 10),
//     )..repeat();
//
//     _loadShader();
//   }
//
//   Future<void> _loadShader() async {
//     final program = await ui.FragmentProgram.fromAsset(
//       'assets/shaders/aurora.frag',
//     );
//     setState(() {
//       _shader = program.fragmentShader();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (_shader == null) return const SizedBox();
//     return AnimatedBuilder(
//       animation: _controller,
//       builder: (context, child) {
//         _shader!
//           ..setFloat(0, _controller.value * 10.0)  // u_time
//           ..setFloat(1, MediaQuery.of(context).size.width)   // u_width
//           ..setFloat(2, MediaQuery.of(context).size.height); // u_height
//         return CustomPaint(
//           painter: _ShaderPainter(_shader!),
//           size: MediaQuery.of(context).size,
//         );
//       },
//     );
//   }
// }
//
// class _ShaderPainter extends CustomPainter {
//   final ui.FragmentShader shader;
//   _ShaderPainter(this.shader);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     canvas.drawPaint(Paint()..shader = shader);
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }
