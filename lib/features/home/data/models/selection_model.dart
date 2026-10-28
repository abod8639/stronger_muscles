/// Data model representing a selectable category shortcut.
/// Decoupled from domain Entity and implements resilient, safe JSON parsing.
class SelectionsModel {
  final String id;
  final String label;
  final String? iconKey;

  const SelectionsModel({
    required this.id,
    required this.label,
    this.iconKey,
  });

  /// Robust, fault-tolerant JSON parser with null safety and type fallback.
  factory SelectionsModel.fromJson(dynamic json) {
    if (json is! Map) {
      return const SelectionsModel(
        id: '',
        label: '',
        iconKey: 'home',
      );
    }

    final safeId = json['id']?.toString() ??
        json['_id']?.toString() ??
        json['slug']?.toString() ??
        '';

    // Label can be a direct String, or a localized map ({'ar': ..., 'en': ...})
    String safeLabel = '';
    final rawLabel = json['label'] ?? json['name'] ?? json['title'];
    if (rawLabel is Map) {
      safeLabel = rawLabel['ar']?.toString() ??
          rawLabel['en']?.toString() ??
          rawLabel.values.firstOrNull?.toString() ??
          '';
    } else if (rawLabel != null) {
      safeLabel = rawLabel.toString();
    }

    final safeIconKey = json['icon']?.toString() ?? json['iconKey']?.toString() ?? safeId;

    return SelectionsModel(
      id: safeId,
      label: safeLabel,
      iconKey: safeIconKey,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'iconKey': iconKey,
      };

  /// Safely converts a dynamic response into a typed List of [SelectionsModel].
  static List<SelectionsModel> fromJsonList(dynamic data) {
    if (data == null) return const [];

    List<dynamic> rawList = const [];
    if (data is List) {
      rawList = data;
    } else if (data is Map) {
      final nested = data['data'] ?? data['items'] ?? data['categories'];
      if (nested is List) {
        rawList = nested;
      }
    }

    final results = <SelectionsModel>[];
    for (final item in rawList) {
      if (item is Map) {
        try {
          results.add(SelectionsModel.fromJson(item));
        } catch (_) {
          // Skip corrupt records defensively
        }
      }
    }
    return results;
  }
}
