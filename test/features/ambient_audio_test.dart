import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/features/timer/presentation/ambient_audio_panel.dart';

void main() {
  testWidgets('ambient audio panel renders', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: Scaffold(body: AmbientAudioPanel())),
      ),
    );
    
    // Should render the container
    expect(find.byType(AmbientAudioPanel), findsOneWidget);
  });
}