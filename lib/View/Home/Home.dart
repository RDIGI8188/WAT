import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wat/View/Training.dart';
import '../../Controller/Home/Homecontroller.dart';
import 'Adoption.dart';
import 'Notification.dart';
import 'Package.dart';
import 'Rescued.dart';
import 'package:video_player/video_player.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());
    VideoPlayerController? _controller;

    return SafeArea(
      child: Scaffold(
        body: Container(
          height: 700,
          width: 400,
          child: Obx(() {
            if (controller.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(),
                  _buildCarousel(controller),
                  _buildIndicator(controller),
                  SizedBox(height: 20),
                  _buildServiceCards(context),
                  SizedBox(height: 20),
                  _buildAdBanner(),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 3, left: 5),
          child: Align(
            alignment: Alignment.topLeft,
            child: Image.asset(
              "assets/Images/logo.png",
              height: 50,
              width: 50,
            ),
          ),
        ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.only(right: 5),
          child: Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () {
                Get.to(NotificationPage());
              },
              icon: const Icon(
                Icons.notifications,
                size: 24,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCarousel(HomeController controller) {
    return Container(
      // margin: EdgeInsets.symmetric(horizontal: 30),
      height: 180,
      width: 400,
      child: Obx(() {
        return CarouselSlider.builder(
          itemCount: controller.sliderData.length,
          itemBuilder: (context, index, realIndex) {
            final item = controller.sliderData[index];
            final imageUrl =
                'https://app.wingsandtails.in/server/pages/slider${item['slider']}';

            return GestureDetector(
              onTap: () => _launchURL(item['url']),
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.fill,
                    onError: (error, stackTrace) {
                      print("Error loading image: $error");
                    },
                  ),
                ),
              ),
            );
          },
          options: CarouselOptions(
            viewportFraction: 0.97,
            height: 150,
            initialPage: 0,
            enlargeCenterPage: true,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 5),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            pauseAutoPlayOnTouch: true,
            onPageChanged: (index, reason) {
              controller.updateActiveIndex(index);
            },
          ),
        );
      }),
    );
  }

  Widget _buildIndicator(HomeController controller) {
    return AnimatedSmoothIndicator(
      activeIndex: controller.activeIndex.value,
      count: controller.sliderData.length,
      effect: const ExpandingDotsEffect(
        dotHeight: 10,
        dotWidth: 10,
        activeDotColor: Color(0xffF1A852),
        dotColor: Color(0xffFFCF6F),
      ),
    );
  }

  Widget _buildServiceCards(BuildContext context) {
    return Column(
      children: [
        _buildCardRow(
          [
            _buildServiceCard(
              "assets/Icon/helping.png",
              "Rescue",
              () => Get.to(RescueList()),
            ),
            _buildServiceCard(
              "assets/Icon/adoption.png",
              "Adoption",
              () => Get.to(Adoption()),
            ),
            _buildServiceCard(
              "assets/Icon/grooming.png",
              "Grooming",
              () => Get.to(PackagePage()),
            ),
          ],
        ),
        SizedBox(height: 20),
        _buildCardRow(
          [
            _buildServiceCard(
              "assets/Icon/training.png",
              "Training",
              () => Get.to(Training()),
            ),
            _buildServiceCard(
              "assets/Icon/dog walking.png",
              "Dog walking",
              () => showComingSoonDialog(context),
            ),
            _buildServiceCard(
              "assets/Icon/boarding.png",
              "Pet boarding",
              () => showComingSoonDialog(context),
            ),
          ],
        ),
        SizedBox(height: 20),
        _buildCardRow(
          [
            _buildServiceCard(
              "assets/Icon/taxi.png",
              "Pet taxi",
              () => showComingSoonDialog(context),
            ),
            _buildServiceCard(
              "assets/Icon/date.png",
              "Pet date",
              () => showComingSoonDialog(context),
            ),
            _buildServiceCard(
              "assets/Icon/other.png",
              "Other",
              () => showComingSoonDialog(context),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCardRow(List<Widget> cards) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: cards,
    );
  }

  Widget _buildServiceCard(String imagePath, String title, Function() onTap) {
    return Card(
      elevation: 11,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 80,
          width: 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagePath,
                height: 60,
                width: 60,
              ),
              Text(
                title,
                style: GoogleFonts.encodeSans(
                  textStyle: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Container(
        height: 96,
        width: 340,
        child: Image.asset(
          "assets/Images/s3.png",
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);

    if (await launchUrl(uri)) {
    } else {
      throw 'Could not launch $url';
    }
  }

  void showComingSoonDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Column(
            children: [
              Image.asset(
                'assets/Images/logo.png',
                height: 50,
                width: 50,
              ),
              SizedBox(height: 10),
              Text(
                'Feature Coming Soon',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Thank you for your interest! This feature is currently in development and will be available shortly.\nStay tuned for updates.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
            ],
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                backgroundColor: Color(0xffED6D4E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Got it!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
