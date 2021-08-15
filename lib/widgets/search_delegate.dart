import 'package:flutter/material.dart';
import 'package:gossip/database/index.dart';
import 'package:gossip/mock/user_model.dart';

class MainSearchDelegate extends SearchDelegate<String?> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      CloseButton(onPressed: () {
        query = '';
      })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return BackButton(
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<FirestoreUser>>(
      future: Database.instance.searchUserByEmail(query),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.done:
            if (!snapshot.hasData) {
              print(snapshot.error);
              return Center(child: CircularProgressIndicator());
            }
            final users = snapshot.data!;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, i) {
                final user = users[i];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user.photoUrl!),
                    backgroundColor: Colors.blue,
                  ),
                  title: Text(user.displayName ?? user.email),
                  onTap: () async {
                    try {
                      final convId =
                          await Database.instance.addConversation([user.id]);
                      close(context, convId);
                    } catch (e) {
                      print(e);
                    }
                  },
                );
              },
            );
          default:
            return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return SizedBox();
  }
}
