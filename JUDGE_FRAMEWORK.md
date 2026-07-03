# ProfileForge Multi-Judge Evaluation Framework

## How This Works
Each judge is a specialized sub-agent persona that reads the ProfileForge codebase
and evaluates it from their unique perspective. Judges produce structured scores
on 8 criteria (100 points each). The framework aggregates results and identifies
improvement priorities.

## Judge Personas (34 total)

### UI/UX Experts (7)
1. **Visual Design Expert** - Color theory, typography, spacing, Material 3 compliance
2. **Interaction Design Expert** - Micro-interactions, animations, feedback loops
3. **Accessibility Expert** - WCAG 2.1, screen readers, color contrast, touch targets
4. **Motion Design Expert** - Animation timing, physics, delight moments
5. **Mobile UX Expert** - Platform conventions, gesture navigation, thumb zones
6. **Brand Identity Expert** - Consistency, personality, differentiation from competitors
7. **Information Architecture Expert** - Navigation hierarchy, content organization

### Gamification Designers (6)
8. **Retention Expert** - Habit loops, daily engagement, re-engagement
9. **Reward Systems Expert** - Intrinsic vs extrinsic motivation, variable rewards
10. **Progression Design Expert** - Skill trees, leveling curves, milestone design
11. **Social Features Expert** - Leaderboards, teams, accountability, social proof
12. **Balance & Economy Expert** - Virtual economy, inflation prevention, fairness
13. **Behavioral Psychology Expert** - Nudge theory, loss aversion, commitment devices

### Admissions Experts (5)
14. **US Admissions Counselor** - Common App, supplements, holistic review
15. **UK Admissions Expert** - UCAS, personal statement, Oxbridge process
16. **Canadian Admissions Expert** - OUAC, competitive programs
17. **Australian Admissions Expert** - VTAC, ATAR, direct entry
18. **EU Admissions Expert** - Studielink, country-specific requirements

### Student Users (7)
19. **Indian 11th Grader (STEM)** - Targeting US engineering programs
20. **Indian 11th Grader (Liberal Arts)** - Targeting UK humanities
21. **Indian 11th Grader (Business)** - Targeting Canadian business schools
22. **Indian 11th Grader (Arts)** - Targeting EU art schools
23. **Indian 11th Grader (Sports)** - Targeting US athletic scholarships
24. **Indian 10th Grader (Prospective)** - Early explorer, overwhelmed
25. **Indian 12th Grader (Senior)** - Time-pressured, last chance

### Parents & Counselors (6)
26. **Indian Parent (First-gen)** - No overseas education experience
27. **Indian Parent (Experienced)** - Has older child in US university
28. **School Counselor** - Manages 100+ students
29. **Independent Consultant** - Premium service, 1-on-1
30. **NGO/Non-profit Counselor** - Serves underserved students
31. **Teacher/Educator** - Classroom perspective

### Technical Reviewers (3)
32. **Flutter Architecture Expert** - Clean architecture, testability, performance
33. **Backend/Data Expert** - Offline support, sync, data integrity
34. **Security & Privacy Expert** - OWASP, data protection, FERPA/GDPR

## Evaluation Criteria (100 points each)

### 1. Visual Design (Weight: 15%)
- Color palette cohesion and appeal
- Typography hierarchy and readability
- Spacing consistency and rhythm
- Component consistency (cards, buttons, inputs)
- Dark mode quality
- Visual delight (gradients, shadows, animations)
- Comparison to Duolingo/Notion/Linear standards

### 2. Interaction Design (Weight: 15%)
- Touch target adequacy (≥44px)
- Feedback on every user action
- Animation timing and easing
- Error state handling
- Loading state handling
- Empty state design
- Haptic feedback strategy

### 3. Gamification Depth (Weight: 15%)
- Streak system sophistication
- Reward variety and appeal
- Progression clarity
- Social competition mechanics
- Balance between challenge and achievability
- Variable reward schedules
- Long-term engagement hooks

### 4. Onboarding Experience (Weight: 10%)
- First impression impact
- Progress indicator clarity
- Information pacing (not overwhelming)
- Personalization during setup
- Value proposition clarity
- Completion motivation
- Skip/back navigation

### 5. Core Value Delivery (Weight: 15%)
- Activity categorization quality
- Admissions probability accuracy
- Opportunity discovery relevance
- Profile completeness visualization
- Actionable next steps
- Data-driven recommendations
- Indian education context accuracy

### 6. Technical Excellence (Weight: 10%)
- Code architecture cleanliness
- Performance (no jank)
- Offline capability
- Error handling robustness
- State management choice
- Test coverage potential
- Build system reliability

### 7. Accessibility (Weight: 10%)
- Color contrast ratios
- Screen reader compatibility
- Font scalability
- Touch target sizes
- Keyboard navigation (web)
- Reduced motion support
- Semantic HTML/labels

### 8. Engagement Potential (Weight: 10%)
- Daily return motivation
- Session depth potential
- Viral/share mechanics
- Push notification strategy
- Content freshness
- Community features
- Competitive differentiation
