// Admissions pillars for college applications
// Shared across gamification models

enum AdmissionsPillar {
  academics,      // Explorer, Scholar
  evidence,       // Evidence Keeper
  consistency,    // Marathon Runner
  research,       // Researcher
  leadership,     // Leader
  creativity,     // Creator
  communityImpact, // Changemaker
  trailblazer,    // Trailblazer (Legendary - encompasses all)
}

extension AdmissionsPillarExtension on AdmissionsPillar {
  String get name => toString().split('.').last;
  
  int get index => AdmissionsPillar.values.indexOf(this);
}