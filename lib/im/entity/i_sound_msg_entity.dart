class ISoundMsgEntity {
	int downloadFlag;
	String path;
	int businessId;
	int dataSize;
	List<String> soundUrls;
	String uuid;
	int taskId;
	int second;

	ISoundMsgEntity({this.downloadFlag, this.path, this.businessId, this.dataSize, this.soundUrls, this.uuid, this.taskId, this.second});

	ISoundMsgEntity.fromJson(Map<String, dynamic> json) {
		downloadFlag = json['downloadFlag'];
		path = json['path'];
		businessId = json['businessId'];
		dataSize = json['dataSize'];
		soundUrls = json['soundUrls']?.cast<String>();
		uuid = json['uuid'];
		taskId = json['taskId'];
		second = json['second'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['downloadFlag'] = this.downloadFlag;
		data['path'] = this.path;
		data['businessId'] = this.businessId;
		data['dataSize'] = this.dataSize;
		data['soundUrls'] = this.soundUrls;
		data['uuid'] = this.uuid;
		data['taskId'] = this.taskId;
		data['second'] = this.second;
		return data;
	}
}
