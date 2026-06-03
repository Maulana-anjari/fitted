class RouteNames {
  RouteNames._();

  // Auth
  static const String welcome = '/welcome';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';

  // Tabs (StatefulShellRoute)
  static const String dailyFit = '/daily-fit';
  static const String wardrobe = '/wardrobe';
  static const String fitPlanner = '/fit-planner';
  static const String fitCheck = '/fit-check';
  static const String profile = '/profile';

  // Wardrobe sub-routes
  static const String wardrobeItemDetail = '/wardrobe/item';
  static const String wardrobeUpload = '/wardrobe/upload';

  // Fits sub-routes
  static const String myFits = '/fits';
  static const String fitBuilder = '/fits/builder';
  static const String fitDetail = '/fits/detail';

  // Planner sub-routes
  static const String plannerDay = '/fit-planner/day';

  // Fit Insights
  static const String fitInsights = '/fit-insights';
}
