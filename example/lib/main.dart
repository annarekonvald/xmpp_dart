import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:console/console.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as image;
import 'package:xmpp_stone/src/logger/Log.dart';
import 'package:xmpp_stone/xmpp_stone.dart' as xmpp;

const String tag = 'example';

const userId = "070466d3-a699-4f0b-a506-4f9bc11fef6c";
const password =
    "eyJraWQiOiJDXC9iM0hEbFppQlVyOXVnWmZIV2hlaU5jY3Y1K25QWll2dUlxSEtiNVllMD0iLCJhbGciOiJSUzI1NiJ9.eyJzdWIiOiIwNzA0NjZkMy1hNjk5LTRmMGItYTUwNi00ZjliYzExZmVmNmMiLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwiaXNzIjoiaHR0cHM6XC9cL2NvZ25pdG8taWRwLnVzLWVhc3QtMS5hbWF6b25hd3MuY29tXC91cy1lYXN0LTFfTHI3WExEYkpxIiwiY29nbml0bzp1c2VybmFtZSI6IjA3MDQ2NmQzLWE2OTktNGYwYi1hNTA2LTRmOWJjMTFmZWY2YyIsImN1c3RvbTp0ZW5hbnRfaWQiOiIxIiwiZ2l2ZW5fbmFtZSI6ImFubmEiLCJvcmlnaW5fanRpIjoiZmYyN2IzZDctYjQ4OC00NDQ0LTk5N2UtZDYwZjZhMzNhYmJlIiwiYXVkIjoiNmxuMHQ1Nm1nOWdwbzZiMjB0MWc3cGc0aiIsImV2ZW50X2lkIjoiMWQ5OWI2ZTQtODgyNS00Y2IyLTg0MTYtOWIwYjc2NmU1ZTdhIiwidG9rZW5fdXNlIjoiaWQiLCJhdXRoX3RpbWUiOjE2NDYzNDA0NTIsIm5hbWUiOiJhbm5hIiwiY3VzdG9tOmFjY291bnRfaWQiOiJlZjJkMWI2NS1hYWY0LTRlY2UtODdkNi1lMzM0MWYxNWU0NTciLCJleHAiOjE2NDY0MjY4NTIsImlhdCI6MTY0NjM0MDQ1MiwiZmFtaWx5X25hbWUiOiJyZWtvIiwianRpIjoiNDE2YjAwYTgtMzExMC00ZjM1LWI1MDUtMTNkNzU1N2QwYzBiIiwiZW1haWwiOiJhbm5hLnJla29udmFsZEBnbG9iYWxsb2dpYy5jb20ifQ.WbNV4RXTt9wX7exyUj44rCAb4GH8WO7YJ0dtjNXlyOYe4NLc4BUzQpu2OjZcBcuoYYTYkCX7z7sOYf2gGm_iAlnK3aI-5szZvGn6NySjCvz5PEN6JRFBKKLZBdx5_Ua461CoU9gg66P9z4y4S1WV4pvJdLn9FzTjA67iS01FlqhR4sK26tVPm6hbS_3DcCq58Rmix6XBlsex6bIfGlkuIfV8619mFp1J16l4GieJ8yfmX7JJBChGaS5wNwvyZ2KsMi7xUdhhxEos1LH6y22RSzzfP1iTulABk_DL8vZUx97Zf4DqFyGoyKJGsq390pFfK9O8ebcGTQSKaOp2VjO_ww";
const hostname = "44.195.135.101"; // saas-msg.visionable.one
const protocol = "wss";
const int port = 5222; // 5443
const endpoint = "http-bind";

//wss://saas-msg.visionable.one:5443/ws-xmpp
//wss://saas-msg.visionable.one:5443/http-bind
void main(List<String> arguments) {
  /*getConsoleStream().asBroadcastStream().listen((String str) {
    messageHandler.sendMessage(receiverJid, str);
  });*/
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Log.logLevel = LogLevel.DEBUG;
    Log.logXmpp = true;
    var userAtDomain = '$userId@$hostname';
    var jid = xmpp.Jid.fromFullJid(userAtDomain);
    var account = xmpp.XmppAccountSettings(userAtDomain, jid.local, jid.domain, password, port,
        // host: "$protocol://$hostname:$port/$endpoint",
        resource: endpoint);
    var connection = xmpp.Connection(account);
    connection.connect();

    /* xmpp.MessagesListener messagesListener = ExampleMessagesListener();
    ExampleConnectionStateChangedListener(connection, messagesListener);
    var presenceManager = xmpp.PresenceManager.getInstance(connection);
    presenceManager.subscriptionStream.listen((streamEvent) {
      if (streamEvent.type == xmpp.SubscriptionEventType.REQUEST) {
        Log.d(tag, 'Accepting presence request');
        presenceManager.acceptSubscription(streamEvent.jid);
      }
    });
    var receiver = '070466d3-a699-4f0b-a506-4f9bc11fef6c@saas-msg.visionable.one';
    //var receiver = '9e59568d-81ed-4e06-9c2b-5b596cca835e@saas-msg.visionable.one';
    var receiverJid = xmpp.Jid.fromFullJid(receiver);*/

    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Welcome to Flutter'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              var messageHandler = xmpp.MessageHandler.getInstance(connection);
              // messageHandler.sendMessage(receiverJid, "Ola");
            },
            child: const Text('just send'),
          ),
        ),
      ),
    );
  }
}

class ExampleConnectionStateChangedListener implements xmpp.ConnectionStateChangedListener {
  late xmpp.Connection _connection;
  late xmpp.MessagesListener _messagesListener;

  late StreamSubscription<String> subscription;

  ExampleConnectionStateChangedListener(xmpp.Connection connection, xmpp.MessagesListener messagesListener) {
    _connection = connection;
    _messagesListener = messagesListener;
    _connection.connectionStateStream.listen(onConnectionStateChanged);
  }

  @override
  void onConnectionStateChanged(xmpp.XmppConnectionState state) {
    if (state == xmpp.XmppConnectionState.Ready) {
      Log.d(tag, 'Connected');
      var vCardManager = xmpp.VCardManager(_connection);
      vCardManager.getSelfVCard().then((vCard) {
        if (vCard != null) {
          Log.d(tag, 'Your info' + vCard.buildXmlString());
        }
      });
      var messageHandler = xmpp.MessageHandler.getInstance(_connection);
      var rosterManager = xmpp.RosterManager.getInstance(_connection);
      messageHandler.messagesStream.listen(_messagesListener.onNewMessage);
      sleep(const Duration(seconds: 1));
      var receiver = 'nemanja2@test';
      var receiverJid = xmpp.Jid.fromFullJid(receiver);
      rosterManager.addRosterItem(xmpp.Buddy(receiverJid)).then((result) {
        if (result.description != null) {
          Log.d(tag, 'add roster' + result.description!);
        }
      });
      sleep(const Duration(seconds: 1));
      vCardManager.getVCardFor(receiverJid).then((vCard) {
        if (vCard != null) {
          Log.d(tag, 'Receiver info' + vCard.buildXmlString());
          if (vCard != null && vCard.image != null) {
            var file = File('test456789.jpg')..writeAsBytesSync(image.encodeJpg(vCard.image!));
            Log.d(tag, 'IMAGE SAVED TO: ${file.path}');
          }
        }
      });
      var presenceManager = xmpp.PresenceManager.getInstance(_connection);
      presenceManager.presenceStream.listen(onPresence);
    }
  }

  void onPresence(xmpp.PresenceData event) {
    var fullJid2 = event.jid?.fullJid;
    Log.d(tag, 'presence Event from ' + fullJid2! + ' PRESENCE: ' + event.showElement.toString());
  }
}

Stream<String> getConsoleStream() {
  return Console.adapter.byteStream().map((bytes) {
    var str = ascii.decode(bytes);
    str = str.substring(0, str.length - 1);
    return str;
  });
}

class ExampleMessagesListener implements xmpp.MessagesListener {
  @override
  void onNewMessage(xmpp.MessageStanza? message) {
    if (message?.body != null) {
      Log.d(
          tag,
          format(
              'New Message from {color.blue}${message!.fromJid!.userAtDomain}{color.end} message: {color.red}${message.body}{color.end}'));
    }
  }
}

/*

To get accessToken

test js
https://github.com/visionable-public/xmpp-test-app

@override
Future<bool> isAuthenticated() async {
  final authSession = await Amplify.Auth.fetchAuthSession(
    options: CognitoSessionOptions(getAWSCredentials: true),
  );

  final auth = (authSession as CognitoAuthSession).userPoolTokens;

  var accessToken = auth?.accessToken ?? "";
  var idToken = auth?.idToken ?? "";
  var refreshToken = auth?.refreshToken ?? "";

  var user = await Amplify.Auth.getCurrentUser();
  print("user id " + user.userId);

  print('auth.accessToken ' + accessToken);
  print('auth.idToken ' + idToken);
  print('auth.refreshToken ' + refreshToken);
  return authSession.isSignedIn;
}*/
