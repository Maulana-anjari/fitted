enum ClothingCategory {
  top('Top'),
  bottom('Bottom'),
  outerwear('Outerwear'),
  footwear('Footwear'),
  accessory('Accessory'),
  dress('Dress'),
  bag('Bag');

  final String label;
  const ClothingCategory(this.label);

  static ClothingCategory fromString(String value) {
    return ClothingCategory.values.firstWhere(
      (c) => c.name.toLowerCase() == value.toLowerCase(),
      orElse: () => ClothingCategory.top,
    );
  }
}
