/// Pure domain entity representing price bounds for search filtering.
class PriceBounds {
  final double min;
  final double max;

  const PriceBounds({required this.min, required this.max});

  /// Map-like operator index access for backward compatibility with existing tests and widgets.
  double? operator [](String key) {
    if (key == 'min') return min;
    if (key == 'max') return max;
    return null;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PriceBounds &&
          runtimeType == other.runtimeType &&
          min == other.min &&
          max == other.max;

  @override
  int get hashCode => Object.hash(min, max);

  @override
  String toString() => 'PriceBounds(min: $min, max: $max)';
}
