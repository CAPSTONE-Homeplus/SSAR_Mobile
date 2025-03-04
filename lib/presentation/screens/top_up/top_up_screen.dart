import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_clean/core/constant/colors.dart';
import 'package:home_clean/core/constant/size_config.dart';
import 'package:home_clean/domain/entities/payment_method/payment_method.dart';
import 'package:home_clean/presentation/blocs/payment_method/payment_method_event.dart';

import '../../../domain/entities/transaction/create_transaction.dart';
import '../../../domain/entities/wallet/wallet.dart';
import '../../blocs/payment_method/payment_method_bloc.dart';
import '../../blocs/payment_method/payment_method_state.dart';
import '../../blocs/transaction/transaction_event.dart';
import '../../blocs/transaction/transation_bloc.dart';
import '../../blocs/wallet/wallet_bloc.dart';
import '../../blocs/wallet/wallet_event.dart';
import '../../blocs/wallet/wallet_state.dart';
import 'components/amount_section.dart';
import 'components/payment_method_selection.dart';
import 'components/suggested_amounts.dart';
import 'components/top_up_button.dart';
import 'components/wallet_place_holder.dart';
import 'components/wallet_summary.dart';
import 'components/wallet_type_selection.dart';

class TopUpScreen extends StatefulWidget {
  TopUpScreen({Key? key}) : super(key: key);

  @override
  State<TopUpScreen> createState() => _TopUpScreenState();
}

class _TopUpScreenState extends State<TopUpScreen> {
  final _formKey = GlobalKey<FormState>();
  List<Wallet> _selectedWalletType = [];
  late String _selectedWalletId = '';
  bool _showError = false;
  late String _selectedPaymentId = '';
  final TextEditingController _amountController = TextEditingController();
  late WalletBloc _walletBloc;
  late PaymentMethodBloc _paymentMethodBloc;
  List<Wallet> walletUser = [];
  List<PaymentMethod> paymentMethods = [];
  bool isLoading = true;

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
    _init();
  }


  void _init() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        setState(() {
          isLoading = true;
        });
        _paymentMethodBloc = context.read<PaymentMethodBloc>();
        _walletBloc = context.read<WalletBloc>();
        _paymentMethodBloc.add(GetPaymentMethodsEvent());
        _walletBloc.add(GetWallet());
        final walletComplete = _processWallet();
        final paymentComplete = _processPaymentMethod();
        await Future.wait([
          paymentComplete,
          walletComplete,
        ]);
        setState(() {
          isLoading = false;
        });
      } catch (e) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  Future<void> _processWallet() async {
    await for (final state in _walletBloc.stream) {
      if (state is WalletLoaded && mounted) {
        setState(() {
          walletUser = state.wallets;
          _selectedWalletType = walletUser;

          if (_selectedWalletType.isNotEmpty) {
            _selectedWalletId = _selectedWalletType[0].id!;
          }
        });
        break;
      }
    }
  }

  Future<void> _processPaymentMethod() async {
    await for (final state in _paymentMethodBloc.stream) {
      if (state is PaymentMethodLoaded && mounted) {
        setState(() {
          paymentMethods = state.response.items;
        });
        break;
      }
    }
  }


  void _onProcess() {
    setState(() {
      _showError = _selectedPaymentId.isEmpty;
    });

    if (_selectedPaymentId.isNotEmpty && _formKey.currentState!.validate()) {
      String amountText = _amountController.text.replaceAll(RegExp(r'\D'), '');
      int amount = int.tryParse(amountText) ?? 0;

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
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Nạp điểm',
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
          child: isLoading
                  ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WalletPlaceHolder(fem: fem, hem: hem),
            ],

              )
              :Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWalletSummary(fem, ffem),
              const SizedBox(height: 4),
              WalletTypeSelection(
                walletUser: walletUser,
                selectedWalletId: _selectedWalletId,
                onWalletSelected: (id) => setState(() => _selectedWalletId = id),
                fem: fem,
                ffem: ffem,
              ),
              _buildDivider(fem),
              AmountSectionWidget(
                controller: _amountController,
                fem: fem,
                ffem: ffem,
              ),
              _buildDivider(fem),
              SuggestedAmountsWidget(
                suggestedAmounts: _suggestedAmounts,
                onAmountSelected: (amount) {
                  _amountController.text = amount.toString();
                },
                fem: fem,
                ffem: ffem,
              ),
              _buildDivider(fem),
              PaymentMethodSelection(
                paymentMethods: paymentMethods,
                selectedPaymentId: _selectedPaymentId,
                onPaymentSelected: (id) => setState(() => _selectedPaymentId = id),
                fem: fem,
                ffem: ffem,
                showError: _showError,
              ),
              const SizedBox(height: 40),
              TopUpButtonWidget(
                formKey: _formKey,
                fem: fem,
                ffem: ffem,
                onProcess: _onProcess,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWalletSummary(double fem, double ffem) {
    if (walletUser.isEmpty) {
      return EmptyWalletMessage(fem: fem, ffem: ffem);
    }
    Wallet selectedWallet = walletUser.firstWhere(
          (wallet) => wallet.id == _selectedWalletId,
      orElse: () => walletUser[0],
    );
    return WalletSummary(selectedWallet: selectedWallet, fem: fem, ffem: ffem);
  }


  Widget _buildDivider(double fem) {
    return Container(
      height: 8 * fem,
      color: Colors.grey[100],
    );
  }

}