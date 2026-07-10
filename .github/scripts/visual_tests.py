#!/usr/bin/env python3
"""
Visual Regression Tests for ProfileForge
Runs comprehensive visual tests using Playwright
"""
import asyncio
import json
import os
from datetime import datetime
from pathlib import Path
from playwright.async_api import async_playwright

# Test scenarios covering all critical user flows
SCENARIOS = [
    # Onboarding Flow (CRITICAL)
    {"name": "onboarding_01_welcome", "path": "/#/onboarding", "wait_for": "text=Welcome", "viewport": {"width": 390, "height": 844}},
    {"name": "onboarding_02_consent", "path": "/#/onboarding/consent", "wait_for": "text=Consent", "viewport": {"width": 390, "height": 844}},
    {"name": "onboarding_03_location", "path": "/#/onboarding/location", "wait_for": "text=Location", "viewport": {"width": 390, "height": 844}},
    {"name": "onboarding_04_academic", "path": "/#/onboarding/academic", "wait_for": "text=Academic", "viewport": {"width": 390, "height": 844}},
    {"name": "onboarding_05_activity", "path": "/#/onboarding/activity", "wait_for": "text=Activity", "viewport": {"width": 390, "height": 844}},
    {"name": "onboarding_06_targets", "path": "/#/onboarding/targets", "wait_for": "text=Target", "viewport": {"width": 390, "height": 844}},
    {"name": "onboarding_07_schedule", "path": "/#/onboarding/schedule", "wait_for": "text=Schedule", "viewport": {"width": 390, "height": 844}},
    {"name": "onboarding_08_motivation", "path": "/#/onboarding/motivation", "wait_for": "text=Motivation", "viewport": {"width": 390, "height": 844}},
    {"name": "onboarding_09_roadmap", "path": "/#/onboarding/roadmap", "wait_for": "text=Roadmap", "viewport": {"width": 390, "height": 844}},
    
    # Home & Navigation
    {"name": "home_light", "path": "/#/home", "wait_for": "text=ProfileForge", "viewport": {"width": 390, "height": 844}},
    {"name": "home_dark", "path": "/#/home", "wait_for": "text=ProfileForge", "viewport": {"width": 390, "height": 844}, "color_scheme": "dark"},
    
    # Gamification Screens
    {"name": "missions_screen", "path": "/#/missions", "wait_for": "text=Weekly Missions", "viewport": {"width": 390, "height": 844}},
    {"name": "missions_daily", "path": "/#/missions/daily", "wait_for": "text=Daily Missions", "viewport": {"width": 390, "height": 844}},
    {"name": "streaks_screen", "path": "/#/streaks", "wait_for": "text=Streak", "viewport": {"width": 390, "height": 844}},
    {"name": "skins_collection", "path": "/#/skins", "wait_for": "text=Skin Collection", "viewport": {"width": 390, "height": 844}},
    {"name": "leaderboard", "path": "/#/leaderboard", "wait_for": "text=League", "viewport": {"width": 390, "height": 844}},
    
    # Opportunity Discovery
    {"name": "opportunities_map", "path": "/#/opportunities/map", "wait_for": "css=.map-container", "viewport": {"width": 390, "height": 844}},
    {"name": "opportunities_list", "path": "/#/opportunities/list", "wait_for": "text=Opportunities", "viewport": {"width": 390, "height": 844}},
    {"name": "opportunity_detail_atl", "path": "/#/opportunities/atl_dps_rkp", "wait_for": "text=Atal Tinkering Lab", "viewport": {"width": 390, "height": 844}},
    
    # Admissions Probability
    {"name": "admissions_dashboard", "path": "/#/admissions", "wait_for": "text=Admissions Probability", "viewport": {"width": 390, "height": 844}},
    {"name": "admissions_university", "path": "/#/admissions/mit", "wait_for": "text=MIT", "viewport": {"width": 390, "height": 844}},
    
    # Profile & Settings
    {"name": "profile_screen", "path": "/#/profile", "wait_for": "text=Profile", "viewport": {"width": 390, "height": 844}},
    {"name": "settings_screen", "path": "/#/settings", "wait_for": "text=Settings", "viewport": {"width": 390, "height": 844}},
]

CRITICAL_SCENARIOS = [
    "onboarding_01_welcome", "onboarding_02_consent", "onboarding_03_location",
    "onboarding_04_academic", "onboarding_05_activity", "onboarding_06_targets",
    "onboarding_07_schedule", "onboarding_08_motivation", "onboarding_09_roadmap",
    "home_light", "home_dark"
]

async def run_visual_tests():
    """Run all visual regression tests"""
    os.makedirs("visual_tests", exist_ok=True)
    
    results = []
    passed = 0
    failed = 0
    
    async with async_playwright() as p:
        # Launch browser with consistent settings
        browser = await p.chromium.launch(
            headless=True,
            args=['--disable-web-security', '--disable-features=VizDisplayCompositor']
        )
        
        for scenario in SCENARIOS:
            print(f"Testing: {scenario['name']}...")
            
            context = await browser.new_context(
                viewport=scenario["viewport"],
                device_scale_factor=2,
                is_mobile=True,
                has_touch=True,
                color_scheme=scenario.get("color_scheme", "light")
            )
            
            page = await context.new_page()
            
            # Track console errors
            console_errors = []
            page.on("console", lambda msg: console_errors.append(msg.text) if msg.type == "error" else None)
            
            try:
                # Navigate to the page
                await page.goto(
                    f"http://localhost:8080{scenario['path']}",
                    wait_until="networkidle",
                    timeout=30000
                )
                
                # Wait for the specific element
                await page.wait_for_selector(scenario["wait_for"], timeout=15000)
                
                # Wait for animations/transitions to settle
                await page.wait_for_timeout(2000)
                
                # Take full-page screenshot
                screenshot_path = f"visual_tests/{scenario['name']}.png"
                await page.screenshot(path=screenshot_path, full_page=True)
                
                # Measure CLS (Cumulative Layout Shift)
                cls = await page.evaluate("""
                    () => new Promise(resolve => {
                        new PerformanceObserver(list => {
                            const entries = list.getEntries();
                            if (entries.length > 0) {
                                resolve(entries[entries.length - 1].value);
                            }
                        }).observe({type: 'layout-shift', buffered: true});
                        setTimeout(() => resolve(0), 5000);
                    })
                """)
                
                results.append({
                    "name": scenario["name"],
                    "path": scenario["path"],
                    "status": "passed",
                    "screenshot": screenshot_path,
                    "cls": cls,
                    "console_errors": console_errors,
                    "viewport": scenario["viewport"],
                    "color_scheme": scenario.get("color_scheme", "light"),
                    "timestamp": datetime.now().isoformat()
                })
                passed += 1
                print(f"  ✅ {scenario['name']} - CLS: {cls:.4f}")
                
            except Exception as e:
                results.append({
                    "name": scenario["name"],
                    "path": scenario["path"],
                    "status": "failed",
                    "error": str(e),
                    "viewport": scenario["viewport"],
                    "color_scheme": scenario.get("color_scheme", "light"),
                    "timestamp": datetime.now().isoformat()
                })
                failed += 1
                print(f"  ❌ {scenario['name']}: {e}")
            
            await context.close()
        
        await browser.close()
    
    # Check critical scenarios
    critical_failures = [r for r in results if r["status"] == "failed" and r["name"] in CRITICAL_SCENARIOS]
    
    # Save results
    summary = {
        "run_id": os.environ.get("GITHUB_RUN_ID", "local"),
        "timestamp": datetime.now().isoformat(),
        "total_scenarios": len(SCENARIOS),
        "passed": passed,
        "failed": failed,
        "critical_failures": len(critical_failures),
        "results": results
    }
    
    with open("visual_test_results.json", "w") as f:
        json.dump(summary, f, indent=2)
    
    print(f"\n{'='*50}")
    print(f"Visual Tests: {passed}/{len(SCENARIOS)} passed")
    print(f"Critical failures: {len(critical_failures)}")
    print(f"{'='*50}")
    
    if critical_failures:
        print("❌ CRITICAL FAILURES:")
        for cf in critical_failures:
            print(f"  - {cf['name']}: {cf.get('error', 'Unknown error')}")
        exit(1)
    
    if failed > 0:
        print(f"⚠️  {failed} non-critical tests failed")
    
    return summary

if __name__ == "__main__":
    asyncio.run(run_visual_tests())