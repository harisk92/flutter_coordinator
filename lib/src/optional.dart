class Optional<T> {
  T? data;

  Optional({this.data});

  T defaultOr(T value) => data ?? value;
}
