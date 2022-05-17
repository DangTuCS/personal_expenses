import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expenses/models/transaction.dart';
import 'package:personal_expenses/widgets/chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;


  const Chart({required this.recentTransactions,});

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(
      7,
      (index) {
        final weekDay = DateTime.now().subtract(
          Duration(days: index),
        );
        double totalSum = 0;
        for (int i = 0; i < recentTransactions.length; i++) {
          if (recentTransactions[i].date.day == weekDay.day &&
              recentTransactions[i].date.month == weekDay.month &&
              recentTransactions[i].date.year == weekDay.year) {
            totalSum += recentTransactions[i].amount;
          }
        }
        return {
          'day': DateFormat.E().format(weekDay).substring(0, 1),
          'amount': totalSum,
        };
      },
    );
  }

  double get totalSpending {
    return groupedTransactionValues.fold(
      0.0,
      (sum, element) => sum + (element['amount'] as double),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 6,
        margin: const EdgeInsets.all(20),
        child:
        Padding(
          padding: const EdgeInsets.all(10),
          child:
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: groupedTransactionValues.map((element) {
              return Flexible(
                fit: FlexFit.tight,
                child: ChartBar(
                    label: element['day'] as String,
                    spendingAmount: element['amount'] as double,
                    spendingPctOfTotal: totalSpending == 0.0
                        ? 0.0
                        :
                    (element['amount'] as double) / totalSpending,
                ),
              );
            }).toList(),
          ),
        ),
    );
  }
}
