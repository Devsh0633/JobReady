enum IndustryCategory {
  it,
  core,
  sales,
  bpo,
}

extension IndustryCategoryExtension on IndustryCategory {
  String get label {
    switch (this) {
      case IndustryCategory.it:
        return 'IT & Software';
      case IndustryCategory.core:
        return 'Core Engineering';
      case IndustryCategory.sales:
        return 'Sales & Marketing';
      case IndustryCategory.bpo:
        return 'BPO & Support';
    }
  }
}
