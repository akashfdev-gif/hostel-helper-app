import 'package:flutter/material.dart';

enum IssueStatus { New, InProgress, Resolved }

enum IssuePriority { Low, Medium, High }

enum MealType { Breakfast, Lunch, Dinner }

class Issue {
  final String id;
  final String studentName;
  final String title;
  final String description;
  final String category;
  final IssuePriority priority;
  IssueStatus status;
  final DateTime timestamp;
  final String? imageUrl;
  String? adminNote;

  Issue({
    required this.id,
    required this.studentName,
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    required this.status,
    required this.timestamp,
    this.imageUrl,
    this.adminNote,
  });
}

class FeedbackItem {
  final String id;
  final String studentName;
  final MealType mealType;
  final int rating; // 1..5
  final String? comment;
  final DateTime date;

  FeedbackItem({
    required this.id,
    required this.studentName,
    required this.mealType,
    required this.rating,
    this.comment,
    required this.date,
  });
}
