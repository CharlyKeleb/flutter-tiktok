import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_tiktok/view/auth/login.dart';
import 'package:flutter_tiktok/view/auth/register.dart';

class AuthChooser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Icon(
          Icons.music_note_rounded,
          color: Colors.white,
          size: 100.0,
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Container(
            height: 120.0,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 50.0,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      color: Theme.of(context).accentColor,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => Register(),
                          ),
                        );
                      },
                      child: Center(
                        child: Text('Create an account  '.toUpperCase(),
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8.0),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 50.0,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      color: Colors.transparent,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => Login(),
                          ),
                        );
                      },
                      child: Center(
                        child: Text('sign in to your account'.toUpperCase(),
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
