import 'package:flutter/material.dart';
import '../../generated/l10n/app_localizations.dart';

class InputValidators {
  static String? validateEmail(String? value, BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return 'Email is required';
    
    if (value == null || value.isEmpty) {
      return l10n.emailRequired;
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return l10n.invalidEmail;
    }
    
    return null;
  }
  
  static String? validatePassword(String? value, BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return 'Password is required';
    
    if (value == null || value.isEmpty) {
      return l10n.passwordRequired;
    }
    
    if (value.length < 8) {
      return l10n.passwordTooShort;
    }
    
    // TODO: Add more password validation messages to ARB files
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }
    
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    
    return null;
  }
  
  static String? validateRequired(String? value, String fieldName, BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return '$fieldName is required';
    
    if (value == null || value.isEmpty) {
      return l10n.fieldRequired(fieldName);
    }
    return null;
  }
  
  static String? validatePhoneNumber(String? value, BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return 'Phone number is required';
    
    if (value == null || value.isEmpty) {
      return l10n.fieldRequired('Phone number'); // TODO: Add phone number to ARB
    }
    
    final phoneRegex = RegExp(r'^\+?[1-9]\d{1,14}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid phone number'; // TODO: Add to ARB
    }
    
    return null;
  }
  
  static String? validateMinLength(String? value, int minLength, String fieldName, BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return '$fieldName is required';
    
    if (value == null || value.isEmpty) {
      return l10n.fieldRequired(fieldName);
    }
    
    if (value.length < minLength) {
      return '$fieldName must be at least $minLength characters long'; // TODO: Add to ARB
    }
    
    return null;
  }
  
  static String? validateMaxLength(String? value, int maxLength, String fieldName, BuildContext context) {
    if (value != null && value.length > maxLength) {
      return '$fieldName must be at most $maxLength characters long'; // TODO: Add to ARB
    }
    
    return null;
  }
} 