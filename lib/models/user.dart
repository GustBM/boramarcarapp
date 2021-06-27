class AppUser {
  final String firstName;
  final String lastName;
  final String email;
  final String bthDate;
  final List<String> events;

  AppUser({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.bthDate,
    this.events = const [],
  });
}
