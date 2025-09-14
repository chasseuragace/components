class Option {
  final String label;
  final String value;
  const Option({required this.label, required this.value});

  @override
  String toString() => 'Option(label: $label, value: $value)';

  // to json 
  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'value': value,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Option && other.value == value && other.label == label;
  }

  @override
  int get hashCode => Object.hash(label, value);
}
