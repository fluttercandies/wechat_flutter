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
		updateInfo = json['updateInfo'];
		appVersion = json['appVersion'];
		appName = json['appName'];
		appId = json['appId'];
		downloadUrl = json['downloadUrl'];
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