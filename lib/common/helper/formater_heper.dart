String formatToCurrency(double amount) {
  return 'Rs.${amount.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+\.)'), (match) => '${match[1]},')}';
}