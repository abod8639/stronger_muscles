
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stronger_muscles/functions/cache_manager.dart';


class FlavorsModel {
  final String name;
  final Color color;
  final String image;

  FlavorsModel({
    required this.name, 
    required this.color, 
    required this.image
    });
}


  final Map<String, FlavorsModel> flavorsData = {
    "vanilla": FlavorsModel(
        name: "Vanilla",
        color: const Color(0xFFF3E5AB),
        image: "https://i.pinimg.com/1200x/34/05/1d/34051d682f6f93788f27d6d28280f2ff.jpg"),
    "chocolate": FlavorsModel(
        name: "Chocolate",
        color: Colors.brown.shade700,
        image: "https://i.pinimg.com/736x/54/cc/0e/54cc0e7213b33cb9c1ee2451bb19d9a3.jpg"),
    "strawberry": FlavorsModel(
        name: "Strawberry",
        color: Colors.pinkAccent,
        image: "https://i.pinimg.com/736x/49/7c/ec/497cecf2e260f0a9f35d6336b74c3d80.jpg"),
    "mango": FlavorsModel(
        name: "Mango",
        color: Colors.orangeAccent,
        image: "https://i.pinimg.com/736x/b8/4e/68/b84e6829e22824e4a244f6b9e72398bf.jpg"),
    "caramel": FlavorsModel(
        name: "Caramel",
        color: Colors.amber.shade800,
        image: "https://i.pinimg.com/736x/e9/87/ae/e987aef33d3b7dbc41486a947ef65c25.jpg"),
    "cookies": FlavorsModel(
        name: "Cookies",
        color: Colors.grey.shade600,
        image: "https://i.pinimg.com/736x/20/52/60/20526056fc1041a1e8781c6a4282eba2.jpg"),
    "banana": FlavorsModel(
        name: "Banana",
        color: Colors.yellow.shade800,
        image: "https://i.pinimg.com/736x/41/45/53/41455324a095edc6a07ac57d67e6bdb7.jpg"),
    "berry": FlavorsModel(
        name: "Berry",
        color: Colors.red.shade800,
        image: "https://i.pinimg.com/736x/33/69/52/33695284fb75b948cf641777a13d9aa5.jpg"),
    "peanut": FlavorsModel(
        name: "Peanut",
        color: Colors.orange.shade800,
        image: "https://i.pinimg.com/736x/6c/67/a4/6c67a495ebbf4db11d3e9ae3d40692b6.jpg"),
    "coffee": FlavorsModel(
        name: "Coffee",
        color: Colors.brown.shade900,
        image: "https://i.pinimg.com/736x/5e/03/98/5e0398fa88c4c64210c5143433afe9b2.jpg"), // استبدلت صورة الكولا هنا للقهوة
    "cola": FlavorsModel(
        name: "Cola",
        color: Colors.brown.shade600,
        image: "https://i.pinimg.com/736x/5e/03/98/5e0398fa88c4c64210c5143433afe9b2.jpg"),
    "watermelon": FlavorsModel(
        name: "Watermelon",
        color: Colors.pink,
        image: "https://i.pinimg.com/736x/00/6e/de/006edeee57d453cef689c246f2dbd14c.jpg"),
    "lemon": FlavorsModel(
        name: "Lemon",
        color: Colors.yellow,
        image: "https://i.pinimg.com/736x/00/6e/de/006edeee57d453cef689c246f2dbd14c.jpg"),
  };



class FlavorImage extends StatelessWidget {
  const FlavorImage({
    super.key,
    required this.isSelected,
    required this.baseColor,
    required this.details,
     this.width,
     this.height,

  });

  final bool isSelected;
  final Color baseColor;
  final FlavorsModel details;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: width??110,
      height: height??60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? baseColor : Colors.transparent,
          width: 3,
        ),
        boxShadow: isSelected
            ? [BoxShadow(color: baseColor.withOpacity(0.4), blurRadius: 8, spreadRadius: 1)]
            : [],
        image: DecorationImage(
          image: CachedNetworkImageProvider(
            details.image,
            cacheManager: CustomCacheManager.instance,
          ),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            isSelected ? Colors.black.withOpacity(0.2) : Colors.black.withOpacity(0.5),
            BlendMode.darken,
          ),
        ),
      ),
      child: Center(
        child: Text(
          details.name.toUpperCase(),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 12,
            shadows: [
              const Shadow(blurRadius: 4, color: Colors.black, offset: Offset(1, 1)),
            ],
          ),
        ),
      ),
    );
  }
}

