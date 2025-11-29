// transaction_model_A1.dart

class TransactionModel_A1 {
  final String trxId_A1;        
  final double totalFinal_A1;   
  final String status_A1;       
  final List<Map<String, dynamic>> items_A1; 
  
  TransactionModel_A1({
    required this.trxId_A1,
    required this.totalFinal_A1,
    required this.status_A1,
    required this.items_A1,
  });

  factory TransactionModel_A1.fromJson_A1(Map<String, dynamic> json) {
    return TransactionModel_A1(
      trxId_A1: json['trx_id'] as String,
      totalFinal_A1: (json['total_final'] as num).toDouble(), 
      status_A1: json['status'] as String,
      items_A1: (json['items'] as List).cast<Map<String, dynamic>>(), 
    );
  }

  Map<String, dynamic> toJson_A1() {
    return {
      'trx_id': trxId_A1,
      'total_final': totalFinal_A1,
      'status': status_A1,
      'items': items_A1,
    };
  }
}