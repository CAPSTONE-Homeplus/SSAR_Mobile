import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_clean/core/size_config.dart';
import 'package:home_clean/core/validation.dart';
import 'package:home_clean/presentation/blocs/transaction/transaction_state.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../domain/entities/transaction/create_transaction.dart';
import '../../../domain/entities/wallet/wallet.dart';
import '../../blocs/transaction/transaction_event.dart';
import '../../blocs/transaction/transation_bloc.dart';

class TopUpScreen extends StatefulWidget {
  List<Wallet> walletUser = [];
  TopUpScreen({Key? key, required this.walletUser}) : super(key: key);

  @override
  State<TopUpScreen> createState() => _TopUpScreenState();
}

class _TopUpScreenState extends State<TopUpScreen> {
  final _formKey = GlobalKey<FormState>();
  late List<Wallet> _selectedWalletType = [];
  late String _selectedWalletId = '';
  late String _selectedPaymentId = '15890b1a-f5a6-42c3-8f37-541029189722';
  String _selectedPaymentMethod = 'banking'; // banking, paypal, etc.
  final TextEditingController _amountController = TextEditingController();

  // Predefined amounts
  final List<int> _suggestedAmounts = [50000, 100000, 200000, 500000];

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _selectedWalletType = widget.walletUser;
    _selectedWalletId = _selectedWalletType[0].id!;
  }

  void _onProcess() {
    if (_formKey.currentState!.validate()) {
      String amountText = _amountController.text.replaceAll(RegExp(r'[^\d]'), ''); // Chỉ giữ lại số

      int amount = int.tryParse(amountText) ?? 0; // Tránh lỗi khi parse

      if (amount <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Số tiền không hợp lệ")),
        );
        return;
      }

      CreateTransaction newTransaction = CreateTransaction(
        walletId: _selectedWalletId,
        paymentMethodId: _selectedPaymentId,
        amount: amount.toString(),
      );

      context.read<TransactionBloc>().add(SaveTransactionEvent(newTransaction));
    }
  }



  @override
  Widget build(BuildContext context) {
    final double fem = SizeConfig.fem;
    final double hem = SizeConfig.hem;
    final double ffem = SizeConfig.ffem; // Font scale factor

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Nạp tiền vào ví',
          style: GoogleFonts.poppins(
            fontSize: 18 * ffem,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWalletSummary(fem, ffem),
              const SizedBox(height: 4),
              _buildWalletTypeSelection(fem, ffem),
              _buildDivider(fem),
              _buildPaymentMethodSelection(fem, ffem),
              _buildDivider(fem),
              _buildAmountSection(fem, ffem),
              _buildDivider(fem),
              _buildSuggestedAmounts(fem, ffem),
              const SizedBox(height: 40),
              _buildTopUpButton(fem, ffem),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWalletSummary(double fem, double ffem) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20 * fem),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50 * fem,
            height: 50 * fem,
            decoration: BoxDecoration(
              color: const Color(0xFF1CAF7D).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.account_balance_wallet,
              color: const Color(0xFF1CAF7D),
              size: 24 * fem,
            ),
          ),
          SizedBox(width: 16 * fem),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tổng số dư hiện tại',
                  style: GoogleFonts.poppins(
                    fontSize: 14 * ffem,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 4 * fem),
                Text(
                  '${_selectedWalletId == widget.walletUser[0].id ? Validation.formatCurrency(widget.walletUser[0].balance!) : Validation.formatCurrency(widget.walletUser[1].balance!)} ₫',
                  style: GoogleFonts.poppins(
                    fontSize: 20 * ffem,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletTypeSelection(double fem, double ffem) {
    return Container(
      padding: EdgeInsets.all(20 * fem),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Chọn loại ví',
            style: GoogleFonts.poppins(
              fontSize: 16 * ffem,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16 * fem),
          Row(
            children: widget.walletUser.map((wallet) {
              return Expanded(
                child: wallet.type == 'Shared' ? _buildWalletTypeOption(
                  Icons.people,
                  Colors.blue,
                  wallet.id!,
                  wallet.type!,
                  fem,
                  ffem,
                ) : _buildWalletTypeOption(
                  Icons.account_circle,
                  Colors.orange,
                  wallet.id!,
                  wallet.type!,
                  fem,
                  ffem,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletTypeOption(
      IconData icon, Color color, String walletId, String title, double fem, double ffem) {
    bool isSelected = _selectedWalletId == walletId  ;

    return InkWell(
      onTap: () => setState(() => _selectedWalletId = walletId),
      borderRadius: BorderRadius.circular(12 * fem),
      child: Container(
        padding: EdgeInsets.all(16 * fem),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.grey[100],
          borderRadius: BorderRadius.circular(12 * fem),
          border: Border.all(
            color: isSelected ? color : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8 * fem),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 18 * fem,
              ),
            ),
            SizedBox(width: 12 * fem),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title == 'Shared' ? 'Ví chung' : 'Ví cá nhân',
                    style: GoogleFonts.poppins(
                      fontSize: 12 * ffem,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (isSelected)
                    Text(
                      'Đã chọn',
                      style: GoogleFonts.poppins(
                        fontSize: 12 * ffem,
                        color: color,
                      ),
                    ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: color,
                size: 20 * fem,
              ),
          ],
        ),
      ),
    );
  }


  Widget _buildPaymentMethodSelection(double fem, double ffem) {
    return Container(
      padding: EdgeInsets.all(20 * fem),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Phương thức thanh toán',
            style: GoogleFonts.poppins(
              fontSize: 16 * ffem,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16 * fem),
          Column(
            children: [
              _buildPaymentOption(
                'banking',
                'Chuyển khoản ngân hàng',
                'assets/images/bank_icon.png',
                fem,
                ffem,
              ),
              SizedBox(height: 12 * fem),
              _buildPaymentOption(
                'paypal',
                'PayPal',
                'assets/images/paypal_icon.png',
                fem,
                ffem,
              ),
              SizedBox(height: 12 * fem),
              _buildPaymentOption(
                'momo',
                'Ví MoMo',
                'assets/images/momo_icon.png',
                fem,
                ffem,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(String value, String title, String iconAsset, double fem, double ffem) {
    final bool isSelected = _selectedPaymentMethod == value;

    return InkWell(
      onTap: () => setState(() => _selectedPaymentMethod = value),
      borderRadius: BorderRadius.circular(12 * fem),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16 * fem,
          vertical: 14 * fem,
        ),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1CAF7D).withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12 * fem),
          border: Border.all(
            color: isSelected ? const Color(0xFF1CAF7D) : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // For demonstration, using icon instead of asset image
            Container(
              width: 40 * fem,
              height: 40 * fem,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8 * fem),
              ),
              child: Icon(
                value == 'banking' ? Icons.account_balance :
                value == 'paypal' ? Icons.paypal :
                Icons.account_balance_wallet,
                color: value == 'banking' ? Colors.blue[800] :
                value == 'paypal' ? Colors.blue[700] :
                Colors.pink,
                size: 20 * fem,
              ),
            ),
            SizedBox(width: 16 * fem),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14 * ffem,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            Radio(
              value: value,
              groupValue: _selectedPaymentMethod,
              activeColor: const Color(0xFF1CAF7D),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() => _selectedPaymentMethod = newValue);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountSection(double fem, double ffem) {
    return Container(
      padding: EdgeInsets.all(20 * fem),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Số tiền nạp',
            style: GoogleFonts.poppins(
              fontSize: 16 * ffem,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16 * fem),
          TextFormField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            style: GoogleFonts.poppins(
              fontSize: 18 * ffem,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            decoration: InputDecoration(
              hintText: 'Nhập số tiền',
              hintStyle: GoogleFonts.poppins(
                fontSize: 16 * ffem,
                color: Colors.grey[400],
              ),
              prefixIcon: Container(
                padding: EdgeInsets.all(16 * fem),
                child: Text(
                  '₫',
                  style: GoogleFonts.poppins(
                    fontSize: 20 * ffem,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1CAF7D),
                  ),
                ),
              ),
              filled: true,
              fillColor: Colors.grey[100],
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12 * fem),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12 * fem),
                borderSide: BorderSide(color: const Color(0xFF1CAF7D), width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12 * fem),
                borderSide: BorderSide(color: Colors.red[300]!, width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12 * fem),
                borderSide: BorderSide(color: Colors.red[300]!, width: 2),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập số tiền';
              }
              final amount = int.tryParse(value.replaceAll(RegExp(r'[^0-9]'), ''));
              if (amount == null || amount < 10000) {
                return 'Số tiền tối thiểu là 10.000₫';
              }
              return null;
            },
            onChanged: (value) {
              // Format currency as user types
              if (value.isNotEmpty) {
                final amount = int.tryParse(value.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
                final formattedAmount = NumberFormat.currency(
                  locale: 'vi_VN',
                  symbol: '',
                  decimalDigits: 0,
                ).format(amount);

                // Avoid infinite loop by checking if the text already matches
                if (value != formattedAmount) {
                  _amountController.value = TextEditingValue(
                    text: formattedAmount,
                    selection: TextSelection.collapsed(offset: formattedAmount.length),
                  );
                }
              }
            },
          ),
          SizedBox(height: 8 * fem),
          Text(
            'Số tiền tối thiểu: 10.000₫',
            style: GoogleFonts.poppins(
              fontSize: 12 * ffem,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestedAmounts(double fem, double ffem) {
    return Container(
      padding: EdgeInsets.all(20 * fem),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Số tiền phổ biến',
            style: GoogleFonts.poppins(
              fontSize: 14 * ffem,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 16 * fem),
          Wrap(
            spacing: 12 * fem,
            runSpacing: 12 * fem,
            children: _suggestedAmounts.map((amount) =>
                _buildAmountChip(amount, fem, ffem)
            ).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountChip(int amount, double fem, double ffem) {
    final formattedAmount = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '',
      decimalDigits: 0,
    ).format(amount);

    return InkWell(
      onTap: () {
        setState(() {
          _amountController.text = formattedAmount;
        });
      },
      borderRadius: BorderRadius.circular(8 * fem),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16 * fem,
          vertical: 10 * fem,
        ),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8 * fem),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Text(
          '$formattedAmount ₫',
          style: GoogleFonts.poppins(
            fontSize: 14 * ffem,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildTopUpButton(double fem, double ffem) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30 * fem),
      width: double.infinity,
      child: BlocConsumer<TransactionBloc, TransactionState>(
        listener: (context, state) async {
          if (state is TransactionSuccess) {
            if (state.transaction.paymentUrl != null) {
              Uri url = Uri.parse(state.transaction.paymentUrl!);
              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Không thể mở trang thanh toán")),
                );
              }
            }
          }
        },
        builder: (context, state) {
          return ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _onProcess();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1CAF7D),
              padding: EdgeInsets.symmetric(vertical: 16 * fem),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12 * fem),
              ),
              elevation: 0,
            ),
            child: state is TransactionLoading
                ? CircularProgressIndicator(color: Colors.white)
                : Text(
              'Xác nhận nạp tiền',
              style: GoogleFonts.poppins(
                fontSize: 16 * ffem,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDivider(double fem) {
    return Container(
      height: 8 * fem,
      color: Colors.grey[100],
    );
  }

  void _showConfirmationDialog(double fem, double ffem) {
    final amount = _amountController.text;
    final walletType = _selectedWalletType == 'personal' ? 'Ví cá nhân' : 'Ví chung';
    final paymentMethod = _selectedPaymentMethod == 'banking'
        ? 'Chuyển khoản ngân hàng'
        : _selectedPaymentMethod == 'paypal'
        ? 'PayPal'
        : 'Ví MoMo';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16 * fem),
        ),
        title: Text(
          'Xác nhận giao dịch',
          style: GoogleFonts.poppins(
            fontSize: 18 * ffem,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60 * fem,
              height: 60 * fem,
              decoration: BoxDecoration(
                color: const Color(0xFF1CAF7D).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle_outline,
                color: const Color(0xFF1CAF7D),
                size: 30 * fem,
              ),
            ),
            SizedBox(height: 20 * fem),
            Text(
              'Bạn sắp nạp:',
              style: GoogleFonts.poppins(
                fontSize: 14 * ffem,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8 * fem),
            Text(
              '$amount ₫',
              style: GoogleFonts.poppins(
                fontSize: 24 * ffem,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 24 * fem),
            _buildConfirmationDetail('Loại ví', walletType, fem, ffem),
            SizedBox(height: 8 * fem),
            _buildConfirmationDetail('Phương thức', paymentMethod, fem, ffem),
            SizedBox(height: 8 * fem),
            _buildConfirmationDetail('Phí giao dịch', 'Miễn phí', fem, ffem),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Hủy',
              style: GoogleFonts.poppins(
                fontSize: 14 * ffem,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Process payment and show success
              _showSuccessDialog(fem, ffem);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1CAF7D),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8 * fem),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 20 * fem,
                vertical: 10 * fem,
              ),
              elevation: 0,
            ),
            child: Text(
              'Xác nhận',
              style: GoogleFonts.poppins(
                fontSize: 14 * ffem,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmationDetail(String label, String value, double fem, double ffem) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14 * ffem,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 14 * ffem,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  void _showSuccessDialog(double fem, double ffem) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16 * fem),
        ),
        child: Container(
          padding: EdgeInsets.all(24 * fem),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80 * fem,
                height: 80 * fem,
                decoration: BoxDecoration(
                  color: const Color(0xFF1CAF7D).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle,
                  color: const Color(0xFF1CAF7D),
                  size: 40 * fem,
                ),
              ),
              SizedBox(height: 24 * fem),
              Text(
                'Nạp tiền thành công!',
                style: GoogleFonts.poppins(
                  fontSize: 20 * ffem,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 16 * fem),
              Text(
                'Số tiền đã được nạp vào ví của bạn',
                style: GoogleFonts.poppins(
                  fontSize: 14 * ffem,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24 * fem),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context); // Return to previous screen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1CAF7D),
                  minimumSize: Size(double.infinity, 50 * fem),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12 * fem),
                  ),
                ),
                child: Text(
                  'Hoàn tất',
                  style: GoogleFonts.poppins(
                    fontSize: 16 * ffem,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}