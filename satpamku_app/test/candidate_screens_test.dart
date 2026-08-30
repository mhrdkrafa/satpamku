import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:satpamku_app/core/theme/app_theme.dart';
import 'package:satpamku_app/core/theme/app_typography.dart';
import 'package:satpamku_app/features/applications/models/job_application_model.dart';
import 'package:satpamku_app/features/applications/widgets/application_card.dart';
import 'package:satpamku_app/features/jobs/models/job_model.dart';
import 'package:satpamku_app/features/jobs/widgets/job_card.dart';
import 'package:satpamku_app/features/profile/models/candidate_profile_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  AppTypography.useGoogleFonts = false;

  group('Candidate Models Tests', () {
    test('JobModel parses correctly and formats salary and shifts', () {
      final json = {
        'id': 1,
        'title': 'Satpam Perbankan Sudirman',
        'slug': 'satpam-perbankan-sudirman',
        'employer': {'company_name': 'PT Sigap Prima', 'logo_url': null, 'city': 'Jakarta Selatan'},
        'category': {'name': 'Perbankan & Kas', 'icon': 'bank'},
        'location': {'name': 'Jakarta Selatan'},
        'shift_type': '3_shift',
        'salary_min': 5500000,
        'salary_max': 6500000,
        'salary_is_hidden': false,
        'required_certificate_level': 'gada_pratama',
        'is_urgent': true,
        'is_featured': true,
      };

      final job = JobModel.fromJson(json);

      expect(job.title, 'Satpam Perbankan Sudirman');
      expect(job.companyName, 'PT Sigap Prima');
      expect(job.isUrgent, true);
      expect(job.isFeatured, true);
      expect(job.formattedShift, '3 Shift (8 Jam)');
      expect(job.formattedSalary, contains('Rp 5.500.000'));
    });

    test('JobApplicationModel parses correctly with status and canWithdraw flag', () {
      final json = {
        'id': 10,
        'status': 'submitted',
        'applied_at': '2026-08-30T10:00:00Z',
        'job': {
          'id': 1,
          'title': 'Satpam Mall Grand Indonesia',
          'slug': 'satpam-mall-grand-indonesia',
          'employer': {'company_name': 'PT Guard Perkasa'},
          'category': {'name': 'Retail'},
          'location': {'name': 'Jakarta Pusat'},
          'shift_type': '2_shift',
          'required_certificate_level': 'gada_pratama',
        },
      };

      final app = JobApplicationModel.fromJson(json);

      expect(app.id, 10);
      expect(app.status, 'submitted');
      expect(app.statusDisplay, 'Lamaran Terkirim');
      expect(app.canWithdraw, true);
    });

    test('CandidateFullProfileModel parses experiences and certifications', () {
      final json = {
        'id': 1,
        'user_id': 1,
        'headline': 'Satpam Berpengalaman 5 Tahun',
        'height_cm': 175,
        'weight_kg': 72,
        'has_sim_a': true,
        'has_sim_c': true,
        'highest_certificate_level': 'gada_madya',
        'profile_completion': 85,
        'user': {
          'name': 'Budi Santoso',
          'email': 'budi@example.com',
          'phone': '081234567890',
        },
        'experiences': [
          {
            'id': 1,
            'company_name': 'PT Delta Guard',
            'position_title': 'Danru Security',
            'start_date': '2022-01-01',
            'is_current': true,
          }
        ],
        'certifications': [
          {
            'id': 1,
            'certificate_level': 'gada_madya',
            'status': 'verified',
            'certification': {'name': 'Ijazah Gada Madya Polda Metro'},
          }
        ],
        'documents': [],
      };

      final profile = CandidateFullProfileModel.fromJson(json);

      expect(profile.fullName, 'Budi Santoso');
      expect(profile.heightCm, 175);
      expect(profile.hasSimA, true);
      expect(profile.highestCertificateLevel, 'gada_madya');
      expect(profile.experiences.length, 1);
      expect(profile.experiences.first.positionTitle, 'Danru Security');
      expect(profile.certifications.length, 1);
      expect(profile.certifications.first.status, 'verified');
    });
  });

  group('Candidate Widget Tests', () {
    testWidgets('JobCard renders details and responds to tap', (WidgetTester tester) async {
      bool tapped = false;

      final job = JobModel(
        id: 1,
        title: 'Komandan Regu Satpam Kawasan Industri',
        slug: 'komandan-regu-satpam-kawasan-industri',
        companyName: 'PT Wira Buana Guard',
        categoryName: 'Industri',
        locationName: 'Bekasi',
        shiftType: '3_shift',
        salaryMin: 6000000,
        salaryMax: 7500000,
        requiredCertificateLevel: 'gada_madya',
        isUrgent: true,
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: Center(
              child: JobCard(
                job: job,
                onTap: () => tapped = true,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Komandan Regu Satpam Kawasan Industri'), findsOneWidget);
      expect(find.text('PT Wira Buana Guard'), findsOneWidget);
      expect(find.text('URGENT HIRING'), findsOneWidget);
      expect(find.text('Gada Madya'), findsOneWidget);

      await tester.tap(find.byType(JobCard));
      await tester.pump();

      expect(tapped, true);
    });

    testWidgets('ApplicationCard renders application status and job title', (WidgetTester tester) async {
      final app = JobApplicationModel(
        id: 5,
        status: 'interview_scheduled',
        appliedAt: DateTime(2026, 8, 25),
        job: JobModel(
          id: 2,
          title: 'Satpam Residensial Mewah',
          slug: 'satpam-residensial-mewah',
          companyName: 'PT Sentra Security',
          categoryName: 'Residensial',
          locationName: 'Tangerang Selatan',
          shiftType: '2_shift',
          requiredCertificateLevel: 'gada_pratama',
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: Center(
              child: ApplicationCard(
                application: app,
                onTap: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('Satpam Residensial Mewah'), findsOneWidget);
      expect(find.text('PT Sentra Security'), findsOneWidget);
      expect(find.text('Interview'), findsOneWidget);
    });
  });
}
