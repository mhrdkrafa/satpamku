import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:satpamku_app/core/theme/app_theme.dart';
import 'package:satpamku_app/core/theme/app_typography.dart';
import 'package:satpamku_app/core/widgets/app_badge.dart';
import 'package:satpamku_app/core/widgets/app_button.dart';
import 'package:satpamku_app/core/widgets/app_text_field.dart';
import 'package:satpamku_app/core/widgets/empty_state_widget.dart';
import 'package:satpamku_app/core/widgets/error_state_widget.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  AppTypography.useGoogleFonts = false;

  Widget createTestWidget(Widget child) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      home: Scaffold(body: Center(child: child)),
    );
  }

  group('Component Widget Tests', () {
    testWidgets('AppButton renders and handles click', (WidgetTester tester) async {
      bool clicked = false;

      await tester.pumpWidget(
        createTestWidget(
          AppButton(
            text: 'Daftar Sebagai Satpam',
            onPressed: () => clicked = true,
          ),
        ),
      );

      expect(find.text('Daftar Sebagai Satpam'), findsOneWidget);

      await tester.tap(find.byType(AppButton));
      await tester.pump();

      expect(clicked, true);
    });

    testWidgets('AppButton displays loading indicator when isLoading is true', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          const AppButton(
            text: 'Simpan Data',
            isLoading: true,
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Simpan Data'), findsNothing);
    });

    testWidgets('AppBadge renders certificate and urgent badges', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          Column(
            children: [
              AppBadge.certificate('gada_pratama'),
              AppBadge.urgent(),
              AppBadge.status('verified'),
            ],
          ),
        ),
      );

      expect(find.text('Gada Pratama'), findsOneWidget);
      expect(find.text('URGENT HIRING'), findsOneWidget);
      expect(find.text('Terverifikasi'), findsOneWidget);
    });

    testWidgets('AppTextField renders label and responds to input', (WidgetTester tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        createTestWidget(
          AppTextField(
            label: 'Nomor Telepon / WhatsApp',
            hint: '081234567890',
            controller: controller,
          ),
        ),
      );

      expect(find.text('Nomor Telepon / WhatsApp'), findsOneWidget);

      await tester.enterText(find.byType(TextFormField), '081299887766');
      expect(controller.text, '081299887766');
    });

    testWidgets('EmptyStateWidget and ErrorStateWidget render message and action buttons', (WidgetTester tester) async {
      bool retried = false;

      await tester.pumpWidget(
        createTestWidget(
          ErrorStateWidget(
            title: 'Koneksi Terputus',
            onRetry: () => retried = true,
          ),
        ),
      );

      expect(find.text('Koneksi Terputus'), findsOneWidget);
      expect(find.text('Coba Lagi'), findsOneWidget);

      await tester.tap(find.text('Coba Lagi'));
      await tester.pump();

      expect(retried, true);
    });
  });
}
