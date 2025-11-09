import 'package:flutter/material.dart';
import '../models/quote.dart';

class ClientInfoForm extends StatelessWidget {
  final ClientInfo clientInfo;
  final ValueChanged<ClientInfo> onChanged;

  const ClientInfoForm({
    super.key,
    required this.clientInfo,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(
                  Icons.person_outline,
                  color: Theme.of(context).colorScheme.secondary,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  'Client Information',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 24),
            TextFormField(
              initialValue: clientInfo.name,
              decoration: InputDecoration(
                labelText: 'Client Name',
                prefixIcon: Icon(
                  Icons.business,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter client name';
                }
                return null;
              },
              onChanged: (value) {
                onChanged(
                  ClientInfo(
                    name: value,
                    address: clientInfo.address,
                    reference: clientInfo.reference,
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: clientInfo.address,
              decoration: InputDecoration(
                labelText: 'Address',
                alignLabelWithHint: true,
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(bottom: 48),
                  child: Icon(
                    Icons.location_on_outlined,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter client address';
                }
                return null;
              },
              onChanged: (value) {
                onChanged(
                  ClientInfo(
                    name: clientInfo.name,
                    address: value,
                    reference: clientInfo.reference,
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: clientInfo.reference,
              decoration: InputDecoration(
                labelText: 'Reference',
                hintText: 'Quote reference or PO number',
                prefixIcon: Icon(
                  Icons.tag,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              onChanged: (value) {
                onChanged(
                  ClientInfo(
                    name: clientInfo.name,
                    address: clientInfo.address,
                    reference: value,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
