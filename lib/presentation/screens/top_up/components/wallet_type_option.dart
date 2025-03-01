import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WalletTypeOption extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String walletId;
  final String title;
  final double fem;
  final double ffem;
  final String selectedWalletId;
  final Function(String) onSelect;

  const WalletTypeOption({
    Key? key,
    required this.icon,
    required this.color,
    required this.walletId,
    required this.title,
    required this.fem,
    required this.ffem,
    required this.selectedWalletId,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isSelected = selectedWalletId == walletId;

    return InkWell(
      onTap: () => onSelect(walletId),
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
}
