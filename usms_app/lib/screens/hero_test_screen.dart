import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:usms_app/models/store_model.dart';
import 'package:usms_app/utils/store_provider.dart';

class ProviderTest extends StatelessWidget {
  const ProviderTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Consumer<StoreProvider>(
        builder: (context, storeProvider, _) {
          List<Store> storeList = storeProvider.storeList;
          return Column(
            children: [
              Center(
                child: SizedBox(
                  height: 600,
                  child: ListView.builder(
                    itemCount: storeList.length,
                    itemBuilder: (context, index) {
                      Store store = storeList[index];
                      return ListTile(
                        title: Text(store.name),
                        subtitle: Text(store.address),
                      );
                    },
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
