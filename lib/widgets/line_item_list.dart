import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/quote.dart';

class LineItemList extends StatelessWidget {
  final List<LineItem> items;
  final Function(int) onItemRemoved;
  final Function(int, LineItem) onItemChanged;

  const LineItemList({
    super.key,
    required this.items,
    required this.onItemRemoved,
    required this.onItemChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (items.isEmpty)
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.add_shopping_cart,
                    size: 48,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No items added yet',
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ...items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: Theme.of(context).colorScheme.secondary,
                    width: 4,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.secondary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.inventory_2_outlined,
                                size: 16,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Item ${index + 1}',
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => onItemRemoved(index),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.red.shade50,
                            foregroundColor: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: item.productName,
                      decoration: InputDecoration(
                        labelText: 'Product/Service Name',
                        prefixIcon: Icon(
                          Icons.shopping_bag_outlined,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter product name';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        onItemChanged(
                          index,
                          LineItem(
                            productName: value,
                            quantity: item.quantity,
                            rate: item.rate,
                            discount: item.discount,
                            taxPercentage: item.taxPercentage,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: item.quantity.toString(),
                            decoration: InputDecoration(
                              labelText: 'Quantity',
                              prefixIcon: Icon(
                                Icons.numbers,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              final quantity = int.tryParse(value);
                              if (quantity == null || quantity <= 0) {
                                return 'Invalid';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              final quantity = int.tryParse(value) ?? 0;
                              onItemChanged(
                                index,
                                LineItem(
                                  productName: item.productName,
                                  quantity: quantity,
                                  rate: item.rate,
                                  discount: item.discount,
                                  taxPercentage: item.taxPercentage,
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            initialValue: item.rate.toString(),
                            decoration: InputDecoration(
                              labelText: 'Rate',
                              prefixText: '\$ ',
                              prefixIcon: Icon(
                                Icons.attach_money,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^\d*\.?\d{0,2}'),
                              ),
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              final rate = double.tryParse(value);
                              if (rate == null || rate < 0) {
                                return 'Invalid';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              final rate = double.tryParse(value) ?? 0;
                              onItemChanged(
                                index,
                                LineItem(
                                  productName: item.productName,
                                  quantity: item.quantity,
                                  rate: rate,
                                  discount: item.discount,
                                  taxPercentage: item.taxPercentage,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: item.discount?.toString() ?? '',
                            decoration: InputDecoration(
                              labelText: 'Discount (Optional)',
                              prefixText: '\$ ',
                              prefixIcon: Icon(
                                Icons.discount_outlined,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^\d*\.?\d{0,2}'),
                              ),
                            ],
                            onChanged: (value) {
                              final discount = double.tryParse(value);
                              onItemChanged(
                                index,
                                LineItem(
                                  productName: item.productName,
                                  quantity: item.quantity,
                                  rate: item.rate,
                                  discount: discount,
                                  taxPercentage: item.taxPercentage,
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            initialValue: item.taxPercentage.toString(),
                            decoration: InputDecoration(
                              labelText: 'Tax %',
                              suffixText: '%',
                              prefixIcon: Icon(
                                Icons.percent,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^\d*\.?\d{0,2}'),
                              ),
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              final tax = double.tryParse(value);
                              if (tax == null || tax < 0 || tax > 100) {
                                return 'Invalid';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              final tax = double.tryParse(value) ?? 0;
                              onItemChanged(
                                index,
                                LineItem(
                                  productName: item.productName,
                                  quantity: item.quantity,
                                  rate: item.rate,
                                  discount: item.discount,
                                  taxPercentage: tax,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Item Total'),
                          Text(
                            '\$${item.subtotal.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}
