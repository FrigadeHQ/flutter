class PaginatedResult<T> {
  final List<T> data;
  final int limit;
  final int offset;

  PaginatedResult({
    required this.data,
    required this.limit,
    required this.offset,
  });

  factory PaginatedResult.fromJson(Map<String, dynamic> json) {
    return PaginatedResult(
      data: json['data'],
      limit: json['limit'],
      offset: json['offset'],
    );
  }
}
