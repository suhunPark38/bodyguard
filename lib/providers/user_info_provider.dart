import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../model/user_model.dart';
import '../services/user_firebase.dart';
import '../services/auth_service.dart';

class UserInfoProvider with ChangeNotifier{
  late Stream<UserInfoModel> user;


  Stream<UserInfoModel> initializeData() {
      return UserFirebase().getUserInfo(uid: Auth().getCurrentUid());
  }

  Widget D(String text){
    return StreamBuilder<UserInfoModel>(
      stream: UserFirebase().getUserInfo(uid: Auth().getCurrentUid()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasData) {
          return SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
              child: Row(
                children: [
                  AutoSizeText(
                    '${snapshot.data!.nickName}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20, color: Colors.deepPurple),
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  ),
                  Text(
                    text,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  )
                ],
              )
          );
        } else {
          return Text('No data available');
        }
      },
    );
  }


}

