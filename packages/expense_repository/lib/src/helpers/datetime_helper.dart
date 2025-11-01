import 'package:expenses_repository/src/models/billing_period.dart';

class DatetimeHelper {
  static const billingStartDay = 25;
  static const billingEndDay = 24;

  static BillingPeriod getCurrentBillingPeriod() {
    final now = DateTime.now();
    final currentDay = now.day;
    
    // If current day is before 25th, billing period is from previous month's 25th to current month's 24th
    // If current day is 25th or after, billing period is from current month's 25th to next month's 24th
    if (currentDay < billingStartDay) {
      return BillingPeriod(
        DateTime(now.year, now.month - 1, billingStartDay), // Start: 25th of previous month
        DateTime(now.year, now.month, billingEndDay),   // End: 24th of current month
      );
    } else {
      return BillingPeriod(
        DateTime(now.year, now.month, billingStartDay),      // Start: 25th of current month
        DateTime(now.year, now.month + 1, billingEndDay),  // End: 24th of next month
      );
    }
  }

  static BillingPeriod getBillingPeriodForMonth(int month, int year) {
    return BillingPeriod(
      DateTime(year, month - 1, billingStartDay),
      DateTime(year, month, billingEndDay),
    );
  }

  static int getBillingMonth(DateTime date) {
    // If the day is before the 25th, the billing month is the current month
    if (date.day < billingStartDay) {
      return date.month;
    } else {
      return date.month + 1 == 13 ? 1 : date.month + 1;
    }
  }

  static int getBillingYear(DateTime date) {
    // If the day is before the 25th, the billing year is the current year
    if (date.day < billingStartDay) {
      return date.year;
    } else {
      // If month is December, increment year
      return date.month + 1 == 13 ? date.year + 1 : date.year;
    }
    
  }

  static int getCurrentBillingMonth() {
    // If the day is before the 25th, the billing month is the current month
    final now = DateTime.now();
    if (now.day < billingStartDay) {
      return now.month;
    } else {
      return now.month + 1 == 13 ? 1 : now.month + 1;
    }
  }

  static int getCurrentBillingYear() {
    // If the day is before the 25th, the billing year is the current year
    final now = DateTime.now();
    if (now.day < billingStartDay) {
      return now.year;
    } else {
      // If month is December, increment year
      return now.month + 1 == 13 ? now.year + 1 : now.year;
    }
  }

  static bool isMonthInCurrentBillingPeriod(int year, int month) {
    final currentBillingMonth = DatetimeHelper.getCurrentBillingMonth();
    final currentBillingYear = DatetimeHelper.getCurrentBillingYear();
    return year == currentBillingYear && month == currentBillingMonth;
  }

  static bool isMonthOlderThanCurrentBillingPeriod(int? year, int? month) {
    final currentBillingMonth = DatetimeHelper.getCurrentBillingMonth();
    final currentBillingYear = DatetimeHelper.getCurrentBillingYear();

    if (year == null || month == null) {
      return false;
    }

    if (year < currentBillingYear) {
      return true;
    } else if (year == currentBillingYear) {
      return month < currentBillingMonth;
    } else {
      return false;
    }
  }

}