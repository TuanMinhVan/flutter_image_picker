class PickerData {
  PickerData.fromJson(dynamic json) {
    id = json["id"];
    name = json["name"];
    path = json["path"];
    mimeType = json["mimeType"];
    time = json["time"];
    width = json["width"];
    height = json["height"];
  }
  String id;
  String name;
  String path;
  String mimeType;
  int time;
  int width;
  int height;


  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "path": path,
      "mimeType": mimeType,
      "time": time,
      "width": width,
      "height": height,
    };
  }

  bool get isImage => mimeType.contains("image");

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    if (other is PickerData && runtimeType == other.runtimeType) {
      return id == other.id;
    } else {
      return false;
    }
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode {
    return id.hashCode;
  }
}
