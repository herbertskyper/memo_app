import 'main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var appState = context.watch<MyAppState>();

    if (appState.history1.isEmpty) {
      return Center(
        child: Text('No history yet.'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(50),
          child: Text('You have '
              '${appState.history2.length} history:'),
        ),
        Expanded(
          // Make better use of wide windows with a grid.
          child: ListView(
            // gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            //   maxCrossAxisExtent: 400,
            //   childAspectRatio: 400 / 80,
            // ),
            children: [
              for (var value in appState.history2)
                ListTile(
                  leading: IconButton(
                    icon: Icon(Icons.delete_outline, semanticLabel: 'Delete'),
                    color: theme.colorScheme.primary,
                    onPressed: () {
                      appState.removeHistory(value);
                      if(appState.favorites.contains(value)){
                        appState.removeFavorite(value);
                      }
                    },
                  ),
                  title: SelectableText(
                    value,
                    semanticsLabel: value,
                  ),
                  trailing: IconButton(
                      icon: Icon(Icons.undo, semanticLabel: 'Undo'),
                      color: theme.colorScheme.primary,
                      onPressed: () {
                        appState.recoverHistory(value);
                        //appState.removeFavorite(pair);
                      }),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
