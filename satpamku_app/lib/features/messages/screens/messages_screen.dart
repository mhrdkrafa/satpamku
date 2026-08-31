import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

class MessagesScreen extends ConsumerStatefulWidget {
  const MessagesScreen({super.key});

  @override
  ConsumerState<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends ConsumerState<MessagesScreen> {
  final _searchController = TextEditingController();
  int _selectedChatIndex = 0;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text(
          'Satpamku',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B2A72),
          ),
        ),
        centerTitle: false,
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
      body: Column(
        children: [
          // Search Messages Input Box
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFCBD5E1)),
              ),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(fontSize: 13),
                decoration: const InputDecoration(
                  hintText: 'Search messages...',
                  hintStyle: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                  prefixIcon: Icon(Icons.search, size: 20, color: Color(0xFF64748B)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),

          // Messages Conversations List
          Expanded(
            child: ListView(
              children: [
                _buildMessageTile(
                  index: 0,
                  name: 'Budi Santoso',
                  lastMessage: 'I have attached my Gada Pratama certificate as...',
                  hasAvatar: true,
                  isOnline: true,
                  isActive: _selectedChatIndex == 0,
                  onTap: () => setState(() => _selectedChatIndex = 0),
                ),
                _buildMessageTile(
                  index: 1,
                  name: 'Agus Wijaya',
                  lastMessage: 'Can we reschedule the interview to tomorrow?',
                  initials: 'AW',
                  initialBg: const Color(0xFFFDE68A),
                  initialTextColor: const Color(0xFF92400E),
                  hasAvatar: false,
                  isActive: _selectedChatIndex == 1,
                  onTap: () => setState(() => _selectedChatIndex = 1),
                ),
                _buildMessageTile(
                  index: 2,
                  name: 'Siti Rahma',
                  lastMessage: 'Thank you for the opportunity. I will be there at 8...',
                  hasAvatar: true,
                  isOnline: false,
                  isActive: _selectedChatIndex == 2,
                  onTap: () => setState(() => _selectedChatIndex = 2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageTile({
    required int index,
    required String name,
    required String lastMessage,
    bool hasAvatar = true,
    bool isOnline = false,
    String? initials,
    Color? initialBg,
    Color? initialTextColor,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFF1F5F9).withOpacity(0.6) : Colors.white,
          border: Border(
            left: BorderSide(
              color: isActive ? const Color(0xFF1B2A72) : Colors.transparent,
              width: 4,
            ),
            bottom: const BorderSide(color: Color(0xFFF1F5F9)),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: initialBg ?? const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: initials != null
                        ? Text(
                            initials,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: initialTextColor ?? const Color(0xFF475569),
                            ),
                          )
                        : const Icon(Icons.person, color: Color(0xFF1B2A72), size: 26),
                  ),
                ),
                if (isOnline)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: const Color(0xFF16A34A),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    lastMessage,
                    style: TextStyle(
                      fontSize: 12.5,
                      color: isActive ? const Color(0xFF1E293B) : const Color(0xFF64748B),
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
