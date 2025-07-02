import 'package:flutter/material.dart';
import '../entities/match.dart';
import '../../../../generated/l10n/app_localizations.dart';

/// A utility class that provides status-related functionality for football matches.
/// 
/// This class handles the mapping between match status codes (0-13) and their display properties,
/// including localized text, colors, and icons. It supports all official match statuses:
/// 
/// Status Codes:
/// - 0: Abnormal (suggest hiding)
/// - 1: Not started
/// - 2: First half
/// - 3: Half-time
/// - 4: Second half
/// - 5: Overtime
/// - 6: Overtime (deprecated)
/// - 7: Penalty Shoot-out
/// - 8: End/Finished
/// - 9: Delay
/// - 10: Interrupt
/// - 11: Cut in half
/// - 12: Cancel
/// - 13: To be determined
/// 
/// Usage:
/// ```dart
/// // Get localized status text
/// final statusText = MatchStatusHelper.getLocalizedStatus(context, match.status, minute: match.minute);
/// 
/// // Get short status for compact UI
/// final shortStatus = MatchStatusHelper.getShortStatus(match.status, minute: match.minute);
/// 
/// // Get status color for theming
/// final statusColor = MatchStatusHelper.getStatusColor(context, match.status);
/// 
/// // Get appropriate icon
/// final statusIcon = MatchStatusHelper.getStatusIcon(match.status);
/// ```
class MatchStatusHelper {
  /// Get localized status text based on match status
  /// 
  /// [context] - BuildContext for accessing localizations
  /// [status] - The match status enum value
  /// [minute] - Optional minute to display for live matches
  /// 
  /// Returns fully localized status text appropriate for detailed displays
  static String getLocalizedStatus(BuildContext context, MatchStatus status, {int? minute}) {
    final l10n = AppLocalizations.of(context)!;
    
    switch (status) {
      case MatchStatus.abnormal:
        return l10n.matchStatusAbnormal;
      case MatchStatus.notStarted:
        return l10n.matchStatusNotStarted;
      case MatchStatus.firstHalf:
        return minute != null ? l10n.matchStatusFirstHalfWithMinute(minute) : l10n.matchStatusFirstHalf;
      case MatchStatus.halfTime:
        return l10n.matchStatusHalfTime;
      case MatchStatus.secondHalf:
        return minute != null ? l10n.matchStatusSecondHalfWithMinute(minute) : l10n.matchStatusSecondHalf;
      case MatchStatus.overtime:
        return minute != null ? l10n.matchStatusOvertimeWithMinute(minute) : l10n.matchStatusOvertime;
      case MatchStatus.overtimeDeprecated:
        return minute != null ? l10n.matchStatusOvertimeWithMinute(minute) : l10n.matchStatusOvertime;
      case MatchStatus.penaltyShootout:
        return l10n.matchStatusPenaltyShootout;
      case MatchStatus.finished:
        return l10n.matchStatusFinished;
      case MatchStatus.delayed:
        return l10n.matchStatusDelayed;
      case MatchStatus.interrupted:
        return l10n.matchStatusInterrupted;
      case MatchStatus.cutInHalf:
        return l10n.matchStatusCutInHalf;
      case MatchStatus.cancelled:
        return l10n.matchStatusCancelled;
      case MatchStatus.toBeDetermined:
        return l10n.matchStatusToBeDetermined;
    }
  }

  /// Get a short display text for the status (for compact UI)
  /// 
  /// [status] - The match status enum value
  /// [minute] - Optional minute to display for live matches
  /// 
  /// Returns short, non-localized status text suitable for compact displays
  static String getShortStatus(MatchStatus status, {int? minute}) {
    switch (status) {
      case MatchStatus.firstHalf:
      case MatchStatus.secondHalf:
        return minute != null ? "$minute'" : 'LIVE';
      case MatchStatus.halfTime:
        return 'HT';
      case MatchStatus.overtime:
      case MatchStatus.overtimeDeprecated:
        return minute != null ? "ET $minute'" : 'ET';
      case MatchStatus.penaltyShootout:
        return 'PENS';
      case MatchStatus.finished:
        return 'FT';
      case MatchStatus.notStarted:
        return 'vs';
      case MatchStatus.delayed:
        return 'DELAYED';
      case MatchStatus.interrupted:
        return 'INT';
      case MatchStatus.cancelled:
        return 'CANCELLED';
      case MatchStatus.toBeDetermined:
        return 'TBD';
      case MatchStatus.cutInHalf:
        return 'ABANDONED';
      case MatchStatus.abnormal:
        return 'ERROR';
    }
  }

  /// Get status color based on match status
  /// 
  /// [context] - BuildContext for accessing theme colors
  /// [status] - The match status enum value
  /// 
  /// Returns appropriate color for the status that fits the app theme
  static Color getStatusColor(BuildContext context, MatchStatus status) {
    final colorScheme = Theme.of(context).colorScheme;
    
    switch (status) {
      case MatchStatus.firstHalf:
      case MatchStatus.secondHalf:
      case MatchStatus.overtime:
      case MatchStatus.overtimeDeprecated:
      case MatchStatus.penaltyShootout:
        return Colors.green; // Live statuses
      case MatchStatus.halfTime:
        return Colors.orange; // Paused
      case MatchStatus.finished:
        return colorScheme.onSurface; // Neutral
      case MatchStatus.notStarted:
        return colorScheme.primary; // Upcoming
      case MatchStatus.delayed:
      case MatchStatus.interrupted:
        return Colors.amber; // Warning
      case MatchStatus.cancelled:
      case MatchStatus.cutInHalf:
      case MatchStatus.abnormal:
        return colorScheme.error; // Error/cancelled
      case MatchStatus.toBeDetermined:
        return colorScheme.outline; // Uncertain
    }
  }

  /// Check if status indicates the match should be prominently displayed
  /// 
  /// [status] - The match status enum value
  /// 
  /// Returns true if the match should be highlighted (live or paused)
  static bool shouldHighlight(MatchStatus status) {
    return status.isLive || status.isPaused;
  }

  /// Get appropriate icon for status
  /// 
  /// [status] - The match status enum value
  /// 
  /// Returns Material Design icon that represents the status
  static IconData getStatusIcon(MatchStatus status) {
    switch (status) {
      case MatchStatus.firstHalf:
      case MatchStatus.secondHalf:
      case MatchStatus.overtime:
      case MatchStatus.overtimeDeprecated:
        return Icons.play_circle;
      case MatchStatus.halfTime:
        return Icons.pause_circle;
      case MatchStatus.penaltyShootout:
        return Icons.sports_soccer;
      case MatchStatus.finished:
        return Icons.check_circle;
      case MatchStatus.notStarted:
        return Icons.schedule;
      case MatchStatus.delayed:
      case MatchStatus.interrupted:
        return Icons.warning;
      case MatchStatus.cancelled:
      case MatchStatus.cutInHalf:
        return Icons.cancel;
      case MatchStatus.toBeDetermined:
        return Icons.help;
      case MatchStatus.abnormal:
        return Icons.error;
    }
  }
} 