import 'fallback_llm_client.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// ProfileForge LLM Provider Configuration
///
/// Three providers with automatic failover:
/// 1. OpenCode Zen — primary (free models: Mimo v2.5, DeepSeek v4, etc.)
/// 2. Nvidia NIM — backup (1000 free credits)
/// 3. 9Router — last resort (local proxy, many models)
///
/// Strategy: Try primary → if fails, try backup → if fails, try last resort.
/// On rate limits: 30s cooldown per provider, then retry.
/// On auth errors: 30min cooldown per provider.
/// ────────────────────────────────────────────────────────────────────────────

class ProfileForgeLlmConfig {
  ProfileForgeLlmConfig._();

  // ═══════════════════════════════════════════════════════════════════════════
  // API KEYS — Stored securely in production
  // ═══════════════════════════════════════════════════════════════════════════

  static const String openCodeZenKey = 'sk-WiR7E9Avs6QHKHDFi1DEhRDQRrefS2TzLBCKgjLzzZKmEaGVH3ruSqwLS2XFnuFw';
  static const String nvidiaNimKey = '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';
  static const String nineRouterKey = 'sk-665c910ad45dae2e-bn1al9-442294b2';

  // ═══════════════════════════════════════════════════════════════════════════
  // PROVIDER CONFIGURATIONS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Provider 1: OpenCode Zen (PRIMARY — free models)
  static const openCodeZen = LlmProviderConfig(
    name: 'OpenCode Zen',
    baseUrl: 'https://api.opencodezen.ai/v1',
    apiKey: openCodeZenKey,
    freeModels: [
      'mimo-v2.5-free',        // Fast, good quality
      'deepseek-v4-free',      // Strong reasoning
      'deepseek-r1-free',      // Chain-of-thought
      'gemma-3-27b-it-free',   // Google Gemma
      'llama-4-maverick-free', // Meta Llama 4
      'qwen-3-30b-a3b-free',  // Alibaba Qwen
    ],
    cooldownMinutes: 5,
  );

  /// Provider 2: Nvidia NIM (BACKUP — 1000 free credits)
  static const nvidiaNim = LlmProviderConfig(
    name: 'Nvidia NIM',
    baseUrl: 'https://integrate.api.nvidia.com/v1',
    apiKey: nvidiaNimKey,
    freeModels: [
      'nvidia/llama-3.3-nemotron-super-49b-v1',   // Best NIM model
      'meta/llama-3.1-8b-instruct',                // Fast fallback
      'nvidia/llama-3.1-nemotron-70b-instruct',    // Larger model
      'google/gemma-2-9b-it',                      // Google Gemma
      'mistralai/mistral-7b-instruct-v0.3',        // Mistral
    ],
    cooldownMinutes: 5,
  );

  /// Provider 3: 9Router (LAST RESORT — local proxy)
  static const nineRouter = LlmProviderConfig(
    name: '9Router',
    baseUrl: 'http://localhost:20128/v1',
    apiKey: nineRouterKey,
    freeModels: [
      'mimo-v2.5-free',
      'deepseek-v4-free',
      'deepseek-r1-free',
      'gemma-3-27b-it-free',
      'llama-4-maverick-free',
      'qwen-3-30b-a3b-free',
    ],
    cooldownMinutes: 3,
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // FACTORY
  // ═══════════════════════════════════════════════════════════════════════════

  /// Create a FallbackLlmClient with all providers configured.
  static FallbackLlmClient createClient({
    String? systemPrompt,
    String preferredProvider = 'OpenCode Zen',
  }) {
    return FallbackLlmClient(
      providers: [openCodeZen, nvidiaNim, nineRouter],
      preferredProvider: preferredProvider,
      systemPrompt: systemPrompt ?? FallbackLlmClient._defaultSystemPrompt,
    );
  }
}
