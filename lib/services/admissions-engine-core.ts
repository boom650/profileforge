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

export * from './admissions-engine-types.js';
export * from './admissions-engine.js';

// Import for internal use
import { AdmissionsEngine, UNIVERSITY_MODELS, SeededRandom } from './admissions-engine.js';
import type { StudentProfile, UniversityModel, AdmissionsResult, AdmissionsEngineConfig } from './admissions-engine-types.js';

// Re-export
export { AdmissionsEngine, UNIVERSITY_MODELS, SeededRandom };

// ============================================================================
// Convenience Functions
// ============================================================================

/**
 * Create a default engine with 10K Monte Carlo runs
 */
export function createAdmissionsEngine(config?: Partial<AdmissionsEngineConfig>): AdmissionsEngine {
  return new AdmissionsEngine(config);
}

/**
 * Quick probability check for a single university
 */
export async function getAdmissionProbability(
  profile: StudentProfile,
  universityId: string,
  config?: Partial<AdmissionsEngineConfig>
): Promise<AdmissionsResult | null> {
  const engine = new AdmissionsEngine(config);
  const model = UNIVERSITY_MODELS[universityId];
  
  if (!model) {
    console.warn(`University model not found: ${universityId}`);
    return null;
  }
  
  return engine.analyzeForUniversity(profile, model);
}

/**
 * Batch analyze multiple universities
 */
export async function analyzeStudentProfile(
  profile: StudentProfile,
  universityIds?: string[],
  config?: Partial<AdmissionsEngineConfig>
): Promise<Record<string, AdmissionsResult>> {
  const engine = new AdmissionsEngine(config);
  return engine.analyzeStudent(profile, universityIds);
}

/**
 * Get list of available university models by country
 */
export function getUniversitiesByCountry(country: UniversityModel['country']): UniversityModel[] {
  return Object.values(UNIVERSITY_MODELS).filter(u => u.country === country);
}

/**
 * Get university model by ID
 */
export function getUniversityModel(id: string): UniversityModel | undefined {
  return UNIVERSITY_MODELS[id];
}

/**
 * Get all university IDs
 */
export function getAllUniversityIds(): string[] {
  return Object.keys(UNIVERSITY_MODELS);
}

/**
 * Get all university models
 */
export function getAllUniversityModels(): UniversityModel[] {
  return Object.values(UNIVERSITY_MODELS);
}

// ============================================================================
// Tier 1-4 Activity Classification Helpers
// ============================================================================

export const TIER_DEFINITIONS = {
  1: {
    name: 'Exceptional Distinction',
    description: 'International/national recognition, founded significant organization, published research, Olympic/elite athlete',
    examples: [
      'International Science Olympiad medalist',
      'Founded non-profit with 1000+ impact',
      'Published first-author research paper',
      'National award winner (Presidential Scholar, etc.)',
      'Professional/near-professional athlete/artist',
    ],
    weight: 1.0,
  },
  2: {
    name: 'High Achievement & Leadership',
    description: 'State/regional recognition, significant leadership role, substantial initiative',
    examples: [
      'State science fair winner',
      'Student body president of large school',
      'Captain of varsity team (state-ranked)',
      'Founded school club with 50+ members',
      'Regional music/arts competition winner',
      'Significant research contribution',
    ],
    weight: 0.7,
  },
  3: {
    name: 'Meaningful Participation & Contribution',
    description: 'Consistent involvement, school-level leadership, skill development',
    examples: [
      'Club officer (not president)',
      'Varsity team member',
      'Regular volunteer (100+ hours)',
      'School newspaper editor',
      'Honor society member',
      'Part-time job with responsibility',
    ],
    weight: 0.4,
  },
  4: {
    name: 'General Participation',
    description: 'Member-level involvement, exploratory activities',
    examples: [
      'Club member',
      'JV team player',
      'Occasional volunteer',
      'General music/art classes',
      'Summer camp participant',
    ],
    weight: 0.15,
  },
} as const;

export type ActivityTier = 1 | 2 | 3 | 4;

export function classifyActivity(activity: {
  recognition: 'international' | 'national' | 'state' | 'regional' | 'school' | 'none';
  leadership: boolean;
  hoursPerWeek: number;
  weeksPerYear: number;
  years: number;
  description: string;
}): ActivityTier {
  const { recognition, leadership, hoursPerWeek, weeksPerYear, years, description } = activity;
  const totalHours = hoursPerWeek * weeksPerYear * years;
  
  // Tier 1: International/National recognition OR exceptional achievement
  if (recognition === 'international' || recognition === 'national') return 1;
  if (leadership && totalHours > 500 && (recognition === 'state' || description.includes('founded') || description.includes('published'))) return 1;
  
  // Tier 2: State/regional recognition OR significant leadership
  if (recognition === 'state') return 2;
  if (recognition === 'regional' && leadership) return 2;
  if (leadership && totalHours > 300) return 2;
  if (totalHours > 600) return 2; // Sustained deep commitment
  
  // Tier 3: School recognition OR consistent participation with some leadership
  if (recognition === 'school') return 3;
  if (recognition === 'regional') return 3;
  if (leadership) return 3;
  if (totalHours > 200) return 3;
  
  // Tier 4: Basic participation
  return 4;
}

export function getActivityCategory(name: string, description: string): Activity['category'] {
  const text = (name + ' ' + description).toLowerCase();
  
  if (text.includes('research') || text.includes('lab') || text.includes('science fair')) return 'research';
  if (text.includes('president') || text.includes('captain') || text.includes('founder') || text.includes('lead')) return 'leadership';
  if (text.includes('volunteer') || text.includes('service') || text.includes('community') || text.includes('nonprofit')) return 'service';
  if (text.includes('music') || text.includes('art') || text.includes('theater') || text.includes('dance') || text.includes('band') || text.includes('orchestra') || text.includes('choir')) return 'arts';
  if (text.includes('sport') || text.includes('team') || text.includes('athletic') || text.includes('varsity') || text.includes('jv')) return 'athletics';
  if (text.includes('work') || text.includes('job') || text.includes('internship') || text.includes('employment')) return 'work';
  if (text.includes('academic') || text.includes('math') || text.includes('science') || text.includes('olympiad') || text.includes('competition') || text.includes('quiz') || text.includes('debate') || text.includes('model un')) return 'academic';
  
  return 'other';
}

// ============================================================================
// Profile Builder Helper
// ============================================================================

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

export function buildProfile(builder: ProfileBuilder): StudentProfile {
  const activities: Activity[] = builder.activities.map((a, i) => ({
    ...a,
    id: `act_${i}`,
    tier: classifyActivity({
      recognition: a.recognition,
      leadership: a.leadership,
      hoursPerWeek: a.hoursPerWeek,
      weeksPerYear: a.weeksPerYear,
      years: a.years,
      description: a.description,
    }),
  }));
  
  return {
    ...builder,
    activities,
    extracurricularHours: activities.reduce((sum, a) => sum + a.hoursPerWeek * a.weeksPerYear, 0),
    leadershipRoles: activities.filter(a => a.leadership).length,
  };
}

// ============================================================================
// Example Profiles for Testing
// ============================================================================

export const EXAMPLE_PROFILES = {
  // Strong US applicant targeting Ivy League
  strongUS: buildProfile({
    gpa: 4.0,
    gpaScale: 4.0,
    classRank: 3,
    classSize: 400,
    sat: 1550,
    act: 35,
    apScores: [5, 5, 5, 5, 4, 4],
    ibScore: undefined,
    aLevels: undefined,
    toefl: undefined,
    ielts: undefined,
    activities: [
      {
        name: 'Science Research - Cancer Immunotherapy',
        category: 'research',
        hoursPerWeek: 15,
        weeksPerYear: 40,
        years: 2,
        description: 'Independent research at university lab, co-authored paper in peer-reviewed journal, presented at international conference',
        leadership: true,
        recognition: 'international',
        startDate: new Date('2022-09-01'),
      },
      {
        name: 'Founder - STEM Outreach Nonprofit',
        category: 'leadership',
        hoursPerWeek: 10,
        weeksPerYear: 50,
        years: 3,
        description: 'Founded 501(c)(3) providing free STEM education to 2000+ underrepresented students across 15 states',
        leadership: true,
        recognition: 'national',
        startDate: new Date('2021-06-01'),
      },
      {
        name: 'Math Olympiad Team Captain',
        category: 'academic',
        hoursPerWeek: 8,
        weeksPerYear: 36,
        years: 3,
        description: 'Led team to state championship 2 years, qualified for USAMO, mentored 15 younger students',
        leadership: true,
        recognition: 'state',
        startDate: new Date('2021-09-01'),
      },
      {
        name: 'Varsity Tennis - Team Captain',
        category: 'athletics',
        hoursPerWeek: 12,
        weeksPerYear: 20,
        years: 4,
        description: 'State-ranked singles player, team captain senior year, sportsmanship award',
        leadership: true,
        recognition: 'state',
        startDate: new Date('2020-08-01'),
      },
    ],
    nationality: 'American',
    residency: 'domestic',
    firstGeneration: false,
    legacyStatus: undefined,
    intendedMajor: 'computer_science',
    applicationRound: 'early_decision',
    personalStatementQuality: 9,
    supplementalEssaysQuality: 9,
    recommendationStrength: 9,
    highSchoolProfile: {
      name: 'Thomas Jefferson HSST',
      type: 'public',
      location: { city: 'Alexandria', state: 'VA', country: 'USA' },
      graduationClassSize: 400,
      apCoursesOffered: 28,
      ibProgram: false,
      collegeAcceptanceRate: 0.98,
      averageSAT: 1510,
      averageACT: 34,
      counselingRatio: 150,
      rigorRating: 5,
    },
    extracurricularHours: 0,
    leadershipRoles: 0,
    awards: [
      { name: 'Regeneron STS Scholar', level: 'national', year: 2024, category: 'Science' },
      { name: 'USAMO Qualifier', level: 'national', year: 2023, category: 'Math' },
      { name: 'Presidential Volunteer Service Award Gold', level: 'national', year: 2024, category: 'Service' },
    ],
  }),
  
  // International applicant targeting UK/Europe
  strongInternational: buildProfile({
    gpa: 3.95,
    gpaScale: 4.0,
    classRank: 5,
    classSize: 200,
    sat: 1520,
    act: undefined,
    apScores: [5, 5, 5, 5, 5],
    ibScore: 42,
    aLevels: undefined,
    toefl: 115,
    ielts: 8.5,
    activities: [
      {
        name: 'IB Extended Essay - Quantum Computing',
        category: 'research',
        hoursPerWeek: 10,
        weeksPerYear: 30,
        years: 1,
        description: 'Original research on error correction in quantum algorithms, scored A',
        leadership: false,
        recognition: 'school',
        startDate: new Date('2023-01-01'),
      },
      {
        name: 'MUN Secretary-General',
        category: 'leadership',
        hoursPerWeek: 8,
        weeksPerYear: 40,
        years: 2,
        description: 'Led 200-delegate conference, managed 30-person secretariat, raised $50k sponsorship',
        leadership: true,
        recognition: 'national',
        startDate: new Date('2022-09-01'),
      },
      {
        name: 'Piano - Diploma Level',
        category: 'arts',
        hoursPerWeek: 10,
        weeksPerYear: 48,
        years: 10,
        description: 'ABRSM Diploma (ARSM) with distinction, performed at national concert hall',
        leadership: false,
        recognition: 'national',
        startDate: new Date('2014-09-01'),
      },
      {
        name: 'Climate Action Volunteer Coordinator',
        category: 'service',
        hoursPerWeek: 5,
        weeksPerYear: 50,
        years: 3,
        description: 'Coordinated 50 volunteers for beach cleanups, policy advocacy with local government',
        leadership: true,
        recognition: 'regional',
        startDate: new Date('2021-09-01'),
      },
    ],
    nationality: 'Indian',
    residency: 'international',
    firstGeneration: true,
    legacyStatus: undefined,
    intendedMajor: 'computer_science',
    applicationRound: 'regular',
    personalStatementQuality: 8,
    supplementalEssaysQuality: 8,
    recommendationStrength: 8,
    highSchoolProfile: {
      name: 'International School of Singapore',
      type: 'international',
      location: { city: 'Singapore', state: '', country: 'Singapore' },
      graduationClassSize: 200,
      apCoursesOffered: 20,
      ibProgram: true,
      collegeAcceptanceRate: 0.95,
      averageSAT: 1450,
      averageACT: 33,
      counselingRatio: 80,
      rigorRating: 5,
    },
    extracurricularHours: 0,
    leadershipRoles: 0,
    awards: [
      { name: 'IB Diploma 42/45', level: 'school', year: 2024, category: 'Academic' },
      { name: 'Best Delegate - THIMUN', level: 'international', year: 2023, category: 'MUN' },
      { name: 'ARSM Piano Distinction', level: 'national', year: 2023, category: 'Arts' },
    ],
  }),
  
  // UK applicant targeting Oxbridge
  ukOxbridge: buildProfile({
    gpa: 3.9,
    gpaScale: 4.0,
    classRank: undefined,
    classSize: undefined,
    sat: undefined,
    act: undefined,
    apScores: undefined,
    ibScore: undefined,
    aLevels: [
      { subject: 'Mathematics', grade: 'A*' },
      { subject: 'Further Mathematics', grade: 'A*' },
      { subject: 'Physics', grade: 'A*' },
      { subject: 'Chemistry', grade: 'A' },
    ],
    toefl: undefined,
    ielts: 8.0,
    activities: [
      {
        name: 'Physics Olympiad (BPhO) Gold',
        category: 'academic',
        hoursPerWeek: 5,
        weeksPerYear: 40,
        years: 2,
        description: 'Top 50 nationally, attended Oxford training camp',
        leadership: false,
        recognition: 'national',
        startDate: new Date('2022-09-01'),
      },
      {
        name: 'STEM Mentoring Program Founder',
        category: 'leadership',
        hoursPerWeek: 4,
        weeksPerYear: 36,
        years: 2,
        description: 'Created peer tutoring program for 100+ GCSE students in maths/physics',
        leadership: true,
        recognition: 'regional',
        startDate: new Date('2022-09-01'),
      },
      {
        name: 'Raspberry Pi Robotics Club President',
        category: 'academic',
        hoursPerWeek: 3,
        weeksPerYear: 36,
        years: 3,
        description: 'Led team to national robotics finals, mentored younger students',
        leadership: true,
        recognition: 'national',
        startDate: new Date('2021-09-01'),
      },
    ],
    nationality: 'British',
    residency: 'domestic',
    firstGeneration: false,
    legacyStatus: undefined,
    intendedMajor: 'engineering',
    applicationRound: 'regular',
    personalStatementQuality: 9,
    supplementalEssaysQuality: 9,
    recommendationStrength: 9,
    highSchoolProfile: {
      name: 'Westminster School',
      type: 'private',
      location: { city: 'London', state: '', country: 'UK' },
      graduationClassSize: 180,
      apCoursesOffered: 0,
      ibProgram: false,
      collegeAcceptanceRate: 0.95,
      averageSAT: 0,
      averageACT: 0,
      counselingRatio: 30,
      rigorRating: 5,
    },
    extracurricularHours: 0,
    leadershipRoles: 0,
    awards: [
      { name: 'BPhO Gold Award', level: 'national', year: 2023, category: 'Physics' },
      { name: 'UKMT Senior Maths Challenge Gold', level: 'national', year: 2023, category: 'Math' },
    ],
  }),
  
  // Canadian applicant targeting UWaterloo CS
  canadianCS: buildProfile({
    gpa: 96,
    gpaScale: 100,
    classRank: 10,
    classSize: 300,
    sat: 1500,
    act: undefined,
    apScores: [5, 5, 5, 5],
    ibScore: undefined,
    aLevels: undefined,
    toefl: undefined,
    ielts: undefined,
    activities: [
      {
        name: 'Euclid Mathematics Contest - Top 1%',
        category: 'academic',
        hoursPerWeek: 3,
        weeksPerYear: 20,
        years: 3,
        description: 'Score 95/100, school champion 2 years',
        leadership: false,
        recognition: 'national',
        startDate: new Date('2021-09-01'),
      },
      {
        name: 'Open Source Contributor - React Native',
        category: 'research',
        hoursPerWeek: 8,
        weeksPerYear: 50,
        years: 2,
        description: 'Core contributor to popular library (50k+ weekly downloads), 50+ merged PRs',
        leadership: true,
        recognition: 'international',
        startDate: new Date('2022-06-01'),
      },
      {
        name: 'Hackathon Organizer - HackTheNorth',
        category: 'leadership',
        hoursPerWeek: 5,
        weeksPerYear: 10,
        years: 2,
        description: 'Co-directed 1000-person hackathon, managed sponsorship ($200k), logistics',
        leadership: true,
        recognition: 'national',
        startDate: new Date('2022-01-01'),
      },
      {
        name: 'CS Tutor - School Peer Tutoring',
        category: 'academic',
        hoursPerWeek: 3,
        weeksPerYear: 36,
        years: 2,
        description: 'Tutored 20+ students in Java/Python, improved average grades by 15%',
        leadership: false,
        recognition: 'school',
        startDate: new Date('2022-09-01'),
      },
    ],
    nationality: 'Canadian',
    residency: 'domestic',
    firstGeneration: false,
    legacyStatus: undefined,
    intendedMajor: 'computer_science',
    applicationRound: 'regular',
    personalStatementQuality: 8,
    supplementalEssaysQuality: 8,
    recommendationStrength: 8,
    highSchoolProfile: {
      name: 'University of Toronto Schools',
      type: 'private',
      location: { city: 'Toronto', state: 'ON', country: 'Canada' },
      graduationClassSize: 300,
      apCoursesOffered: 15,
      ibProgram: false,
      collegeAcceptanceRate: 0.98,
      averageSAT: 1420,
      averageACT: 32,
      counselingRatio: 60,
      rigorRating: 5,
    },
    extracurricularHours: 0,
    leadershipRoles: 0,
    awards: [
      { name: 'Euclid Contest School Champion', level: 'school', year: 2023, category: 'Math' },
      { name: 'CCC Senior - Perfect Score', level: 'national', year: 2023, category: 'Computing' },
      { name: 'HackTheNorth Grand Prize', level: 'national', year: 2023, category: 'Hackathon' },
    ],
  }),
  
  // Australian applicant targeting Medicine
  australianMed: buildProfile({
    gpa: 99.5,
    gpaScale: 100,
    classRank: 1,
    classSize: 200,
    sat: undefined,
    act: undefined,
    apScores: undefined,
    ibScore: 44,
    aLevels: undefined,
    toefl: undefined,
    ielts: 8.0,
    activities: [
      {
        name: 'Hospital Volunteer - 500+ hours',
        category: 'service',
        hoursPerWeek: 6,
        weeksPerYear: 40,
        years: 2,
        description: 'Patient support in emergency and oncology wards, developed communication skills',
        leadership: false,
        recognition: 'school',
        startDate: new Date('2022-02-01'),
      },
      {
        name: 'Medical Research - Cancer Genetics',
        category: 'research',
        hoursPerWeek: 8,
        weeksPerYear: 20,
        years: 1,
        description: 'Summer research program at university, contributed to publication',
        leadership: false,
        recognition: 'state',
        startDate: new Date('2023-12-01'),
      },
      {
        name: 'School Captain',
        category: 'leadership',
        hoursPerWeek: 10,
        weeksPerYear: 40,
        years: 1,
        description: 'Led student body of 1500, represented school at official functions',
        leadership: true,
        recognition: 'school',
        startDate: new Date('2024-01-01'),
      },
      {
        name: 'Rural Health Outreach Program',
        category: 'service',
        hoursPerWeek: 4,
        weeksPerYear: 10,
        years: 2,
        description: 'Organized health screenings in remote communities, 200+ patients served',
        leadership: true,
        recognition: 'national',
        startDate: new Date('2022-06-01'),
      },
    ],
    nationality: 'Australian',
    residency: 'domestic',
    firstGeneration: false,
    legacyStatus: undefined,
    intendedMajor: 'medicine',
    applicationRound: 'regular',
    personalStatementQuality: 9,
    supplementalEssaysQuality: 9,
    recommendationStrength: 9,
    highSchoolProfile: {
      name: 'Scotch College Melbourne',
      type: 'private',
      location: { city: 'Melbourne', state: 'VIC', country: 'Australia' },
      graduationClassSize: 200,
      apCoursesOffered: 0,
      ibProgram: true,
      collegeAcceptanceRate: 0.95,
      averageSAT: 0,
      averageACT: 0,
      counselingRatio: 50,
      rigorRating: 5,
    },
    extracurricularHours: 0,
    leadershipRoles: 0,
    awards: [
      { name: 'IB 44/45', level: 'school', year: 2024, category: 'Academic' },
      { name: 'Australian Science Olympiad - Biology Gold', level: 'national', year: 2023, category: 'Science' },
      { name: 'Order of Australia Student Citizenship Award', level: 'national', year: 2024, category: 'Leadership' },
    ],
  }),
  
  // European applicant targeting ETH Zurich / EPFL
  europeanSTEM: buildProfile({
    gpa: 5.8,
    gpaScale: 6.0,
    classRank: 2,
    classSize: 100,
    sat: 1530,
    act: undefined,
    apScores: [5, 5, 5],
    ibScore: undefined,
    aLevels: undefined,
    toefl: 112,
    ielts: 8.0,
    activities: [
      {
        name: 'Swiss Physics Olympiad - Gold Medal',
        category: 'academic',
        hoursPerWeek: 10,
        weeksPerYear: 30,
        years: 2,
        description: 'Selected for national team, attended IPhO training camp',
        leadership: false,
        recognition: 'national',
        startDate: new Date('2022-09-01'),
      },
      {
        name: 'CERN Summer Student Program',
        category: 'research',
        hoursPerWeek: 40,
        weeksPerYear: 8,
        years: 1,
        description: 'Worked on LHCb detector upgrade, analyzed collision data',
        leadership: false,
        recognition: 'international',
        startDate: new Date('2023-07-01'),
      },
      {
        name: 'Robotics Club Founder & President',
        category: 'leadership',
        hoursPerWeek: 8,
        weeksPerYear: 36,
        years: 2,
        description: 'Founded club, led team to Swiss Robotics Championship finals',
        leadership: true,
        recognition: 'national',
        startDate: new Date('2022-09-01'),
      },
    ],
    nationality: 'Swiss',
    residency: 'domestic',
    firstGeneration: false,
    legacyStatus: undefined,
    intendedMajor: 'electrical_engineering',
    applicationRound: 'regular',
    personalStatementQuality: 8,
    supplementalEssaysQuality: 8,
    recommendationStrength: 8,
    highSchoolProfile: {
      name: 'Gymnasium Kirchenfeld',
      type: 'public',
      location: { city: 'Bern', state: 'BE', country: 'Switzerland' },
      graduationClassSize: 100,
      apCoursesOffered: 0,
      ibProgram: false,
      collegeAcceptanceRate: 0.85,
      averageSAT: 0,
      averageACT: 0,
      counselingRatio: 40,
      rigorRating: 5,
    },
    extracurricularHours: 0,
    leadershipRoles: 0,
    awards: [
      { name: 'Swiss Physics Olympiad Gold', level: 'national', year: 2023, category: 'Physics' },
      { name: 'IPhO Participation', level: 'international', year: 2023, category: 'Physics' },
      { name: 'CERN Summer Student', level: 'international', year: 2023, category: 'Research' },
    ],
  }),
};

// ============================================================================
// Demo / Test Runner
// ============================================================================

export async function runDemo() {
  console.log('🎓 AI Admissions Probability Engine - Demo');
  console.log('===========================================\n');
  
  const engine = new AdmissionsEngine({ monteCarloRuns: 5000, randomSeed: 42 });
  
  // Test US universities
  console.log('--- US Universities (Common App) ---');
  const usResults = await engine.analyzeStudent(EXAMPLE_PROFILES.strongUS, [
    'harvard', 'stanford', 'mit', 'yale', 'princeton', 'columbia', 'uchicago', 'upenn',
    'duke', 'northwestern', 'jhu', 'caltech', 'dartmouth', 'brown', 'vanderbilt',
    'rice', 'washu', 'cornell', 'notre_dame', 'ucla', 'ucb', 'usc', 'nyu'
  ]);
  
  for (const [id, result] of Object.entries(usResults)) {
    const pct = (result.simulation.probability * 100).toFixed(1);
    const ci = result.simulation.confidenceInterval.map(x => (x * 100).toFixed(1));
    console.log(`${result.universityName}: ${pct}% (95% CI: ${ci[0]}%-${ci[1]}%)`);
  }
  
  // Test UK universities
  console.log('\n--- UK Universities (UCAS) ---');
  const ukResults = await engine.analyzeStudent(EXAMPLE_PROFILES.ukOxbridge, [
    'oxford', 'cambridge', 'imperial', 'lse', 'ucl', 'kcl', 'edinburgh', 'manchester'
  ]);
  
  for (const [id, result] of Object.entries(ukResults)) {
    const pct = (result.simulation.probability * 100).toFixed(1);
    const ci = result.simulation.confidenceInterval.map(x => (x * 100).toFixed(1));
    console.log(`${result.universityName}: ${pct}% (95% CI: ${ci[0]}%-${ci[1]}%)`);
  }
  
  // Test Canadian universities
  console.log('\n--- Canadian Universities ---');
  const caResults = await engine.analyzeStudent(EXAMPLE_PROFILES.canadianCS, [
    'utoronto', 'mcgill', 'ubc', 'waterloo'
  ]);
  
  for (const [id, result] of Object.entries(caResults)) {
    const pct = (result.simulation.probability * 100).toFixed(1);
    const ci = result.simulation.confidenceInterval.map(x => (x * 100).toFixed(1));
    console.log(`${result.universityName}: ${pct}% (95% CI: ${ci[0]}%-${ci[1]}%)`);
  }
  
  // Test Australian universities
  console.log('\n--- Australian Universities ---');
  const auResults = await engine.analyzeStudent(EXAMPLE_PROFILES.australianMed, [
    'anu', 'melbourne', 'sydney', 'unsw', 'uq'
  ]);
  
  for (const [id, result] of Object.entries(auResults)) {
    const pct = (result.simulation.probability * 100).toFixed(1);
    const ci = result.simulation.confidenceInterval.map(x => (x * 100).toFixed(1));
    console.log(`${result.universityName}: ${pct}% (95% CI: ${ci[0]}%-${ci[1]}%)`);
  }
  
  // Test European universities
  console.log('\n--- European Universities ---');
  const euResults = await engine.analyzeStudent(EXAMPLE_PROFILES.europeanSTEM, [
    'eth_zurich', 'epfl', 'tu_munich', 'tu_delft', 'kth', 'sciences_po', 'bocconi', 'ie_madrid'
  ]);
  
  for (const [id, result] of Object.entries(euResults)) {
    const pct = (result.simulation.probability * 100).toFixed(1);
    const ci = result.simulation.confidenceInterval.map(x => (x * 100).toFixed(1));
    console.log(`${result.universityName}: ${pct}% (95% CI: ${ci[0]}%-${ci[1]}%)`);
  }
  
  // Show detailed analysis for one university
  console.log('\n--- Detailed Analysis: Harvard ---');
  const harvardResult = usResults['harvard'];
  if (harvardResult) {
    console.log(`Probability: ${(harvardResult.simulation.probability * 100).toFixed(1)}%`);
    console.log(`Percentile vs Admitted: ${harvardResult.simulation.percentile.toFixed(0)}th`);
    console.log(`Confidence Interval: ${harvardResult.simulation.confidenceInterval.map(x => (x*100).toFixed(1)).join('% - ')}%`);
    console.log(`Runs: ${harvardResult.simulation.runs}`);
    console.log(`Standard Error: ${harvardResult.simulation.standardError.toFixed(4)}`);
    
    console.log('\nTop Levers:');
    for (const lever of harvardResult.levers.quickWins.slice(0, 3)) {
      console.log(`  • ${lever.factor}: +${(lever.probabilityGain * 100).toFixed(1)}% (${lever.effort} effort, ${lever.timeframe})`);
    }
    
    console.log('\nLong-term Investments:');
    for (const lever of harvardResult.levers.longTermInvestments.slice(0, 3)) {
      console.log(`  • ${lever.factor}: +${(lever.probabilityGain * 100).toFixed(1)}% (${lever.effort} effort, ${lever.timeframe})`);
    }
    
    console.log('\nTrajectory:');
    for (const point of harvardResult.trajectory.timeline.slice(0, 4)) {
      console.log(`  ${point.date.toLocaleDateString()}: ${(point.probability * 100).toFixed(1)}% - ${point.narrative}`);
    }
    
    console.log('\nRisk Factors:');
    for (const risk of harvardResult.trajectory.riskFactors.slice(0, 3)) {
      console.log(`  ⚠ ${risk.factor} (${risk.severity}): ${risk.mitigation}`);
    }
  }
  
  console.log('\n✅ Demo completed!');
}

// Run if executed directly
if (require.main === module) {
  runDemo().catch(console.error);
}