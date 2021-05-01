abstract class Location<T> {
  T data;
  Map<String, String> params;

  Location({required this.data, required this.params});

  abstract String uniqueKey;
}

abstract class BasicLocation extends Location<dynamic> {
  BasicLocation() : super(data: Object(), params: Map<String, String>());
}
