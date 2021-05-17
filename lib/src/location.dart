import 'dart:async';

abstract class Location<T> {
  T data;
  Map<String, String> params;
  Completer result;

  Location({required this.data, required this.params})
      : this.result = Completer<dynamic>.sync();

  abstract String uniqueKey;
}

abstract class BasicLocation extends Location<dynamic> {
  BasicLocation() : super(data: Object(), params: Map<String, String>());
}

class Result {
  dynamic? data;

  Result({this.data});
}
