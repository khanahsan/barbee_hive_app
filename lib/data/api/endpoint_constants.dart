class ApiEndPoints {
  static const String baseUrl = 'https://barbeehive.staging.pegasync.com/api/';

  /// AUTH
  static const String login = 'login';
  static const String logout = 'logout';
  static const String forgotPassword = 'forgot-password';
  static const String changePassword = 'change-password';
  static const String dashboardUsers = 'dashboard/nearest-users';
  static const String deleteAccount = 'delete-account';

  /// COMMON
  static const String eyeColors = 'dashboard/eye-colors';
  static const String hairColors = 'dashboard/hair-colors';
  static const String getSkills = 'dashboard/skills';
  static const String getExperienceLevels = 'dashboard/experience-levels';
  static const String getJobTypes = 'dashboard/job-types';
  static const String getGenders = 'dashboard/genders';
  static const String getHeights = 'dashboard/heights';
  static const String getCountries = 'dashboard/countries';
  static const String getStates = 'dashboard/states';
  static const String getSalaryTypes = 'dashboard/salary-types';
  static const String getContactTypes = 'dashboard/contact-types';
  static const String dashboardDropdown = 'dashboard/dropdown?filter=eye-colors,hair-colors,skills,experience-levels,job-types,genders,heights,salary-types,countries,states,contact-types';

  static const String registerEmployee = 'register';
  static const String userProfile = 'profiles';
  static const String jobStore = 'jobs/store';
  static const String jobUpdate = 'jobs/update';
  static const String updateProfile = 'profiles/update';
  static const String jobs = 'jobs';
  static const String appliedJobs = 'jobs/applied';
  static const String applyJob = 'jobs/applications/store';
  static const String jobApplications = 'jobs/applications/show';

  /// SETTINGS
  static const String setting = 'settings';
  static const String updateSettings = 'settings/update';
  static const String feedbackSupport = 'contact';

  /// SUBSCRIPTION
  static const String subscriptionPlans = 'subscription/plans';
  static const String applySubscription = 'subscription/apply';
  static const String finalizeSubscription = 'subscription/finalize';


  /// DASHBOARD
  static const String unreadCount = 'notifications/unread-count';
  static const String getAllNotifications = 'notifications';
  static const String markAllAsRead = 'notifications/mark-all-read';
}
