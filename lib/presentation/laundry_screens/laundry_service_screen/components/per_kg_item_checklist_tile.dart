import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PerKgItemChecklistTile extends StatefulWidget {
  final dynamic item;
  final Color primaryColor;
  final Function(dynamic item, bool? isSelected) onItemToggle;
  final Function(dynamic item, int quantity) onQuantityChanged;

  const PerKgItemChecklistTile({
    Key? key,
    required this.item,
    required this.primaryColor,
    required this.onItemToggle,
    required this.onQuantityChanged,
  }) : super(key: key);

  @override
  _PerKgItemChecklistTileState createState() => _PerKgItemChecklistTileState();
}

class _PerKgItemChecklistTileState extends State<PerKgItemChecklistTile> {
  bool _isSelected = false;
  int _quantity = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: _isSelected
            ? widget.primaryColor.withOpacity(0.1)
            : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: CheckboxListTile(
        title: Text(
          widget.item.name ?? 'Mục Dịch Vụ',
          style: TextStyle(
            color: _isSelected ? widget.primaryColor : Colors.black87,
            fontWeight: _isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Giá: ${widget.item.pricePerKg?.toString() ?? 'Chưa xác định'} đ/kg',
              style: TextStyle(
                color: _isSelected ? widget.primaryColor : Colors.grey[700],
              ),
            ),
            if (_isSelected)
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.remove_circle_outline, color: widget.primaryColor),
                    onPressed: _quantity > 0
                        ? () {
                      setState(() {
                        _quantity--;
                        widget.onQuantityChanged(widget.item, _quantity);
                      });
                    }
                        : null,
                  ),
                  Text(
                    '$_quantity kg',
                    style: TextStyle(
                      color: widget.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add_circle_outline, color: widget.primaryColor),
                    onPressed: () {
                      setState(() {
                        _quantity++;
                        widget.onQuantityChanged(widget.item, _quantity);
                      });
                    },
                  ),
                ],
              ),
          ],
        ),
        value: _isSelected,
        onChanged: (bool? newValue) {
          setState(() {
            _isSelected = newValue ?? false;
            _quantity = _isSelected ? 1 : 0;
            widget.onItemToggle(widget.item, _isSelected);
            widget.onQuantityChanged(widget.item, _quantity);
          });
        },
        activeColor: widget.primaryColor,
        checkColor: Colors.white,
        controlAffinity: ListTileControlAffinity.trailing,
      ),
    );
  }
}

// Existing widget for per-item pricing
class LaundryServiceItemRow extends StatelessWidget {
  final dynamic item;
  final Color primaryColor;
  final String? serviceType;
  final Function(dynamic item, bool? isSelected)? onAddItem;

  const LaundryServiceItemRow({
    Key? key,
    required this.item,
    required this.primaryColor,
    this.serviceType,
    this.onAddItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Existing implementation for per-item pricing
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(
          item.name ?? 'Mục Dịch Vụ',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          'Giá: ${item.pricePerItem?.toString() ?? 'Chưa xác định'} đ/cái',
          style: TextStyle(
            color: Colors.grey[700],
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.add_circle_outline),
          color: primaryColor,
          onPressed: () {
            onAddItem?.call(item, true);
          },
        ),
      ),
    );
  }
}