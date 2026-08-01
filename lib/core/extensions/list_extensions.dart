/// Shared extensions for common list operations.
extension ListExtensions<T> on List<T> {
  /// Returns the first element, or a default value if the list is empty.
  T get firstOrNull => isEmpty ? null as T : first;

  /// Returns the first element, or a fallback value if the list is empty.
  T firstOrElse(T fallback) => isEmpty ? fallback : first;
}

extension StringListExtensions on List<String> {
  /// Returns the first element, or empty string if the list is empty.
  String get firstOrEmpty => isEmpty ? '' : first;
}
