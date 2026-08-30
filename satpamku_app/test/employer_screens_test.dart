import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:satpamku_app/core/theme/app_theme.dart';
import 'package:satpamku_app/core/theme/app_typography.dart';
import 'package:satpamku_app/features/employer/models/employer_applicant_model.dart';
import 'package:satpamku_app/features/employer/models/employer_dashboard_model.dart';
import 'package:satpamku_app/features/employer/widgets/employer_applicant_card.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  AppTypography.useGoogleFonts = false;

  group('Employer Models Tests', () {
    test('EmployerDashboardModel parses KPI metrics and recent applicants', () {
      final json = {
        'metrics': {
          'active_jobs': 4,
          'total_jobs': 6,
          'total_applicants': 18,
          'pending_review': 5,
          'interviews_scheduled': 3,
          'accepted': 2,
        },
        'recent_applicants': [
          {
            'id': 1,
            'status': 'submitted',
            'applied_at': '2026-08-30T10:00:00Z',
            'job_title': 'Satpam Perbankan Jakarta',
            'job_id': 1,
            'candidate_name': 'Rudi Hermawan',
            'candidate_avatar': null,
            'certificate_level': 'gada_pratama',
            'height_cm': 174,
            'weight_kg': 70,
          }
        ],
      };

      final dashboard = EmployerDashboardModel.fromJson(json);

      expect(dashboard.activeJobs, 4);
      expect(dashboard.totalApplicants, 18);
      expect(dashboard.pendingReview, 5);
      expect(dashboard.recentApplicants.length, 1);
      expect(dashboard.recentApplicants.first.candidateName, 'Rudi Hermawan');
    });

    test('EmployerApplicantModel parses candidate details and status', () {
      final json = {
        'id': 1,
        'status': 'interview_scheduled',
        'applied_at': '2026-08-30T10:00:00Z',
        'job': {'id': 1, 'title': 'Danru Security'},
        'candidate': {
          'id': 2,
          'name': 'Bambang Supriyanto',
          'email': 'bambang@example.com',
          'phone': '081234567890',
          'highest_certificate_level': 'gada_madya',
          'height_cm': 176,
          'weight_kg': 73,
          'has_sim_a': true,
          'has_sim_c': true,
        },
      };

      final applicant = EmployerApplicantModel.fromJson(json);

      expect(applicant.candidate.name, 'Bambang Supriyanto');
      expect(applicant.candidate.highestCertificateLevel, 'gada_madya');
      expect(applicant.statusDisplay, 'Interview Terjadwal');
      expect(applicant.candidate.hasSimA, true);
    });
  });

  group('Employer Widgets Tests', () {
    testWidgets('EmployerApplicantCard renders applicant info and handles tap', (WidgetTester tester) async {
      bool tapped = false;

      final applicant = EmployerApplicantModel(
        id: 1,
        status: 'submitted',
        appliedAt: DateTime(2026, 8, 30),
        jobTitle: 'Satpam Retail Senayan City',
        jobId: 2,
        candidate: CandidateApplicantInfo(
          id: 5,
          name: 'Joko Prabowo',
          email: 'joko@example.com',
          phone: '081299988877',
          highestCertificateLevel: 'gada_pratama',
          heightCm: 172,
          weightKg: 68,
          hasSimC: true,
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: Center(
              child: EmployerApplicantCard(
                applicant: applicant,
                onTap: () => tapped = true,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Joko Prabowo'), findsOneWidget);
      expect(find.text('Posisi: Satpam Retail Senayan City'), findsOneWidget);
      expect(find.text('Gada Pratama'), findsOneWidget);
      expect(find.text('172 cm'), findsOneWidget);

      await tester.tap(find.byType(EmployerApplicantCard));
      await tester.pump();

      expect(tapped, true);
    });
  });
}
