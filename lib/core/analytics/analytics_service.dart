import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Analytics events used across Fitted.
enum AnalyticsEvent {
  signUp('sign_up'),
  signIn('sign_in'),
  signOut('sign_out'),
  wardrobeItemAdded('wardrobe_item_added'),
  wardrobeItemDeleted('wardrobe_item_deleted'),
  wardrobeItemWorn('wardrobe_item_worn'),
  fitCreated('fit_created'),
  fitDeleted('fit_deleted'),
  fitPlanned('fit_planned'),
  fitGenerated('fit_generated'),
  fitShared('fit_shared'),
  fitCoachUsed('fit_coach_used'),
  premiumClicked('premium_clicked'),
  screenViewed('screen_viewed'),
  aiRecommendationAccepted('ai_recommendation_accepted'),
  aiRecommendationRejected('ai_recommendation_rejected'),
  uploadStarted('upload_started'),
  uploadCompleted('upload_completed'),
  uploadFailed('upload_failed');

  final String name;
  const AnalyticsEvent(this.name);
}

class AnalyticsService {
  AnalyticsService();

  Future<void> initialize({required String apiKey}) async {
    // PostHog initialization happens in bootstrap.dart
    // This service wraps PostHog calls for typed events.
  }

  static void identify({
    required String userId,
    Map<String, dynamic>? properties,
  }) {
    try {
      // Posthog().identify(userId: userId, properties: properties);
      print('[Analytics] identify: $userId ${properties ?? {}}');
    } catch (_) {}
  }

  static void track(
    AnalyticsEvent event, {
    Map<String, dynamic>? properties,
  }) {
    try {
      // Posthog().capture(eventName: event.name, properties: properties);
      print('[Analytics] ${event.name}: ${properties ?? {}}');
    } catch (_) {}
  }

  static void screen(String screenName, {Map<String, dynamic>? properties}) {
    track(
      AnalyticsEvent.screenViewed,
      properties: {'screen': screenName, ...?properties},
    );
  }

  static void reset() {
    try {
      // Posthog().reset();
      print('[Analytics] reset');
    } catch (_) {}
  }
}

/// Provider that gives access to analytics tracking.
final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  return AnalyticsService();
});
