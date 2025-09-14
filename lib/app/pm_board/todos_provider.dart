import 'package:flutter_riverpod/flutter_riverpod.dart';

final todosProvider = StateProvider(
  (_) => [
    // Phase 1: Authentication & Basic Profile (Week of Sept 15-19)
    {
      "title": "Candidate Authentication",
      "description": "Implement OTP based authentication flows",
      "subtasks": [
        "Sign up with OTP",
        "Login with OTP",
        "OTP verification screen",
        "Session management",
      ],
    },
    {
      "title": "Preference Management",
      "description": "Manage job preferences and titles",
      "subtasks": [
        "UI for selecting preferred job titles",
        "Add/remove job titles",
        "Sort job titles",
        "Save preferences to job profile",
        "Test cases for preference management",
      ],
    },
    {
      "title": "Candidate Profile Management",
      "description": "CRUD operations for candidate profile",
      "subtasks": [
        "Create candidate profile",
        "Update candidate profile",
        "View candidate profile",
        "Form validation",
        "API integration",
      ],
    },
    {
      "title": "Job Profile Management",
      "description": "Manage job-related profile information",
      "subtasks": [
        "Add/update skills",
        "Education details management",
        "Experience management",
        "Save filters as job profile blob",
      ],
    },
    {
      "title": "Job Application Flow",
      "description": "Job application and management",
      "subtasks": [
        "View job details by ID",
        "Apply to a job",
        "Withdraw application",
        "Application status tracking",
      ],
    },

    // Phase 2: Job Search & Application Management (Week of Sept 22-26)
    {
      "title": "Application Dashboard",
      "description": "View and manage job applications",
      "subtasks": [
        "List applied jobs",
        "Group by application stage",
        "Application status tracking",
        "Document attachment to applications",
      ],
    },
    {
      "title": "Document Management",
      "description": "Handle document uploads and management",
      "subtasks": [
        "Upload CV/Resume",
        "Attach documents to profile",
        "Attach documents to applications",
        "Document preview functionality",
      ],
    },
    {
      "title": "Agency & Job Discovery",
      "description": "Browse agencies and jobs",
      "subtasks": [
        "List agencies",
        "View agency profiles",
        "Job listing with filters",
        "Relevant jobs section",
      ],
    },

    // Technical Foundation
    {
      "title": "Technical Implementation",
      "description": "Core technical requirements",
      "subtasks": [
        "Set up clean architecture",
        "API service layer",
        "State management",
        "Local storage for offline access",
        "Error handling and logging",
      ],
    },
  ],
);
