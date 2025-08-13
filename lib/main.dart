import 'package:barbee_hive_app/firebase_options.dart';
import 'package:barbee_hive_app/infrastructure/navigation/bindings/initial_binding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_responsive_ui/my_responsive_ui.dart';

import 'data/api/api_service.dart';
import 'infrastructure/helpers/shared_preference_helper.dart';
import 'infrastructure/navigation/navigation.dart';
import 'infrastructure/navigation/routes.dart';


Future<void> addDummyChats() async {
  final dummyChats = [
    {
      "senderId": "user123",
      "receiverId": "user456",
      "name": "Kyle Crane",
      "profileImage": "https://i.pravatar.cc/150?img=1",
      "updatedAt": DateTime.now(),
      "messages": [
        {
          "senderId": "user123",
          "text": "Hey, I saw your profile!",
          "timestamp": DateTime.now().subtract(const Duration(minutes: 30)),
        },
        {
          "senderId": "user456",
          "text": "Oh, thanks! What did you have in mind?",
          "timestamp": DateTime.now().subtract(const Duration(minutes: 20)),
        },
        {
          "senderId": "user123",
          "text": "I think you'd be great for this position.",
          "timestamp": DateTime.now().subtract(const Duration(minutes: 10)),
        },
      ]
    },
    {
      "senderId": "user789",
      "receiverId": "user456",
      "name": "Jade Nguyen",
      "profileImage": "https://i.pravatar.cc/150?img=2",
      "updatedAt": DateTime.now().subtract(const Duration(minutes: 15)),
      "messages": [
        {
          "senderId": "user789",
          "text": "Hello, are you available?",
          "timestamp": DateTime.now().subtract(const Duration(hours: 1)),
        },
        {
          "senderId": "user456",
          "text": "Yes, what's up?",
          "timestamp": DateTime.now().subtract(const Duration(minutes: 50)),
        },
        {
          "senderId": "user789",
          "text": "Can we schedule an interview for tomorrow?",
          "timestamp": DateTime.now().subtract(const Duration(minutes: 15)),
        },
      ]
    },
    {
      "senderId": "user555",
      "receiverId": "user456",
      "name": "Rahul Sharma",
      "profileImage": "https://i.pravatar.cc/150?img=3",
      "updatedAt": DateTime.now().subtract(const Duration(hours: 1)),
      "messages": [
        {
          "senderId": "user555",
          "text": "Hi, I saw your project work.",
          "timestamp": DateTime.now().subtract(const Duration(hours: 3)),
        },
        {
          "senderId": "user456",
          "text": "Thanks! Did you like it?",
          "timestamp": DateTime.now().subtract(const Duration(hours: 2, minutes: 45)),
        },
        {
          "senderId": "user555",
          "text": "Yes, please share your portfolio link.",
          "timestamp": DateTime.now().subtract(const Duration(hours: 1)),
        },
      ]
    },
  ];

  for (var chat in dummyChats) {
    final senderId = chat["senderId"];
    final receiverId = chat["receiverId"];
    final docId = "$senderId-$receiverId"; // custom doc ID

    await FirebaseFirestore.instance
        .collection('chats')
        .doc(docId)
        .set(chat);
  }

  print("✅ Dummy chats with inline messages added using custom IDs");
}


// Future<void> addDummyChats() async {
//   final dummyChats = [
//     {
//       "senderId": "user123",
//       "receiverId": "user456",
//       "name": "Kyle Crane",
//       "lastMessage": "Hey, I saw your profile and found you suitable for this position",
//       "profileImage": "https://i.pravatar.cc/150?img=1",
//       "updatedAt": DateTime.now(),
//     },
//     {
//       "senderId": "user789",
//       "receiverId": "user456",
//       "name": "Jade Nguyen",
//       "lastMessage": "Can we schedule an interview for tomorrow?",
//       "profileImage": "https://i.pravatar.cc/150?img=2",
//       "updatedAt": DateTime.now().subtract(const Duration(minutes: 15)),
//     },
//     {
//       "senderId": "user555",
//       "receiverId": "user456",
//       "name": "Rahul Sharma",
//       "lastMessage": "Please share your portfolio link",
//       "profileImage": "https://i.pravatar.cc/150?img=3",
//       "updatedAt": DateTime.now().subtract(const Duration(hours: 1)),
//     },
//   ];
//
//   for (var chat in dummyChats) {
//     final senderId = chat["senderId"];
//     final receiverId = chat["receiverId"];
//     final docId = "$senderId-$receiverId"; // Custom document ID
//
//     await FirebaseFirestore.instance
//         .collection('chats')
//         .doc(docId) // set custom ID instead of auto-generate
//         .set(chat);
//   }
//   print("✅ Dummy chats added with custom IDs");
// }


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await addDummyChats();

  var initialRoute = await Routes.initialRoute;
  await ApiService.initToken();
  await SharedPreferenceHelper.init();

  runApp(Main(initialRoute));



}

class Main extends StatelessWidget {
  final String initialRoute;

  const Main(this.initialRoute, {super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveInitializer(
      baseHeight: 956,
      baseWidth: 440,
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Inter',
          textTheme: TextTheme(
            bodyLarge: TextStyle(fontSize: 16.0),
            titleLarge: TextStyle(fontWeight: FontWeight.bold),
            titleSmall: TextStyle(fontSize: 16.0),
          ),
        ),
        initialRoute: initialRoute,
        getPages: Nav.routes,
        initialBinding: InitialBindings(),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }
}
