class Passenger {
  final int? id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String? gender;
  final String? status;

  const Passenger({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    this.gender,
    this.status,
  });

  factory Passenger.fromJson(Map<String, dynamic> json) {
    return Passenger(
      id: json['id'] as int?,
      firstName: (json['first_name'] ?? json['firstName'] ?? '').toString(),
      lastName: (json['last_name'] ?? json['lastName'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      phone: (json['phone'] ?? '').toString(),
      gender: json['gender']?.toString(),
      status: json['status']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'gender': gender,
      'status': status,
    };
  }
}
