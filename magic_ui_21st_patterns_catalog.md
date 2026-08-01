# Magic UI / 21st.dev Patterns → Flutter Adaptation Catalog

Research sources: `magicui.design` (79 components), `21st.dev` (12 categories + community libraries including Aceternity UI)

---

## 1. ANIMATED HEROES

### Magic UI Components
- **Globe** — 3D rotating globe with hover interaction (CSS 3D transforms + JS pointer tracking)
- **Hero Video Dialog** — autoplay video hero with modal expansion
- **Light Rays** — animated light ray beams emanating from center
- **Orbiting Circles** — concentric orbital animation paths
- **Particles** — floating particle field background

### 21st.dev Hero Components
- **Animated Hero** — gradient morphing text + parallax elements
- **Hero** — glassmorphism container with animated gradient border

### Flutter Replication
| Effect | Flutter Approach |
|--------|-----------------|
| 3D Globe | `SceneViewer` widget or `flame` 3D, or `CustomPainter` with rotation matrices on sphere |
| Video Hero | `VideoPlayer` + `AnimatedContainer` scale transitions |
| Light Rays | `CustomPainter` drawing `LinearGradient` rays with `AnimationController` rotation |
| Orbiting Circles | `CustomPaint` + trigonometric `sin`/`cos` positioning in `AnimationController` |
| Particles | `Canvas.drawCircle` in `CustomPainter` with velocity vectors + `Ticker` |
| Gradient Morphing | `ShaderMask` + `AnimatedContainer` on `LinearGradient` colors |

---

## 2. MAGIC UI CATEGORIES

### Component Categories (from magicui.design)
| Category | Components |
|----------|-----------|
| **Text Effects** | animated-gradient-text, animated-shiny-text, aurora-text, comic-text, dia-text-reveal, hyper-text, kinetic-text, line-shadow-text, morphing-text, number-ticker, shimmer-text, sparkles-text, spinning-text, text-3d-flip, text-animate, text-reveal, typing-animation, video-text, word-rotate |
| **Cards** | magic-card, neon-gradient-card, glare-hover, hero-video-dialog, tweet-card, bento-grid |
| **Backgrounds** | animated-grid-pattern, dot-pattern, flickering-grid, grid-pattern, interactive-grid-pattern, retro-grid, hexagon-pattern, striped-pattern, particles, meteors, noise-texture, warp-background |
| **Borders** | border-beam, shine-border, backlight |
| **Buttons** | interactive-hover-button, pulsating-button, rainbow-button, ripple-button, shimmer-button, shiny-button |
| **Layout** | marquee, animated-list, dock, file-tree, bento-grid, scroll-based-velocity, scroll-progress |
| **Misc** | globe, icon-cloud, lens, pointer, smooth-cursor, pixel-image, confetti, cool-mode, animated-beam, animated-circular-progress-bar, orbiting-circles, progressive-blur, safari, terminal, animated-theme-toggler, code-comparison, dotted-map, avatar-circles, highlighter |

### 21st.dev Categories
| Category | Focus |
|----------|-------|
| **animated-hero** | Hero sections with motion |
| **background** | Full-page animated backgrounds |
| **button** | Interactive button variants |
| **card** | Hover/tilt/spotlight cards |
| **carousel** | Swiping image/content carousels |
| **gradient** | Animated gradient effects |
| **shader** | WebGL/GLSL shader effects |
| **navigation-menu** | Animated nav patterns |
| **ai-chat** | Chat UI with typing indicators |
| **sign-in** | Auth form animations |
| **footer** | Animated footer patterns |

---

## 3. SHADERS

### Available Shader Effects
| Effect | Description | WebGL Implementation |
|--------|-------------|---------------------|
| **Aurora** | Northern lights color band animation | Fragment shader: `sin(u_time + coord.y * freq)` modulating hue |
| **Ripple** | Concentric ring distortion from center | Distance field + `sin(dist * freq - time)` |
| **Glow** | Radial soft light emission | Gaussian falloff `exp(-dist²/sigma)` |
| **Noise** | Perlin/simplex noise field | `sin(dot(coord, vec2(12.9898,78.233)))` hash-based |
| **Gradient Morph** | Smooth color gradient transitions | `mix()` of 3+ colors driven by `u_time` |
| **Fractal** | Recursive fractal patterns | Mandelbrot/Julia set iterations |
| **Warp** | Coordinate distortion effects | `uv += sin(uv.yx + time)` style warping |

### Flutter Replication
- **Fragment Shaders**: Use `FragmentProgram` (Flutter 3.7+) — compile GLSL `.frag` files, pass uniforms via `FragmentShader.setFloat()`
- **Performance**: Use `dart:ui` `FragmentProgram.fromAsset()` for GPU-accelerated shaders
- **Alternative**: `shader_codelab` package or `flutter_shaders` package
- **Simpler Effects**: `CustomPainter` with noise algorithms (simplex noise in Dart) for non-GPU shaders

---

## 4. GLASS EFFECTS

### Magic UI Glass Patterns
- **Neon Gradient Card** — glass card with animated neon border glow
- **Progressive Blur** — gaussian blur increasing toward edges
- **Shine Border** — rotating gradient border with glass fill
- **Border Beam** — animated light beam traveling along border path
- **Backlight** — soft glow emanating from behind card

### 21st.dev Glass Components
- Glassmorphism containers with `backdrop-filter: blur()` + `background: rgba(255,255,255,0.1)`

### Flutter Replication
| Effect | Flutter Approach |
|--------|-----------------|
| Frosted Glass | `BackdropFilter` + `ImageFilter.blur(sigmaX: 10, sigmaY: 10)` + `ClipRRect` + semi-transparent container |
| Neon Border | `CustomPainter` drawing animated `Paint()` with `PaintingStyle.stroke` + `SweepGradient` |
| Border Beam | `CustomPaint` with `SweepGradient` rotation via `AnimationController` on `angle` |
| Backlight | `Container` with `BoxShadow` using large `spreadRadius` + `blurRadius` + animated color |
| Progressive Blur | `ShaderMask` with vertical `LinearGradient` mask + `ImageFilter.blur()` |

### Key Packages
- `backdrop_blur: ^1.0.0` (community)
- `frosted_glass: ^0.1.0`
- Native: `BackdropFilter` is built-in

---

## 5. BUTTON ANIMATIONS

### Magic UI Buttons
| Button | Effect |
|--------|--------|
| **Pulsating Button** | CSS `scale()` pulse with `box-shadow` expansion |
| **Rainbow Button** | Animated `linear-gradient` border cycling hue values |
| **Ripple Button** | Material-like ripple emanating from click point |
| **Shimmer Button** | Diagonal shine sweep across button surface |
| **Shiny Button** | Metallic gradient highlight animation |
| **Interactive Hover Button** | Scale + color shift on hover, with icon morph |

### 21st.dev Button Variants
- Magnetic button (follows cursor within threshold)
- Confetti burst on click
- Shine/gloss sweep
- Ripple from tap point
- Size morph on interaction

### Flutter Replication
| Effect | Flutter Approach |
|--------|-----------------|
| Ripple | `InkWell` (built-in Material ripple) or `CustomPainter` for custom shape |
| Shimmer/Sweep | `ShaderMask` + `LinearGradient` animated via `AnimationController` with `begin`/`end` offset |
| Rainbow Border | `AnimatedContainer` cycling `SweepGradient` colors on `border` paint |
| Pulse | `AnimatedScale` + `AnimatedContainer` with `boxShadow` radius animation |
| Confetti | `CustomPaint` spawning particles with random velocity vectors on tap |
| Magnetic | `GestureDetector` + `Transform.translate` offset toward pointer position (clamped distance) |
| Metallic Shine | `LinearGradient` with white-to-transparent midstop, `Tween<Offset>` sliding across |

---

## 6. CARD EFFECTS

### Magic UI Cards
| Card | Effect |
|------|--------|
| **Magic Card** | Pointer-following gradient highlight + dark background |
| **Neon Gradient Card** | Animated neon border colors cycling |
| **Glare Hover** | Specular glare reflection following pointer |
| **Bento Grid** | Masonry-style layout with individual card hover animations |

### 21st.dev Card Variants
- **Tilt/3D Perspective** — CSS `perspective` + `rotateX`/`rotateY` following pointer
- **Spotlight** — Radial gradient mask following pointer, illuminating card surface
- **Glare** — Specular highlight (white gradient) rotating based on pointer angle
- **Border Glow** — Animated gradient border that intensifies on hover
- **Parallax Depth** — Layers within card shift at different rates based on tilt

### Flutter Replication
| Effect | Flutter Approach |
|--------|-----------------|
| Pointer-following gradient | `Listener` for `onPointerMove` → update `Offset` → `CustomPaint` radial gradient at that offset |
| 3D Tilt | `Transform` with `Matrix4.identity()..setEntry(3,2, perspective)..rotateX(angle)..rotateY(angle)` |
| Glare/Specular | `CustomPaint` drawing `RadialGradient` at pointer angle position, with `BlendMode.softLight` |
| Spotlight Mask | `ShaderMask` with `RadialGradient` centered at pointer `Offset` |
| Neon Border | `CustomPaint` with animated `SweepGradient` stroke |
| Parallax | Multiple `Transform.translate` layers with different multipliers |

---

## 7. TEXT ANIMATIONS

### Magic UI Text Effects
| Effect | Description |
|--------|-------------|
| **Typed Animation** | Characters appear one-by-one with blinking cursor |
| **Text Reveal** | Text revealed left-to-right as user scrolls |
| **Animated Gradient Text** | `background-clip: text` with sliding gradient position |
| **Sparkles Text** | Random sparkle particles spawning around text |
| **Morphing Text** | Text smoothly morphing between multiple words |
| **Text 3D Flip** | Each character flips on X-axis to reveal next text |
| **Word Rotate** | Words rotate into view one at a time |
| **Kinetic Text** | Characters with individual spring animations |
| **Hyper Text** | Characters randomly cycle through charset then settle |
| **Aurora Text** | Text colored with aurora borealis gradient effect |
| **Line Shadow Text** | Animated diagonal shadow lines through text |
| **Spinning Text** | Characters arranged in a spinning circle |
| **Dia Text Reveal** — Diamond-shaped reveal mask |
| **Shiny Text** — Diagonal light reflection sweeping across text |
| **Video Text** — Text filled with video content via clip mask |
| **Comic Text** — Comic/manga style speech bubble text |
| **Number Ticker** — Numbers rolling/counting up animation |

### Flutter Replication
| Effect | Flutter Approach |
|--------|-----------------|
| Typewriter | `AnimatedBuilder` + incrementing `substring(0, index)` with `Interval` timing |
| Text Reveal | `AnimatedBuilder` with `ScrollController` → mask width = scroll fraction |
| Gradient Text | `ShaderMask` with `LinearGradient` on `Text` widget |
| Sparkles | Stack of `Text` + `CustomPaint` spawning small star shapes at random offsets |
| Morphing | `AnimatedSwitcher` crossfade + character-by-character interpolation |
| 3D Flip | `AnimatedSwitcher` + `Transform` with rotation animation per character |
| Hyper Text | `Timer.periodic` cycling character codes until final value |
| Number Ticker | `Tween<double>` animating number value, formatted with `toStringAsFixed` |
| Video Text | `ClipPath` using text path from `TextPainter` + `VideoPlayer` |
| Kinetic Text | Per-character `AnimationController` with staggered delays |

---

## 8. BACKGROUND EFFECTS

### Magic UI Backgrounds
| Effect | Description |
|--------|-------------|
| **Particles** | Floating dots with random velocities and connections |
| **Meteors** | Shooting stars streaking across background |
| **Animated Grid Pattern** | Grid lines with animated dash offsets |
| **Interactive Grid Pattern** | Grid cells highlight near pointer |
| **Dot Pattern** | Regular dot array, adjustable density |
| **Flickering Grid** | Grid with random cells blinking on/off |
| **Retro Grid** | Perspective-transformed grid (80s synthwave) |
| **Hexagon Pattern** | Honeycomb hexagonal grid |
| **Striped Pattern** | Diagonal striped texture |
| **Noise Texture** | Perlin noise overlay for grain |
| **Warp Background** | Distortion warp effect |

### 21st.dev Background Variants
- Aurora (northern lights color bands)
- Gradient mesh (multiple radial gradients)
- Particle field
- Grid with spotlight
- Noise grain

### Flutter Replication
| Effect | Flutter Approach |
|--------|-----------------|
| Particles | `CustomPainter` + `Ticker` with list of particle objects (x, y, vx, vy) |
| Meteors | `CustomPaint` drawing short `Line` objects with trail gradient + position animation |
| Grid | `CustomPaint` + `canvas.drawRect` loop with offset animation |
| Interactive Grid | `CustomPaint` + pointer distance calculation to adjust cell opacity |
| Flickering Grid | `CustomPaint` + `Random().nextBool()` per cell per frame |
| Retro Grid | `Transform` with `Matrix4` perspective + `vanishingPoint` |
| Noise | Precomputed simplex noise lookup table + `Canvas.drawImage` |
| Warp | Fragment shader via `FragmentProgram` |
| Dot/Hex Patterns | `CustomPaint` with math-based positioning |

### Key Packages
- `particles_flutter` — particle system
- `flutter_shaders` — GLSL shader support
- `simplex_noise` — noise generation

---

## CROSS-CUTTING FLUTTER IMPLEMENTATION NOTES

### GPU Shaders (Flutter 3.7+)
```dart
// Load and use fragment shader
final program = await FragmentProgram.fromAsset('shaders/aurora.frag');
final shader = program.fragmentShader()
  ..setFloat(0, time)           // uniform float u_time
  ..setFloat(1, size.width)     // uniform float u_width
  ..setFloat(2, size.height);   // uniform float u_height

Canvas.drawPaint(Paint()..shader = shader);
```

### Performance Patterns
- Use `RepaintBoundary` around animated widgets to isolate repaints
- Cache `CustomPainter` computations where possible
- Use `shouldRepaint` override to avoid unnecessary redraws
- For particle systems: cap at ~200 particles, use object pooling
- Prefer `AnimationController` over `Timer` for GPU-synchronized animation
- Use `Transform` (compositor-level) over `Container` decoration changes

### Package Dependencies (recommended)
| Purpose | Package |
|---------|---------|
| Animations | `flutter_animate`, `rive` |
| Particles | `particles_flutter` (or custom `CustomPainter`) |
| Glassmorphism | Built-in `BackdropFilter` |
| Shaders | Built-in `FragmentProgram` (Flutter 3.7+) |
| 3D transforms | Built-in `Transform` with `Matrix4` |
| Tilt/accelerometer | `flutter_sensors` or `sensors_plus` |
| Confetti | `confetti_widget` |
| Lottie | `lottie` (for pre-made JSON animations) |
| Rive | `rive` (for complex state-machine animations) |
| Number animation | `flutter_countdown` or custom `Tween` |

---

## SUMMARY: HIGHEST-VALUE PATTERNS FOR FLUTTER PORT

**Tier 1 — Direct Flutter equivalents exist (fastest to port)**
1. Gradient text → `ShaderMask`
2. Typewriter/text reveal → `AnimatedBuilder` + `Text`
3. Glassmorphism → `BackdropFilter`
4. Ripple button → `InkWell`
5. Shimmer button → `ShaderMask` + animated `LinearGradient`
6. Marquee → `SingleChildScrollView` with `AnimationController`
7. Number ticker → `Tween<double>` animation

**Tier 2 — CustomPainter straightforward (medium effort)**
8. Particle system → `CustomPainter` + `Ticker`
9. Grid patterns → `CustomPaint` loops
10. Point-following spotlight → `Listener` + `CustomPaint` radial gradient
11. 3D card tilt → `Transform` + `Matrix4`
12. Border beam → `CustomPaint` + `SweepGradient`
13. Glow/shadow effects → `BoxShadow` animation

**Tier 3 — Fragment shaders needed (higher effort)**
14. Aurora effect → GLSL fragment shader
15. Warp/distortion → GLSL with coordinate manipulation
16. Noise texture → GLSL or precomputed lookup
17. Complex gradient morphs → GLSL for smooth multi-stop gradients

**Tier 4 — Rive/Lottie preferred (complex state machines)**
18. Morphing text → Rive state machine
19. 3D flip text → Rive or manual `Transform` per character
20. Spinning text → Rive or `Transform.rotate` per character
