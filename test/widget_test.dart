import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_instrument/app.dart';
import 'package:the_instrument/core/constants.dart';

void main() {
  testWidgets('App smoke test - Today screen renders properly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: TheInstrumentApp(),
      ),
    );

    expect(find.text(appTitle), findsOneWidget);
    expect(find.text(weekDayDefault), findsOneWidget);
    expect(find.text(morningRoutineNotStarted), findsOneWidget);
    expect(find.text(startRoutineButton), findsOneWidget);
    expect(find.text(tabToday), findsOneWidget);
    expect(find.text(tabRoutine), findsOneWidget);
    expect(find.text(tabProgress), findsOneWidget);
    expect(find.text(tabSettings), findsOneWidget);
  });
}
