import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class Introduction extends StatefulWidget {
  static bool DatabaseCreated = false;
  const Introduction({Key? key}) : super(key: key);

  @override
  State<Introduction> createState() => _IntroductionState();
}

class _IntroductionState extends State<Introduction> {



  late PageController _pageController;

  int _pageIndex = 0;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

    onBoard_opend() async {
      int isViewed = 0 ;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt("onboard", isViewed);
      print("dooooooooone");
    }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage('assets/intro.png'),
          fit: BoxFit.cover,
        )),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                      itemCount: demo_date.length,
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _pageIndex = index;
                          print(_pageIndex);
                        });
                      },
                      itemBuilder: (context, index) => OnboardContent(
                            image: demo_date[index].image,
                            title: demo_date[index].title,
                            description: demo_date[index].description,
                          )),
                ),
                Row(
                  children: [
                    ...List.generate(
                        demo_date.length,
                        (index) => Padding(
                              padding: EdgeInsets.only(right: 4),
                              child: DotIndecator(
                                isActive: index == _pageIndex,
                              ),
                            )),
                    Spacer(),
                    SizedBox(
                      height: 60,
                      width: 60,
                      child: ElevatedButton(
                        onPressed: () async {
                         await onBoard_opend();
                          if (_pageIndex == 2) {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) => home()),
                                (route) => false);
                          } else {
                            _pageController.nextPage(
                                curve: Curves.ease,
                                duration: Duration(milliseconds: 300));
                          }

                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 15,
                          shadowColor: HexColor("#c5c4f2"),
                          backgroundColor: HexColor("#c5c4f2"),
                          shape: CircleBorder(),
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: HexColor("#201691"),
                        ),
                      ),
                    ),
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

class DotIndecator extends StatelessWidget {
  const DotIndecator({
    Key? key,
    this.isActive = false,
  }) : super(key: key);

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: isActive ? 12 : 4,
      width: 4,
      decoration: BoxDecoration(
        color: isActive ? HexColor("#f5e4ff") : HexColor("#c5c4f2"),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}

class Onboard {
  final String image, title, description;

  Onboard(
      {required this.image, required this.title, required this.description});
}

final List<Onboard> demo_date = [
  Onboard(
    image: "assets/smile.png",
    title:
        "Enjoy with beautiful note which will help you to be more productive",
    description: "",
  ),
  Onboard(
    image: "assets/tap.png",
    title: "Easy to control with",
    description: "hint: you can delete note by double tap",
  ),
  Onboard(
    image: "assets/mobiles.png",
    title: "Works on android and ios",
    description: "",
  ),
];

class OnboardContent extends StatelessWidget {
  const OnboardContent({
    Key? key,
    required this.image,
    required this.title,
    required this.description,
  }) : super(key: key);

  final String image, title, description;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Spacer(),
        Center(
          child: Image.asset(
            image,
            height: 175,
          ),
        ),
        Spacer(),
        SizedBox(
          height: 5,
        ),
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .headline5!
              .copyWith(fontWeight: FontWeight.w500, color: Colors.white),
        ),
        SizedBox(
          height: 16,
        ),
        Text(
          description,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
        Spacer(),
      ],
    );
  }
}
