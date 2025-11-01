import 'package:flutter_riverpod/flutter_riverpod.dart';

final docsProvider = StateProvider(
  (_) => '''
1.1 Job Seeker Mobile Application (Flutter)
- OTP-based registration and authentication system
- User profile creation and management (personal details, skills, experience)
- Document upload functionality (CV, passport, certificates)
- Job search with filters (country, salary, job type, experience level)
- Job vacancy browsing and detailed view
- Application submission system
- Application status tracking dashboard (Applied → Shortlisted → Interview → Selected/Rejected)
- Real-time push notifications for application updates
- Click-to-call functionality for agency contacts
- Multi-language support (English and Nepali)

- Observations | Open discussions 
in preference selction when adding preference the list expands , which causes the ui to jump a little 
- show compact list 
- tap edit to show teh reorderable list in a bottom sheet ?
'''
);
