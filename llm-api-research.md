# LLM API Research for Flutter Mobile App

## 1. OpenCode Zen

**What is it?**
- Part of OpenCode (opencode.ai) — open source AI coding agent by Anomaly
- Zen is a **paid credit-based** model service: curated, benchmarked models for coding agents
- NOT a general-purpose free API — requires adding $20 balance, pay-per-request, zero-markups
- Works with OpenCode and any OpenAI-compatible agent

**Base URL:** Not publicly documented as standalone API. Integrated via OpenCode config.
**Auth:** Account + credit balance ($20 minimum), auto-topup at $5
**Models:** Claude, GPT, Gemini, Llama, Qwen families (curated set)
**Pricing:** Pay-as-you-go, zero markups on provider pricing. NOT free.
**Free tier:** NONE
**OpenAPI endpoint:** No standalone REST endpoint found — works through OpenCode's config system

**Verdict:** NOT suitable as a free LLM API for a Flutter mobile app. It's a paid service for OpenCode users.

---

## 2. Nvidia NIM API (build.nvidia.com)

**Base URL:** `https://integrate.api.nvidia.com/v1`
**Auth:** API key via `Authorization: Bearer nvapi-xxx` header
**Sign up:** https://build.nvidia.com (free account, get API key)

**Free Tier:** Yes — 1000 API credits on signup (varies by model). Rate-limited but functional.
**Pricing:** Credit-based after free tier; some models cheaper than others

**OpenAI-compatible endpoint:** `POST https://integrate.api.nvidia.com/v1/chat/completions`

### Key Models (confirmed available via API):

**Best free-tier models for mobile:**
| Model ID | Type | Notes |
|---|---|---|
| `meta/llama-3.1-8b-instruct` | Chat | Fast, small, great for mobile |
| `meta/llama-3.3-70b-instruct` | Chat | Powerful, higher credit cost |
| `meta/llama-3.2-3b-instruct` | Chat | Ultra-light, fast inference |
| `mistralai/mistral-7b-instruct-v0.3` | Chat | Good general purpose |
| `mistralai/mistral-large-2-instruct` | Chat | Strong reasoning |
| `deepseek-ai/deepseek-v4-flash` | Chat | New, fast |
| `deepseek-ai/deepseek-v4-pro` | Chat | Strong coding |
| `google/gemma-3-4b-it` | Chat | Small, efficient |
| `google/gemma-3-12b-it` | Chat | Good balance |
| `nvidia/llama-3.3-nemotron-super-49b-v1` | Chat | NVIDIA-tuned |
| `nvidia/llama-3.1-nemotron-ultra-253b-v1` | Chat | Most powerful NIM |
| `nvidia/nemotron-3-nano-30b-a3b` | Chat | MoE, efficient |
| `microsoft/phi-3.5-moe-instruct` | Chat | Microsoft small model |

### Curl Example:
```bash
curl -s https://integrate.api.nvidia.com/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer nvapi-YOUR_KEY_HERE" \
  -d '{
    "model": "meta/llama-3.1-8b-instruct",
    "messages": [{"role": "user", "content": "Hello!"}],
    "temperature": 0.7,
    "max_tokens": 256
  }'
```

### Dart/Flutter Example:
```dart
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> callNvidiaNim(String prompt) async {
  final response = await http.post(
    Uri.parse('https://integrate.api.nvidia.com/v1/chat/completions'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer nvapi-YOUR_KEY_HERE',
    },
    body: jsonEncode({
      'model': 'meta/llama-3.1-8b-instruct',
      'messages': [
        {'role': 'user', 'content': prompt},
      ],
      'temperature': 0.7,
      'max_tokens': 256,
    }),
  );
  final data = jsonDecode(response.body);
  return data['choices'][0]['message']['content'];
}
```

---

## 3. Other Free LLM APIs

### A. Groq (groq.com)

**Base URL:** `https://api.groq.com/openai/v1`
**Auth:** API key via `Authorization: Bearer gsk_xxx`
**Sign up:** https://console.groq.com
**Free Tier:** Yes — generous free tier with rate limits (e.g., 30 RPM for llama-3.3-70b-versatile)
**OpenAI-compatible:** YES

**Key Models:**
| Model ID | Rate Limit (free) |
|---|---|
| `llama-3.1-8b-instant` | ~30 RPM |
| `llama-3.3-70b-versatile` | ~30 RPM |
| `gemma2-9b-it` | ~30 RPM |
| `mixtral-8x7b-32768` | ~30 RPM |
| `compound-mini` | Available |

**Curl Example:**
```bash
curl -s https://api.groq.com/openai/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer gsk_YOUR_KEY_HERE" \
  -d '{
    "model": "llama-3.1-8b-instant",
    "messages": [{"role": "user", "content": "Hello!"}],
    "temperature": 0.7,
    "max_tokens": 256
  }'
```

**Dart/Flutter:** Same pattern as Nvidia NIM — just change base URL and model name.

**Speed:** Groq is the FASTEST inference provider (custom LPU hardware). Best for mobile UX.

---

### B. Together AI (together.xyz)

**Base URL:** `https://api.together.xyz/v1`
**Auth:** API key via `Authorization: Bearer YOUR_KEY`
**Sign up:** https://api.together.xyz
**Free Tier:** $1 free credit on signup. Pay-as-you-go after.
**OpenAI-compatible:** YES

**Key Models (cheapest/free-tier friendly):**
| Model ID | Price per 1M tokens |
|---|---|
| `meta-llama/Meta-Llama-3.1-8B-Instruct-Turbo` | Very cheap |
| `meta-llama/Meta-Llama-3.3-70B-Instruct-Turbo` | Cheap |
| `mistralai/Mistral-7B-Instruct-v0.3` | Very cheap |
| `Qwen/Qwen2.5-72B-Instruct-Turbo` | Cheap |
| `deepseek-ai/DeepSeek-V3` | Cheap |
| `google/gemma-2-9b-it` | Very cheap |

**Curl Example:**
```bash
curl -s https://api.together.xyz/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_KEY" \
  -d '{
    "model": "meta-llama/Meta-Llama-3.1-8B-Instruct-Turbo",
    "messages": [{"role": "user", "content": "Hello!"}],
    "temperature": 0.7,
    "max_tokens": 256
  }'
```

---

### C. Mistral AI (mistral.ai)

**Base URL:** `https://api.mistral.ai/v1`
**Auth:** API key via `Authorization: Bearer YOUR_KEY`
**Sign up:** https://console.mistral.ai
**Free Tier:** Free tier available with rate limits
**OpenAI-compatible:** YES

**Key Models:**
| Model ID | Notes |
|---|---|
| `mistral-small-latest` | Fast, cheap |
| `mistral-medium-latest` | Good balance |
| `open-mistral-nemo` | Free, open source |
| `codestral-latest` | Code-specialized |
| `pixtral-large-latest` | Multimodal |

**Curl Example:**
```bash
curl -s https://api.mistral.ai/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_KEY" \
  -d '{
    "model": "mistral-small-latest",
    "messages": [{"role": "user", "content": "Hello!"}],
    "temperature": 0.7,
    "max_tokens": 256
  }'
```

---

### D. Google Gemini (ai.google.dev)

**Base URL:** `https://generativelanguage.googleapis.com/v1beta`
**Auth:** API key via `?key=YOUR_KEY` or `x-goog-api-key` header
**Free Tier:** YES — very generous (15 RPM Gemini 2.0 Flash, 2 RPM Gemini 2.5 Pro)
**OpenAI-compatible:** NO (Google's own format, but SDKs available)

**Key Models:**
| Model ID | Free RPM |
|---|---|
| `gemini-2.0-flash` | 15 RPM |
| `gemini-2.5-flash-preview-05-20` | 10 RPM |
| `gemini-2.5-pro-preview-05-06` | 2 RPM |

**Dart/Flutter:** Official `google_generative_ai` package from Google.

---

## Recommendation for Flutter Mobile App

### Best Free Options (ranked):
1. **Groq** — Fastest inference, free tier, OpenAI-compatible. Best for UX.
2. **Nvidia NIM** — Free credits, many models, OpenAI-compatible. Good variety.
3. **Google Gemini** — Most generous free tier, official Dart SDK.
4. **Mistral AI** — Free tier, OpenAI-compatible.
5. **Together AI** — $1 free credit, wide model selection.

### All OpenAI-compatible APIs share the same Dart HTTP pattern:
```dart
final response = await http.post(
  Uri.parse('${baseUrl}/chat/completions'),
  headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $apiKey',
  },
  body: jsonEncode({
    'model': 'MODEL_ID',
    'messages': [{'role': 'user', 'content': prompt}],
    'temperature': 0.7,
    'max_tokens': 256,
  }),
);
```

### Key findings:
- **OpenCode Zen** — NOT a free standalone API. It's a paid credit service for OpenCode users.
- **Nvidia NIM** — Real free tier, 100+ models, OpenAI-compatible. Strong choice.
- **Groq** — Best speed for mobile. Free tier. All 4 providers use same API format.
