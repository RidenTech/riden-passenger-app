import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Riden/widgets/shared_map_widget.dart';
import 'package:Riden/widgets/riden_bottom_nav.dart';
import 'package:Riden/models/notification_model.dart';
import 'package:Riden/controllers/navigation_controller.dart';
import 'package:Riden/home/home_screen.dart';
import 'package:get/get.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  int _selectedNavIndex = 2; // Activity/Notifications is typically 2
  late List<NotificationModel> _notifications;

  @override
  void initState() {
    super.initState();
    _notifications = _generateSampleNotifications();
    _selectedNavIndex = Get.find<NavigationController>().selectedNavIndex.value;
  }

  // Generate sample notifications for demo
  List<NotificationModel> _generateSampleNotifications() {
    final now = DateTime.now();
    return [
      NotificationModel(
        id: '1',
        title: 'Payment Successfully!',
        message: 'Lorem ipsum dolor sit amet consectetur ubiqu tri consequitur',
        icon: 'payment',
        timestamp: now.subtract(const Duration(minutes: 20)),
        isRead: false,
      ),
      NotificationModel(
        id: '2',
        title: '30% Special Discount!',
        message: 'Lorem ipsum dolor sit amet consectetur ubiqu tri consequitur',
        icon: 'discount',
        timestamp: now.subtract(const Duration(hours: 2)),
        isRead: false,
      ),
      NotificationModel(
        id: '3',
        title: 'Payment Successfully!',
        message: 'Lorem ipsum dolor sit amet consectetur ubiqu tri consequitur',
        icon: 'payment',
        timestamp: now.subtract(const Duration(hours: 3)),
        isRead: true,
      ),
      NotificationModel(
        id: '4',
        title: 'Credit Card added!',
        message: 'Lorem ipsum dolor sit amet consectetur ubiqu tri consequitur',
        icon: 'card',
        timestamp: now.subtract(const Duration(hours: 5)),
        isRead: true,
      ),
      NotificationModel(
        id: '5',
        title: 'Added Money wallet Successfully!',
        message: 'Lorem ipsum dolor sit amet consectetur ubiqu tri consequitur',
        icon: 'wallet',
        timestamp: now.subtract(const Duration(days: 1, hours: 2)),
        isRead: false,
      ),
      NotificationModel(
        id: '6',
        title: '5% Special Discount!',
        message: 'Lorem ipsum dolor sit amet consectetur ubiqu tri consequitur',
        icon: 'discount',
        timestamp: now.subtract(const Duration(days: 2)),
        isRead: true,
      ),
    ];
  }

  // Get icon based on notification type
  Widget _getNotificationIcon(String iconType) {
    switch (iconType) {
      case 'payment':
        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_circle_outline,
            color: Colors.blue,
            size: 20,
          ),
        );
      case 'discount':
        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.local_offer,
            color: Colors.orange,
            size: 20,
          ),
        );
      case 'wallet':
        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.account_balance_wallet,
            color: Colors.green,
            size: 20,
          ),
        );
      case 'card':
        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.purple.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.credit_card,
            color: Colors.purple,
            size: 20,
          ),
        );
      default:
        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.notifications,
            color: Colors.grey,
            size: 20,
          ),
        );
    }
  }

  // Mark all notifications as read
  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification.isRead = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('All notifications marked as read'),
        backgroundColor: Colors.green.withOpacity(0.8),
        duration: const Duration(milliseconds: 800),
      ),
    );
  }

  // Build notification item
  Widget _buildNotificationItem(NotificationModel notification) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
          ),
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _getNotificationIcon(notification.icon),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.message,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      color: Colors.white54,
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.formattedTime,
                    style: GoogleFonts.poppins(
                      color: Colors.white30,
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            if (!notification.isRead)
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF12C5ED),
                  shape: BoxShape.circle,
                ),
              )
            else
              const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Separate notifications into today and previous days
    final todayNotifications =
        _notifications.where((n) => n.isToday).toList();
    final previousNotifications =
        _notifications.where((n) => n.isPreviousDay).toList();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Map Background (Top 20%)
          Positioned.fill(
            child: SharedMapWidget(height: MediaQuery.of(context).size.height),
          ),

          // Semi-transparent overlay on map
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),

          // Back button on map area
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),

          // Bottom Sheet with Notifications
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.75,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF030408),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [
                  // Handle bar
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Header with title and mark all as read button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Notifications',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: _markAllAsRead,
                          child: Text(
                            'Mark all as read',
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF12C5ED),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Notifications List
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Today's notifications
                          if (todayNotifications.isNotEmpty) ...[
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                'Today',
                                style: GoogleFonts.poppins(
                                  color: Colors.white54,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            ...todayNotifications
                                .map((n) => _buildNotificationItem(n)),
                            const SizedBox(height: 16),
                          ],

                          // Previous days notifications
                          if (previousNotifications.isNotEmpty) ...[
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                'Previous',
                                style: GoogleFonts.poppins(
                                  color: Colors.white54,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            ...previousNotifications
                                .map((n) => _buildNotificationItem(n)),
                            const SizedBox(height: 16),
                          ],

                          // Empty state
                          if (_notifications.isEmpty)
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(32),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.notifications_off_outlined,
                                      color: Colors.white24,
                                      size: 48,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'No notifications yet',
                                      style: GoogleFonts.poppins(
                                        color: Colors.white54,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                          // Spacing for bottom nav
                          SizedBox(
                            height: MediaQuery.of(context).padding.bottom + 90,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Navigation Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: RidenBottomNav(
                  selectedIndex: _selectedNavIndex,
                  onItemSelected: (index) {
                    Get.find<NavigationController>().setSelectedIndex(index);
                    Get.offAll(
                      () => const HomeScreen(),
                      transition: Transition.fadeIn,
                      duration: const Duration(milliseconds: 600),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
