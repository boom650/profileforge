/**
 * AI Admissions Probability Engine - Type Definitions
 */

export interface StudentProfile {
  // Academic
  gpa: number;
  gpaScale: number;
  classRank?: number;
  classSize?: number;
  
  // Standardized Tests
  sat?: number;
  act?: number;
  satSubjectTests?: number[];
  apScores?: number[];
  ibScore?: number;
  aLevels?: { subject: string; grade: string }[];
  toefl?: number;
  ielts?: number;
  duolingo?: number;
  
  // Activities (Tier 1-4 classification)
  activities: Activity[];
  
  // Demographics
  nationality: string;
  residency: 'domestic' | 'international' | 'permanent_resident';
  firstGeneration: boolean;
  legacyStatus?: string;
  intendedMajor: string;
  applicationRound: 'early_decision' | 'early_action' | 'regular' | 'rolling';
  
  // Essays & Recommendations (quality scores 1-10)
  personalStatementQuality: number;
  supplementalEssaysQuality: number;
  recommendationStrength: number;
  
  // Context
  highSchoolProfile: HighSchoolProfile;
  extracurricularHours: number;
  leadershipRoles: number;
  awards: Award[];
}

export interface Activity {
  id: string;
  name: string;
  tier: 1 | 2 | 3 | 4;
  category: 'academic' | 'leadership' | 'service' | 'arts' | 'athletics' | 'work' | 'research' | 'other';
  hoursPerWeek: number;
  weeksPerYear: number;
  years: number;
  description: string;
  leadership: boolean;
  recognition: 'international' | 'national' | 'state' | 'regional' | 'school' | 'none';
  startDate: Date;
  endDate?: Date;
}

export interface Award {
  name: string;
  level: 'international' | 'national' | 'state' | 'regional' | 'school';
  year: number;
  category: string;
}

export interface HighSchoolProfile {
  name: string;
  type: 'public' | 'private' | 'charter' | 'international' | 'boarding';
  location: { city: string; state: string; country: string };
  graduationClassSize: number;
  apCoursesOffered: number;
  ibProgram: boolean;
  collegeAcceptanceRate: number;
  averageSAT: number;
  averageACT: number;
  counselingRatio: number;
  rigorRating: 1 | 2 | 3 | 4 | 5;
}

export interface UniversityModel {
  id: string;
  name: string;
  country: 'US' | 'UK' | 'Canada' | 'Australia' | 'Europe';
  system: 'common_app' | 'ucas' | 'ouac' | 'uac' | 'vtac' | 'qtac' | 'direct' | 'eu_central';
  selectivityTier: 1 | 2 | 3 | 4 | 5;
  
  weights: {
    gpa: number;
    testScores: number;
    rigor: number;
    activities: number;
    essays: number;
    recommendations: number;
    demographics: number;
    demonstratedInterest: number;
  };
  
  minimums: {
    gpa?: number;
    sat?: number;
    act?: number;
    ib?: number;
    toefl?: number;
    ielts?: number;
    atar?: number;
    matura?: number;
    abibac?: number;
    french_bac?: number;
    testas?: number;
    bocconi_test?: number;
    ie_test?: number;
    sat_math2?: number;
    pat?: number;
    mat?: number;
    step?: number;
    eng_aa?: number;
    nsaa?: number;
    ucat?: number;
    lnat?: number;
    ts_a?: number;
  };
  
  holisticFactors: {
    valuesAlignment: string[];
    specialConsiderations: string[];
    yieldProtection: boolean;
  };
  
  historicalData: {
    admitRate: number;
    earlyAdmitRate?: number;
    averageGPA: number;
    averageSAT: number;
    averageACT: number;
    middle50SAT: [number, number];
    middle50ACT: [number, number];
    middle50GPA: [number, number];
    enrolledStudents: number;
    internationalRatio: number;
  };
  
  programAdjustments: Record<string, {
    weightMultiplier: number;
    additionalRequirements: string[];
    competitiveness: number;
  }>;
}

export interface FactorScores {
  gpa: number;
  rigor: number;
  testScores: number;
  activities: number;
  essays: number;
  recommendations: number;
  demographics: number;
  demonstratedInterest: number;
}

export interface SimulationResult {
  universityId: string;
  probability: number;
  confidenceInterval: [number, number];
  percentile: number;
  runs: number;
  standardError: number;
}

export interface SensitivityAnalysis {
  factor: string;
  impact: number;
  elasticity: number;
  leverPriority: 'high' | 'medium' | 'low';
  actionable: boolean;
  recommendations: string[];
}

export interface Lever {
  factor: string;
  currentValue: number | string;
  targetValue: number | string;
  probabilityGain: number;
  effort: 'low' | 'medium' | 'high' | 'very_high';
  timeframe: 'immediate' | 'weeks' | 'months' | 'years';
  cost: 'none' | 'low' | 'medium' | 'high';
  description: string;
  steps: string[];
}

export interface LeverIdentification {
  levers: Lever[];
  quickWins: Lever[];
  longTermInvestments: Lever[];
  totalPotentialGain: number;
}

export interface TrajectoryPoint {
  date: Date;
  probability: number;
  gpa: number;
  testScores: TestScoreProjection;
  activities: ActivityProjection;
  narrative: string;
}

export interface TestScoreProjection {
  sat?: number;
  act?: number;
  apProjected?: number[];
}

export interface ActivityProjection {
  newActivities: Activity[];
  upgradedActivities: { from: Activity; to: Activity }[];
  totalHours: number;
  leadershipCount: number;
}

export interface Milestone {
  date: Date;
  description: string;
  probabilityImpact: number;
  completed: boolean;
}

export interface RiskFactor {
  factor: string;
  severity: 'low' | 'medium' | 'high';
  probability: number;
  mitigation: string;
}

export interface TrajectoryProjection {
  currentProbability: number;
  projectedProbability: number;
  timeline: TrajectoryPoint[];
  milestones: Milestone[];
  riskFactors: RiskFactor[];
}

export interface AdmissionsEngineConfig {
  monteCarloRuns: number;
  confidenceLevel: number;
  randomSeed?: number;
  enableParallel: boolean;
}

export interface AdmissionsResult {
  universityId: string;
  universityName: string;
  simulation: SimulationResult;
  sensitivity: SensitivityAnalysis[];
  levers: LeverIdentification;
  trajectory: TrajectoryProjection;
  profileSnapshot: Record<string, unknown>;
  timestamp: Date;
}

export interface AdmittedProfileDistributions {
  gpa: { mean: number; std: number };
  sat: { mean: number; std: number };
  act: { mean: number; std: number };
  rigor: { mean: number; std: number };
  activities: { mean: number; std: number };
  essays: { mean: number; std: number };
  recommendations: { mean: number; std: number };
  demographics: { mean: number; std: number };
  demonstratedInterest: { mean: number; std: number };
}

export interface AdmittedProfile {
  gpa: number;
  sat: number;
  act: number;
  rigor: number;
  activities: number;
  essays: number;
  recommendations: number;
  demographics: number;
  demonstratedInterest: number;
}

export interface ProfileBuilder {
  gpa: number;
  gpaScale: number;
  classRank?: number;
  classSize?: number;
  sat?: number;
  act?: number;
  apScores?: number[];
  ibScore?: number;
  aLevels?: { subject: string; grade: string }[];
  toefl?: number;
  ielts?: number;
  activities: Omit<Activity, 'id' | 'tier'>[];
  nationality: string;
  residency: 'domestic' | 'international' | 'permanent_resident';
  firstGeneration: boolean;
  legacyStatus?: string;
  intendedMajor: string;
  applicationRound: 'early_decision' | 'early_action' | 'regular' | 'rolling';
  personalStatementQuality: number;
  supplementalEssaysQuality: number;
  recommendationStrength: number;
  highSchoolProfile: HighSchoolProfile;
  extracurricularHours: number;
  leadershipRoles: number;
  awards: Award[];
}

export type ActivityTier = 1 | 2 | 3 | 4;