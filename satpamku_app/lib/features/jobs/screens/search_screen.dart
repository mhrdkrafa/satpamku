import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/widgets/error_state_widget.dart';
import '../../../core/widgets/loading_skeleton.dart';
import '../providers/jobs_provider.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/job_card.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _titleController = TextEditingController();
  final _locationController = TextEditingController(text: 'Jakarta Pusat');
  final List<String> _recentSearches = ['Retail Security', 'Event Guard', 'Patrol Officer'];

  @override
  void initState() {
    super.initState();
    final filter = ref.read(jobFilterProvider);
    if (filter.query != null) {
      _titleController.text = filter.query!;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _openFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const FilterBottomSheet(),
    );
  }

  void _executeSearch(String query) {
    if (query.trim().isNotEmpty && !_recentSearches.contains(query.trim())) {
      setState(() {
        _recentSearches.insert(0, query.trim());
      });
    }
    ref.read(jobFilterProvider.notifier).update((state) => state.copyWith(query: query.trim()));
  }

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(jobFilterProvider);
    final jobsAsync = ref.watch(searchJobsProvider);
    final hasActiveQuery = filter.query != null && filter.query!.isNotEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: hasActiveQuery
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF1B2A72)),
                onPressed: () {
                  _titleController.clear();
                  ref.read(jobFilterProvider.notifier).update((state) => state.copyWith(clearQuery: true));
                },
              )
            : null,
        title: hasActiveQuery
            ? Container(
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _titleController,
                  onSubmitted: _executeSearch,
                  decoration: InputDecoration(
                    hintText: 'Cari posisi...',
                    hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                    prefixIcon: const Icon(Icons.search, size: 18, color: Color(0xFF64748B)),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.close, size: 16, color: Color(0xFF64748B)),
                      onPressed: () {
                        _titleController.clear();
                        ref.read(jobFilterProvider.notifier).update((state) => state.copyWith(clearQuery: true));
                      },
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              )
            : const Text(
                'Satpamku',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B2A72),
                ),
              ),
        centerTitle: !hasActiveQuery,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none, color: Color(0xFF1B2A72), size: 24),
                onPressed: () => context.push('/notifications'),
              ),
              Positioned(
                right: 12,
                top: 12,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEF4444),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(searchJobsProvider),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!hasActiveQuery) ...[
                // Title: Find Your Next Post
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Find Your Next Post',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B2A72),
                      letterSpacing: -0.4,
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // 2 Search Input Fields (Keyword & Location)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFCBD5E1)),
                        ),
                        child: TextField(
                          controller: _titleController,
                          onSubmitted: _executeSearch,
                          decoration: const InputDecoration(
                            hintText: 'Job title, keyword, or company',
                            hintStyle: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                            prefixIcon: Icon(Icons.search, size: 20, color: Color(0xFF64748B)),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFCBD5E1)),
                        ),
                        child: TextField(
                          controller: _locationController,
                          decoration: const InputDecoration(
                            hintText: 'Jakarta Pusat',
                            hintStyle: TextStyle(fontSize: 13, color: Color(0xFF334155)),
                            prefixIcon: Icon(Icons.location_on_outlined, size: 20, color: Color(0xFF64748B)),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () => _executeSearch(_titleController.text),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1B2A72),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Search Jobs',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Recent Searches
                if (_recentSearches.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: const [
                        Icon(Icons.history, size: 16, color: Color(0xFF64748B)),
                        SizedBox(width: 6),
                        Text(
                          'Recent Searches',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _recentSearches
                          .map(
                            (query) => Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: const Color(0xFFE2E8F0)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      _titleController.text = query;
                                      _executeSearch(query);
                                    },
                                    child: Text(
                                      query,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF334155),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        _recentSearches.remove(query);
                                      });
                                    },
                                    child: const Icon(Icons.close, size: 14, color: Color(0xFF94A3B8)),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // Popular Categories Grid Cards
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Icon(Icons.category_outlined, size: 16, color: Color(0xFF64748B)),
                      SizedBox(width: 6),
                      Text(
                        'Popular Categories',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildPopularCategoryCard(
                          icon: Icons.storefront_outlined,
                          title: 'Retail',
                          count: '245 Jobs',
                          onTap: () => _executeSearch('Retail'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildPopularCategoryCard(
                          icon: Icons.calendar_month_outlined,
                          title: 'Event',
                          count: '112 Jobs',
                          onTap: () => _executeSearch('Event'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildPopularCategoryCard(
                          icon: Icons.star_border,
                          title: 'VIP',
                          count: '45 Jobs',
                          onTap: () => _executeSearch('VIP'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Header: Recommended Jobs or Search Results Count
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hasActiveQuery
                              ? 'Hasil Pencarian'
                              : 'Recommended Jobs',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1B2A72),
                          ),
                        ),
                        if (hasActiveQuery) ...[
                          const SizedBox(height: 2),
                          Text(
                            'untuk "${filter.query}" di ${_locationController.text}',
                            style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                          ),
                        ],
                      ],
                    ),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.tune, size: 16, color: Color(0xFF1B2A72)),
                      label: const Text(
                        'Filters',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1B2A72),
                        ),
                      ),
                      onPressed: _openFilterModal,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFCBD5E1)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Horizontal Filter Chips (Gaji, Shift, Pengalaman)
              if (hasActiveQuery) ...[
                SizedBox(
                  height: 36,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      _buildFilterDropdownChip('Gaji', _openFilterModal),
                      _buildFilterDropdownChip('Shift', _openFilterModal),
                      _buildFilterDropdownChip('Pengalaman', _openFilterModal),
                      _buildFilterDropdownChip('Sertifikasi', _openFilterModal),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
              ],

              // Job Cards List
              jobsAsync.when(
                data: (jobs) {
                  if (jobs.isEmpty) {
                    return const EmptyStateWidget(
                      title: 'Tidak Ada Lowongan Ditemukan',
                      message: 'Coba ubah kata kunci pencarian atau sesuaikan opsi filter Anda.',
                      icon: Icons.search_off_rounded,
                    );
                  }
                  return Column(
                    children: [
                      ListView.separated(
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
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: TextButton.icon(
                          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF1B2A72), size: 18),
                          label: const Text(
                            'Muat Lebih Banyak',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1B2A72),
                            ),
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Semua lowongan telah ditampilkan.')),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
                loading: () => ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: 3,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, __) => LoadingSkeleton.card(height: 140),
                ),
                error: (err, _) => ErrorStateWidget(
                  message: err.toString(),
                  onRetry: () => ref.invalidate(searchJobsProvider),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPopularCategoryCard({
    required IconData icon,
    required String title,
    required String count,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF1B2A72), size: 24),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              count,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF94A3B8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterDropdownChip(String label, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: ActionChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.keyboard_arrow_down, size: 14, color: Color(0xFF64748B)),
          ],
        ),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFFCBD5E1)),
        ),
        onPressed: onTap,
      ),
    );
  }
}
