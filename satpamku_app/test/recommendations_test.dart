import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:satpamku_app/core/theme/app_theme.dart';
import 'package:satpamku_app/core/theme/app_typography.dart';
import 'package:satpamku_app/features/jobs/models/job_model.dart';
import 'package:satpamku_app/features/jobs/widgets/job_card.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  AppTypography.useGoogleFonts = false;

  group('Recommendation Engine Tests', () {
    test('JobModel parses matchScore and explainable matchReasons', () {
      final json = {
        'id': 1,
        'title': 'Satpam Perbankan Sudirman',
        'slug': 'satpam-perbankan-sudirman',
        'employer': {'company_name': 'PT Sigap Prima'},
        'category': {'name': 'Perbankan'},
        'location': {'name': 'Jakarta Selatan'},
        'shift_type': '3_shift',
        'required_certificate_level': 'gada_pratama',
        'match_score': 95,
        'match_reasons': [
          'Ijazah Gada Pratama memenuhi kualifikasi lowongan',
          'Lokasi penempatan cocok dengan domisili Anda',
          'Tinggi badan (174 cm) memenuhi standar fisik minimal',
        ],
      };

      final job = JobModel.fromJson(json);

      expect(job.matchScore, 95);
      expect(job.matchReasons.length, 3);
      expect(job.matchReasons.first, contains('Gada Pratama'));
    });

    testWidgets('JobCard renders match percentage badge when matchScore is present', (WidgetTester tester) async {
      final job = JobModel(
        id: 1,
        title: 'Komandan Regu Security',
        slug: 'danru-security',
        companyName: 'PT Delta Guard',
        categoryName: 'Industri',
        locationName: 'Bekasi',
        shiftType: '3_shift',
        requiredCertificateLevel: 'gada_madya',
        matchScore: 92,
        matchReasons: ['Tinggi badan dan sertifikat cocok'],
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: Center(
              child: JobCard(
                job: job,
                onTap: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('92% Cocok'), findsOneWidget);
      expect(find.text('Komandan Regu Security'), findsOneWidget);
    });
  });
}
