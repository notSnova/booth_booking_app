class BoothPackage {
  final String imagePath;
  final String name;
  final double price;
  final String size;
  final String details;
  final Map<String, double> additionalItems;

  BoothPackage({
    required this.imagePath,
    required this.name,
    required this.price,
    required this.size,
    required this.details,
    required this.additionalItems,
  });
}

final List<BoothPackage> boothPackages = [
  BoothPackage(
    imagePath: 'assets/compact_booth.png',
    name: 'Compact Booth',
    price: 300.0,
    size: '2m x 2m',
    details: 'Budget friendly booth, ideal for individual sellers or startups.',
    additionalItems: {
      'Extra Chair': 15.0,
      'Extra Table': 25.0,
      'Lounge Seating': 40.0,
      'Carpet': 20.0,
      'Brochure Stand': 10.0,
    },
  ),
  BoothPackage(
    imagePath: 'assets/standard_booth.png',
    name: 'Standard Booth',
    size: '4m x 4m',
    price: 600.0,
    details: 'A well balanced option for growing businesses with larger group.',
    additionalItems: {
      'Extra Chair': 15.0,
      'Extra Table': 25.0,
      'Lounge Seating': 40.0,
      'Carpet': 20.0,
      'Brochure Stand': 10.0,
    },
  ),
  BoothPackage(
    imagePath: 'assets/extended_booth.png',
    name: 'Extended Booth',
    price: 900.0,
    size: '6m x 6m',
    details:
        'Perfect option for established businesses to maximize brand exposure.',
    additionalItems: {
      'Extra Chair': 15.0,
      'Extra Table': 25.0,
      'Lounge Seating': 40.0,
      'Carpet': 20.0,
      'Brochure Stand': 10.0,
    },
  ),
];
