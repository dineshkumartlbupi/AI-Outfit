import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:ai_outfit_app/main.dart';
import 'package:ai_outfit_app/state/tryon_provider.dart';

void main() {
  testWidgets('App smoke test launches MainNavigation', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => TryOnProvider()),
        ],
        child: const AIOutfitApp(),
      ),
    );

    expect(find.text('TRY ON AI'), findsWidgets);
  });
}
