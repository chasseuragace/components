class GetAllApplicationsParams {
  final int page;
  final String? status;

  const GetAllApplicationsParams({
    this.page = 1,
    this.status,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GetAllApplicationsParams &&
        other.page == page &&
        other.status == status;
  }

  @override
  int get hashCode => page.hashCode ^ status.hashCode;
}
