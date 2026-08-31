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

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

final routerProvider = Provider<GoRouter>((ref) {
  return AppRouter.router;
});

class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        pageBuilder: (context, state, child) => MaterialPage(
          key: const ValueKey('shell_page'),
          child: MainShellScreen(child: child),
        ),
        routes: [
          // Candidate Shell Tabs
          GoRoute(
            path: '/',
            name: 'home',
            pageBuilder: (context, state) => const NoTransitionPage(
              key: ValueKey('home_tab'),
              child: HomeScreen(),
            ),
          ),
          GoRoute(
            path: '/jobs',
            name: 'jobs',
            pageBuilder: (context, state) => const NoTransitionPage(
              key: ValueKey('jobs_tab'),
              child: SearchScreen(),
            ),
          ),
          GoRoute(
            path: '/saved',
            name: 'saved_jobs_tab',
            pageBuilder: (context, state) => const NoTransitionPage(
              key: ValueKey('saved_tab'),
              child: SavedJobsScreen(),
            ),
          ),
          GoRoute(
            path: '/applications',
            name: 'applications_tab',
            pageBuilder: (context, state) => const NoTransitionPage(
              key: ValueKey('applications_tab'),
              child: ApplicationsScreen(),
            ),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            pageBuilder: (context, state) => const NoTransitionPage(
              key: ValueKey('profile_tab'),
              child: ProfileScreen(),
            ),
          ),

          // Employer Shell Tabs
          GoRoute(
            path: '/employer/dashboard',
            name: 'employer_dashboard',
            pageBuilder: (context, state) => const NoTransitionPage(
              key: ValueKey('employer_dashboard_tab'),
              child: EmployerDashboardScreen(),
            ),
          ),
          GoRoute(
            path: '/employer/jobs',
            name: 'employer_jobs',
            pageBuilder: (context, state) => const NoTransitionPage(
              key: ValueKey('employer_jobs_tab'),
              child: EmployerJobsScreen(),
            ),
          ),
          GoRoute(
            path: '/employer/applicants',
            name: 'employer_applicants',
            pageBuilder: (context, state) => const NoTransitionPage(
              key: ValueKey('employer_applicants_tab'),
              child: EmployerApplicantsScreen(),
            ),
          ),
          GoRoute(
            path: '/employer/profile',
            name: 'employer_profile',
            pageBuilder: (context, state) => const NoTransitionPage(
              key: ValueKey('employer_profile_tab'),
              child: EmployerProfileScreen(),
            ),
          ),
        ],
      ),

      // Root Fullscreen Routes
      GoRoute(
        path: '/splash',
        name: 'splash',
        pageBuilder: (context, state) => MaterialPage(
          key: const ValueKey('splash_screen'),
          child: const SplashScreen(),
        ),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        pageBuilder: (context, state) => MaterialPage(
          key: const ValueKey('onboarding_screen'),
          child: const OnboardingScreen(),
        ),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        pageBuilder: (context, state) => MaterialPage(
          key: const ValueKey('login_screen'),
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        pageBuilder: (context, state) => MaterialPage(
          key: const ValueKey('register_screen'),
          child: const RegisterScreen(),
        ),
      ),
      GoRoute(
        path: '/register-employer',
        name: 'register_employer',
        pageBuilder: (context, state) => MaterialPage(
          key: const ValueKey('register_employer_screen'),
          child: const RegisterEmployerScreen(),
        ),
      ),
      GoRoute(
        path: '/jobs/:slug',
        name: 'job_detail',
        pageBuilder: (context, state) {
          final slug = state.pathParameters['slug'] ?? '';
          return MaterialPage(
            key: ValueKey('job_detail_$slug'),
            child: JobDetailScreen(slug: slug),
          );
        },
      ),
      GoRoute(
        path: '/companies/:name',
        name: 'company_detail',
        pageBuilder: (context, state) {
          final name = state.pathParameters['name'] ?? '';
          return MaterialPage(
            key: ValueKey('company_detail_$name'),
            child: CompanyDetailScreen(companyName: Uri.decodeComponent(name)),
          );
        },
      ),
      GoRoute(
        path: '/applications/:id',
        name: 'application_detail',
        pageBuilder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
          return MaterialPage(
            key: ValueKey('application_detail_$id'),
            child: ApplicationDetailScreen(applicationId: id),
          );
        },
      ),
      GoRoute(
        path: '/notifications',
        name: 'notifications',
        pageBuilder: (context, state) => MaterialPage(
          key: const ValueKey('notifications_screen'),
          child: const NotificationsScreen(),
        ),
      ),
      GoRoute(
        path: '/edit-profile',
        name: 'edit_profile',
        pageBuilder: (context, state) => MaterialPage(
          key: const ValueKey('edit_profile_screen'),
          child: const EditProfileScreen(),
        ),
      ),
      GoRoute(
        path: '/profile/edit',
        name: 'profile_edit',
        pageBuilder: (context, state) => MaterialPage(
          key: const ValueKey('profile_edit_screen'),
          child: const EditProfileScreen(),
        ),
      ),
      GoRoute(
        path: '/profile/certifications',
        name: 'profile_certifications',
        pageBuilder: (context, state) => MaterialPage(
          key: const ValueKey('profile_certifications_screen'),
          child: const CertificationsScreen(),
        ),
      ),
      GoRoute(
        path: '/profile/experiences/add',
        name: 'profile_add_experience',
        pageBuilder: (context, state) => MaterialPage(
          key: const ValueKey('profile_add_experience_screen'),
          child: const AddExperienceScreen(),
        ),
      ),
      GoRoute(
        path: '/profile/documents',
        name: 'profile_documents',
        pageBuilder: (context, state) => MaterialPage(
          key: const ValueKey('profile_documents_screen'),
          child: const DocumentsScreen(),
        ),
      ),
      GoRoute(
        path: '/experiences',
        name: 'experiences',
        pageBuilder: (context, state) => MaterialPage(
          key: const ValueKey('experiences_screen'),
          child: const ExperiencesScreen(),
        ),
      ),
      GoRoute(
        path: '/experiences/add',
        name: 'add_experience',
        pageBuilder: (context, state) => MaterialPage(
          key: const ValueKey('experiences_add_screen'),
          child: const AddExperienceScreen(),
        ),
      ),
      GoRoute(
        path: '/certifications',
        name: 'certifications',
        pageBuilder: (context, state) => MaterialPage(
          key: const ValueKey('certifications_screen'),
          child: const CertificationsScreen(),
        ),
      ),
      GoRoute(
        path: '/documents',
        name: 'documents',
        pageBuilder: (context, state) => MaterialPage(
          key: const ValueKey('documents_screen'),
          child: const DocumentsScreen(),
        ),
      ),
      GoRoute(
        path: '/messages',
        name: 'messages',
        pageBuilder: (context, state) => MaterialPage(
          key: const ValueKey('messages_screen'),
          child: const MessagesScreen(),
        ),
      ),
      GoRoute(
        path: '/saved-jobs',
        name: 'saved_jobs',
        pageBuilder: (context, state) => MaterialPage(
          key: const ValueKey('saved_jobs_screen'),
          child: const SavedJobsScreen(),
        ),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        pageBuilder: (context, state) => MaterialPage(
          key: const ValueKey('settings_screen'),
          child: const SettingsScreen(),
        ),
      ),

      // Employer App Detail Routes
      GoRoute(
        path: '/employer/jobs/create',
        name: 'employer_job_create',
        pageBuilder: (context, state) => MaterialPage(
          key: const ValueKey('employer_job_create_screen'),
          child: const CreateEditJobScreen(),
        ),
      ),
      GoRoute(
        path: '/employer/jobs/:id/edit',
        name: 'employer_job_edit',
        pageBuilder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '0');
          return MaterialPage(
            key: ValueKey('employer_job_edit_$id'),
            child: CreateEditJobScreen(jobId: id),
          );
        },
      ),
      GoRoute(
        path: '/employer/applicants/:id',
        name: 'employer_applicant_detail',
        pageBuilder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
          return MaterialPage(
            key: ValueKey('employer_applicant_detail_$id'),
            child: EmployerApplicantDetailScreen(applicationId: id),
          );
        },
      ),
      GoRoute(
        path: '/employer/pipeline',
        name: 'employer_pipeline',
        pageBuilder: (context, state) => MaterialPage(
          key: const ValueKey('employer_pipeline_screen'),
          child: const RecruitmentPipelineScreen(),
        ),
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
    final String location = GoRouter.maybeOf(context)?.routeInformationProvider.value.uri.path ?? '/';

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
