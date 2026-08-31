import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_avatar.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/widgets/error_state_widget.dart';
import '../../../core/widgets/loading_skeleton.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/jobs_provider.dart';
import '../widgets/job_card.dart';
import '../widgets/urgent_job_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String _selectedLocation = 'Jakarta Selatan';

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final user = authState.user;

    final urgentAsync = ref.watch(urgentJobsProvider);
    final searchAsync = ref.watch(searchJobsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 16,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: AppAvatar(
            name: user?.name ?? 'Ahmad',
            imageUrl: user?.avatarUrl,
            radius: 18,
          ),
        ),
        title: const Text(
          'Satpamku',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B2A72),
            letterSpacing: -0.3,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Color(0xFF1B2A72), size: 24),
            onPressed: () => context.push('/notifications'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(urgentJobsProvider);
          ref.invalidate(searchJobsProvider);
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Location Selector & Greeting
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: _showLocationPicker,
                      borderRadius: BorderRadius.circular(6),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.location_on_outlined, size: 14, color: Color(0xFF64748B)),
                          const SizedBox(width: 4),
                          Text(
                            _selectedLocation,
                            style: const TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          const Icon(Icons.keyboard_arrow_down, size: 16, color: Color(0xFF64748B)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Halo, ${user?.name ?? "Bpk. Ahmad"}.',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1B2A72),
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Siap bertugas hari ini?',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Search Bar with Filter Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => context.push('/jobs'),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          height: 48,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.02),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.search, color: Color(0xFF94A3B8), size: 20),
                              SizedBox(width: 10),
                              Text(
                                'Cari lowongan...',
                                style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: () => context.push('/jobs'),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: const Icon(Icons.tune, color: Color(0xFF1B2A72), size: 20),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Sector Categories (5 Circular/Rounded Square Items)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSectorItem('Retail', Icons.storefront_outlined),
                    _buildSectorItem('Residensial', Icons.holiday_village_outlined),
                    _buildSectorItem('VIP', Icons.star_border),
                    _buildSectorItem('Event', Icons.account_balance_outlined),
                    _buildSectorItem('Industri', Icons.factory_outlined),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Urgent Hiring Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Urgent Hiring',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1B2A72),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.push('/jobs'),
                      child: const Text(
                        'Lihat Semua',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1B2A72),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              urgentAsync.when(
                data: (urgentJobs) {
                  if (urgentJobs.isEmpty) return const SizedBox.shrink();
                  return SizedBox(
                    height: 155,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: urgentJobs.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final job = urgentJobs[index];
                        return UrgentJobCard(
                          job: job,
                          onTap: () => context.push('/jobs/${job.slug}'),
                        );
                      },
                    ),
                  );
                },
                loading: () => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: LoadingSkeleton.card(height: 140),
                ),
                error: (_, __) => const SizedBox.shrink(),
              ),
              const SizedBox(height: 24),

              // Recommended for You Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Recommended for You',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1B2A72),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.push('/jobs'),
                      child: const Text(
                        'Lihat Semua',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1B2A72),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              searchAsync.when(
                data: (jobs) {
                  if (jobs.isEmpty) {
                    return const EmptyStateWidget(
                      title: 'Belum Ada Lowongan',
                      message: 'Saat ini belum ada lowongan baru yang tersedia.',
                    );
                  }
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: jobs.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final job = jobs[index];
                      return JobCard(
                        job: job,
                        onTap: () => context.push('/jobs/${job.slug}'),
                      );
                    },
                  );
                },
                loading: () => ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: 2,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, __) => LoadingSkeleton.card(height: 140),
                ),
                error: (err, _) => ErrorStateWidget(
                  message: err.toString(),
                  onRetry: () => ref.invalidate(searchJobsProvider),
                ),
              ),
              const SizedBox(height: 20),

              // Gada Pratama Training Banner
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1B2A72), Color(0xFF0F172A)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1B2A72).withOpacity(0.25),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.workspace_premium, color: Color(0xFFFDE68A), size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Gada Pratama Training',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Tingkatkan kualifikasi Anda. Daftar pelatihan sertifikasi dasar Satpam gelombang bulan ini.',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: Color(0xFFCBD5E1),
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 14),
                      ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Pusat Pelatihan & Diklat Satpam POLDA Metro Jaya')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFDE68A),
                          foregroundColor: const Color(0xFF92400E),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Lihat Jadwal',
                          style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectorItem(String title, IconData icon) {
    return InkWell(
      onTap: () => context.push('/jobs'),
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Icon(icon, size: 24, color: const Color(0xFF1B2A72)),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF475569),
            ),
          ),
        ],
      ),
    );
  }

  void _showLocationPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.65),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Pilih Wilayah Penugasan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B2A72)),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView(
                  children: ['Jakarta Selatan', 'Jakarta Pusat', 'Jakarta Barat', 'Jakarta Utara', 'Jakarta Timur', 'Bekasi & Cikarang', 'Tangerang', 'Surabaya']
                      .map(
                        (loc) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.location_city, color: Color(0xFF1B2A72)),
                          title: Text(loc, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                          trailing: _selectedLocation == loc ? const Icon(Icons.check, color: Color(0xFF1B2A72)) : null,
                          onTap: () {
                            setState(() => _selectedLocation = loc);
                            Navigator.pop(context);
                          },
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
