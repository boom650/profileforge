# Flutter FragmentProgram (Shaders) Research

## 1. How FragmentProgram Works in Flutter 3.x

### Overview
Flutter's `FragmentProgram` API (stable since Flutter 3.7) lets you load and execute GLSL fragment shaders directly in Dart. Each shader runs on the GPU as a per-pixel program.

### Loading a .frag GLSL file
```dart
import 'dart:ui' as ui;

// Load from assets (declared in pubspec.yaml under flutter: assets:)
final program = await ui.FragmentProgram.fromAsset('shaders/my_shader.frag');

// Create a shader from the program
final shader = program.fragmentShader();
// Set uniforms
shader.setFloat(0, time);           // uniform float uTime
shader.setFloat(1, resolution.x);   // uniform vec2 uResolution
shader.setImageSampler(0, image);   // uniform sampler2D uTexture (if needed)
```

### pubspec.yaml declaration
```yaml
flutter:
  shaders:
    - shaders/my_shader.frag
```

### GLSL shader format (Flutter uses GLSL ES 1.0 / SkSL)
```glsl
#version 460 core  // or just use SkSL conventions

#include <flutter/runtime_effect.glsl>

uniform float uTime;
uniform vec2 uResolution;

out vec4 fragColor;

void main() {
    vec2 uv = FlutterFragCoord().xy / uResolution;
    // ... shader logic ...
    fragColor = vec4(color, 1.0);
}
```

**Key point**: Use `FlutterFragCoord()` instead of `gl_FragCoord`. 
The `#include <flutter/runtime_effect.glsl>` directive is required.

### Drawing with shader in CustomPaint
```dart
class ShaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ShaderPainter(),
      size: Size.infinite,
    );
  }
}

class ShaderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final program = /* loaded fragment program */;
    final shader = program.fragmentShader();
    shader.setFloat(0, time);
    shader.setFloat(1, size.width);
    shader.setFloat(2, size.height);
    
    final paint = Paint()..shader = shader;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }
}
```

---

## 2. Aurora Borealis Shader Effect

```glsl
#version 460 core
#include <flutter/runtime_effect.glsl>

uniform float uTime;
uniform vec2 uResolution;

out vec4 fragColor;

// Simplex noise helper
vec3 permute(vec3 x) { return mod(((x*34.0)+1.0)*x, 289.0); }

float snoise(vec2 v) {
    const vec4 C = vec4(0.211324865405187, 0.366025403784439,
                       -0.577350269189626, 0.024390243902439);
    vec2 i = floor(v + dot(v, C.yy));
    vec2 x0 = v - i + dot(i, C.xx);
    vec2 i1 = (x0.x > x0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
    vec4 x12 = x0.xyxy + C.xxzz;
    x12.xy -= i1;
    i = mod(i, 289.0);
    vec3 p = permute(permute(i.y + vec3(0.0, i1.y, 1.0))
      + i.x + vec3(0.0, i1.x, 1.0));
    vec3 m = max(0.5 - vec3(dot(x0,x0), dot(x12.xy,x12.xy),
      dot(x12.zw,x12.zw)), 0.0);
    m = m*m; m = m*m;
    vec3 x = 2.0 * fract(p * C.www) - 1.0;
    vec3 h = abs(x) - 0.5;
    vec3 ox = floor(x + 0.5);
    vec3 a0 = x - ox;
    m *= 1.79284291400159 - 0.85373472095314 * (a0*a0 + h*h);
    vec3 g;
    g.x = a0.x * x0.x + h.x * x0.y;
    g.yz = a0.yz * x12.xz + h.yz * x12.yw;
    return 130.0 * dot(m, g);
}

void main() {
    vec2 uv = FlutterFragCoord().xy / uResolution;
    float t = uTime * 0.3;
    
    // Multiple noise layers for aurora
    float n1 = snoise(vec2(uv.x * 2.0 + t * 0.5, uv.y * 1.5)) * 0.5 + 0.5;
    float n2 = snoise(vec2(uv.x * 3.0 - t * 0.3, uv.y * 2.0 + 10.0)) * 0.5 + 0.5;
    float n3 = snoise(vec2(uv.x * 1.5 + t * 0.2, uv.y * 0.8 + 20.0)) * 0.5 + 0.5;
    
    // Aurora shape - concentrated in upper portion
    float band = smoothstep(0.0, 0.4, uv.y) * smoothstep(1.0, 0.5, uv.y);
    float aurora = band * (n1 * 0.5 + n2 * 0.3 + n3 * 0.2);
    
    // Color: green-cyan-purple gradient
    vec3 green = vec3(0.1, 0.9, 0.4);
    vec3 cyan = vec3(0.2, 0.8, 0.8);
    vec3 purple = vec3(0.5, 0.2, 0.8);
    
    vec3 color = mix(green, cyan, n1);
    color = mix(color, purple, n2 * 0.3);
    color *= aurora * 0.8;
    
    // Dark sky background
    vec3 sky = vec3(0.02, 0.02, 0.05);
    color = mix(sky, color, aurora);
    
    // Stars
    float star = step(0.998, fract(sin(dot(floor(uv * 200.0), vec2(12.9898,78.233))) * 43758.5453));
    color += star * 0.5 * (1.0 - aurora);
    
    fragColor = vec4(color, 1.0);
}
```

---

## 3. Gradient Wave Shader

```glsl
#version 460 core
#include <flutter/runtime_effect.glsl>

uniform float uTime;
uniform vec2 uResolution;

out vec4 fragColor;

void main() {
    vec2 uv = FlutterFragCoord().xy / uResolution;
    float t = uTime;
    
    // Multiple sine waves
    float wave1 = sin(uv.x * 6.0 + t * 1.5) * 0.1;
    float wave2 = sin(uv.x * 4.0 - t * 0.8 + 1.5) * 0.08;
    float wave3 = sin(uv.x * 8.0 + t * 2.0 + 3.0) * 0.05;
    
    float combinedWave = uv.y + wave1 + wave2 + wave3;
    
    // Gradient colors
    vec3 color1 = vec3(0.95, 0.2, 0.5);  // Hot pink
    vec3 color2 = vec3(0.3, 0.1, 0.9);   // Deep purple
    vec3 color3 = vec3(0.1, 0.8, 0.9);   // Cyan
    
    float gradientT = combinedWave;
    vec3 color = mix(color1, color2, smoothstep(0.2, 0.5, gradientT));
    color = mix(color, color3, smoothstep(0.6, 0.9, gradientT));
    
    // Soft edge fade
    color *= smoothstep(-0.1, 0.2, combinedWave) * smoothstep(1.1, 0.8, combinedWave);
    
    fragColor = vec4(color, 1.0);
}
```

---

## 4. Glow/Bloom Effect Shader

```glsl
#version 460 core
#include <flutter/runtime_effect.glsl>

uniform float uTime;
uniform vec2 uResolution;
uniform sampler2D uTexture;  // Source image to bloom

out vec4 fragColor;

vec4 blur(sampler2D tex, vec2 uv, vec2 dir) {
    vec4 color = vec4(0.0);
    float weights[5] = float[](0.227027, 0.1945946, 0.1216216, 0.054054, 0.016216);
    float offsets[5] = float[](0.0, 1.384615, 3.230769, 5.176923, 7.023077);
    
    color += texture(tex, uv) * weights[0];
    for (int i = 1; i < 5; i++) {
        vec2 offset = dir * offsets[i] / uResolution;
        color += texture(tex, uv + offset) * weights[i];
        color += texture(tex, uv - offset) * weights[i];
    }
    return color;
}

void main() {
    vec2 uv = FlutterFragCoord().xy / uResolution;
    
    // Two-pass blur simulated in single pass (approximate)
    vec4 original = texture(uTexture, uv);
    vec4 blurredH = blur(uTexture, uv, vec2(1.0, 0.0));
    vec4 blurredV = blur(uTexture, uv, vec2(0.0, 1.0));
    vec4 blurred = (blurredH + blurredV) * 0.5;
    
    // Bloom: extract bright areas, blur, add back
    float bloomThreshold = 0.7;
    vec4 bloom = max(blurred - bloomThreshold, 0.0) * 2.0;
    
    // Pulse bloom intensity with time
    float pulse = sin(uTime * 2.0) * 0.2 + 0.8;
    
    vec4 result = original + bloom * pulse;
    fragColor = result;
}
```

---

## 5. Performance Considerations

- **GPU-bound**: Shaders run per-pixel. Large canvases = more GPU work.
- **Impeller vs Skia**: Impeller (Flutter 3.16+ iOS, 3.19+ Android) pre-compiles shaders at build time, eliminating shader compilation jank. Skia compiles at runtime → first-frame stutters.
- **Avoid in lists**: Don't put shader-powered widgets inside scrollable lists.
- **Resolution scaling**: Render at lower resolution, scale up → cheaper:
  ```dart
  Transform.scale(
    scale: 0.5, // render at half res
    child: ShaderWidget(),
  )
  ```
- **RepaintBoundary**: Wrap shader widgets in `RepaintBoundary` to isolate repaints.
- **Avoid texture sampling when possible**: Uniform-only shaders are cheapest.
- **Mobile GPU limits**: Fragment texture lookups limited (typically 8-16 per fragment).
- **Profile mode only**: Always benchmark in `--profile`, never `--debug`.
- **60fps budget**: Each frame has ~16.67ms. Simple shaders: 1-2ms. Complex noise: 5-8ms.

---

## 6. Loading .frag GLSL Files in Flutter

### Steps
1. Place `.frag` files in `lib/shaders/` or `assets/shaders/`
2. Declare in `pubspec.yaml`:
   ```yaml
   flutter:
     shaders:
       - shaders/my_shader.frag
   ```
3. Load asynchronously:
   ```dart
   final program = await ui.FragmentProgram.fromAsset('shaders/my_shader.frag');
   ```
4. Create shader instance, set uniforms, use in `CustomPainter`

### Uniform types
| GLSL Type | Dart Method |
|-----------|------------|
| `float` | `shader.setFloat(index, value)` |
| `vec2` | Two `setFloat` calls (index, index+1) |
| `vec3` | Three `setFloat` calls |
| `vec4` | Four `setFloat` calls |
| `sampler2D` | `shader.setImageSampler(index, image)` |

### Common gotcha
- `FragmentProgram.fromAsset` is async — must `await` before painting.
- Cache the program object; only create new `fragmentShader()` per frame.
- The `index` for uniforms is sequential across all uniforms (floats AND samplers interleaved).

---

## 7. CustomPainter-Based Visual Effects (No Shaders)

When shaders aren't needed or aren't available (web with some limitations):

### Gradient Wave with CustomPainter
```dart
class WavePainter extends CustomPainter {
  final double time;
  WavePainter(this.time);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(0, size.height * 0.3),
        Offset(0, size.height * 0.7),
        [Colors.pink, Colors.purple, Colors.cyan],
      );

    final path = Path()..moveTo(0, size.height);
    for (double x = 0; x <= size.width; x++) {
      double y = size.height * 0.5
        + sin(x * 0.02 + time) * 30
        + sin(x * 0.01 - time * 0.5) * 20;
      path.lineTo(x, y);
    }
    path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(WavePainter old) => old.time != time;
}
```

### Glow Effect with CustomPainter
```dart
class GlowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20)
      ..color = Colors.blue.withOpacity(0.5);
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      40,
      paint,
    );
    // Sharp inner circle
    paint..maskFilter = null..color = Colors.white;
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      30,
      paint,
    );
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
```

---

## 8. When to Use What

| Feature | Use When | Avoid When |
|---------|----------|-----------|
| **FragmentProgram (shaders)** | Complex per-pixel effects (aurora, noise fields, image processing, custom gradients with math), GPU acceleration needed | Simple shapes, basic gradients, mobile perf is critical and shader is complex |
| **CustomPainter** | Medium-complexity 2D effects (waves, particles, glow), canvas drawing, data visualization, need CPU fallback | Real-time per-pixel math, image processing, need WebGL-level GPU |
| **AnimatedBuilder** | Simple property animations (opacity, position, scale), widget-based UI transitions, when no custom drawing needed | Complex canvas/GPU effects, particle systems, visual effects |

### Decision tree
1. Need GPU-accelerated per-pixel math? → **FragmentProgram**
2. Need custom canvas drawing with moderate complexity? → **CustomPainter**
3. Need standard widget property animations? → **AnimatedBuilder**
4. Need rich pre-made animations? → **Lottie/Rive**

### Hybrid approach
Many production apps combine all three:
- FragmentProgram for background shader effects
- CustomPainter for overlay particles/data viz
- AnimatedBuilder for widget transitions
- Lottie for icon/status animations
