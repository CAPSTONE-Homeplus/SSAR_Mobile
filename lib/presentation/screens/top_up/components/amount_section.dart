import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AmountSectionWidget extends StatefulWidget {
  final TextEditingController controller;
  final double fem;
  final double ffem;

  const AmountSectionWidget({
    Key? key,
    required this.controller,
    required this.fem,
    required this.ffem,
  }) : super(key: key);

  @override
  _AmountSectionWidgetState createState() => _AmountSectionWidgetState();
}

class _AmountSectionWidgetState extends State<AmountSectionWidget> {
  int _points = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updatePoints);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updatePoints);
    super.dispose();
  }

  void _updatePoints() {
    String cleanValue =
        widget.controller.text.replaceAll(RegExp(r'[^0-9]'), '');
    int amount = int.tryParse(cleanValue) ?? 0;

    if (amount > 50000000) {
      amount = 50000000;
      widget.controller.text =
          NumberFormat.currency(locale: 'vi_VN', symbol: '', decimalDigits: 0)
              .format(amount);
      widget.controller.selection = TextSelection.fromPosition(
        TextPosition(offset: widget.controller.text.length),
      );
    }

    setState(() {
      _points = amount;
    });
  }

  String? _validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập số tiền';
    }

    final cleanValue = value.replaceAll(RegExp(r'[^0-9]'), '');
    final amount = int.tryParse(cleanValue) ?? 0;

    if (amount == 0) {
      return 'Số tiền không được là 0';
    }

    if (amount < 10000) {
      return 'Số tiền tối thiểu là 10.000₫';
    }

    if (amount > 50000000) {
      return 'Số tiền tối đa là 50.000.000₫';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20 * widget.fem),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Số tiền nạp',
            style: GoogleFonts.poppins(
              fontSize: 16 * widget.ffem,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16 * widget.fem),
          TextFormField(
            controller: widget.controller,
            keyboardType: TextInputType.number,
            style: GoogleFonts.poppins(
              fontSize: 18 * widget.ffem,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            decoration: InputDecoration(
              hintText: 'Nhập số tiền',
              hintStyle: GoogleFonts.poppins(
                fontSize: 16 * widget.ffem,
                color: Colors.grey[400],
              ),
              prefixIcon: Container(
                padding: EdgeInsets.all(16 * widget.fem),
                child: Text(
                  '₫',
                  style: GoogleFonts.poppins(
                    fontSize: 20 * widget.ffem,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1CAF7D),
                  ),
                ),
              ),
              filled: true,
              fillColor: Colors.grey[100],
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12 * widget.fem),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12 * widget.fem),
                borderSide:
                    BorderSide(color: const Color(0xFF1CAF7D), width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12 * widget.fem),
                borderSide: BorderSide(color: Colors.red[300]!, width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12 * widget.fem),
                borderSide: BorderSide(color: Colors.red[300]!, width: 2),
              ),
            ),
            validator: _validateAmount,
            // Thay đổi onChanged thành bộ định dạng đầu vào
            inputFormatters: [
              MoneyInputFormatter(
                onValueChanged: (value) {
                  // Không cần làm gì ở đây vì listener sẽ xử lý
                },
              ),
            ],
          ),
          SizedBox(height: 8 * widget.fem),
          Text(
            'Số tiền tối đa: 50.000.000₫',
            style: GoogleFonts.poppins(
              fontSize: 12 * widget.ffem,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 12 * widget.fem),
          Row(
            children: [
              Icon(
                Icons.monetization_on_outlined,
                color: Color(0xFF1CAF7D),
                size: 20 * widget.fem,
              ),
              SizedBox(width: 8 * widget.fem),
              RichText(
                text: TextSpan(
                  style: GoogleFonts.poppins(
                    fontSize: 14 * widget.ffem,
                    color: Colors.grey[800],
                  ),
                  children: [
                    TextSpan(text: 'Bạn sẽ nhận được: '),
                    TextSpan(
                      text: '$_points điểm',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1CAF7D),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MoneyInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: '',
    decimalDigits: 0,
  );

  final Function(int)? onValueChanged;

  MoneyInputFormatter({this.onValueChanged});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      if (onValueChanged != null) {
        onValueChanged!(0);
      }
      return newValue;
    }
    int cursorPosition = newValue.selection.end;
    int oldTextLength = oldValue.text.length;
    String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (newText.isEmpty) {
      if (onValueChanged != null) {
        onValueChanged!(0);
      }
      return TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }
    if (newText.startsWith('0') && newText.length > 1) {
      newText = newText.replaceFirst(RegExp(r'^0+'), '');
    }
    int amount = int.tryParse(newText) ?? 0;
    String formattedValue = _formatter.format(amount);
    int newCursorPosition;
    if (newValue.text.length > oldValue.text.length) {
      int diff = formattedValue.length - oldTextLength;
      newCursorPosition = cursorPosition + diff;
    } else {
      int lengthDiff = oldTextLength - newValue.text.length;
      int actualDiff = oldTextLength - formattedValue.length;
      newCursorPosition = cursorPosition - (lengthDiff - actualDiff);
    }

    if (newCursorPosition < 0) {
      newCursorPosition = 0;
    } else if (newCursorPosition > formattedValue.length) {
      newCursorPosition = formattedValue.length;
    }

    if (onValueChanged != null) {
      onValueChanged!(amount);
    }

    return TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: newCursorPosition),
    );
  }
}
