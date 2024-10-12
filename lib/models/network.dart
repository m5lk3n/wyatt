class GeocodeAddress {
  // format: see https://developers.google.com/maps/documentation/geocoding/start
  // we're only interested in the status
  final String status;

  const GeocodeAddress({
    required this.status,
  });

  factory GeocodeAddress.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'status': String status,
      } =>
        GeocodeAddress(
          status: status,
        ),
      _ => throw const FormatException('Failed to load geocoded address.'),
    };
  }
}
