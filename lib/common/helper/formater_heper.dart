String formatToCurrency(double amount) {
  return 'Rs.${amount.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+\.)'), (match) => '${match[1]},')}';
}

// Format amount as currency
  String formatCurrency(String rawAmount) {
    if (rawAmount.isEmpty) return '0.00';
    
    // Remove any non-digit characters except decimal point
    String cleaned = rawAmount.replaceAll(RegExp(r'[^\d.]'), '');
    
    // Handle decimal point logic
    if (cleaned.isEmpty) return '0.00';
    
    // If there's a decimal point, format accordingly
    if (cleaned.contains('.')) {
      List<String> parts = cleaned.split('.');
      String integerPart = parts[0].isEmpty ? '0' : parts[0];
      String decimalPart = parts.length > 1 ? parts[1] : '';
      
      // Limit decimal places to 2
      if (decimalPart.length > 2) {
        decimalPart = decimalPart.substring(0, 2);
      }
      
      // Add thousands separators to integer part
      if (integerPart.length > 3) {
        String reversed = integerPart.split('').reversed.join('');
        String formatted = '';
        for (int i = 0; i < reversed.length; i++) {
          if (i > 0 && i % 3 == 0) {
            formatted += ',';
          }
          formatted += reversed[i];
        }
        integerPart = formatted.split('').reversed.join('');
      }
      
      return decimalPart.isEmpty ? '$integerPart.00' : '$integerPart.$decimalPart';
    } else {
      // No decimal point, treat as cents if less than 3 digits, otherwise as dollars
      if (cleaned.length <= 2) {
        double value = double.tryParse(cleaned) ?? 0;
        return (value / 100).toStringAsFixed(2);
      } else {
        // Add thousands separators
        String reversed = cleaned.split('').reversed.join('');
        String formatted = '';
        for (int i = 0; i < reversed.length; i++) {
          if (i > 0 && i % 3 == 0) {
            formatted += ',';
          }
          formatted += reversed[i];
        }
        return '${formatted.split('').reversed.join('')}.00';
      }
    }
  }