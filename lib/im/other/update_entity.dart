class UpdateEntity {
	String updateInfo;
	String appVersion;
	String appName;
	String appId;
	String downloadUrl;

	UpdateEntity({this.updateInfo, this.appVersion, this.appName, this.appId, this.downloadUrl});

	UpdateEntity.fromJson(Map<String, dynamic> json) {
		updateInfo = json['updateInfo'];
		appVersion = json['appVersion'];
		appName = json['appName'];
		appId = json['appId'];
		downloadUrl = json['downloadUrl'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['updateInfo'] = this.updateInfo;
		data['appVersion'] = this.appVersion;
		data['appName'] = this.appName;
		data['appId'] = this.appId;
		data['downloadUrl'] = this.downloadUrl;
		return data;
	}
}
