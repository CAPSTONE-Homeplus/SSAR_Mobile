import 'package:flutter/material.dart';
import 'package:home_clean/presentation/widgets/currency_display.dart';
import 'package:intl/intl.dart';

class PriceInputComponent extends StatefulWidget {
  final Color primaryColor;
  final double pricePerKg;
  final double? initialWeight;
  final void Function(double quantity, double totalPrice)? onTotalPriceChanged;
  final double maxWeight;


  const PriceInputComponent({
    Key? key,
    required this.primaryColor,
    required this.pricePerKg,
    this.initialWeight,
    this.onTotalPriceChanged,
    this.maxWeight = 100.0, // Default max weight of 100 kg

  }) : super(key: key);

  @override
  _PriceInputComponentState createState() => _PriceInputComponentState();
}

class _PriceInputComponentState extends State<PriceInputComponent> {
  late double _quantity;
  late final TextEditingController weightController;

  @override
  void initState() {
    super.initState();
    // Use initial weight if provided, otherwise start at 0
    _quantity = widget.initialWeight ?? 0.0;
    weightController = TextEditingController(
      text: _quantity.toString(),
    );

    // Call onTotalPriceChanged with initial total price if provided
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notifyTotalPriceChanged();
    });
  }

  @override
  void dispose() {
    weightController.dispose();
    super.dispose();
  }

  void _updateQuantity(String value) {
    setState(() {
      _quantity = double.tryParse(value) ?? 0.0;
      _notifyTotalPriceChanged();
    });
  }

  void _notifyTotalPriceChanged() {
    if (widget.onTotalPriceChanged != null) {
      widget.onTotalPriceChanged!(_quantity, _totalPrice);
    }
  }


  double get _totalPrice => _quantity * widget.pricePerKg;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 150),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Tham khảo giá:',
            style: TextStyle(
              color: widget.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 4),
          TextField(
            controller: weightController,
            decoration: InputDecoration(
              labelText: 'Kg',
              hintText: 'Nhập kg',
              isDense: true,
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 10,
              ),
            ),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            onChanged: _updateQuantity,
            onSubmitted: _updateQuantity,
          ),

          SizedBox(height: 4),
          Row(
            children: [
              Text("Tổng giá: "),
              CurrencyDisplay(
                price: _totalPrice,
                fontSize: 14,
                iconSize: 16,
              ),
            ],
          ),
        ],
      ),
    );
  }
}