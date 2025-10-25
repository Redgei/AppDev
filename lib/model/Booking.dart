class Booking {
  final String id;
  final String user;
  final String details;
  final String pickupLocation;
  final String dropoffLocation;
  final String bookingTime;
  final double fare;
  final String status;

  Booking({
    required this.id,
    required this.user,
    required this.details,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.bookingTime,
    required this.fare,
    required this.status,
  });
}