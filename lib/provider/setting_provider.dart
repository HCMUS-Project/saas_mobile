import 'package:flutter/material.dart';
import 'package:mobilefinalhcmus/helper/app_localization.dart';

class SettingsProvider extends ChangeNotifier{

  bool _isVisible = false;
  bool get isVisible => _isVisible;

  //Strong password requirement
  RegExp strongPassword = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$&*~]).{8,}$');

  //Validated Email format
  RegExp emailRequirement = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  //General Validator
  validator(String value, String message){
    if(value.isEmpty){
      return message;
    }else{
      return null;
    }
  }


  //Phone number validator
  phoneValidator(String value){
    if(value.isEmpty){
      return "Phone is required";
    }else if(value.length < 8 || value.length > 10 ){
      return "Phone number is not valid";
    }else {
      return null;
    }
  }

  //Strong password requirement
  /*
  1. must have a small letter
  2. must have a capital letter
  3. must have a digit or number
  4. contain a special character
  5. minimum 8 character long
   */

  //Password validator | Strong password
  passwordValidator(String value, BuildContext context){
    if(value.isEmpty){
      return AppLocalizations.of(context)!.translate('requiredFillPassword')!;
    }else if(!strongPassword.hasMatch(value)){
    return AppLocalizations.of(context)!.translate('checkStrongPassword')!;
    }else{
      return null;
    }
  }

  //Confirm password
  confirmPass(String value1, String value2){
    if(value1.isEmpty){
      return "Re-enter your password";
    }else if(value1 != value2){
      return "Passwords don't match";
    }else{
      return null;
    }
  }

  //Note | If you don't want any text field as required | remove the value.isEmpty condition
  //Email validator
  emailValidator(String value, BuildContext context){
    if(value.isEmpty){
      return AppLocalizations.of(context)!.translate('requiredFillEmail')!;
    }else if(!emailRequirement.hasMatch(value)){
      return AppLocalizations.of(context)!.translate('checkValidEmail')!;
    }else{
      return null;
    }
  }

  usernameValidator(String value, BuildContext context){
    if(value.isEmpty){
      return AppLocalizations.of(context)!.translate('requiredFillUsername')!;
    }else{
      return null;
    }
  }
  //Password show & hide
  void showHidePassword(){
    _isVisible =! _isVisible;
    notifyListeners();
  }

  //SnackBar Message
  showSnackBar(String message,context){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(message))
    );
  }

}