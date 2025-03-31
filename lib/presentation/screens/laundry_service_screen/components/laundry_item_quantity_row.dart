import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../widgets/currency_display.dart';

class LaundryItemQuantityRow extends StatefulWidget {
  final dynamic item;
  final Color primaryColor;
  final Function(int) onQuantityChanged;

  const LaundryItemQuantityRow({
    Key? key,
    required this.item,
    required this.primaryColor,
    required this.onQuantityChanged,
  }) : super(key: key);

  @override
  _LaundryItemQuantityRowState createState() => _LaundryItemQuantityRowState();
}

class _LaundryItemQuantityRowState extends State<LaundryItemQuantityRow> {
  late TextEditingController _quantityController;
  int _quantity = 0;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController(text: '0');
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  void _updateQuantity(int newQuantity) {
    setState(() {
      _quantity = newQuantity;
      _quantityController.text = newQuantity.toString();
    });
    widget.onQuantityChanged(newQuantity);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Minus button
        IconButton(
          icon: Icon(Icons.remove_circle_outline, color: widget.primaryColor),
          onPressed: _quantity > 0
              ? () => _updateQuantity(_quantity - 1)
              : null,
        ),

        // Quantity input
        Container(
          width: 50,
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: _quantityController,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(3), // Limit to 3 digits
            ],
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: '0',
              contentPadding: EdgeInsets.zero,
            ),
            onChanged: (value) {
              int? newQuantity = int.tryParse(value);
              if (newQuantity != null) {
                _updateQuantity(newQuantity);
              }
            },
          ),
        ),

        // Plus button
        IconButton(
          icon: Icon(Icons.add_circle_outline, color: widget.primaryColor),
          onPressed: () => _updateQuantity(_quantity + 1),
        ),
      ],
    );
  }
}

// Example of how to use in the main screen
class LaundryServiceItemRow extends StatefulWidget {
  final dynamic item;
  final Color primaryColor;
  final String? serviceType;

  const LaundryServiceItemRow({
    Key? key,
    required this.item,
    required this.primaryColor,
    this.serviceType,
  }) : super(key: key);

  @override
  _LaundryServiceItemRowState createState() => _LaundryServiceItemRowState();
}

class _LaundryServiceItemRowState extends State<LaundryServiceItemRow> {
  int _itemQuantity = 0;
  late double _totalPrice;

  @override
  void initState() {
    super.initState();
    _totalPrice = 0;
  }

  void _updateTotalPrice(int quantity) {
    setState(() {
      _itemQuantity = quantity;
      _totalPrice = (widget.item.pricePerItem ?? 0) * quantity;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.item.name ?? 'Mục Giặt',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  widget.item.description ?? 'Mô tả',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Price display
              widget.item.pricePerItem != null
                  ? Row(
                children: [
                  Text(
                    'Số lượng: ',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  LaundryItemQuantityRow(
                    item: widget.item,
                    primaryColor: widget.primaryColor,
                    onQuantityChanged: _updateTotalPrice,
                  ),
                ],
              )
                  : SizedBox.shrink(),

              // Price and quantity information
              widget.item.pricePerItem != null
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CurrencyDisplay(
                    price: widget.item.pricePerItem,
                    unit: " / cái",
                    fontSize: 16,
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Tổng: ${NumberFormat('#,###', 'vi_VN').format(_totalPrice)} ₫',
                    style: TextStyle(
                      color: widget.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              )
                  : Text(
                'Giá: Liên hệ',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}