import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:khetmti/features/khetma/models/khetma_part.dart';
import 'package:khetmti/features/khetma/models/part_state.dart';
import 'package:khetmti/features/khetma/presentation/widgets/part_tile.dart';
import 'package:khetmti/shared/widgets/app_text_field.dart';
import 'package:khetmti/shared/widgets/sliding_segments.dart';

Widget _app(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  group('PartTile', () {
    final calls = <String>[];

    Widget tile(PartState state, {String? reader, bool busy = false}) => _app(
          PartTile(
            number: 2,
            title: 'سورة البقرة',
            part: KhetmaPart(username: reader),
            state: state,
            busy: busy,
            onOpen: () => calls.add('open'),
            onReserve: () => calls.add('reserve'),
            onFinish: () => calls.add('finish'),
            onRelease: () => calls.add('release'),
            onUndo: () => calls.add('undo'),
          ),
        );

    setUp(calls.clear);

    testWidgets('available: says so and offers to reserve', (tester) async {
      await tester.pumpWidget(tile(PartState.available));
      expect(find.text('متاحة للحجز'), findsOneWidget);
      await tester.tap(find.text('احجز'));
      expect(calls, ['reserve']);
    });

    testWidgets('mine: offers to finish or release', (tester) async {
      await tester.pumpWidget(tile(PartState.mine));
      expect(find.text('محجوزة لك'), findsOneWidget);
      await tester.tap(find.text('أتممت'));
      await tester.tap(find.byTooltip('إلغاء الحجز'));
      expect(calls, ['finish', 'release']);
    });

    testWidgets('taken: names the reader and offers no action', (tester) async {
      await tester.pumpWidget(tile(PartState.taken, reader: 'رانية'));
      expect(find.text('محجوزة لـ رانية'), findsOneWidget);
      expect(find.text('احجز'), findsNothing);
      expect(find.text('أتممت'), findsNothing);
    });

    testWidgets('finished by me: can be undone', (tester) async {
      await tester.pumpWidget(tile(PartState.finishedByMe));
      expect(find.text('أتممتَ قراءتها'), findsOneWidget);
      await tester.tap(find.text('تراجع'));
      expect(calls, ['undo']);
    });

    testWidgets('busy: hides the actions behind a spinner', (tester) async {
      await tester.pumpWidget(tile(PartState.available, busy: true));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('احجز'), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('tapping the tile opens the reader', (tester) async {
      await tester.pumpWidget(tile(PartState.taken, reader: 'علي'));
      await tester.tap(find.text('سورة البقرة'));
      expect(calls, ['open']);
    });
  });

  testWidgets('AppTextField shows and hides a password', (tester) async {
    final controller = TextEditingController(text: 'secret');
    await tester.pumpWidget(_app(
      AppTextField(controller: controller, label: 'كلمة السر', isPassword: true),
    ));
    bool obscured() =>
        tester.widget<TextField>(find.byType(TextField)).obscureText;

    expect(obscured(), isTrue);
    await tester.tap(find.byTooltip('إظهار كلمة السر'));
    await tester.pump();
    expect(obscured(), isFalse);
  });

  testWidgets('SlidingSegments reports the tapped segment', (tester) async {
    int? picked;
    await tester.pumpWidget(_app(Center(
      child: SlidingSegments(
        labels: const ['النشطة', 'المكتملة'],
        selected: 0,
        segmentWidth: 100,
        onChanged: (i) => picked = i,
      ),
    )));
    await tester.tap(find.text('المكتملة'));
    expect(picked, 1);
  });
}
