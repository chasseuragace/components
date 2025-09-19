class CoordinatesEntity {
  final double? lat;
  final double? lng;
  const CoordinatesEntity({this.lat, this.lng});

  factory CoordinatesEntity.fromJson(Map<String, dynamic> json) {
    return CoordinatesEntity(
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        if (lat != null) 'lat': lat,
        if (lng != null) 'lng': lng,
      };
}

class AddressEntity {
  final String? name;
  final CoordinatesEntity? coordinates;
  final String? province;
  final String? district;
  final String? municipality;
  final String? ward;

  const AddressEntity({
    this.name,
    this.coordinates,
    this.province,
    this.district,
    this.municipality,
    this.ward,
  });

  factory AddressEntity.fromJson(Map<String, dynamic> json) {
    return AddressEntity(
      name: json['name'] as String?,
      coordinates: json['coordinates'] is Map<String, dynamic>
          ? CoordinatesEntity.fromJson(json['coordinates'] as Map<String, dynamic>)
          : null,
      province: json['province'] as String?,
      district: json['district'] as String?,
      municipality: json['municipality'] as String?,
      ward: json['ward'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        if (name != null) 'name': name,
        if (coordinates != null) 'coordinates': coordinates!.toJson(),
        if (province != null) 'province': province,
        if (district != null) 'district': district,
        if (municipality != null) 'municipality': municipality,
        if (ward != null) 'ward': ward,
      };
}
