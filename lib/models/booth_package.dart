class BoothPackage {
  final String imagePath;
  final String name;
  final double price;
  final String size;
  final String details;
  final List<String> additionalItems;

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
    details:
        'Come with one table and two chairs. Ideal for individual sellers or startups.',
    additionalItems: [
      'Extra Chair',
      'Extra Table',
      'Lounge Seating',
      'Carpet',
      'Brochure Stand',
    ],
  ),
  BoothPackage(
    imagePath: 'assets/standard_booth.png',
    name: 'Standard Booth',
    size: '4m x 4m',
    price: 600.0,
    details:
        'Come with two tables and four chairs. Suitable for growing businesses with larger group.',
    additionalItems: [
      'Extra Chair',
      'Extra Table',
      'Lounge Seating',
      'Carpet',
      'Brochure Stand',
    ],
  ),
  BoothPackage(
    imagePath: 'assets/extended_booth.png',
    name: 'Extended Booth',
    price: 900.0,
    size: '6m x 6m',
    details:
        'Come with 3 tables and eight chairs. Perfect for established businesses looking to maximize brand exposure.',
    additionalItems: [
      'Extra Chair',
      'Extra Table',
      'Lounge Seating',
      'Carpet',
      'Brochure Stand',
    ],
  ),
];
