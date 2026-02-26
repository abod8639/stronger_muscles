import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stronger_muscles/data/models/product_model.dart';
import 'package:stronger_muscles/functions/cache_manager.dart';

class FlavorsModel {
  final String name;
  final Color color;
  final String image;

  FlavorsModel({required this.name, required this.color, required this.image});
}

class ProductFlavorSelector extends StatelessWidget {
  final ProductModel product;
  final String selectedFlavor;
  final Function(String) onFlavorSelected;

  const ProductFlavorSelector({
    super.key,
    required this.product,
    required this.selectedFlavor,
    required this.onFlavorSelected,
  });

  // نقوم بتعريف البيانات كـ Map لسهولة البحث والوصول
  static final Map<String, FlavorsModel> _flavorsData = {
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
        color: Colors.brown.shade900,
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

  // دالة لجلب البيانات بناءً على الاسم مع توفير بديل افتراضي
  FlavorsModel _getFlavorDetails(String flavorName) {
    final key = flavorName.toLowerCase().trim();
    // البحث عن أقرب تطابق (مثلاً "Chocolate Ice" سيجد "chocolate")
    final match = _flavorsData.keys.firstWhere(
      (k) => key.contains(k),
      orElse: () => "default",
    );

    return _flavorsData[match] ??
        FlavorsModel(
          name: flavorName,
          color: Colors.blueGrey,
          image: "https://via.placeholder.com/150", // صورة افتراضية
        );
  }

  @override
  Widget build(BuildContext context) {
    final flavorsList = product.flavors;
    if (flavorsList.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "CHOOSE YOUR FLAVOR",
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                fontStyle: FontStyle.italic,
              ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 12,
          children: flavorsList.map((flavor) {
            final isSelected = selectedFlavor == flavor;
            final details = _getFlavorDetails(flavor);
            final baseColor = details.color;

            return GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                onFlavorSelected(flavor);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 110,
                height: 60,
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
                    flavor.toUpperCase(),
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
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:stronger_muscles/core/constants/app_colors.dart';
// import 'package:stronger_muscles/data/models/product_model.dart';

// class FlavorsModel {
//   final String name;
//   final Color color;
//   final String? image;

//   FlavorsModel({required this.name, required this.color, this.image});
// }

// class ProductFlavorSelector extends StatelessWidget {
//   final ProductModel product;
//   final String selectedFlavor;
//   final Function(String) onFlavorSelected;

//   const ProductFlavorSelector({
//     super.key,
//     required this.product,
//     required this.selectedFlavor,
//     required this.onFlavorSelected,
//   });



//   @override
//   Widget build(BuildContext context) {
//     List<FlavorsModel> flivorsList = [
//       FlavorsModel(
//         name: "Vanilla", 
//         color: Colors.yellow,
//         image: "https://i.pinimg.com/1200x/34/05/1d/34051d682f6f93788f27d6d28280f2ff.jpg"
//         ),
//       FlavorsModel(
//         name: "Chocolate", 
//         color: Colors.brown,
//         image: "https://i.pinimg.com/736x/54/cc/0e/54cc0e7213b33cb9c1ee2451bb19d9a3.jpg"
//         ),
//       FlavorsModel(
//         name: "Strawberry", 
//         color: Colors.pink,
//         image: "https://i.pinimg.com/736x/49/7c/ec/497cecf2e260f0a9f35d6336b74c3d80.jpg"
//         ),
//       FlavorsModel(
//         name: "Mango", 
//         color: Colors.orange,
//         image:"https://i.pinimg.com/736x/b8/4e/68/b84e6829e22824e4a244f6b9e72398bf.jpg"
//         ),
//       FlavorsModel(
//         name: "Caramel", 
//         color: Colors.amber,
//         image:"https://i.pinimg.com/736x/e9/87/ae/e987aef33d3b7dbc41486a947ef65c25.jpg"),
//       FlavorsModel(
//         name: "Cookies", 
//         color: Colors.grey,
//         image:"https://i.pinimg.com/736x/20/52/60/20526056fc1041a1e8781c6a4282eba2.jpg"),
//       FlavorsModel(
//         name: "Banana", 
//         color: Colors.yellow,
//         image:"https://i.pinimg.com/736x/41/45/53/41455324a095edc6a07ac57d67e6bdb7.jpg"),
//       FlavorsModel(
//         name: "Berry", 
//         color: Colors.red,
//         image:"https://i.pinimg.com/736x/af/f0/58/aff058e3c5aa245feb1221ddedf876eb.jpg"),
//       FlavorsModel(
//         name: "Peanut", 
//         color: Colors.orange,
//         image:"https://i.pinimg.com/736x/6c/67/a4/6c67a495ebbf4db11d3e9ae3d40692b6.jpg"),
//       FlavorsModel(
//         name: "Coffee", 
//         color: Colors.brown),
//       FlavorsModel(
//         name: "Cola", 
//         color: Colors.brown,
//         image:"https://i.pinimg.com/736x/5e/03/98/5e0398fa88c4c64210c5143433afe9b2.jpg"),
//       FlavorsModel(
//         name: "Watermelon", 
//         color: Colors.pink,
//         image:"https://i.pinimg.com/736x/00/6e/de/006edeee57d453cef689c246f2dbd14c.jpg"),

//     ];

//       Color _getFlavorColor(String flavor) {
//     final f = flavor.toLowerCase();
//     if (f.contains(flivorsList[0].name)) return const Color(0xFFF3E5AB);
//     if (f.contains(flivorsList[1].name)) return Colors.pinkAccent;
//     if (f.contains(flivorsList[2].name)) return Colors.brown.shade700;
//     if (f.contains(flivorsList[3].name)) return Colors.orangeAccent;
//     if (f.contains(flivorsList[4].name)) return Colors.amber.shade800;
//     if (f.contains(flivorsList[5].name)) return Colors.grey.shade600;
//     if (f.contains(flivorsList[6].name)) return Colors.yellow.shade800;
//     if (f.contains(flivorsList[7].name)) return Colors.red.shade800;
//     if (f.contains(flivorsList[8].name)) return Colors.orange.shade800;
//     if (f.contains(flivorsList[9].name)) return Colors.brown.shade700;
//     if (f.contains(flivorsList[10].name)) return Colors.green.shade800;
//     if (f.contains(flivorsList[11].name)) return Colors.brown.shade900;

//     return Colors.blueGrey;
//   }
//     final flavorsList = product.flavors;
//     if (flavorsList.isEmpty) return const SizedBox.shrink();

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           "CHOOSE YOUR FLAVOR",
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.bold,
//             letterSpacing: 1.2,
//             fontStyle: FontStyle.italic,
//           ),
//         ),
//         const SizedBox(height: 12),
//         Wrap(
//           spacing: 5,
//           runSpacing: 10,
//           children: flavorsList.map((flavor) {
//             final isSelected = selectedFlavor == flavor;
//             final baseColor = _getFlavorColor(flavor);

//             return GestureDetector(
//               onTap: () {
//                 HapticFeedback.mediumImpact();
//                 onFlavorSelected(flavor);
//               },
//               child: AnimatedContainer(
//                 duration: const Duration(milliseconds: 200),
//                 width: 120,
//                 height: 50,
//                 decoration: BoxDecoration(
//                   image: DecorationImage(
//                     image: NetworkImage(flivorsList.image!),
//                     fit: BoxFit.cover,
//                   ),
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(
//                     color: isSelected ? baseColor : AppColors.greyMedium,
//                     width: 2.5,
//                   ),
//                   // (Stripped Pattern)
//                   gradient: LinearGradient(
//                     begin: const Alignment(-1.0, -1.0),
//                     end: const Alignment(1.0, 1.0),
//                     stops: const [
//                       0.0,
//                       0.2,
//                       0.2,
//                       0.4,
//                       0.4,
//                       0.6,
//                       0.6,
//                       0.8,
//                       0.8,
//                       1.0,
//                     ],
//                     colors: [
//                       isSelected ? baseColor : baseColor,
//                       isSelected ? baseColor : baseColor,
//                       isSelected
//                           ? baseColor.withValues(alpha: .8)
//                           : Colors.grey.shade400,
//                       isSelected
//                           ? baseColor.withValues(alpha: .8)
//                           : Colors.grey.shade400,
//                       isSelected ? baseColor : AppColors.grey,
//                       isSelected ? baseColor : AppColors.grey,
//                       isSelected
//                           ? baseColor.withValues(alpha: .8)
//                           : Colors.grey.shade400,
//                       isSelected
//                           ? baseColor.withValues(alpha: .8)
//                           : Colors.grey.shade400,
//                       isSelected ? baseColor : AppColors.grey,
//                       isSelected ? baseColor : AppColors.grey,
//                     ],
//                   ),
//                 ),
//                 child: Stack(
//                   children: [
//                     Center(
//                       child: Text(
//                         flavor.toUpperCase(),
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           color: isSelected ? Colors.white : Colors.black,
//                           fontWeight: FontWeight.w900,
//                           fontSize: 14,
//                           shadows: isSelected
//                               ? [
//                                   Shadow(
//                                     blurRadius: 2,
//                                     color: Colors.black,
//                                     offset: Offset(1, 1),
//                                   ),
//                                 ]
//                               : [
//                                   Shadow(
//                                     blurRadius: 1,
//                                     color: baseColor.withAlpha(150),
//                                     offset: Offset(1, 1),
//                                   ),
//                                 ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }).toList(),
//         ),
//       ],
//     );
//   }
// }