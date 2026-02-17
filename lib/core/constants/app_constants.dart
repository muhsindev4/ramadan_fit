import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF1B8A6B);
  static const primaryDark = Color(0xFF0D5E48);
  static const secondary = Color(0xFFE8A838);
  static const accent = Color(0xFFFF6B6B);
  static const background = Color(0xFF0A0E21);
  static const surface = Color(0xFF1D1F33);
  static const surfaceLight = Color(0xFF252840);
  static const cardDark = Color(0xFF161929);
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFFB0B3C5);
  static const success = Color(0xFF4CAF50);
  static const warning = Color(0xFFFF9800);
  static const error = Color(0xFFE53935);
  static const water = Color(0xFF42A5F5);
  static const gold = Color(0xFFD4AF37);
}

class AppStrings {
  static const appName = 'Ramadan Fit';
  static const tagline = '30-Day Transformation';

  // Routes
  static const splashRoute = '/';
  static const homeRoute = '/home';
  static const mealPlanRoute = '/meal-plan';
  static const workoutRoute = '/workout';
  static const waterRoute = '/water';
  static const progressRoute = '/progress';
  static const settingsRoute = '/settings';
}

class NotificationChannels {
  static const suhoorId = 'suhoor_channel';
  static const suhoorName = 'Suhoor Reminders';
  static const iftarId = 'iftar_channel';
  static const iftarName = 'Iftar Reminders';
  static const waterId = 'water_channel';
  static const waterName = 'Water Reminders';
  static const exerciseId = 'exercise_channel';
  static const exerciseName = 'Exercise Reminders';
}

class MealData {
  static const suhoorMeals = [
    {
      'name': '2 Whole Eggs + 1 Egg White',
      'calories': 220,
      'icon': '🥚',
      'protein': '20g',
    },
    {
      'name': '1 Banana',
      'calories': 105,
      'icon': '🍌',
      'protein': '1g',
    },
    {
      'name': '1 Chapati / ½ Cup Oats',
      'calories': 150,
      'icon': '🫓',
      'protein': '4g',
    },
    {
      'name': '2 Glasses Water',
      'calories': 0,
      'icon': '💧',
      'protein': '0g',
    },
  ];

  static const iftarStep1 = [
    {
      'name': '2 Dates',
      'calories': 133,
      'icon': '🌴',
      'protein': '1g',
    },
    {
      'name': '1 Glass Water',
      'calories': 0,
      'icon': '💧',
      'protein': '0g',
    },
  ];

  static const iftarStep2 = [
    {
      'name': 'Small Fruit Bowl / Veg Soup',
      'calories': 120,
      'icon': '🥗',
      'protein': '3g',
    },
  ];

  static const dinnerMeals = [
    {
      'name': '1 Chapati',
      'calories': 120,
      'icon': '🫓',
      'protein': '3g',
    },
    {
      'name': '2 Eggs / Fish / Boiled Kadala',
      'calories': 200,
      'icon': '🐟',
      'protein': '18g',
    },
    {
      'name': 'Large Vegetable Portion',
      'calories': 80,
      'icon': '🥦',
      'protein': '4g',
    },
  ];

  static const workouts = [
    {
      'name': 'Brisk Walking',
      'duration': '20-30 min',
      'icon': '🚶',
      'calories': 150,
      'sets': 1,
    },
    {
      'name': 'Squats',
      'reps': '15 reps',
      'icon': '🏋️',
      'calories': 30,
      'sets': 3,
    },
    {
      'name': 'Push-ups',
      'reps': '10 reps',
      'icon': '💪',
      'calories': 25,
      'sets': 3,
    },
    {
      'name': 'Plank',
      'reps': '30 sec',
      'icon': '🧘',
      'calories': 15,
      'sets': 3,
    },
  ];
}
