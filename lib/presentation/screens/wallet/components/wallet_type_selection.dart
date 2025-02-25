import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../domain/entities/wallet/wallet.dart';
import 'wallet_type_option.dart'; // Import file chứa WalletTypeOption

class WalletTypeSelection extends StatefulWidget {
  final List<Wallet> walletUser;
  final String selectedWalletId;
  final Function(String) onWalletSelected;
  final double fem;
  final double ffem;

  const WalletTypeSelection({
    Key? key,
    required this.walletUser,
    required this.selectedWalletId,
    required this.onWalletSelected,
    required this.fem,
    required this.ffem,
  }) : super(key: key);

  @override
  _WalletTypeSelectionState createState() => _WalletTypeSelectionState();
}

class _WalletTypeSelectionState extends State<WalletTypeSelection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20 * widget.fem),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Chọn loại ví',
            style: GoogleFonts.poppins(
              fontSize: 16 * widget.ffem,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16 * widget.fem),
          Row(
            children: widget.walletUser.map((wallet) {
              return Expanded(
                child: WalletTypeOption(
                  icon: wallet.type == 'Shared' ? Icons.people : Icons.account_circle,
                  color: wallet.type == 'Shared' ? Colors.blue : Colors.orange,
                  walletId: wallet.id!,
                  title: wallet.type!,
                  fem: widget.fem,
                  ffem: widget.ffem,
                  selectedWalletId: widget.selectedWalletId,
                  onSelect: (id) => widget.onWalletSelected(id),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
