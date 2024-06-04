import 'package:flutter/material.dart';
import 'package:mobilefinalhcmus/feature/auth/providers/auth_provider.dart';
import 'package:provider/provider.dart';

enum ButtonType{
  NORMAL,
  VALIDATE_TOKEN
}

class FeatureOfProfile extends StatelessWidget{
  String titleOfFeature;
  void Function(String? token)? callback;
  ButtonType? type = ButtonType.NORMAL;
  BuildContext context;
  FeatureOfProfile(
    {
      super.key,
      required this.context,
      required this.titleOfFeature,
      this.callback,
      this.type
    }
  );

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      decoration: BoxDecoration(
        color: Colors.white
      ),
      child: ListTile(
        onTap: (){
          if (type == ButtonType.VALIDATE_TOKEN){
            final token = context.read<AuthenticateProvider>().token;
            callback!(token);
          }
        },
        title: Text(titleOfFeature,style: Theme.of(context).textTheme.bodyMedium,),
        trailing: Icon(Icons.arrow_forward_ios_outlined ),
      ),
    );
  }
}
