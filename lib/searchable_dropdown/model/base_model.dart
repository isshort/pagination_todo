abstract class BaseModel<T> {
  T fromJson(Map<String, dynamic> json);
  Map<String, dynamic>? toJson();

  const BaseModel();
}

T? modelDecode<T>(dynamic json, BaseModel model) {
  return json != null ? model.fromJson(json) as T : null;
}

List<T>? modelListDecode<T>(dynamic json, BaseModel model) {
  if (json != null) {
    return json.map((e) => model.fromJson(e)).toList().cast<T>();
  }
  return null;
}
