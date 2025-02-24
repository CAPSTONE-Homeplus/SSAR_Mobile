import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../core/enums/transaction_enums.dart';
import '../../../domain/entities/transaction/transaction.dart';
import '../../blocs/transaction/transation_bloc.dart';
import '../../blocs/transaction/transaction_event.dart';
import '../../blocs/transaction/transaction_state.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _initTransactions();
  }

  void _initTransactions() {
    context.read<TransactionBloc>().add(GetTransactionByUserEvent());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Lịch sử giao dịch',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey[200]!,
                  width: 1,
                ),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              labelStyle: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              unselectedLabelStyle: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              labelColor: const Color(0xFF1CAF7D),
              unselectedLabelColor: Colors.grey,
              indicatorColor: const Color(0xFF1CAF7D),
              indicatorWeight: 3,
              tabs: const [
                Tab(text: 'Đang chờ'),
                Tab(text: 'Hoàn thành'),
                Tab(text: 'Đã hủy'),
              ],
            ),
          ),
        ),
      ),
      body: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
          if (state is TransactionLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TransactionFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Không thể tải lịch sử dịch vụ',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _initTransactions,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1CAF7D),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          if (state is TransactionsLoaded) {
            return TabBarView(
              controller: _tabController,
              children: [
                _buildTransactionList(
                  state.transactions.items,
                  TransactionStatus.pending,
                ),
                _buildTransactionList(
                  state.transactions.items,
                  TransactionStatus.success,
                ),
                _buildTransactionList(
                  state.transactions.items,
                  TransactionStatus.failed,
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildTransactionList(
      List<Transaction> transactions,
      TransactionStatus filterStatus,
      ) {
    final filteredTransactions = transactions
        .where((txn) => txn.status == filterStatus.name)
        .toList();

    if (filteredTransactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Chưa có dịch vụ nào',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => _initTransactions(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredTransactions.length,
        itemBuilder: (context, index) {
          return _buildTransactionCard(filteredTransactions[index]);
        },
      ),
    );
  }

  Widget _buildTransactionCard(Transaction transaction) {
    return GestureDetector(
      onTap: () => _showTransactionDetails(transaction),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 5,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _getTransactionIcon(transaction.status ?? ''),
                    color: TransactionStatusExtension.fromString(transaction.status ?? '').color,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _getServiceType(transaction),
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  _buildStatusChip(
                    TransactionStatusExtension.fromString(transaction.status ?? ''),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        transaction.createdAt ?? '',
                        style: GoogleFonts.poppins(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _getServiceAddress(transaction),
                          style: GoogleFonts.poppins(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tổng tiền',
                        style: GoogleFonts.poppins(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: transaction.type == 'Deposit' ? '▲ ' : '▼ ',
                              style: TextStyle(
                                color: transaction.type == 'Deposit' ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: '${transaction.type == 'Deposit' ? '+' : '-'}'
                                  '${NumberFormat('#,###.##').format(double.tryParse(transaction.amount ?? '0') ?? 0)}',
                              style: TextStyle(
                                color: Colors.black, // Giữ phần số màu đen
                              ),
                            ),
                          ],
                        ),
                      )

                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(TransactionStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: status.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _getStatusText(status),
        style: GoogleFonts.poppins(
          color: status.color,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
    );
  }

  String _getStatusText(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.pending:
        return 'ĐANG CHỜ';
      case TransactionStatus.success:
        return 'HOÀN THÀNH';
      case TransactionStatus.failed:
        return 'ĐÃ HỦY';
      default:
        return '';
    }
  }

  String _getServiceType(Transaction transaction) {
    return 'Dọn dẹp nhà';
  }

  String _getServiceAddress(Transaction transaction) {
    return '123 Nguyễn Văn Linh, Quận 7, TP.HCM';
  }

  IconData _getTransactionIcon(String status) {
    switch (TransactionStatusExtension.fromString(status)) {
      case TransactionStatus.pending:
        return Icons.pending_outlined;
      case TransactionStatus.success:
        return Icons.check_circle_outline;
      case TransactionStatus.failed:
        return Icons.cancel_outlined;
      default:
        return Icons.cleaning_services_outlined;
    }
  }

  void _showTransactionDetails(Transaction transaction) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    'Chi tiết đơn dịch vụ',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // TODO: Add transaction details content
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}