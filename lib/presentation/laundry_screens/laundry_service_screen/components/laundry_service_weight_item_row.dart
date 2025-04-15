import 'package:flutter/material.dart';
import 'package:home_clean/data/laundry_repositories/laundry_order_repo.dart';

class LaundryServiceWeightItemRow extends StatefulWidget {
  final dynamic item;
  final Color primaryColor;
  final Function(OrderDetailsRequest) onAddItem;

  const LaundryServiceWeightItemRow({
    Key? key,
    required this.item,
    required this.primaryColor,
    required this.onAddItem,
  }) : super(key: key);

  @override
  _LaundryServiceWeightItemRowState createState() => _LaundryServiceWeightItemRowState();
}

class _LaundryServiceWeightItemRowState extends State<LaundryServiceWeightItemRow> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.item.name ?? 'Dịch vụ không tên',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Giá: ${widget.item.pricePerKg ?? 0} đ/kg',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Checkbox(
            value: _isSelected,
            onChanged: (bool? newValue) {
              setState(() {
                _isSelected = newValue ?? false;
              });

              if (_isSelected) {
                // Add item with just the ID when selected
                widget.onAddItem(OrderDetailsRequest(
                  itemTypeId: widget.item.id,
                  weight: 0,
                  quantity: null,
                ));
              }
            },
            activeColor: widget.primaryColor,
          ),
        ],
      ),
    );
  }
}