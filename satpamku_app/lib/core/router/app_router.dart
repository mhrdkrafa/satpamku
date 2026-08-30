import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../../features/applications/screens/application_detail_screen.dart';
import '../../features/applications/screens/applications_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/onboarding_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/employer/screens/create_edit_job_screen.dart';
import '../../features/employer/screens/employer_applicant_detail_screen.dart';
import '../../features/employer/screens/employer_applicants_screen.dart';
import '../../features/employer/screens/employer_dashboard_screen.dart';
import '../../features/employer/screens/employer_jobs_screen.dart';
import '../../features/employer/screens/employer_profile_screen.dart';
import '../../features/jobs/screens/home_screen.dart';
import '../../features/jobs/screens/job_detail_screen.dart';
import '../../features/jobs/screens/search_screen.dart';
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

class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return MainShellScreen(child: child);
        },
        routes: [
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
            path: '/notifications',
            name: 'notifications',
            builder: (context, state) => const NotificationsScreen(),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/jobs/:slug',
        name: 'job_detail',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final slug = state.pathParameters['slug'] ?? '';
          return JobDetailScreen(slug: slug);
        },
      ),
      GoRoute(
        path: '/applications',
        name: 'applications',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ApplicationsScreen(),
      ),
      GoRoute(
        path: '/applications/:id',
        name: 'application_detail',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
          return ApplicationDetailScreen(applicationId: id);
        },
      ),
      GoRoute(
        path: '/edit-profile',
        name: 'edit_profile',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/experiences',
        name: 'experiences',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ExperiencesScreen(),
      ),
      GoRoute(
        path: '/experiences/add',
        name: 'add_experience',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AddExperienceScreen(),
      ),
      GoRoute(
        path: '/certifications',
        name: 'certifications',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CertificationsScreen(),
      ),
      GoRoute(
        path: '/documents',
        name: 'documents',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const DocumentsScreen(),
      ),
      GoRoute(
        path: '/saved-jobs',
        name: 'saved_jobs',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SavedJobsScreen(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SettingsScreen(),
      ),

      // Employer App Routes
      GoRoute(
        path: '/employer/dashboard',
        name: 'employer_dashboard',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const EmployerDashboardScreen(),
      ),
      GoRoute(
        path: '/employer/jobs',
        name: 'employer_jobs',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const EmployerJobsScreen(),
      ),
      GoRoute(
        path: '/employer/jobs/create',
        name: 'employer_job_create',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CreateEditJobScreen(),
      ),
      GoRoute(
        path: '/employer/jobs/:id/edit',
        name: 'employer_job_edit',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '0');
          return CreateEditJobScreen(jobId: id);
        },
      ),
      GoRoute(
        path: '/employer/applicants',
        name: 'employer_applicants',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const EmployerApplicantsScreen(),
      ),
      GoRoute(
        path: '/employer/applicants/:id',
        name: 'employer_applicant_detail',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
          return EmployerApplicantDetailScreen(applicationId: id);
        },
      ),
      GoRoute(
        path: '/employer/profile',
        name: 'employer_profile',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const EmployerProfileScreen(),
      ),
    ],
  );
}

class MainShellScreen extends StatelessWidget {
  final Widget child;

  const MainShellScreen({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/jobs')) return 1;
    if (location.startsWith('/notifications')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        GoRouter.of(context).go('/');
        break;
      case 1:
        GoRouter.of(context).go('/jobs');
        break;
      case 2:
        GoRouter.of(context).go('/notifications');
        break;
      case 3:
        GoRouter.of(context).go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _calculateSelectedIndex(context),
        onDestinationSelected: (index) => _onItemTapped(index, context),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: AppColors.primary),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.work_outline),
            selectedIcon: Icon(Icons.work, color: AppColors.primary),
            label: 'Lowongan',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_none_outlined),
            selectedIcon: Icon(Icons.notifications, color: AppColors.primary),
            label: 'Notifikasi',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: AppColors.primary),
            label: 'Akun',
          ),
        ],
      ),
    );
  }
}
