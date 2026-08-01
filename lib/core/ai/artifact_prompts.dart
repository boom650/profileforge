/// Pre-built prompts for different artifact types
class ArtifactPrompts {
  ArtifactPrompts._();

  /// Analyze a research paper or project description
  static String researchPaper({
    required String title,
    required String description,
    String? methodology,
    String? findings,
    String? targetUniversity,
  }) {
    final buffer = StringBuffer();
    buffer.writeln('Analyze this research activity for elite college admissions:');
    buffer.writeln('');
    buffer.writeln('**Title**: $title');
    buffer.writeln('**Description**: $description');
    if (methodology != null) buffer.writeln('**Methodology**: $methodology');
    if (findings != null) buffer.writeln('**Findings**: $findings');
    buffer.writeln('');
    buffer.writeln('Evaluate:');
    buffer.writeln('1. Research rigor and methodology quality');
    buffer.writeln('2. Originality and intellectual curiosity demonstrated');
    buffer.writeln('3. Impact and real-world relevance');
    buffer.writeln('4. How to strengthen the narrative for admissions');
    if (targetUniversity != null) {
      buffer.writeln('5. Specific alignment with $targetUniversity values');
    }
    return buffer.toString();
  }

  /// Analyze a personal essay or statement
  static String personalEssay({
    required String essayText,
    String? prompt,
    String? targetUniversity,
  }) {
    final buffer = StringBuffer();
    buffer.writeln('Critique this personal essay for college admissions:');
    buffer.writeln('');
    if (prompt != null) buffer.writeln('**Essay Prompt**: $prompt');
    buffer.writeln('**Essay Text**:');
    buffer.writeln(essayText);
    buffer.writeln('');
    buffer.writeln('Evaluate:');
    buffer.writeln('1. Narrative voice and authenticity');
    buffer.writeln('2. Specificity vs generic platitudes');
    buffer.writeln('3. Emotional impact and vulnerability');
    buffer.writeln('4. Structure and flow');
    buffer.writeln('5. What admissions officers at top schools would think');
    buffer.writeln('');
    buffer.writeln('Provide a line-by-line critique of the strongest and weakest paragraphs.');
    return buffer.toString();
  }

  /// Analyze extracurricular activities
  static String activities({
    required List<Map<String, String>> activities,
    String? targetUniversity,
  }) {
    final buffer = StringBuffer();
    buffer.writeln('Evaluate this activity list for elite college admissions:');
    buffer.writeln('');
    for (var i = 0; i < activities.length; i++) {
      final a = activities[i];
      buffer.writeln('${i + 1}. **${a['name'] ?? 'Unknown'}**');
      if (a['role'] != null) buffer.writeln('   Role: ${a['role']}');
      if (a['duration'] != null) buffer.writeln('   Duration: ${a['duration']}');
      if (a['description'] != null) buffer.writeln('   Description: ${a['description']}');
      buffer.writeln('');
    }
    buffer.writeln('Evaluate:');
    buffer.writeln('1. Depth vs breadth balance');
    buffer.writeln('2. Leadership evidence');
    buffer.writeln('3. Impact and outcomes');
    buffer.writeln('4. How to position the "spike" (area of deepest expertise)');
    buffer.writeln('5. Missing opportunities to strengthen the profile');
    return buffer.toString();
  }

  /// Generate a daily mission based on student goals
  static String dailyMission({
    required Map<String, dynamic> studentProfile,
    required List<String> recentActivities,
    required String targetDeadline,
  }) {
    final buffer = StringBuffer();
    buffer.writeln('Generate a personalized daily mission for this student:');
    buffer.writeln('');
    buffer.writeln('**Student Profile**:');
    studentProfile.forEach((key, value) {
      buffer.writeln('- $key: $value');
    });
    buffer.writeln('');
    buffer.writeln('**Recent Activities**: ${recentActivities.join(", ")}');
    buffer.writeln('**Application Deadline**: $targetDeadline');
    buffer.writeln('');
    buffer.writeln('Generate ONE specific, actionable mission that:');
    buffer.writeln('1. Advances their application in a measurable way');
    buffer.writeln('2. Can be completed in 30-60 minutes');
    buffer.writeln('3. Builds toward the application deadline');
    buffer.writeln('4. Matches their current skill level and interests');
    buffer.writeln('');
    buffer.writeln('Format: Title, Description, Expected Outcome, Time Estimate');
    return buffer.toString();
  }

  /// Admissions readiness assessment
  static String readinessCheck({
    required Map<String, dynamic> studentData,
    required String targetUniversity,
  }) {
    final buffer = StringBuffer();
    buffer.writeln('Assess admissions readiness for $targetUniversity:');
    buffer.writeln('');
    studentData.forEach((key, value) {
      buffer.writeln('- $key: $value');
    });
    buffer.writeln('');
    buffer.writeln('Provide:');
    buffer.writeln('1. Overall readiness score (1-100)');
    buffer.writeln('2. Strengths (top 3)');
    buffer.writeln('3. Critical gaps (top 3)');
    buffer.writeln('4. Timeline recommendations (weeks before deadline)');
    buffer.writeln('5. Risk assessment: what could go wrong');
    return buffer.toString();
  }
}
