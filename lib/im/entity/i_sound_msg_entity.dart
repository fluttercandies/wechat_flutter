class ISoundMsgEntity {
	int? downloadFlag;
	String? path;
	int? businessId;
	int? dataSize;
	List<String>? soundUrls;
	String? uuid;
	int? taskId;
	int? second;

	ISoundMsgEntity({
		this.downloadFlag,
		this.path,
		this.businessId,
		this.dataSize,
		this.soundUrls,
		this.uuid,
		this.taskId,
		this.second,
	});

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
		final Map<String, dynamic> data = <String, dynamic>{};
		data['downloadFlag'] = downloadFlag;
		data['path'] = path;
		data['businessId'] = businessId;
		data['dataSize'] = dataSize;
		data['soundUrls'] = soundUrls;
		data['uuid'] = uuid;
		data['taskId'] = taskId;
		data['second'] = second;
		return data;
	}
}