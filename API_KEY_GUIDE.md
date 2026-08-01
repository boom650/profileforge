# ProfileForge — LLM API Key Integration Guide

## 🏆 Recommended: Nvidia NIM (OpenCode Zen's backend)

OpenCode Zen is a **paid** coding agent ($20 min) — NOT a free API. But it runs on **Nvidia NIM**, which IS free.

### Nvidia NIM API

| Field | Value |
|-------|-------|
| **Endpoint** | `https://integrate.api.nvidia.com/v1/chat/completions` |
| **Auth** | `Authorization: Bearer nvapi-xxxxxxxx` |
| **Free Tier** | 1000 credits on signup |
| **Format** | OpenAI-compatible |
| **Best Models** | `meta/llama-3.3-70b-instruct`, `deepseek-ai/deepseek-r1`, `mistralai/mistral-large-2-instruct` |

**How to get your API key:**
1. Go to https://build.nvidia.com
2. Sign up / log in
3. Click any model → "Get API Key"
4. Copy the `nvapi-xxx` key
5. Set it in ProfileForge settings

**curl test:**
```bash
curl -s https://integrate.api.nvidia.com/v1/chat/completions \
  -H "Authorization: Bearer nvapi-YOUR_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "meta/llama-3.3-70b-instruct",
    "messages": [{"role":"user","content":"Hello!"}],
    "max_tokens": 100
  }'
```

---

## 🥈 Best Free Alternatives

### 1. Google Gemini (Most Generous Free Tier)

| Field | Value |
|-------|-------|
| **Endpoint** | `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent` |
| **Auth** | `?key=YOUR_API_KEY` (query param) |
| **Free Tier** | 15 RPM, 1M tokens/day (Flash) |
| **Format** | Google-native (NOT OpenAI-compatible) |
| **Best Models** | `gemini-2.0-flash`, `gemini-2.5-flash` |

**How to get your API key:**
1. Go to https://aistudio.google.com/apikey
2. Click "Create API Key"
3. Copy the key

**Dart SDK:** `dart pub add google_generative_ai`

---

### 2. Groq (Fastest Inference)

| Field | Value |
|-------|-------|
| **Endpoint** | `https://api.groq.com/openai/v1/chat/completions` |
| **Auth** | `Authorization: Bearer gsk_xxxxxxxxx` |
| **Free Tier** | 30 RPM, 13K tokens/min |
| **Format** | OpenAI-compatible |
| **Best Models** | `llama-3.3-70b-versatile`, `mixtral-8x7b-32768` |

**How to get your API key:**
1. Go to https://console.groq.com/keys
2. Sign up with Google/GitHub
3. Click "Create API Key"
4. Copy the `gsk_xxx` key

---

### 3. Mistral AI

| Field | Value |
|-------|-------|
| **Endpoint** | `https://api.mistral.ai/v1/chat/completions` |
| **Auth** | `Authorization: Bearer xxx` |
| **Free Tier** | Limited free tier |
| **Format** | OpenAI-compatible |
| **Best Models** | `mistral-small-latest`, `mistral-medium-latest` |

**How to get your API key:**
1. Go to https://console.mistral.ai/api-keys/
2. Sign up
3. Create API Key

---

### 4. Together AI

| Field | Value |
|-------|-------|
| **Endpoint** | `https://api.together.xyz/v1/chat/completions` |
| **Auth** | `Authorization: Bearer xxx` |
| **Free Tier** | $1 free credit on signup |
| **Format** | OpenAI-compatible |
| **Best Models** | `meta-llama/Llama-3.3-70B-Instruct-Turbo`, `Qwen/Qwen2.5-72B-Instruct-Turbo` |

**How to get your API key:**
1. Go to https://api.together.xyz/settings/api-keys
2. Sign up
3. Create API Key

---

## 🔧 Implementation Notes

### Unified OpenAI-compatible client

All providers except Gemini use the **same API format**. One Dart HTTP function can handle them all:

```dart
class LlmClient {
  final String baseUrl;
  final String apiKey;
  final String model;

  LlmClient({required this.baseUrl, required this.apiKey, required this.model});

  Future<String> chat(String prompt) async {
    final response = await http.post(
      Uri.parse('$baseUrl/chat/completions'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': model,
        'messages': [{'role': 'user', 'content': prompt}],
        'max_tokens': 1024,
      }),
    );
    final data = jsonDecode(response.body);
    return data['choices'][0]['message']['content'];
  }
}
```

### Provider configs for ProfileForge:

| Provider | baseUrl | model |
|----------|---------|-------|
| Nvidia NIM | `https://integrate.api.nvidia.com/v1` | `meta/llama-3.3-70b-instruct` |
| Groq | `https://api.groq.com/openai/v1` | `llama-3.3-70b-versatile` |
| Mistral | `https://api.mistral.ai/v1` | `mistral-small-latest` |
| Together | `https://api.together.xyz/v1` | `meta-llama/Llama-3.3-70B-Instruct-Turbo` |

### Priority order for free usage:
1. **Nvidia NIM** — 1000 credits, best models ✅ (PREFERRED)
2. **Groq** — fastest inference, generous free tier
3. **Google Gemini** — most tokens free (but different API format)
4. **Together AI** — $1 credit, good for testing
5. **Mistral** — limited free tier

---

## ⚠️ Tasks That Require API Keys

| Task | API Needed | Priority |
|------|-----------|----------|
| AI Chat screen (artifact analysis) | Any LLM API | HIGH |
| AI artifact analyzer | Any LLM API | HIGH |
| AI-powered admissions insights | Any LLM API | MEDIUM |
| Smart mission generation | Any LLM API | LOW |
| Essay feedback | Any LLM API | LOW |

All other features (timer, XP, streaks, leagues, goals, buddies, teams, challenges, quests, analytics) work **offline** with no API keys needed.
