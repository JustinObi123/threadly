class Address {
  final String id;
  final String label;       // "Home", "Work"
  final String fullName;
  final String phone;
  final String line1;
  final String? line2;
  final String city;
  final String state;
  final String zip;
  final String country;
  final double? lat;
  final double? lng;
  final bool isDefault;

  const Address({
    required this.id,
    required this.label,
    required this.fullName,
    required this.phone,
    required this.line1,
    this.line2,
    required this.city,
    required this.state,
    required this.zip,
    required this.country,
    this.lat,
    this.lng,
    this.isDefault = false,
  });

  Map<String, dynamic> toMap() => {
        'label': label,
        'fullName': fullName,
        'phone': phone,
        'line1': line1,
        'line2': line2,
        'city': city,
        'state': state,
        'zip': zip,
        'country': country,
        'lat': lat,
        'lng': lng,
        'isDefault': isDefault,
      };

  factory Address.fromMap(String id, Map<String, dynamic> m) => Address(
        id: id,
        label: m['label'] ?? '',
        fullName: m['fullName'] ?? '',
        phone: m['phone'] ?? '',
        line1: m['line1'] ?? '',
        line2: m['line2'],
        city: m['city'] ?? '',
        state: m['state'] ?? '',
        zip: m['zip'] ?? '',
        country: m['country'] ?? '',
        lat: (m['lat'] as num?)?.toDouble(),
        lng: (m['lng'] as num?)?.toDouble(),
        isDefault: m['isDefault'] ?? false,
      );
}
