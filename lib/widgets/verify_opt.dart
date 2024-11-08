import 'package:flutter/material.dart';
import 'package:mobilefinalhcmus/widgets/pin_widget.dart';

class VerifyOtp extends StatefulWidget {
  VerifyOtp(
    {
      super.key,
      required this.email,
      required this.style
    }
  );
  String email;
  String style;

  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  bool checkValidate = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          centerTitle: true,
          title: Text(
            "Verify Your Email",
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            width: size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
          
              children: [
                Container(
                  height: 250,
                  width: 250,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 250, 206),
                      shape: BoxShape.circle),
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                       shape: BoxShape.circle),
                    child: Image(image: AssetImage("assets/images/email.png")),
                  ),
                ),
                SizedBox(
                  height: 35,
                ),
                Text("Please Enter The 6 Digit Code Sent To", style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold
                )),
                Text(widget.email,style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold
                )),
                SizedBox(
                  height: 35,
                ),
                PinWidget(
                  email: widget.email,
                  validator: () {
                    setState(() {
                      checkValidate = true;
                    });
                  },
                ),
                SizedBox(
                  height: 35,
                ),
                GestureDetector(
                  onTap: (){

                  },
                  child: Text("Resend code", style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Color(0xFFFE9B6A),
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    decorationThickness: 1,
                    decorationColor: Color(0xFFFE9B6A)
                  ),),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: size.width / 1.5,
                      child: checkValidate ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFFFCE01)
                        ),
                        child:  Text("Continue", style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold
                        ),)
                        ,onPressed: (){
                          if (widget.style == "sign-up"){
                            
                          }
                          else{
                            Navigator.of(context).pushNamed("/forgetpassword/createpassword");
                          }
                        },) : null,
                    )))
          
              ],
            ),
          ),
        ));
  }
}