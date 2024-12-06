class UpdateEntity {
  String? updateInfo;
  String? appVersion;
  String? appName;
  String? appId;
  String? downloadUrl;

  UpdateEntity({
    this.updateInfo,
    this.appVersion,
    this.appName,
    this.appId,
    this.downloadUrl,
  });

  UpdateEntity.fromJson(Map<String, dynamic> json) {
    updateInfo = json['updateInfo'] as String?;
    appVersion = json['appVersion'] as String?;
    appName = json['appName'] as String?;
    appId = json['appId'] as String?;
    downloadUrl = json['downloadUrl'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['updateInfo'] = updateInfo;
    data['appVersion'] = appVersion;
    data['appName'] = appName;
    data['appId'] = appId;
    data['downloadUrl'] = downloadUrl;
    return data;
  }
}
