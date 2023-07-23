import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple/components/user_list_tile.dart';
import 'package:simple/model/user_data/user_data.dart';
import 'package:simple/pages/settings/profile_page.dart';
import 'package:simple/repository/friends_repository.dart';
import 'package:simple/repository/user_data_repository.dart';

class FriendsPage extends HookConsumerWidget {
  const FriendsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _scrollController = useMemoized(ScrollController.new, []);
    final friends = ref.watch(friendsProvider);
    final user = ref.watch(userDataProvider);

    useEffect(
      () {
        _scrollController.addListener(() {
          if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent) {}
        });

        return _scrollController.dispose;
      },
      [],
    );

    return ListView.builder(
      controller: _scrollController,
      itemCount: friends.length + 1,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        if (index == 0) {
          return _MyUserCard(user: user);
        }
        final friend = friends[index - 1];
        return UserListTile(user: friend);
      },
    );
  }
}

class _MyUserCard extends StatelessWidget {
  const _MyUserCard({required this.user});

  final UserData user;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Card(child: UserListTile(user: user)),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (context) => const ProfilePage(),
          ),
        );
      },
    );
  }
}
