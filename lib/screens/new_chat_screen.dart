import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../core/model/user_credentials.dart';
import '../core/repos/app_preferences.dart';
import '../core/repos/token_service.dart';
import '../di/injector.dart';
import 'channel_screen.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({Key? key}) : super(key: key);

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  late final StreamChatClient client;
  late final StreamUserListController userListController;
  late final AppPreferences prefs;
  late final UserCredentials credentials;

  @override
  void initState() {
    super.initState(); // Call `super.initState` first as a best practice
    prefs = locator.get<AppPreferences>();
    credentials = prefs.userCredentials!;
    client = StreamChatCore.of(context).client;
    userListController = StreamUserListController(
      client: client,
      limit: 20,
      filter: Filter.notEqual('id', credentials.userInfo.id),
    );
    userListController.doInitialLoad();
    // connectUserTest().then((_) {
    //   userListController.doInitialLoad();
    // }).catchError((error) {
    //   // Handle or log error if user connection fails
    //   print("Error connecting user: $error");
    // });
  }

  Future<void> connectUserTest() async {
    try {
      final tokenResponse = await locator
          .get<TokenService>()
          .loadToken(userId: credentials.userInfo.id);
      final token = tokenResponse.token;
      // ignore: use_build_context_synchronously

      await client.connectUser(
        OwnUser(
          id: credentials.userInfo.id,
        ),
        token,
      );
    } catch (error) {
      // Handle connection error
      print("Failed to connect user: $error");
      throw error; // Rethrow if you need to catch it outside
    }
  }

  @override
  void dispose() {
    userListController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: PagedValueListenableBuilder<int, User>(
        valueListenable: userListController,
        builder: (context, value, child) {
          return value.when(
            (users, nextPageKey, error) {
              if (users.isEmpty) {
                return const Center(child: Text('There are no users'));
              }
              return LazyLoadScrollView(
                onEndOfPage: () async {
                  if (nextPageKey != null) {
                    userListController.loadMore(nextPageKey);
                  }
                },
                child: ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    return _ContactTile(user: users[index]);
                  },
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e) => Text(e.message),
          );
        },
      ),
    );
  }
}

class _ContactTile extends StatefulWidget {
  const _ContactTile({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  State<_ContactTile> createState() => _ContactTileState();
}

class _ContactTileState extends State<_ContactTile> {
  Future<void> createChannel(BuildContext context) async {
    // final core = StreamChatCore.of(context);
    final prefs = locator.get<AppPreferences>();
    final credentials = prefs.userCredentials;
    final StreamChatClient client = locator.get();
    final nav = Navigator.of(context);
    final members = [credentials!.userInfo.id, widget.user.id];
    final channel =
        client.channel('messaging', extraData: {'members': members});
    await channel.watch();

    // ignore: use_build_context_synchronously
    if (Navigator.of(context).canPop()) {
      // ignore: use_build_context_synchronously
      context.pop();
    }

    // ignore: use_build_context_synchronously
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StreamChannel(
            channel: channel,
            child: ChannelPage(
              selectedMembers: members,
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        createChannel(context);
      },
      child: ListTile(
        leading: const Icon(Icons.person),
        title: Text(widget.user.name),
      ),
    );
  }
}
