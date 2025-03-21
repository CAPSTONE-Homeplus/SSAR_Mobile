import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_clean/core/constant/size_config.dart';
import 'package:intl/intl.dart';
import 'package:home_clean/presentation/blocs/transaction/transaction_event.dart';
import 'package:home_clean/core/constant/colors.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../../../core/format/formater.dart';
import '../../../../../../../domain/entities/wallet/wallet.dart';
import '../../../../../../core/enums/transaction_enums.dart';
import '../../../../../../domain/entities/transaction/transaction.dart';
import '../../../../../blocs/transaction/transaction_state.dart';
import '../../../../../blocs/transaction/transation_bloc.dart';

class TransactionScreen extends StatefulWidget {
  final Wallet wallet;
  final String amount;
  final bool isContribution;
  final String time;

  const TransactionScreen({
    Key? key,
    required this.wallet,
    required this.amount,
    required this.isContribution,
    required this.time,
  }) : super(key: key);

  @override
  State<TransactionScreen> createState() => _ShareWalletTransactionScreenState();
}

class _ShareWalletTransactionScreenState extends State<TransactionScreen> {
  final NumberFormat currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

  @override
  void initState() {
    super.initState();
    context.read<TransactionBloc>().add(GetTransactionByWalletEvent(walletId: widget.wallet.id));
  }

  @override
  Widget build(BuildContext context) {
    final double fem = SizeConfig.fem;

    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        if (state is TransactionLoading) {
          return _buildShimmerLoading(fem);
        } else if (state is TransactionsLoaded) {
          final transactions = state.transactions.items;

          if (transactions.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.receipt_long,
                    size: 64 * fem,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16 * fem),
                  Text(
                    'Chưa có giao dịch nào',
                    style: GoogleFonts.poppins(
                      fontSize: 16 * fem,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 8 * fem),
                  Text(
                    'Các giao dịch trong ví chung sẽ hiển thị ở đây',
                    style: GoogleFonts.poppins(
                      fontSize: 14 * fem,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: transactions.length,
            padding: EdgeInsets.symmetric(horizontal: 4 * fem),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              final TransactionType transactionType = transaction.type!.toTransactionType();
              final TransactionStatus transactionStatus = TransactionStatusExtension.fromString(
                  transaction.status ?? 'pending'
              );
              final bool isPositiveTransaction =
                  transactionType == TransactionType.deposit ||
                      transactionType == TransactionType.refund;

              return GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16 * fem)),
                    ),
                    builder: (context) {
                      return _buildTransactionDetailModal(transaction, fem);
                    },
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 12 * fem),
                  decoration: BoxDecoration(
                    color: transactionStatus == TransactionStatus.failed
                        ? Colors.red.withOpacity(0.05)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(16 * fem),
                    border: transactionStatus == TransactionStatus.failed
                        ? Border.all(color: Colors.red.withOpacity(0.3), width: 1)
                        : null,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16 * fem),
                    child: Material(
                      color: Colors.transparent,
                      child: Padding(
                        padding: EdgeInsets.all(16 * fem),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Transaction Type and Amount Header
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Left side: Icon and Type
                                Row(
                                  children: [
                                    Container(
                                      width: 40 * fem,
                                      height: 40 * fem,
                                      decoration: BoxDecoration(
                                        color: transactionStatus == TransactionStatus.failed
                                            ? Colors.red.withOpacity(0.1)
                                            : transactionType.color.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12 * fem),
                                      ),
                                      child: Icon(
                                        transactionStatus == TransactionStatus.failed
                                            ? transactionStatus.icon
                                            : transactionType.icon,
                                        color: transactionStatus == TransactionStatus.failed
                                            ? transactionStatus.color
                                            : transactionType.color,
                                        size: 20 * fem,
                                      ),
                                    ),
                                    SizedBox(width: 12 * fem),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              transactionType.name,
                                              style: GoogleFonts.poppins(
                                                fontSize: 16 * fem,
                                                fontWeight: FontWeight.w600,
                                                color: transactionStatus == TransactionStatus.failed
                                                    ? Colors.grey[700]
                                                    : Colors.black,
                                              ),
                                            ),
                                            if (transactionStatus != TransactionStatus.success)
                                              Padding(
                                                padding: EdgeInsets.only(left: 8 * fem),
                                                child: _buildStatusBadge(
                                                  transactionStatus.name.toUpperCase(),
                                                  transactionStatus.color,
                                                  fem,
                                                ),
                                              ),
                                          ],
                                        ),
                                        SizedBox(height: 4 * fem),
                                        Text(
                                          Formater.formatDateTime(transaction.createdAt),
                                          style: GoogleFonts.poppins(
                                            fontSize: 12 * fem,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                // Right side: Amount
                                Text(
                                  transactionStatus == TransactionStatus.failed
                                      ? (isPositiveTransaction
                                      ? '+${Formater.formatAmount(transaction.amount)}'
                                      : '-${Formater.formatAmount(transaction.amount)}')
                                      : (isPositiveTransaction
                                      ? '+${Formater.formatAmount(transaction.amount)}'
                                      : '-${Formater.formatAmount(transaction.amount)}'),
                                  style: GoogleFonts.poppins(
                                    fontSize: 16 * fem,
                                    fontWeight: FontWeight.w700,
                                    color: transactionStatus == TransactionStatus.failed
                                        ? Colors.grey[600]
                                        : transactionType.color,
                                    decoration: transactionStatus == TransactionStatus.failed
                                        ? TextDecoration.lineThrough
                                        : null,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),

                            // Divider
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 12 * fem),
                              child: Divider(
                                color: Colors.grey[300],
                                height: 1 * fem,
                              ),
                            ),

                            // Transaction Code
                            Row(
                              children: [
                                Text(
                                  'Mã giao dich: ',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14 * fem,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10 * fem,
                                      vertical: 6 * fem,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(8 * fem),
                                    ),
                                    child: Text(
                                      transaction.code ?? 'Không có mã',
                                      style: GoogleFonts.robotoMono(
                                        fontSize: 13 * fem,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[800],
                                        letterSpacing: 0.7,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (transaction.status != null && transaction.status!.isNotEmpty)
                              Padding(
                                padding: EdgeInsets.only(top: 12 * fem),
                                child: Row(
                                  children: [
                                    Text(
                                      'Trạng thái giao dịch: ',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14 * fem,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 10 * fem, vertical: 6 * fem),
                                      child: Text(
                                        transaction.status ?? 'Chưa có',
                                        style: GoogleFonts.poppins(
                                          fontSize: 13 * fem,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        } else if (state is TransactionFailure) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64 * fem,
                  color: Colors.red[400],
                ),
                SizedBox(height: 16 * fem),
                Text(
                  'Đã xảy ra lỗi',
                  style: GoogleFonts.poppins(
                    fontSize: 16 * fem,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 8 * fem),
                Text(
                  'Không thể tải giao dịch. Vui lòng thử lại sau.',
                  style: GoogleFonts.poppins(
                    fontSize: 14 * fem,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16 * fem),
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<TransactionBloc>().add(
                      GetTransactionByWalletEvent(walletId: widget.wallet.id),
                    );
                  },
                  icon: Icon(Icons.refresh),
                  label: Text('Thử lại'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: AppColors.primaryColor,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16 * fem,
                      vertical: 10 * fem,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8 * fem),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.receipt_long,
                size: 64 * fem,
                color: Colors.grey[400],
              ),
              SizedBox(height: 16 * fem),
              Text(
                'Không có giao dịch nào',
                style: GoogleFonts.poppins(
                  fontSize: 16 * fem,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusBadge(String status, Color color, double fem) {
    return Container(
      margin: EdgeInsets.only(left: 8 * fem),
      padding: EdgeInsets.symmetric(horizontal: 6 * fem, vertical: 2 * fem),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4 * fem),
      ),
      child: Text(
        Formater.parseStatusToString(status),
        style: GoogleFonts.poppins(
          fontSize: 10 * fem,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
  Widget _buildShimmerLoading(double fem) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 5, // số lượng placeholder items
        padding: EdgeInsets.symmetric(horizontal: 4 * fem),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(bottom: 12 * fem),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16 * fem),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16 * fem),
              child: Material(
                color: Colors.transparent,
                child: Padding(
                  padding: EdgeInsets.all(16 * fem),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 40 * fem,
                                height: 40 * fem,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12 * fem),
                                ),
                              ),
                              SizedBox(width: 12 * fem),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 80 * fem,
                                    height: 16 * fem,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(4 * fem),
                                    ),
                                  ),
                                  SizedBox(height: 8 * fem),
                                  Container(
                                    width: 120 * fem,
                                    height: 12 * fem,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(4 * fem),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            width: 70 * fem,
                            height: 16 * fem,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4 * fem),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12 * fem),
                      if (index % 2 == 0) // Một số item có phần note
                        Container(
                          padding: EdgeInsets.all(10 * fem),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8 * fem),
                          ),
                          child: Container(
                            width: double.infinity,
                            height: 13 * fem,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4 * fem),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }


  Widget _buildTransactionDetailModal(Transaction transaction, double fem) {
    return Container(
      padding: EdgeInsets.all(16 * fem),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16 * fem)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40 * fem,
              height: 4 * fem,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2 * fem),
              ),
            ),
          ),
          SizedBox(height: 16 * fem),
          Text(
            'Chi tiết giao dịch',
            style: GoogleFonts.poppins(
              fontSize: 18 * fem,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12 * fem),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Loại giao dịch:',
                style: GoogleFonts.poppins(
                  fontSize: 14 * fem,
                  color: Colors.grey[700],
                ),
              ),
              Text(
                transaction.type!.toTransactionType().name,
                style: GoogleFonts.poppins(
                  fontSize: 14 * fem,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 8 * fem),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Số tiền:',
                style: GoogleFonts.poppins(
                  fontSize: 14 * fem,
                  color: Colors.grey[700],
                ),
              ),
              Text(
                Formater.formatAmount(transaction.amount),
                style: GoogleFonts.poppins(
                  fontSize: 14 * fem,
                  fontWeight: FontWeight.w600,
                  color: transaction.type!.toTransactionType().color,
                ),
              ),
            ],
          ),
          SizedBox(height: 8 * fem),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ngày giao dịch:',
                style: GoogleFonts.poppins(
                  fontSize: 14 * fem,
                  color: Colors.grey[700],
                ),
              ),
              Text(
                Formater.formatDateTime(transaction.createdAt),
                style: GoogleFonts.poppins(
                  fontSize: 14 * fem,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          if (transaction.note != null && transaction.note!.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: 12 * fem),
              child: Text(
                'Ghi chú: ${transaction.note}',
                style: GoogleFonts.poppins(
                  fontSize: 14 * fem,
                  color: Colors.grey[700],
                ),
              ),
            ),
          SizedBox(height: 16 * fem),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Đóng'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20 * fem, vertical: 12 * fem),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12 * fem),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}