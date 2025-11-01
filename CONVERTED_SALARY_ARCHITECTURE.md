# Converted Salary Architecture

## Overview
The mobile job API provides **position-level** converted salaries, not job-level converted salaries. This document clarifies the correct usage pattern.

## Data Structure

### API Response Structure
```json
{
  "id": "e45c2113-9ba3-47cc-a8d5-cbc2169d4cd1",
  "postingTitle": "Senior Electrical Technician - Dubai Project",
  "matchPercentage": "0",
  "salary": "AED 2500 - AED 2500",
  "convertedSalary": null,  // ❌ NOT provided at job level
  "positions": [
    {
      "id": "b75257cb-0c3a-4d84-8e10-774ed15064ae",
      "title": "Electrician",
      "baseSalary": "AED 2500",
      "convertedSalary": "NPR 90000",  // ✅ Provided at position level
      "currency": "AED"
    }
  ]
}
```

## Frontend Implementation

### Entity Definition
- `MobileJobEntity.convertedSalary` - **@deprecated** - Use `positions[].convertedSalary` instead
- `JobPosition.convertedSalary` - **✅ Correct field** - Contains NPR/USD conversions

### Correct Usage Pattern

#### ❌ Incorrect (Deprecated)
```dart
// Don't use job-level convertedSalary
final salary = job.convertedSalary; // Will be null or 'Not available'
```

#### ✅ Correct
```dart
// Use position-level convertedSalary
final firstPosition = job.positions.first;
final convertedSalary = firstPosition.convertedSalary; // "NPR 90000"
```

### Updated Components

1. **`salary_section.dart`** - Now displays ALL positions with individual salaries, not just the first one
   - Shows salary range at job level (if available)
   - Individual cards for each position with base salary, converted salary, and requirements
   - Properly handles multiple positions with different compensation
2. **`ramesh_happy_path_test.dart`** - Test now loops through positions and displays each converted salary
3. **`mobile_job_model.dart`** - Documented that job-level convertedSalary is typically null

## Why Position-Level?

Jobs can have **multiple positions** with different salaries:
- Position 1: "Electrician" - AED 2500 → NPR 90000
- Position 2: "Senior Electrician" - AED 3500 → NPR 126000

There's no single "job salary" - each position has its own base and converted salary.

## Migration Guide

If you're using `job.convertedSalary` anywhere in the codebase:

### ❌ Old Approach (Showing only first position)
```dart
Text(job.convertedSalary ?? 'Not available')
```

### ⚠️ Quick Fix (Shows only first position - not recommended)
```dart
Text(
  job.positions.isNotEmpty && 
  job.positions.first.convertedSalary != null
    ? job.positions.first.convertedSalary!
    : 'Not available'
)
```

### ✅ Recommended Approach (Show all positions)
```dart
Column(
  children: job.positions.map((position) {
    return Card(
      child: Column(
        children: [
          Text(position.title),
          if (position.baseSalary != null)
            Text('Base: ${position.baseSalary}'),
          if (position.convertedSalary != null)
            Text('Converted: ${position.convertedSalary}'),
        ],
      ),
    );
  }).toList(),
)
```

See `salary_section.dart` for a complete implementation example.

## Test Coverage

The integration test now properly verifies:
- ✅ Position-level base salary
- ✅ Position-level converted salary (NPR/USD)
- ✅ Currency information per position
- ✅ Multiple positions with different salaries

## Notes

- The `matchPercentage` field at job level is correct and remains unchanged
- All currency conversions happen at the position level
- Frontend should iterate through `positions[]` array to display all available roles
