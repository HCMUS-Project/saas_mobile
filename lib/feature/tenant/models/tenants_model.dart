class TenantModel {
  TenantProfile? tenantProfile;

  TenantModel({this.tenantProfile});

  TenantModel.fromJson(Map<String, dynamic> json) {
    tenantProfile = json['tenantProfile'] != null
        ? new TenantProfile.fromJson(json['tenantProfile'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.tenantProfile != null) {
      data['tenantProfile'] = this.tenantProfile!.toJson();
    }
    return data;
  }
}

class TenantProfile {
  String? id;
  String? tenantId;
  String? email;
  String? serviceName;
  String? address;
  String? phoneNumber;
  String? logo;
  String? description;
  String? facebookUrl;
  String? instagramUrl;
  String? youtubeUrl;
  String? createdAt;
  String? updatedAt;

  TenantProfile(
      {this.id,
      this.tenantId,
      this.email,
      this.serviceName,
      this.address,
      this.phoneNumber,
      this.logo,
      this.description,
      this.facebookUrl,
      this.instagramUrl,
      this.youtubeUrl,
      this.createdAt,
      this.updatedAt});

  TenantProfile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tenantId = json['tenantId'];
    email = json['email'];
    serviceName = json['serviceName'];
    address = json['address'];
    phoneNumber = json['phoneNumber'];
    logo = json['logo'];
    description = json['description'];
    facebookUrl = json['facebookUrl'];
    instagramUrl = json['instagramUrl'];
    youtubeUrl = json['youtubeUrl'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tenantId'] = this.tenantId;
    data['email'] = this.email;
    data['serviceName'] = this.serviceName;
    data['address'] = this.address;
    data['phoneNumber'] = this.phoneNumber;
    data['logo'] = this.logo;
    data['description'] = this.description;
    data['facebookUrl'] = this.facebookUrl;
    data['instagramUrl'] = this.instagramUrl;
    data['youtubeUrl'] = this.youtubeUrl;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}