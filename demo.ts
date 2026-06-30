#!/usr/bin/env node
/**
 * Demo runner for AI Admissions Probability Engine
 */

import { 
  AdmissionsEngine, 
  UNIVERSITY_MODELS, 
  EXAMPLE_PROFILES,
  runDemo,
  analyzeStudentProfile,
  getAllUniversityIds
} from './lib/services/index';

// Run the full demo
async function main() {
  console.log('🎓 AI Admissions Probability Engine - Full Demo');
  console.log('===============================================\n');
  
  await runDemo();
  
  // Additional: Cross-system comparison for a single profile
  console.log('\n--- Cross-System Comparison for Strong US Profile ---');
  const engine = new AdmissionsEngine({ monteCarloRuns: 5000, randomSeed: 42 });
  
  const allUniIds = getAllUniversityIds();
  console.log(`Testing ${allUniIds.length} universities across 5 countries...\n`);
  
  const results = await engine.analyzeStudent(EXAMPLE_PROFILES.strongUS, allUniIds);
  
  // Group by country
  const byCountry: Record<string, Array<{name: string, prob: number}>> = {};
  for (const [id, result] of Object.entries(results)) {
    const model = UNIVERSITY_MODELS[id];
    if (!model) continue;
    if (!byCountry[model.country]) byCountry[model.country] = [];
    byCountry[model.country].push({ name: result.universityName, prob: result.simulation.probability });
  }
  
  for (const [country, unis] of Object.entries(byCountry)) {
    console.log(`\n${country}:`);
    unis.sort((a, b) => b.prob - a.prob);
    for (const u of unis) {
      console.log(`  ${u.name}: ${(u.prob * 100).toFixed(1)}%`);
    }
  }
  
  console.log('\n✅ Demo complete!');
}

main().catch(console.error);