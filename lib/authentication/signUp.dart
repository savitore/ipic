import 'package:flutter/material.dart';
import 'package:ipic/services/auth.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var name="",email="",password="",confirm="",admission_no="";
  var formKey = GlobalKey<FormState>();

  var years = [
    '1st year',
    '2nd year',
    '3rd year',
    '4th year',
    '5th year',
  ];
  var branches = [
    'Applied Geology',
    'Applied Geophysics',
    'Chemical Engineering',
    'Civil Engineering',
    'Computer Science Engineering',
    'Electrical Engineering',
    'Electronics & Communication Engineering',
    'Electronics & Instrumentation Engineering',
    'Engineering Physics',
    'Environmental Science Engineering',
    'Mathematics & Computing',
    'Mechanical Engineering',
    'Mineral Engineering',
    'Mining Engineering',
    'Mining Machinery Engineering'
  ];
  String year = '1st year';
  String branch = 'Computer Science Engineering';
  AuthService authService= AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back,color: Colors.white,),
        ),
      ),
      backgroundColor: Colors.blue[400],
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Column(
                  children: [
                    Text('SIGN UP',style: TextStyle(color: Colors.white,fontSize: 25),),
                    SizedBox(height: 30,),
                    TextFormField(
                      validator: (val)=> val!.isEmpty? 'Enter your name':null,
                      keyboardType: TextInputType.name,
                      onChanged: (value){
                        name=value;
                      },
                      decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.grey[300]),
                          filled: true,
                          fillColor: Colors.blue[300],
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          hintText: "Enter Your Name"
                      ),
                    ),
                    SizedBox(height: 20,),
                    TextFormField(
                      validator: (val)=> val!.isEmpty? 'Enter Your Admission Number':null,
                      keyboardType: TextInputType.text,
                      onChanged: (value){
                        admission_no=value;
                      },
                      decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.grey[300]),
                          filled: true,
                          fillColor: Colors.blue[300],
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          hintText: "Enter Your Admission Number"
                      ),
                    ),
                    SizedBox(height: 20,),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Select year of study',style: TextStyle(color: Colors.grey[300],fontSize: 18),),
                          SizedBox(width: 20,),
                          DropdownButton(
                            value: year,
                              items: years.map((String items){
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(items,style: TextStyle(),),
                                );
                              }).toList(),
                              onChanged: (String? newValue){
                                setState(() {
                                  year=newValue!;
                                });
                              }
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Select your branch',style: TextStyle(color: Colors.grey[300],fontSize: 18),),
                        // SizedBox(width: 20,),
                        DropdownButton(
                            value: branch,
                            items: branches.map((String items){
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items,style: TextStyle(),),
                              );
                            }).toList(),
                            onChanged: (String? newValue){
                              setState(() {
                                branch=newValue!;
                              });
                            }
                        ),
                      ],
                    ),
                    SizedBox(height: 20,),
                    TextFormField(
                      validator: (val)=> val!.isEmpty? 'Enter your email':null,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value){
                        email=value;
                      },
                      decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.grey[300]),
                          filled: true,
                          fillColor: Colors.blue[300],
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          hintText: "Enter Your Email"
                      ),
                    ),
                    SizedBox(height: 20,),
                    TextFormField(
                      obscureText: true,
                      validator: (val)=> val!.length<6? 'Password should be atleast 6 characters':null,
                      keyboardType: TextInputType.text,
                      onChanged: (value){
                        password=value;
                      },
                      decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.grey[300]),
                          filled: true,
                          fillColor: Colors.blue[300],
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          hintText: "Enter Your Password"
                      ),
                    ),
                    SizedBox(height: 20,),
                    TextFormField(
                      obscureText: true,
                      validator: (val)=> val!=password? 'Passwords do not match':null,
                      keyboardType: TextInputType.text,
                      onChanged: (value){
                        confirm=value;
                      },
                      decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.grey[300]),
                          filled: true,
                          fillColor: Colors.blue[300],
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          hintText: "Confirm Password"
                      ),
                    ),
                    SizedBox(height: 40,),
                    SizedBox(
                      height: 45,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if(formKey.currentState!.validate()){
                            showLoaderDialog(BuildContext context){
                              AlertDialog alert = AlertDialog(
                                content: new Row(
                                  children: [
                                    CircularProgressIndicator(),
                                    Container(margin: EdgeInsets.only(left: 7),child: Text("Loading..."),)
                                  ],
                                ),
                              );
                              showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (BuildContext context){
                                    return alert;
                                  }
                              );
                            }
                            showLoaderDialog(context);
                            authService.signUp(email, password, name, branch,year, admission_no, context);

                          }
                        },
                        child: Text('REGISTER',style: TextStyle(color: Colors.blue,fontSize: 17),),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.white,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                      ),
                    ),
                    SizedBox(height: 20,),
                    InkWell(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Already registered? ',style: TextStyle(color: Colors.white,fontSize: 17),),
                          Text('Sign in',style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.bold),)
                        ],
                      ),
                    ),
                    SizedBox(height: 20,)
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
