import 'dart:async';

import 'package:app/PasswordResetpage.dart';
import 'package:app/components/my_button.dart';
import 'package:app/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpValidation extends StatefulWidget {
  OtpValidation({super.key, required this.text});
  String text;
  

  @override
  State<OtpValidation> createState() => _OtpValidationPageState(text: text);
}

class _OtpValidationPageState extends State<OtpValidation> {
  _OtpValidationPageState({required this.text});

  bool isButtonDisabled = true;
  
  Color color = Color(0xffA9A5Af);
  
  @override
  void initState() {
    super.initState();
    startTimer();
    if(myDuration == 0)
    {
      color = Color(0xff9766D5);
    }
  }

   @override
  void dispose() {
    countdownTimer!.cancel();
    print("Timer disposed");
    super.dispose();
  }

  Timer? countdownTimer;
  Duration myDuration = Duration(seconds: 5);

  void startTimer() {
    countdownTimer =
        Timer.periodic(Duration(seconds: 1), ((_) {
          if(countdownTimer == 0)
          {
             color = Color(0xff9766D5);
          }
          setCountDown();
        })) ;
  }
  

  void stopTimer() {
    setState(() => countdownTimer!.cancel());
  }
  
  void resetTimer() {
    stopTimer();
     color = Color(0xffA9A5Af);
    setState(() => myDuration = Duration(seconds: 5));
  }



  void setCountDown() {
    final reduceSecondsBy = 1;
    setState(() {
      final seconds = myDuration.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        color = Color(0xff9766D5);
        isButtonDisabled = false;
        countdownTimer!.cancel();

      } else {
        myDuration = Duration(seconds: seconds);
      }
    });
  }

  


  String text;
  @override
  Widget build(BuildContext context) {
    String strDigits(int n) => n.toString().padLeft(2, '0');
  
    final hours = strDigits(myDuration.inHours.remainder(24));
    final minutes = strDigits(myDuration.inMinutes.remainder(60));
    final seconds = strDigits(myDuration.inSeconds.remainder(60));
    return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            
              padding: const EdgeInsets.only(left: 31, right: 31),
              child: Form(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      
                      children: [
                    SizedBox(
                      height: getProportionateScreenHeight(70),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios,
                            size: 20,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          color: Color(0xff979797),
                        ),
                        SizedBox(
                          width: 25,
                        ),
                        Text(
                          "Verification",
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D0051)),
                        ),
                      ],
                    ),
        
                    SizedBox(
                      height: getProportionateScreenHeight(90),
                    ),
                    Text(
                      text,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          color: Color(0xffA9A5Af)),
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(50),
                    ),
        
                    ///otp box
        
                    PinCodeTextField(
                      appContext: context,
                      length: 5,
                      inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      ],
                      pastedTextStyle: TextStyle(
                        color: Color(0xFF2D0051),
                        fontWeight: FontWeight.bold,
                      ),
                      obscureText: false,
                      animationType: AnimationType.fade,
                      cursorColor: Color(0xFF2D0051),
                      animationDuration: const Duration(milliseconds: 300),
                      
                      pinTheme: PinTheme(
                        activeColor: Colors.black,
                        inactiveColor: Colors.black),
                      keyboardType: TextInputType.number,
                      
                      
                      onChanged: (value) {
                        debugPrint(value);
                        setState(() {
                          value;
                        });
                      },
                      beforeTextPaste: (text) {
                        debugPrint("Allowing to paste $text");
                        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                        //but you can show anything you want here, like your pop up saying wrong paste format or etc
                        return true;
                      },
                    ),

                    SizedBox(
                      height: getProportionateScreenHeight(50),
                    ),

                    Row(
                      children: [
                        Text(
                          '$hours:$minutes:$seconds',
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Color(0xffA9A5Af),
                              fontSize: 24),
                        ),
                        TextButton(
                          
                          onPressed:isButtonDisabled ? null : (){
                            resetTimer();
                            startTimer();
                          },child:Text(
                          "Resend Code",
                          style: TextStyle(
                            color: color,
                            
                          ),
                          
                        ))
                      ],
                    ),
                   
                    SizedBox(
                      height: getProportionateScreenHeight(140),
                    ),
                    //TODO: add timer for otp resend
        
                    MyButton(text: "Submit", onTap: () {
                      
                     Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            //TODO: change the message here
                            builder: (context) {
                             
                              return passwordResetPage();
                            }
                        ),
                        (r)
                        {
                          return false;
                        }
                        );
                    },enabled: true,)
                  ]))),
        ));
  }
}
