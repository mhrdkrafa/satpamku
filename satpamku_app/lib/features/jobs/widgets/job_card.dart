import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_avatar.dart';
import '../../../core/widgets/app_badge.dart';
import '../models/job_model.dart';

class JobCard extends StatelessWidget {
  final JobModel job;
  final VoidCallback onTap;
  final VoidCallback? onBookmarkTap;
  final VoidCallback? onApplyTap;
  final bool isBookmarked;
  final bool showApplyButton;

  const JobCard({
    super.key,
    required this.job,
    required this.onTap,
    this.onBookmarkTap,
    this.onApplyTap,
    this.isBookmarked = false,
    this.showApplyButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: job.isFeatured ? const Color(0xFFC69214).withOpacity(0.5) : const Color(0xFFE2E8F0),
            width: job.isFeatured ? 1.5 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1B2A72).withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
            decoration: BoxDecoration(
              border: job.isFeatured
                  ? const Border(
                      left: BorderSide(color: Color(0xFFC69214), width: 4.5),
                    )
                  : null,
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Logo, Title, Company, Bookmark Icon
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(9),
                        child: job.companyLogoUrl != null && job.companyLogoUrl!.isNotEmpty
                            ? Image.network(
                                job.companyLogoUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Center(
                                  child: Icon(Icons.shield_outlined, color: Color(0xFF1B2A72), size: 22),
                                ),
                              )
                            : const Center(
                                child: Icon(Icons.shield_outlined, color: Color(0xFF1B2A72), size: 22),
                              ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            job.title,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1B2A72),
                              height: 1.25,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  job.companyName,
                                  style: const TextStyle(
                                    fontSize: 12.5,
                                    color: Color(0xFF64748B),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.verified, size: 14, color: Color(0xFFC69214)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                        color: isBookmarked ? const Color(0xFF1B2A72) : const Color(0xFF94A3B8),
                        size: 22,
                      ),
                      onPressed: onBookmarkTap,
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Middle Badges / Metadata Chips
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    if (job.matchScore != null)
                      AppBadge(
                        label: '${job.matchScore}% Cocok',
                        variant: job.matchScore! >= 80 ? AppBadgeVariant.success : AppBadgeVariant.secondary,
                        icon: Icons.verified_user,
                        isSmall: true,
                      ),
                    if (job.isUrgent) AppBadge.urgent(),
                    _buildChip(
                      icon: Icons.location_on_outlined,
                      label: job.locationName,
                    ),
                    _buildChip(
                      icon: Icons.payments_outlined,
                      label: job.formattedSalary,
                    ),
                    _buildChip(
                      icon: Icons.schedule,
                      label: job.formattedShift,
                    ),
                    if (job.requiredCertificateLevel != 'none')
                      _buildCertChip(job.requiredCertificateLevel),
                  ],
                ),
                const SizedBox(height: 12),

                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                const SizedBox(height: 10),

                // Bottom Row: Posted Time + Action Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Diposting ${job.postedTimeAgo.isNotEmpty ? job.postedTimeAgo : "baru saja"}',
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: Color(0xFF94A3B8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    showApplyButton
                        ? SizedBox(
                            height: 32,
                            child: ElevatedButton(
                              onPressed: onApplyTap ?? onTap,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1B2A72),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Lamar',
                                style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        : InkWell(
                            onTap: onTap,
                            child: const Row(
                              children: [
                                Text(
                                  'Lihat Detail',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1B2A72),
                                  ),
                                ),
                                SizedBox(width: 3),
                                Icon(Icons.arrow_forward_ios, size: 10, color: Color(0xFF1B2A72)),
                              ],
                            ),
                          ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: const Color(0xFF64748B)),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF334155),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCertChip(String level) {
    String name = 'Gada Pratama';
    if (level.contains('madya')) name = 'Gada Madya';
    if (level.contains('utama')) name = 'Gada Utama';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF3C7),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFFDE68A)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.workspace_premium, size: 13, color: Color(0xFFD97706)),
          const SizedBox(width: 4),
          Text(
            name,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.bold,
              color: Color(0xFF92400E),
            ),
          ),
        ],
      ),
    );
  }
}
