abstract class Location<T> {
  T data;
  Map<String, String> params;

  Location(this.data, this.params);

  String? uniqueKey;
}
