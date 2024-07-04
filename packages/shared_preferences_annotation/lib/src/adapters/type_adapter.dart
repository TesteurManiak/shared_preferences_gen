abstract class TypeAdapter<T, S> {
  const TypeAdapter();

  T fromSharedPrefs(S value);
  S toSharedPrefs(T value);
}
