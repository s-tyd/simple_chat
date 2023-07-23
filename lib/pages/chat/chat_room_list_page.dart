import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple/repository/rooms_repository.dart';

import 'chat_room_page.dart';

class ChatRoomListPage extends HookConsumerWidget {
  const ChatRoomListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rooms = ref.watch(roomsProvider);
    if (rooms.isEmpty) {
      return const Center(child: Text('No chat rooms'));
    }

    return ListView.builder(
      itemCount: rooms.length,
      itemBuilder: (BuildContext context, int index) {
        final room = rooms[index];
        return ListTile(
          leading: CircleAvatar(child: Text(room.name[0])),
          title: Text(room.name),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => ChatRoomPage(room: room),
              ),
            );
          },
        );
      },
    );
  }
}
