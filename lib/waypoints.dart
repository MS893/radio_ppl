import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:gap/gap.dart';

// Affichage de la page identification des waypoints de LFMA et aux alentours
class MyWaypointsRoute extends StatelessWidget {
  const MyWaypointsRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Points d'entrée de la CTR"),
        ),
        body: const Carousel(),
      ),
    );
  }

}

class Carousel extends StatefulWidget {
  const Carousel({super.key});

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  static const images = <String>[
    "res/images/AW_AN_AT.png",
    "res/images/AW.jpeg",
    "res/images/AN.png",
    "res/images/AT.png",
    "res/images/AR.png",
  ];
  static const images2 = <String>[
    "res/images/AE_AS.png",
    "res/images/AE.jpg",
    "res/images/AS.png",
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Swiper(
            itemBuilder: (context, index) {
              return Image.asset(images[index], fit: BoxFit.fill);
            },
            autoplay: false,
            itemCount: images.length,
            pagination: SwiperPagination(),
            control: SwiperControl(),
            viewportFraction: 0.8,
            scale: 0.9,
          ),
        ),
        Gap(14),
        Expanded(
          child: Swiper(
            itemBuilder: (context, index) {
              return Image.asset(images2[index], fit: BoxFit.fill);
            },
            autoplay: false,
            itemCount: images2.length,
            pagination: SwiperPagination(),
            control: SwiperControl(),
            itemWidth: 360.0,
            layout: SwiperLayout.STACK,
          ),
        ),
      ],
    );
  }

}
