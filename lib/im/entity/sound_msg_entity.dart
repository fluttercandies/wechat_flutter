class SoundMsgEntity {
	int? downloadFlag;
	int? duration;
	String? path;
	List<String>? urls;
	int? businessId;
	int? dataSize;
	String? type;
	String? uuid;
	int? taskId;

	SoundMsgEntity({
		this.downloadFlag,
		this.duration,
		this.path,
		this.urls,
		this.businessId,
		this.dataSize,
		this.type,
		this.uuid,
		this.taskId,
	});

	SoundMsgEntity.fromJson(Map<String, dynamic> json) {
		downloadFlag = json['downloadFlag'];
		duration = json['duration'];
		path = json['path'];
		urls = json['urls']?.cast<String>();
		businessId = json['businessId'];
		dataSize = json['dataSize'];
		type = json['type'];
		uuid = json['uuid'];
		taskId = json['taskId'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = <String, dynamic>{};
		data['downloadFlag'] = downloadFlag;
		data['duration'] = duration;
		data['path'] = path;
		data['urls'] = urls;
		data['businessId'] = businessId;
		data['dataSize'] = dataSize;
		data['type'] = type;
		data['uuid'] = uuid;
		data['taskId'] = taskId;
		return data;
	}
}