import 'package:flutter/material.dart';
import 'package:mms_app/app/colors.dart';
import 'package:mms_app/core/routes/router.dart';
import 'package:mms_app/screens/general/auth/login_layout.dart';
import 'package:mms_app/screens/widgets/buttons.dart';
import 'package:mms_app/screens/widgets/text_widgets.dart';
import 'package:mms_app/app/size_config/extensions.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({Key key}) : super(key: key);

  @override
  _OnboardingViewState createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  int _index = 0;

  PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.h),
            child: Stack(
              children: [
                PageView.builder(
                  controller: controller,
                  onPageChanged: (a) {
                    _index = a;
                    setState(() {});
                  },
                  itemCount: items().length,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 100.h),
                        regularText(items()[index].title,
                            fontSize: 26.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryColor),
                        SizedBox(height: 22.h),
                        regularText(items()[index].desc,
                            fontSize: 17.sp, color: AppColors.primaryColor),
                        Image.asset('images/onboard${index + 1}.png')
                      ],
                    );
                  },
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Spacer(),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 20.h,
                          child: ListView.builder(
                              itemCount: 2,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: _index != index ? 6.h : 10.h,
                                      width: _index != index ? 6.h : 10.h,
                                      margin: EdgeInsets.all(5.h),
                                      decoration: BoxDecoration(
                                          color: _index != index
                                              ? AppColors.textGrey
                                              : AppColors.primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(10.h)),
                                    )
                                  ],
                                );
                              }),
                        ),
                        SizedBox(height: 50.h),
                        InkWell(
                          onTap: () {
                            routeToReplace(context, LoginLayout());
                          },
                          child: regularText(_index == 1 ? '' : 'Skip',
                              fontSize: 17.sp, color: AppColors.primaryColor),
                        ),
                        SizedBox(height: 20.h),
                        buttonWithBorder(_index == 1 ? 'Proceed' : 'Next',
                            buttonColor: AppColors.primaryColor,
                            fontSize: 17.sp,
                            height: 50.h,
                            textColor: AppColors.white,
                            fontWeight: FontWeight.w600, onTap: () {
                          if (_index == 1) {
                            routeToReplace(context, LoginLayout());
                            return;
                          }
                          controller.nextPage(
                              duration: Duration(seconds: 1),
                              curve: Curves.easeIn);
                        })
                      ],
                    )
                  ],
                ),
              ],
            )),
      ),
    );
  }
}

class Item {
  String title;
  String desc;

  Item({this.title, this.desc});
}

List<Item> items() {
  return [
    Item(
      title: 'Find truckloads in\nyour area conveniently',
      desc: 'Truckloads posted daily',
    ),
    Item(
      title: 'Post available\ntruckloads',
      desc: 'Find available truckers',
    ),
  ];
}
