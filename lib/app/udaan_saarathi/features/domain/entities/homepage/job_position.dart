class JobPosition {
  final String id;
  final String title;
  final String? baseSalary;
  final String? convertedSalary;
  final String? currency;
  final List<String> requirements;

  JobPosition({
    required this.id,
    required this.title,
    this.baseSalary,
    this.convertedSalary,
    this.currency,
    this.requirements = const [],
  });
}