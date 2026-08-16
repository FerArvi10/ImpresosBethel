import 'package:flutter_test/flutter_test.dart';
import 'package:order_tracker/main.dart';

void main() {
  testWidgets('OrderTracker app loads login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const OrderTrackerApp());
    expect(find.textContaining('Impresos Bethel'), findsWidgets);
  });
}
