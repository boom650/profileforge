import os
import re
import json

def run_judge():
    # 1. Run Flutter Analyze
    os.system('flutter analyze > analyze_report.txt')
    with open('analyze_report.txt', 'r') as f:
        analyze_output = f.read()
    
    # 2. Run Tests
    os.system('flutter test > test_report.txt')
    with open('test_report.txt', 'r') as f:
        test_output = f.read()

    # 3. Simple scoring logic (Placeholder for complex ruby analysis)
    # Lint warnings
    lint_warnings = len(re.findall(r'warning', analyze_output, re.IGNORECASE))
    
    # Simple score based on lint count
    score = max(0, 100 - (lint_warnings * 2))
    
    report = {
        'overall_score': score,
        'evidence': {
            'lint_warnings_count': lint_warnings,
            'lint_summary': analyze_output[:500],
            'test_summary': test_output[:500]
        }
    }
    
    with open('judge_report.json', 'w') as f:
        json.dump(report, f, indent=2)

if __name__ == '__main__':
    run_judge()

