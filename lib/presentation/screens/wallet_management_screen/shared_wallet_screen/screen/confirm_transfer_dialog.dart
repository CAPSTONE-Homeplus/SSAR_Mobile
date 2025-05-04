import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_clean/core/router/app_router.dart';
import 'package:home_clean/presentation/widgets/show_dialog.dart';
import 'package:intl/intl.dart';

import '../../../../../domain/entities/wallet/wallet.dart';
import '../../../../blocs/wallet/wallet_bloc.dart';
import '../../../../blocs/wallet/wallet_event.dart';
import '../../../../blocs/wallet/wallet_state.dart';

class ConfirmTransferDialog extends StatefulWidget {
  final Wallet sharedWallet;
  final Wallet personalWallet;
  final String title;
  final String message;

  const ConfirmTransferDialog({
    Key? key,
    required this.sharedWallet,
    required this.personalWallet,
    required this.title,
    required this.message,
  }) : super(key: key);

  @override
  _ConfirmTransferDialogState createState() => _ConfirmTransferDialogState();
}

class _ConfirmTransferDialogState extends State<ConfirmTransferDialog> {
  late final TextEditingController _amountController;
  final NumberFormat _currencyFormatter = NumberFormat.decimalPattern('vi');
  static const int _maxAmount = 20000000;
  static const int _minAmount = 10000;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransferBloc, TransferPointToSharedWalletState>(
      listener: (context, state) {
        if (state is TransferPointToSharedWalletLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => Center(
              child: CircularProgressIndicator(
                color: Colors.green[700],
              ),
            ),
          );
        } else if (state is TransferPointToSharedWalletSuccess) {
          _showTransferSuccessDialog(
              context,
              _amountController.text.isNotEmpty
                  ? int.parse(_amountController.text.replaceAll(RegExp(r'[.,]'), ''))
                  : 0
          );
        } else if (state is TransferPointToSharedWalletError) {
          if (!context.mounted) return;
          showCustomDialog(
            context: context,
            message: state.message,
            type: DialogType.error,
            onConfirm: () {
              Get.back();
            },
          );
        }
      },
      builder: (context, state) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            widget.title,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: Colors.blueGrey[800],
            ),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Nhập số dư bạn muốn chuyển (Tối đa 20.000.000)',
                style: GoogleFonts.poppins(
                  color: Colors.blueGrey[700],
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  TextInputFormatter.withFunction((oldValue, newValue) {
                    if (newValue.text.isEmpty) {
                      return newValue;
                    }
                    final number = int.parse(newValue.text);


                    if (number < _minAmount) {
                      return TextEditingValue(
                        text: _currencyFormatter.format(_minAmount),
                        selection: TextSelection.collapsed(offset: 6),
                      );
                    }
                    // Limit to max amount
                    if (number > _maxAmount) {
                      return TextEditingValue(
                        text: _currencyFormatter.format(_maxAmount),
                        selection: TextSelection.collapsed(
                            offset: _currencyFormatter.format(_maxAmount).length
                        ),
                      );
                    }

                    final formatted = _currencyFormatter.format(number);
                    return TextEditingValue(
                      text: formatted,
                      selection: TextSelection.collapsed(offset: formatted.length),
                    );
                  }),
                ],
                decoration: InputDecoration(
                  hintText: 'Nhập số điểm',
                  hintStyle: GoogleFonts.poppins(color: Colors.grey),
                  suffixText: 'Point',
                  helperText: 'Tối đa 20.000.000 điểm',
                  helperStyle: GoogleFonts.poppins(color: Colors.grey, fontSize: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.green[700]!, width: 2),
                  ),
                ),
                style: GoogleFonts.poppins(),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Hủy',
                      style: GoogleFonts.poppins(color: Colors.grey),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _handleConfirmTransfer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Xác nhận',
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
  void _handleConfirmTransfer() {
    // Remove formatting and convert to number
    final amount = int.tryParse(
        _amountController.text.replaceAll(RegExp(r'[.,]'), '')
    ) ?? 0;

    if (amount >= _minAmount && amount <= _maxAmount) {
      BlocProvider.of<TransferBloc>(context).add(
        TransferToSharedWallet(
          sharedWalletId: widget.sharedWallet.id!,
          personalWalletId: widget.personalWallet.id!,
          amount: amount,
        ),
      );
    } else {
      // Show error SnackBar
      _showErrorSnackBar('Vui lòng nhập số điểm từ 10.000 đến 20.000.000');
    }
  }

  void _showTransferSuccessDialog(BuildContext context, int amount) {
    final NumberFormat currencyFormatter = NumberFormat.decimalPattern('vi');

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Chuyển điểm thành công',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: Colors.green[700],
            ),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Bạn đã chuyển ${currencyFormatter.format(amount)} điểm thành công',
                style: GoogleFonts.poppins(),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                 AppRouter.navigateToHome();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Đóng',
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}