class BoothPackage {
  final String imagePath;
  final String name;
  final double price;
  final String details;
  final List<String> additionalItems;

  BoothPackage({
    required this.imagePath,
    required this.name,
    required this.price,
    required this.details,
    required this.additionalItems,
  });
}

final List<BoothPackage> boothPackages = [
  BoothPackage(
    imagePath: 'assets/basic-booth.png',
    name: 'Basic Booth',
    price: 150.0,
    details: 'Includes one table, two chairs, and a banner stand.',
    additionalItems: ['Extra Chair', 'Power Socket', 'Wi-Fi Access'],
  ),
  BoothPackage(
    imagePath: 'assets/premium-booth.png',
    name: 'Premium Booth',
    price: 300.0,
    details:
        'Includes everything in Basic Booth, plus two tables, four chairs, lighting, and large signage.',
    additionalItems: [
      'Extra Chair',
      'Power Socket',
      'Wi-Fi Access',
      'TV Display',
      'Storage Box',
      'Carpet Flooring',
    ],
  ),
  BoothPackage(
    imagePath: 'assets/deluxe-booth.png',
    name: 'Deluxe Booth',
    price: 700.0,
    details:
        'Includes everything in Premium Booth, plus full setup with furniture, branding, and spotlighting.',
    additionalItems: [
      'Extra Chair',
      'Power Socket',
      'Wi-Fi Access',
      'TV Display',
      'Storage Box',
      'Carpet Flooring',
      'Projector',
      'High-Speed Internet',
      'Custom Lighting Design',
      'On-site Technical Support',
    ],
  ),
];
