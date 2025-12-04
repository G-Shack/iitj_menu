import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/event_model.dart';
import '../../../providers/app_config_provider.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final events = context.watch<AppConfigProvider>().config.events;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [AppColors.darkBackground, AppColors.darkBackgroundSecondary]
                : [
                    AppColors.lightBackground,
                    AppColors.lightBackgroundSecondary
                  ],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                              ),
                              borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusMedium),
                            ),
                            child: const Icon(
                              Icons.celebration_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: AppDimensions.md),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Campus Events',
                                style: AppTextStyles.headlineLarge.copyWith(
                                  color: isDark
                                      ? AppColors.darkTextPrimary
                                      : AppColors.lightTextPrimary,
                                ),
                              ),
                              Text(
                                'What\'s happening around you 🎉',
                                style: AppTextStyles.body.copyWith(
                                  color: isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.lightTextSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Events List
              if (events.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.event_busy_rounded,
                          size: 80,
                          color: isDark
                              ? AppColors.darkTextSecondary.withOpacity(0.5)
                              : AppColors.lightTextSecondary.withOpacity(0.5),
                        ),
                        const SizedBox(height: AppDimensions.md),
                        Text(
                          'No events scheduled',
                          style: AppTextStyles.headline.copyWith(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.sm),
                        Text(
                          'Check back later for updates!',
                          style: AppTextStyles.body.copyWith(
                            color: isDark
                                ? AppColors.darkTextSecondary.withOpacity(0.7)
                                : AppColors.lightTextSecondary.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppDimensions.lg),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final event = events[index];
                        return Padding(
                          padding:
                              const EdgeInsets.only(bottom: AppDimensions.md),
                          child: _EventCard(event: event),
                        );
                      },
                      childCount: events.length,
                    ),
                  ),
                ),

              // Bottom spacing
              const SliverToBoxAdapter(
                child: SizedBox(height: AppDimensions.xxl),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final EventModel event;

  const _EventCard({required this.event});

  Color _getStatusColor() {
    switch (event.status) {
      case EventStatus.upcoming:
        return AppColors.success;
      case EventStatus.completed:
        return AppColors.info;
      case EventStatus.cancelled:
        return AppColors.error;
    }
  }

  IconData _getStatusIcon() {
    switch (event.status) {
      case EventStatus.upcoming:
        return Icons.schedule_rounded;
      case EventStatus.completed:
        return Icons.check_circle_rounded;
      case EventStatus.cancelled:
        return Icons.cancel_rounded;
    }
  }

  String _getStatusText() {
    switch (event.status) {
      case EventStatus.upcoming:
        return 'UPCOMING';
      case EventStatus.completed:
        return 'COMPLETED';
      case EventStatus.cancelled:
        return 'CANCELLED';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final statusColor = _getStatusColor();
    final isCancelled = event.status == EventStatus.cancelled;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        border: Border.all(
          color: statusColor.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: statusColor.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Status indicator bar on left
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 4,
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppDimensions.radiusLarge),
                  bottomLeft: Radius.circular(AppDimensions.radiusLarge),
                ),
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(AppDimensions.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status badge
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.15),
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusRound),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getStatusIcon(),
                            size: 14,
                            color: statusColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _getStatusText(),
                            style: AppTextStyles.caption.copyWith(
                              color: statusColor,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppDimensions.md),

                // Event name
                Text(
                  event.name,
                  style: AppTextStyles.headline.copyWith(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                    decoration: isCancelled ? TextDecoration.lineThrough : null,
                    decorationColor: AppColors.error,
                  ),
                ),

                const SizedBox(height: AppDimensions.md),

                // Venue
                Row(
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      size: 18,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        event.venue,
                        style: AppTextStyles.body.copyWith(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppDimensions.sm),

                // Time
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 18,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        event.time,
                        style: AppTextStyles.body.copyWith(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
