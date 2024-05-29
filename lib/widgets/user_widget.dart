import 'package:auto_size_text/auto_size_text.dart';
import 'package:bodyguard/providers/user_info_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


Widget userIDTitle(BuildContext context, String text){
  return SizedBox(
    //height: MediaQuery.of(context).size.height * 0.05,
    child: Row(
      children: [
        AutoSizeText(
          '${Provider.of<UserInfoProvider>(context).info?.nickName}',
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.deepPurple),
          overflow: TextOverflow.ellipsis,
          softWrap: false,
        ),
        Text(
          text,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20),
          overflow: TextOverflow.ellipsis,
          softWrap: false,
        )
      ],
    )
  );
}