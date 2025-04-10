import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_clean/presentation/laundry_screens/laundry_service_screen/components/price_input.dart';
import 'package:intl/intl.dart';
import '../../../../data/laundry_repositories/laundry_order_repo.dart';
import '../../../widgets/currency_display.dart';

class LaundryItemQuantityRow extends StatefulWidget {
  final dynamic item;
  final Color primaryColor;
  final Function(int) onQuantityChanged;
  final Function(double)? onTotalPriceChanged;


  const LaundryItemQuantityRow({
    Key? key,
    required this.item,
    required this.primaryColor,
    required this.onQuantityChanged,
    this.onTotalPriceChanged,
  }) : super(key: key);

  @override
  _LaundryItemQuantityRowState createState() => _LaundryItemQuantityRowState();
}

class _LaundryItemQuantityRowState extends State<LaundryItemQuantityRow> {
  late TextEditingController _quantityController;
  late TextEditingController _weightController;
  int _quantity = 0;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController(text: '0');
    _weightController = TextEditingController(text: '0');
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _weightController.dispose();
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
          onPressed:
              _quantity > 0 ? () => _updateQuantity(_quantity - 1) : null,
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
class LaundryServiceItemRow extends StatefulWidget {
  final dynamic item;
  final Color primaryColor;
  final String? serviceType;
  final Function(OrderDetailsRequest) onAddItem;

  const LaundryServiceItemRow({
    Key? key,
    required this.item,
    required this.primaryColor,
    this.serviceType,
    required this.onAddItem,
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

  // Hàm xử lý khi có giá theo item
  void _updateTotalPriceByItem(int quantity) {
    setState(() {
      _itemQuantity = quantity;
      _totalPrice = (widget.item.pricePerItem ?? 0) * quantity;
    });

    OrderDetailsRequest orderDetailsRequest = OrderDetailsRequest(
      itemTypeId: widget.item.id,
      quantity: _itemQuantity,
    );
    widget.onAddItem(orderDetailsRequest);
  }

  // Hàm xử lý khi tính giá theo kg
  void _updateTotalPriceByWeight(double weight, double totalPrice) {
    setState(() {
      _totalPrice = totalPrice;
    });

    OrderDetailsRequest orderDetailsRequest = OrderDetailsRequest(
      itemTypeId: widget.item.id,
      weight: weight,
    );
    widget.onAddItem(orderDetailsRequest);
  }


  // Layout khi có giá theo item
  Widget _buildItemPriceLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
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
              onQuantityChanged: _updateTotalPriceByItem,
            ),
          ],
        ),
        SizedBox(height: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CurrencyDisplay(
              price: widget.item.pricePerItem,
              unit: " / cái",
              fontSize: 16,
            ),
            SizedBox(height: 4),
            CurrencyDisplay(
              price: _totalPrice,
              fontSize: 16,
            ),
          ],
        ),
      ],
    );
  }

  // Layout khi tính giá theo kg
  Widget _buildWeightPriceLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        PriceInputComponent(
          primaryColor: widget.primaryColor,
          pricePerKg: widget.item.pricePerKg ?? 0,
          initialWeight: 0,
          onTotalPriceChanged: (kg, total) {
            _updateTotalPriceByWeight(kg, total);
          },
        ),
      ],
    );
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              widget.item.pricePerItem != null
                  ? _buildItemPriceLayout()
                  : _buildWeightPriceLayout(),
            ],
          ),
        ],
      ),
    );
  }
}