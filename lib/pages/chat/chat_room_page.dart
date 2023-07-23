import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:simple/model/message/message.dart';
import 'package:simple/model/room/room.dart';
import 'package:simple/providers/firebase.dart';

import '../member_list_page.dart';

class ChatRoomPage extends HookConsumerWidget {
  const ChatRoomPage({super.key, required this.room});

  final Room room;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageController = useTextEditingController();
    final auth = ref.read(firebaseAuthProvider);
    final focusNode = useFocusNode();
    final isEnableTextField = useState(false);
    final scrollController = useScrollController();

    useEffect(
      () {
        void onFocusChange() {
          isEnableTextField.value = focusNode.hasFocus;
          if (focusNode.hasFocus) {
            scrollController.jumpTo(scrollController.position.maxScrollExtent);
            messageController.selection = TextSelection.fromPosition(
              TextPosition(offset: messageController.text.length),
            );
          }
        }

        focusNode.addListener(onFocusChange);
        return () => focusNode.removeListener(onFocusChange);
      },
      [focusNode],
    );

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(room.name),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.group),
              tooltip: 'Members',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => MemberListPage(room: room),
                  ),
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('rooms/${room.id}/messages')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (
                  BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot,
                ) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return ListView(
                    controller: scrollController,
                    reverse: true,
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      final message = Message.fromJson(
                        document.data()! as Map<String, dynamic>,
                      );
                      final isOwnMessage =
                          message.userId == auth.currentUser!.uid;

                      final formattedTime =
                          DateFormat('hh:mm').format(message.createdAt!);

                      return ListTile(
                        title: Align(
                          alignment: isOwnMessage
                              ? Alignment.topRight
                              : Alignment.topLeft,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isOwnMessage ? Colors.blue : Colors.grey,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              message.context,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        subtitle: Align(
                          alignment: isOwnMessage
                              ? Alignment.bottomRight
                              : Alignment.bottomLeft,
                          child: Text(formattedTime),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  children: [
                    TextField(
                      focusNode: focusNode,
                      controller: messageController,
                      maxLines: isEnableTextField.value ? 10 : 1,
                      minLines: 1,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        hintText: 'Enter your message',
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                    if (isEnableTextField.value)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: _chooseImage,
                            icon: const Icon(Icons.image),
                          ),
                          IconButton(
                            onPressed: () =>
                                _sendMessage(auth, messageController, room),
                            icon: const Icon(Icons.send),
                          ),
                        ],
                      )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _chooseImage() async {}

  Future<void> _sendMessage(
    FirebaseAuth auth,
    TextEditingController controller,
    Room room,
  ) async {
    final text = controller.text;
    if (text.isEmpty) {
      return;
    }

    await FirebaseFirestore.instance
        .collection('rooms/${room.id}/messages')
        .add({
      'context': text,
      'createdAt': Timestamp.now(),
      'userId': auth.currentUser!.uid,
    });

    controller.clear();
  }
}
