// ignore: avoid_web_libraries_in_flutter

import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:flutter_svg/svg.dart';
import 'package:splash_screen/utils/color_utils.dart';

Image logowidget(String imagename) {
  return Image.asset(
    imagename,
    fit: BoxFit.fitWidth,
    width: 300,
    height: 300,
    color: Colors.white,
  );
}

TextField reusableTextField(String text, IconData icon, bool isPassword,
    TextEditingController controller) {
  return TextField(
    controller: controller,
    obscureText: isPassword,
    enableSuggestions: !isPassword,
    autocorrect: !isPassword,
    cursorColor: Colors.white,
    style: TextStyle(color: Colors.white.withOpacity(0.9)),
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: Colors.white70,
      ),
      labelText: text,
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.white.withOpacity(0.3),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: const BorderSide(width: 0, style: BorderStyle.none),
      ),
    ),
    keyboardType:
        isPassword ? TextInputType.visiblePassword : TextInputType.emailAddress,
  );
}

Container signInSignUpbutton(
    BuildContext context, bool isLogin, Function onTap) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.black26;
            }
            return Colors.white;
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
      child: Text(
        isLogin ? 'LOG IN' : 'SIGN UP',
        style: const TextStyle(
            color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16),
      ),
    ),
  );
}

Container menuOptions(String imageName, String titleName, Function onTap) {
  return Container(
      decoration: BoxDecoration(
          color: Colors.transparent, borderRadius: BorderRadius.circular(13)),
      child: ElevatedButton(
        onPressed: () {
          onTap();
        },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.pressed)) {
                return const Color.fromARGB(255, 0, 126, 94);
              }
              return const Color.fromARGB(255, 0, 148, 104);
            }),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(6),
              child: Image.asset(
                imageName,
                height: 70.0,
                color: Colors.white,
              ),
            ),
            // Spacer(),
            Text(
              titleName,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, color: Colors.white),
            )
          ],
        ),
      ));
}

// 1
class binPage1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            hexStringToColor('71C044'),
            hexStringToColor('71C044'),
            hexStringToColor("0D8142"),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(bottom: 150, top: 20, left: 20, right: 20),
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(13)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/Organic.png',
                  height: 300,
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 8, left: 10, top: 10),
                  child: Text(
                    'Organic waste generally refers to biodegradable, compostable waste from homes, bussiness  institutions, and industrial sources.',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 8, left: 10, top: 4),
                  child: Text(
                    'Examples include food scraps, yard and garden trimmings, food-soiled paper products and biosolids.',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
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

//2
class binPage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            hexStringToColor('71C044'),
            hexStringToColor('71C044'),
            hexStringToColor("0D8142"),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(bottom: 150, top: 20, left: 20, right: 20),
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(13)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/Glass.png',
                  height: 300,
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 8, left: 10, top: 10),
                  child: Text(
                    'Waste glass is another waste material that is produced in large quantities and is difficult to eliminate.',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 8, left: 10, top: 4),
                  child: Text(
                    'Examples include  soft drink bottles; wine and liquor bottles; and bottles and jars for food, cosmetics and other products.',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
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

//3
class binPage3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            hexStringToColor('71C044'),
            hexStringToColor('71C044'),
            hexStringToColor("0D8142"),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(bottom: 150, top: 20, left: 20, right: 20),
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(13)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/Plastic.png',
                  height: 300,
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 8, left: 10, top: 10),
                  child: Text(
                    'Plastic waste, or plastic pollution, is the accumulation of plastic objects  in the Earth\'s environment that adversely affects wildlife, wildlife habitat, and humans.',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 8, left: 10, top: 4),
                  child: Text(
                    'Examples include Food wrappers, plastic bottles, plastic bottle caps, plastic grocery bags, plastic straws, and stirrers are the next most common items',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
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

//4
class binPage4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            hexStringToColor('71C044'),
            hexStringToColor('71C044'),
            hexStringToColor("0D8142"),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(bottom: 150, top: 20, left: 20, right: 20),
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(13)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/Paper.png',
                  height: 300,
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 8, left: 10, top: 10),
                  child: Text(
                    'Paper production causes deforestation, uses enormous amounts of energy and water, and contributes to air pollution and waste problems.',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 8, left: 10, top: 4),
                  child: Text(
                    'Examples include  old newspaper, bills, or letters. ',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
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

//5
class binPage5 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            hexStringToColor('71C044'),
            hexStringToColor('71C044'),
            hexStringToColor("0D8142"),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(bottom: 150, top: 20, left: 20, right: 20),
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(13)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/E-Waste.png',
                  height: 300,
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 8, left: 10, top: 10),
                  child: Text(
                    'Electronic waste or e-waste describes discarded electrical or electronic devices. I',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 8, left: 10, top: 4),
                  child: Text(
                    'Examples include TVs, computer monitors, printers, scanners, keyboards, mice, cables, circuit boards, lamps, clocks',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
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

//6

class binPage6 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            hexStringToColor('71C044'),
            hexStringToColor('71C044'),
            hexStringToColor("0D8142"),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(bottom: 150, top: 20, left: 20, right: 20),
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(13)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/Metal.png',
                  height: 300,
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 8, left: 10, top: 10),
                  child: Text(
                    'Metal waste or scrap metal is any product that\'s broken or no longer useable, which is made completely or mostly from a metal material.',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 8, left: 10, top: 4),
                  child: Text(
                    'Examples include broken tools, metal sheets from manufacturing, a bent pipe, old electrical appliances, and more.',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
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
