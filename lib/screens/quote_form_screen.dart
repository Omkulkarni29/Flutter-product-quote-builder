import 'package:flutter/material.dart';
import '../models/quote.dart';
import '../widgets/client_info_form.dart';
import '../widgets/line_item_list.dart';

class QuoteFormScreen extends StatefulWidget {
  const QuoteFormScreen({super.key});

  @override
  State<QuoteFormScreen> createState() => _QuoteFormScreenState();
}

class _QuoteFormScreenState extends State<QuoteFormScreen> {
  late Quote _quote;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _quote = Quote(
      clientInfo: ClientInfo(name: '', address: '', reference: ''),
      items: [],
    );
  }

  void _addNewLineItem() {
    setState(() {
      _quote.addItem(
        LineItem(productName: '', quantity: 1, rate: 0.0, taxPercentage: 0.0),
      );
    });
  }

  void _removeLineItem(int index) {
    setState(() {
      _quote.removeItem(index);
    });
  }

  void _toggleTaxMode(bool value) {
    setState(() {
      _quote = Quote(
        clientInfo: _quote.clientInfo,
        items: _quote.items,
        isTaxInclusive: value,
        status: _quote.status,
        createdAt: _quote.createdAt,
        updatedAt: DateTime.now(),
      );
    });
  }

  void _previewQuote() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Navigator.pushNamed(context, '/preview', arguments: _quote);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 900;
    final isPadSize = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Quote',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.visibility),
            onPressed: _previewQuote,
            tooltip: 'Preview Quote',
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isPadSize ? 24.0 : 16.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (isWideScreen)
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            flex: 2,
                            child: ClientInfoForm(
                              clientInfo: _quote.clientInfo,
                              onChanged: (info) {
                                setState(() {
                                  _quote = Quote(
                                    clientInfo: info,
                                    items: _quote.items,
                                    isTaxInclusive: _quote.isTaxInclusive,
                                    status: _quote.status,
                                    createdAt: _quote.createdAt,
                                    updatedAt: DateTime.now(),
                                  );
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: Column(
                              children: [
                                _buildTaxCard(),
                                const SizedBox(height: 24),
                                _buildTotalsCard(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  else ...[
                    ClientInfoForm(
                      clientInfo: _quote.clientInfo,
                      onChanged: (info) {
                        setState(() {
                          _quote = Quote(
                            clientInfo: info,
                            items: _quote.items,
                            isTaxInclusive: _quote.isTaxInclusive,
                            status: _quote.status,
                            createdAt: _quote.createdAt,
                            updatedAt: DateTime.now(),
                          );
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    _buildTaxCard(),
                  ],
                  const SizedBox(height: 24),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Line Items',
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              ElevatedButton.icon(
                                onPressed: _addNewLineItem,
                                icon: const Icon(Icons.add),
                                label: const Text('Add Item'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.secondary,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          LineItemList(
                            items: _quote.items,
                            onItemRemoved: _removeLineItem,
                            onItemChanged: (index, item) {
                              setState(() {
                                _quote.items[index] = item;
                                _quote.updatedAt = DateTime.now();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (!isWideScreen) ...[
                    const SizedBox(height: 24),
                    _buildTotalsCard(),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton:
          isPadSize
              ? null
              : FloatingActionButton(
                onPressed: _previewQuote,
                child: const Icon(Icons.visibility),
              ),
    );
  }

  Widget _buildTaxCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tax Inclusive',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Switch(value: _quote.isTaxInclusive, onChanged: _toggleTaxMode),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Quote Summary',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Subtotal'),
                Text(
                  '\$${_quote.subtotal.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Grand Total', style: TextStyle(fontSize: 18)),
                Text(
                  '\$${_quote.grandTotal.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E88E5),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
