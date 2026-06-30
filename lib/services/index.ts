/**
 * AI Admissions Probability Engine - Main Export
 * 
 * Monte Carlo simulation (10K runs), sensitivity analysis, lever identification,
 * trajectory projection with university-specific models for:
 * - US (Common App)
 * - UK (UCAS)
 * - Canada (OUAC/Direct)
 * - Australia (UAC/VTAC/QTAC)
 * - Europe (Direct applications)
 */

// Types
export * from './admissions-engine-types';

// Core Engine
export { AdmissionsEngine, SeededRandom, UNIVERSITY_MODELS } from './admissions-engine-core';

// Convenience Functions
export { 
  createAdmissionsEngine,
  getAdmissionProbability,
  analyzeStudentProfile,
  getUniversitiesByCountry,
  getUniversityModel,
  getAllUniversityIds,
  getAllUniversityModels,
} from './admissions-engine-core';

// Tier 1-4 Activity Classification
export { 
  TIER_DEFINITIONS, 
  classifyActivity, 
  getActivityCategory,
  type ActivityTier 
} from './admissions-engine-core';

// Profile Builder
export { buildProfile, type ProfileBuilder } from './admissions-engine-core';

// Example Profiles
export { EXAMPLE_PROFILES } from './admissions-engine-core';

// Demo Runner
export { runDemo } from './admissions-engine-core';