import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pravda_news/data/dto/news_dto.dart';
import 'package:pravda_news/presentation/favnews_line.dart';

import '../news_page.dart';

Route createRouteOpenNews(NewsDto newsDto) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        NewsPage(newsDto: newsDto),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const beginOffset = Offset(1.0, 0.0);
      const endOffset = Offset.zero;
      final tweenOffset = Tween<Offset>(begin: beginOffset, end: endOffset);

      const curve = Curves.linear;

      final offsetAnimation = CurvedAnimation(
        parent: animation,
        curve: curve,
      );

      final opacityAnimation = CurvedAnimation(parent: animation, curve: curve);
      final tweenOpacity = Tween<double>(begin: 0.0, end: 1.0);

      return SlideTransition(
        position: tweenOffset.animate(offsetAnimation),
        child: FadeTransition(
          opacity: tweenOpacity.animate(opacityAnimation),
          child: child,
        ),
      );
    },
  );
}

Route createRouteOpenFavs() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        const FavNewsLine(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const beginOffset = Offset(-1.0, 0.0);
      const endOffset = Offset.zero;
      final tweenOffset = Tween<Offset>(begin: beginOffset, end: endOffset);

      const curve = Curves.linear;

      final offsetAnimation = CurvedAnimation(
        parent: animation,
        curve: curve,
      );

      final opacityAnimation = CurvedAnimation(parent: animation, curve: curve);
      final tweenOpacity = Tween<double>(begin: 0.0, end: 1.0);

      return SlideTransition(
        position: tweenOffset.animate(offsetAnimation),
        child: FadeTransition(
          opacity: tweenOpacity.animate(opacityAnimation),
          child: child,
        ),
      );
    },
  );
}
