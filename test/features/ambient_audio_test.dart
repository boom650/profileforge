import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/features/audio/presentation/ambient_audio_panel.dart';

void main() {
  testWidgets('ambient audio panel renders control buttons', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: Scaffold(body: AmbientAudioPanel())),
      ),
    );
    
    // Should show play button and volume slider
    expect(find.byIcon(Icons.play_arrow), findsOneWidget);
    expect(find.byType(Slider), findsOneWidget);
    
    // Tap play to switch to pause
    await tester.tap(find.byIcon(Icons.play_arrow));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.pause), findsOneWidget);
  });
  
  testWidgets('ambient audio panel shows sound options', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: AmbientAudioPanel(showSoundOptions: true),
          ),
        ),
      ),
    );
    
    // Should show sound selection chips
    expect(find.byType(Chip), findsWidgets);
    expect(find.byType(Wrap), findsOneWidget);
  });
}