import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:satpamku_app/core/theme/app_theme.dart';
import 'package:satpamku_app/core/theme/app_typography.dart';
import 'package:satpamku_app/features/notifications/models/notification_model.dart';
import 'package:satpamku_app/features/notifications/widgets/notification_card.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  AppTypography.useGoogleFonts = false;

  group('Notification Models Tests', () {
    test('NotificationModel parses correctly and computes isRead', () {
      final json = {
        'id': 'notif-uuid-1234',
        'type': 'application_status',
        'title': 'Undangan Interview: Satpam Bandara',
        'message': 'Jadwal interview Anda telah ditentukan pada 2 September 2026.',
        'payload': {
          'application_id': 10,
          'status': 'interview_scheduled',
        },
        'read_at': null,
        'created_at': '2026-08-30T10:00:00Z',
      };

      final notif = NotificationModel.fromJson(json);

      expect(notif.id, 'notif-uuid-1234');
      expect(notif.type, 'application_status');
      expect(notif.title, 'Undangan Interview: Satpam Bandara');
      expect(notif.isRead, false);
      expect(notif.payload['application_id'], 10);
    });

    test('NotificationListResponse parses unread count and items', () {
      final json = {
        'unread_count': 3,
        'items': [
          {
            'id': '1',
            'type': 'new_application',
            'title': 'Pelamar Baru: Budi',
            'message': 'Kandidat Budi baru saja melamar.',
            'payload': {},
            'read_at': '2026-08-30T11:00:00Z',
            'created_at': '2026-08-30T10:30:00Z',
          }
        ],
      };

      final response = NotificationListResponse.fromJson(json);

      expect(response.unreadCount, 3);
      expect(response.items.length, 1);
      expect(response.items.first.isRead, true);
    });
  });

  group('Notification Widgets Tests', () {
    testWidgets('NotificationCard renders details and responds to tap', (WidgetTester tester) async {
      bool tapped = false;

      final notif = NotificationModel(
        id: 'abc',
        type: 'certificate_near_expiry',
        title: 'Peringatan Masa Berlaku Gada Pratama',
        message: 'Ijazah Gada Pratama Anda akan berakhir dalam 14 hari.',
        payload: {},
        readAt: null,
        createdAt: DateTime(2026, 8, 30, 9, 30),
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: Center(
              child: NotificationCard(
                notification: notif,
                onTap: () => tapped = true,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Peringatan Masa Berlaku Gada Pratama'), findsOneWidget);
      expect(find.text('Ijazah Gada Pratama Anda akan berakhir dalam 14 hari.'), findsOneWidget);

      await tester.tap(find.byType(NotificationCard));
      await tester.pump();

      expect(tapped, true);
    });
  });
}
