class ManpowerAgency {
  final int id;
  final String name;
  final String location;
  final String description;
  final bool verified;
  final List<TrustFactor> trustFactors;
  final List<String> specializations;
  final int activeJobs;
  final int successRate;
  final String? phone;
  final String? email;
  final int? views;

  ManpowerAgency({
    required this.id,
    required this.name,
    required this.location,
    required this.description,
    required this.verified,
    required this.trustFactors,
    required this.specializations,
    required this.activeJobs,
    required this.successRate,
    this.phone,
    this.email,
    this.views,
  });

  String getInitials() {
    return name
        .split(' ')
        .map((word) => word[0])
        .take(2)
        .join('')
        .toUpperCase();
  }
}

class TrustFactor {
  final TrustFactorType type;
  final String value;
  final String displayText;

  TrustFactor({
    required this.type,
    required this.value,
    required this.displayText,
  });
}

enum TrustFactorType { established, employees, rating, verified }

// Sample Data
final List<ManpowerAgency> sampleAgencies = [
  ManpowerAgency(
    id: 1,
    name: 'Global Talent Solutions',
    location: 'Kathmandu, Nepal',
    description:
        'Leading manpower agency specializing in international placements with 15+ years of experience in skilled worker recruitment.',
    verified: true,
    trustFactors: [
      TrustFactor(
        type: TrustFactorType.established,
        value: '2008',
        displayText: 'Est. 2008',
      ),
      TrustFactor(
        type: TrustFactorType.employees,
        value: '2500',
        displayText: '2500+ placed',
      ),
      TrustFactor(
        type: TrustFactorType.rating,
        value: '4.8',
        displayText: '4.8/5',
      ),
    ],
    specializations: [
      'IT & Software',
      'Healthcare',
      'Engineering',
      'Hospitality',
      'Construction',
    ],
    activeJobs: 45,
    successRate: 94,
  ),
  ManpowerAgency(
    id: 2,
    name: 'Nepal Workforce International',
    location: 'Pokhara, Nepal',
    description:
        'Trusted recruitment partner for overseas employment opportunities with comprehensive training programs.',
    verified: true,
    trustFactors: [
      TrustFactor(
        type: TrustFactorType.established,
        value: '1995',
        displayText: 'Est. 1995',
      ),
      TrustFactor(
        type: TrustFactorType.employees,
        value: '1800',
        displayText: '1800+ placed',
      ),
      TrustFactor(
        type: TrustFactorType.verified,
        value: 'true',
        displayText: 'Verified',
      ),
    ],
    specializations: ['Manufacturing', 'Agriculture', 'Retail', 'Security'],
    activeJobs: 32,
    successRate: 89,
  ),
  ManpowerAgency(
    id: 3,
    name: 'Himalayan Staffing Co.',
    location: 'Lalitpur, Nepal',
    description:
        'Premium staffing solutions focusing on executive and specialized roles across various industries.',
    verified: false,
    trustFactors: [
      TrustFactor(
        type: TrustFactorType.established,
        value: '2012',
        displayText: 'Est. 2012',
      ),
      TrustFactor(
        type: TrustFactorType.employees,
        value: '950',
        displayText: '950+ placed',
      ),
      TrustFactor(
        type: TrustFactorType.rating,
        value: '4.6',
        displayText: '4.6/5',
      ),
    ],
    specializations: ['Finance', 'Marketing', 'HR', 'Legal'],
    activeJobs: 28,
    successRate: 91,
  ),
  ManpowerAgency(
    id: 4,
    name: 'Everest Employment Services',
    location: 'Biratnagar, Nepal',
    description:
        'Comprehensive manpower solutions with focus on skill development and career guidance for job seekers.',
    verified: true,
    trustFactors: [
      TrustFactor(
        type: TrustFactorType.established,
        value: '2000',
        displayText: 'Est. 2000',
      ),
      TrustFactor(
        type: TrustFactorType.employees,
        value: '3200',
        displayText: '3200+ placed',
      ),
      TrustFactor(
        type: TrustFactorType.rating,
        value: '4.7',
        displayText: '4.7/5',
      ),
      TrustFactor(
        type: TrustFactorType.verified,
        value: 'true',
        displayText: 'Verified',
      ),
    ],
    specializations: [
      'Healthcare',
      'Education',
      'Logistics',
      'Customer Service',
    ],
    activeJobs: 67,
    successRate: 96,
  ),
  ManpowerAgency(
    id: 5,
    name: 'Metro Recruiting Solutions',
    location: 'Bhaktapur, Nepal',
    description:
        'Modern recruitment agency leveraging technology for efficient talent acquisition and placement services.',
    verified: true,
    trustFactors: [
      TrustFactor(
        type: TrustFactorType.established,
        value: '2015',
        displayText: 'Est. 2015',
      ),
      TrustFactor(
        type: TrustFactorType.employees,
        value: '750',
        displayText: '750+ placed',
      ),
      TrustFactor(
        type: TrustFactorType.rating,
        value: '4.5',
        displayText: '4.5/5',
      ),
    ],
    specializations: ['Technology', 'Digital Marketing', 'Design', 'Sales'],
    activeJobs: 23,
    successRate: 87,
  ),
];
