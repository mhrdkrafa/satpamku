import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../../features/applications/screens/application_detail_screen.dart';
import '../../features/applications/screens/applications_screen.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/onboarding_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/auth/screens/register_employer_screen.dart';
import '../../features/auth/screens/splash_screen.dart';
import '../../features/employer/screens/create_edit_job_screen.dart';
import '../../features/employer/screens/employer_applicant_detail_screen.dart';
import '../../features/employer/screens/employer_applicants_screen.dart';
import '../../features/employer/screens/employer_dashboard_screen.dart';
import '../../features/employer/screens/employer_jobs_screen.dart';
import '../../features/employer/screens/employer_profile_screen.dart';
import '../../features/employer/screens/recruitment_pipeline_screen.dart';
import '../../features/jobs/screens/company_detail_screen.dart';
import '../../features/jobs/screens/home_screen.dart';
import '../../features/jobs/screens/job_detail_screen.dart';
import '../../features/jobs/screens/search_screen.dart';
import '../../features/messages/screens/messages_screen.dart';
import '../../features/notifications/screens/notifications_screen.dart';
import '../../features/profile/screens/add_experience_screen.dart';
import '../../features/profile/screens/certifications_screen.dart';
import '../../features/profile/screens/documents_screen.dart';
import '../../features/profile/screens/edit_profile_screen.dart';
import '../../features/profile/screens/experiences_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/profile/screens/saved_jobs_screen.dart';
import '../../features/profile/screens/settings_screen.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

final routerProvider = Provider<GoRouter>((ref) {
  return AppRouter.router;
});

class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/splash',
    routes: [
      ShellRoute(
        navigatorKey: shellNavigatorKey,
        builder: (context, state, child) {
          return MainShellScreen(child: child);
        },
        routes: [
          // Candidate Shell Tabs
          GoRoute(
            path: '/',
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/jobs',
            name: 'jobs',
            builder: (context, state) => const SearchScreen(),
          ),
          GoRoute(
            path: '/saved',
            name: 'saved_jobs_tab',
            builder: (context, state) => const SavedJobsScreen(),
          ),
          GoRoute(
            path: '/applications',
            name: 'applications_tab',
            builder: (context, state) => const ApplicationsScreen(),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),

          // Employer Shell Tabs
          GoRoute(
            path: '/employer/dashboard',
            name: 'employer_dashboard',
            builder: (context, state) => const EmployerDashboardScreen(),
          ),
          GoRoute(
            path: '/employer/jobs',
            name: 'employer_jobs',
            builder: (context, state) => const EmployerJobsScreen(),
          ),
          GoRoute(
            path: '/employer/applicants',
            name: 'employer_applicants',
            builder: (context, state) => const EmployerApplicantsScreen(),
          ),
          GoRoute(
            path: '/employer/profile',
            name: 'employer_profile',
            builder: (context, state) => const EmployerProfileScreen(),
          ),
        ],
      ),

      // Root Fullscreen Routes (Cover bottom navbar)
      GoRoute(
        path: '/splash',
        name: 'splash',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/register-employer',
        name: 'register_employer',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const RegisterEmployerScreen(),
      ),
      GoRoute(
        path: '/jobs/:slug',
        name: 'job_detail',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final slug = state.pathParameters['slug'] ?? '';
          return JobDetailScreen(slug: slug);
        },
      ),
      GoRoute(
        path: '/companies/:name',
        name: 'company_detail',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final name = state.pathParameters['name'] ?? '';
          return CompanyDetailScreen(companyName: Uri.decodeComponent(name));
        },
      ),
      GoRoute(
        path: '/applications/:id',
        name: 'application_detail',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
          return ApplicationDetailScreen(applicationId: id);
        },
      ),
      GoRoute(
        path: '/notifications',
        name: 'notifications',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/edit-profile',
        name: 'edit_profile',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/profile/edit',
        name: 'profile_edit',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/profile/certifications',
        name: 'profile_certifications',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const CertificationsScreen(),
      ),
      GoRoute(
        path: '/profile/experiences/add',
        name: 'profile_add_experience',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const AddExperienceScreen(),
      ),
      GoRoute(
        path: '/profile/documents',
        name: 'profile_documents',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const DocumentsScreen(),
      ),
      GoRoute(
        path: '/experiences',
        name: 'experiences',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const ExperiencesScreen(),
      ),
      GoRoute(
        path: '/experiences/add',
        name: 'add_experience',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const AddExperienceScreen(),
      ),
      GoRoute(
        path: '/certifications',
        name: 'certifications',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const CertificationsScreen(),
      ),
      GoRoute(
        path: '/documents',
        name: 'documents',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const DocumentsScreen(),
      ),
      GoRoute(
        path: '/messages',
        name: 'messages',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const MessagesScreen(),
      ),
      GoRoute(
        path: '/saved-jobs',
        name: 'saved_jobs',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const SavedJobsScreen(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const SettingsScreen(),
      ),

      // Employer App Detail Routes
      GoRoute(
        path: '/employer/jobs/create',
        name: 'employer_job_create',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const CreateEditJobScreen(),
      ),
      GoRoute(
        path: '/employer/jobs/:id/edit',
        name: 'employer_job_edit',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '0');
          return CreateEditJobScreen(jobId: id);
        },
      ),
      GoRoute(
        path: '/employer/applicants/:id',
        name: 'employer_applicant_detail',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
          return EmployerApplicantDetailScreen(applicationId: id);
        },
      ),
      GoRoute(
        path: '/employer/pipeline',
        name: 'employer_pipeline',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const RecruitmentPipelineScreen(),
      ),
    ],
  );
}

class MainShellScreen extends ConsumerWidget {
  final Widget child;

  const MainShellScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).user;
    final isEmployer = user?.role == 'employer';
    final String location = GoRouterState.of(context).uri.path;

    int selectedIndex = 0;
    if (isEmployer) {
      if (location.startsWith('/employer/jobs')) {
        selectedIndex = 1;
      } else if (location.startsWith('/employer/applicants')) {
        selectedIndex = 2;
      } else if (location.startsWith('/employer/profile')) {
        selectedIndex = 3;
      } else {
        selectedIndex = 0;
      }
    } else {
      if (location.startsWith('/jobs')) {
        selectedIndex = 1;
      } else if (location.startsWith('/saved')) {
        selectedIndex = 2;
      } else if (location.startsWith('/applications')) {
        selectedIndex = 3;
      } else if (location.startsWith('/profile')) {
        selectedIndex = 4;
      } else {
        selectedIndex = 0;
      }
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          if (isEmployer) {
            switch (index) {
              case 0:
                context.go('/employer/dashboard');
                break;
              case 1:
                context.go('/employer/jobs');
                break;
              case 2:
                context.go('/employer/applicants');
                break;
              case 3:
                context.go('/employer/profile');
                break;
            }
          } else {
            switch (index) {
              case 0:
                context.go('/');
                break;
              case 1:
                context.go('/jobs');
                break;
              case 2:
                context.go('/saved');
                break;
              case 3:
                context.go('/applications');
                break;
              case 4:
                context.go('/profile');
                break;
            }
          }
        },
        destinations: isEmployer
            ? const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home, color: Color(0xFF1B2A72)),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.work_outline),
                  selectedIcon: Icon(Icons.work, color: Color(0xFF1B2A72)),
                  label: 'Jobs',
                ),
                NavigationDestination(
                  icon: Icon(Icons.people_outline),
                  selectedIcon: Icon(Icons.people, color: Color(0xFF1B2A72)),
                  label: 'Candidates',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person, color: Color(0xFF1B2A72)),
                  label: 'Profile',
                ),
              ]
            : const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home, color: Color(0xFF1B2A72)),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.work_outline),
                  selectedIcon: Icon(Icons.work, color: Color(0xFF1B2A72)),
                  label: 'Jobs',
                ),
                NavigationDestination(
                  icon: Icon(Icons.bookmark_outline),
                  selectedIcon: Icon(Icons.bookmark, color: Color(0xFF1B2A72)),
                  label: 'Saved',
                ),
                NavigationDestination(
                  icon: Icon(Icons.assignment_turned_in_outlined),
                  selectedIcon: Icon(Icons.assignment_turned_in, color: Color(0xFF1B2A72)),
                  label: 'Applied',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person, color: Color(0xFF1B2A72)),
                  label: 'Profile',
                ),
              ],
      ),
    );
  }
}
