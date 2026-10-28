/// Pure domain entity representing a selectable home category shortcut.
/// 100% Pure Dart with zero dependencies on Flutter UI, Dio, or 3rd-party SDKs.
class SelectionEntity {
  final String id;
  final String label;
  final String? iconKey;

  const SelectionEntity({
    required this.id,
    required this.label,
    this.iconKey,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SelectionEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          label == other.label &&
          iconKey == other.iconKey;

  @override
  int get hashCode => Object.hash(id, label, iconKey);
}
