import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../providers/notification_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animationController.forward();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = 'v${packageInfo.version}';
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 140,
            pinned: true,
            backgroundColor:
                isDark ? AppColors.darkBackground : AppColors.lightBackground,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_rounded,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding:
                  const EdgeInsets.only(left: 56, bottom: 16, right: 16),
              title: Text(
                'Settings',
                style: AppTextStyles.headline.copyWith(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary.withOpacity(0.1),
                      isDark
                          ? AppColors.darkBackground
                          : AppColors.lightBackground,
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Settings Content
          SliverPadding(
            padding: const EdgeInsets.all(AppDimensions.md),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Notifications Section
                _buildSectionHeader(
                    context, 'Notifications', Icons.notifications_rounded),
                const SizedBox(height: AppDimensions.sm),
                _buildNotificationCard(context, isDark),

                const SizedBox(height: AppDimensions.xl),

                // About Section
                _buildSectionHeader(context, 'About', Icons.info_rounded),
                const SizedBox(height: AppDimensions.sm),
                _buildAboutCard(context, isDark),

                const SizedBox(height: AppDimensions.xl),

                // Support Section
                _buildSectionHeader(context, 'Support', Icons.support_rounded),
                const SizedBox(height: AppDimensions.sm),
                _buildSupportCard(context, isDark),

                const SizedBox(height: AppDimensions.xxl),

                // App Version
                Center(
                  child: Text(
                    'IITJ Mess Menu $_appVersion',
                    style: AppTextStyles.caption.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.sm),
                Center(
                  child: Text(
                    'Made with ❤️ for IITJ Community',
                    style: AppTextStyles.caption.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.xl),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
      BuildContext context, String title, IconData icon) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 18,
          ),
        ),
        const SizedBox(width: AppDimensions.sm),
        Text(
          title,
          style: AppTextStyles.title.copyWith(
            color:
                isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationCard(BuildContext context, bool isDark) {
    return Consumer<NotificationProvider>(
      builder: (context, notificationProvider, _) {
        return _buildCard(
          context,
          isDark,
          child: Column(
            children: [
              _buildNotificationToggleItem(
                context,
                isDark,
                title: 'Meal Reminders',
                subtitle: 'Get notified when it\'s meal time',
                icon: Icons.restaurant_rounded,
                isEnabled: notificationProvider.isEnabled,
                isLoading: notificationProvider.isLoading,
                onToggle: () async {
                  await notificationProvider.toggleNotifications();
                  if (notificationProvider.isEnabled && mounted) {
                    _showSnackBar(
                      context,
                      '🔔 You\'ll receive meal reminders!',
                      isSuccess: true,
                    );
                  }
                },
              ),
              if (notificationProvider.isEnabled) ...[
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.all(AppDimensions.md),
                  child: Row(
                    children: [
                      Icon(
                        Icons.schedule_rounded,
                        size: 16,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                      const SizedBox(width: AppDimensions.sm),
                      Expanded(
                        child: Text(
                          'Reminders are sent at meal start times',
                          style: AppTextStyles.caption.copyWith(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildNotificationToggleItem(
    BuildContext context,
    bool isDark, {
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isEnabled,
    required bool isLoading,
    required VoidCallback onToggle,
  }) {
    return InkWell(
      onTap: isLoading ? null : onToggle,
      borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.md),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isEnabled
                      ? [AppColors.primary, AppColors.primaryDark]
                      : [
                          isDark
                              ? AppColors.darkSurface
                              : AppColors.lightBorder,
                          isDark
                              ? AppColors.darkSurface
                              : AppColors.lightBorder,
                        ],
                ),
                borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
              ),
              child: Icon(
                icon,
                color: isEnabled
                    ? Colors.white
                    : (isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary),
                size: 20,
              ),
            ),
            const SizedBox(width: AppDimensions.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTextStyles.caption.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isLoading)
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              Switch.adaptive(
                value: isEnabled,
                onChanged: (_) => onToggle(),
                activeColor: AppColors.primary,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutCard(BuildContext context, bool isDark) {
    return _buildCard(
      context,
      isDark,
      child: Column(
        children: [
          _buildSettingsItem(
            context,
            isDark,
            title: 'Privacy Policy',
            icon: Icons.privacy_tip_rounded,
            onTap: () => _launchUrl('https://iitjmenu.vercel.app/privacy'),
          ),
          const Divider(height: 1),
          _buildSettingsItem(
            context,
            isDark,
            title: 'Terms of Service',
            icon: Icons.description_rounded,
            onTap: () => _launchUrl('https://iitjmenu.vercel.app/terms'),
          ),
          const Divider(height: 1),
          _buildSettingsItem(
            context,
            isDark,
            title: 'Open Source Licenses',
            icon: Icons.code_rounded,
            onTap: () => showLicensePage(
              context: context,
              applicationName: 'IITJ Mess Menu',
              applicationVersion: _appVersion,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportCard(BuildContext context, bool isDark) {
    return _buildCard(
      context,
      isDark,
      child: Column(
        children: [
          _buildSettingsItem(
            context,
            isDark,
            title: 'Rate the App',
            icon: Icons.star_rounded,
            iconColor: AppColors.secondary,
            onTap: () => _launchUrl(
              'https://play.google.com/store/apps/details?id=com.omtathed.iitj_menu',
            ),
          ),
          const Divider(height: 1),
          _buildSettingsItem(
            context,
            isDark,
            title: 'Share with Friends',
            icon: Icons.share_rounded,
            iconColor: AppColors.info,
            onTap: () => Share.share(
              'Check out IITJ Mess Menu app! Never miss a meal again 🍽️\n\nhttps://play.google.com/store/apps/details?id=com.omtathed.iitj_menu',
            ),
          ),
          const Divider(height: 1),
          _buildSettingsItem(
            context,
            isDark,
            title: 'Report a Bug',
            icon: Icons.bug_report_rounded,
            iconColor: AppColors.error,
            onTap: () =>
                _launchUrl('mailto:support@iitjmenu.app?subject=Bug Report'),
          ),
          const Divider(height: 1),
          _buildSettingsItem(
            context,
            isDark,
            title: 'Request a Feature',
            icon: Icons.lightbulb_rounded,
            iconColor: AppColors.success,
            onTap: () => _launchUrl(
                'mailto:support@iitjmenu.app?subject=Feature Request'),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, bool isDark,
      {required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        child: child,
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context,
    bool isDark, {
    required String title,
    required IconData icon,
    Color? iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.md,
          vertical: AppDimensions.md,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: iconColor ?? AppColors.primary,
              size: 22,
            ),
            const SizedBox(width: AppDimensions.md),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.body.copyWith(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _showSnackBar(BuildContext context, String message,
      {bool isSuccess = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isSuccess ? AppColors.success : AppColors.error,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
        ),
      ),
    );
  }
}
