import '../models/app_models.dart';

class AppData {
  AppData._private();
  static final AppData i = AppData._private();

  final List<Issue> issues = List.generate(5, (index) {
    final cats = ['Water', 'WiFi', 'Light', 'Cleanliness', 'Food'];
    final pr = [IssuePriority.Low, IssuePriority.Medium, IssuePriority.High];
    final st = [IssueStatus.New, IssueStatus.InProgress, IssueStatus.Resolved];
    return Issue(
      id: 'ISS-${100 + index}',
      studentName: 'Student ${index + 1}',
      title: '${cats[index % cats.length]} problem',
      description: 'Detailed description of the problem #${index + 1}.',
      category: cats[index % cats.length],
      priority: pr[index % pr.length],
      status: st[index % st.length],
      timestamp: DateTime.now().subtract(Duration(hours: index * 5)),
      imageUrl: null,
    );
  });

  final List<FeedbackItem> feedbacks = [
    FeedbackItem(
      id: 'FB-1',
      studentName: 'Student 1',
      mealType: MealType.Breakfast,
      rating: 4,
      comment: 'Paneer bhurji thoda kam spicy.',
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),
    FeedbackItem(
      id: 'FB-2',
      studentName: 'Student 2',
      mealType: MealType.Dinner,
      rating: 2,
      comment: 'Dal watery thi.',
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
    FeedbackItem(
      id: 'FB-3',
      studentName: 'Student 3',
      mealType: MealType.Lunch,
      rating: 5,
      comment: 'Perfect!',
      date: DateTime.now(),
    ),
  ];

  void addIssue(Issue issue) => issues.insert(0, issue);

  void updateIssue(Issue updated) {
    final idx = issues.indexWhere((e) => e.id == updated.id);
    if (idx != -1) issues[idx] = updated;
  }

  void addFeedback(FeedbackItem f) => feedbacks.insert(0, f);
}
