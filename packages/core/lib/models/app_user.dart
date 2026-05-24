enum UserRole { customer, vendor, driver, admin }

UserRole _roleFrom(String? s) {
  switch (s) {
    case 'vendor': return UserRole.vendor;
    case 'driver': return UserRole.driver;
    case 'admin':  return UserRole.admin;
    default:       return UserRole.customer;
  }
}

class AppUser {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final String? phone;
  final UserRole role;
  final DateTime createdAt;

  const AppUser({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.phone,
    this.role = UserRole.customer,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        'email': email,
        'displayName': displayName,
        'photoUrl': photoUrl,
        'phone': phone,
        'role': role.name,
        'createdAt': createdAt.toIso8601String(),
      };

  factory AppUser.fromMap(String uid, Map<String, dynamic> m) => AppUser(
        uid: uid,
        email: m['email'] ?? '',
        displayName: m['displayName'],
        photoUrl: m['photoUrl'],
        phone: m['phone'],
        role: _roleFrom(m['role']),
        createdAt: DateTime.tryParse(m['createdAt'] ?? '') ?? DateTime.now(),
      );
}
