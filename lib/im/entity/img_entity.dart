class ImgEntity {
	int size;
	int width;
	String type;
	String uuid;
	String url;
	int height;

	ImgEntity({this.size, this.width, this.type, this.uuid, this.url, this.height});

	ImgEntity.fromJson(Map<String, dynamic> json) {
		size = json['size'];
		width = json['width'];
		type = json['type'];
		uuid = json['uuid'];
		url = json['url'];
		height = json['height'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['size'] = this.size;
		data['width'] = this.width;
		data['type'] = this.type;
		data['uuid'] = this.uuid;
		data['url'] = this.url;
		data['height'] = this.height;
		return data;
	}
}
