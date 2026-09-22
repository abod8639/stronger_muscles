# توثيق تطبيق Stronger Muscles

هذا المستند يقدم شرحاً تفصيلياً لهيكلة وبنية تطبيق `Stronger Muscles` المبني باستخدام Flutter، مع التركيز على تسهيل الفهم والتنقل داخل المشروع باستخدام روابط Obsidian.

---

## ١. نظرة عامة (Overview)

تطبيق **Stronger Muscles** هو تطبيق تجارة إلكترونية متكامل مصمم لبيع المكملات الغذائية. يتيح للمستخدمين تصفح المنتجات، إضافتها إلى سلة التسوق وقائمة الرغبات، وإتمام عمليات الشراء.

**الميزات الرئيسية:**
- نظام تسجيل دخول وتسجيل حسابات للمستخدمين (بالبريد الإلكتروني أو Google).
- عرض المنتجات وتصنيفها.
- سلة تسوق وقائمة مفضلات (Wishlist).
- إدارة عناوين الشحن.
- عملية دفع وإتمام الطلبات (Checkout).
- دعم متعدد اللغات (العربية والإنجليزية).
- دعم الوضع الليلي والنهاري.
- تخزين البيانات محلياً باستخدام Hive لتحسين الأداء وتجربة المستخدم بدون إنترنت.

---

## ٢. هيكلة المشروع (Folder Structure)

تم تنظيم الملفات داخل مجلد `lib` بطريقة تفصل بين الاهتمامات (Separation of Concerns)، مما يسهل الصيانة والتطوير.

- **`/config`**: يحتوي على ملفات الإعدادات الرئيسية للتطبيق.
  - `[[api_config.dart]]`: يُعرف ثوابت نقاط النهاية (Endpoints) للـ API الخلفي.

- **`/core`**: يحتوي على الأجزاء الأساسية المشتركة عبر التطبيق.
  - `constants`: ثوابت الألوان، الأنماط، وثيمات التطبيق.
  - `errors`: تعريف الأخطاء المخصصة مثل `[[failures.dart]]`.
  - `services`: خدمات أساسية مثل `[[api_service.dart]]` للتواصل مع الخادم، `[[auth_service.dart]]` للمصادقة، و `[[storage_service.dart]]` للتخزين المحلي.
  - `utils`: أدوات مساعدة مثل `[[responsive_helper.dart]]`.

- **`/data`**: طبقة البيانات (Data Layer) المسؤولة عن مصادر البيانات.
  - `models`: تعريف هياكل البيانات (Data Models) مثل `[[user_model.dart]]` و `[[product_model.dart]]`. تستخدم هذه النماذج حزم `freezed` و `json_serializable` لإنشاء كود غير قابل للتغيير (immutable) وتسهيل التحويل من وإلى JSON.
  - `repositories`: مستودعات البيانات التي تفصل منطق العمل عن مصادر البيانات.
  - `services`: خدمات متخصصة بالبيانات مثل `[[paymob_service.dart]]`.

- **`/presentation`**: طبقة العرض (UI Layer) وكل ما يتعلق بواجهة المستخدم.
  - `bindings`: يحتوي على وحدات التحكم (Controllers) الخاصة بـ GetX، وهي المسؤولة عن حالة الواجهة ومنطقها، مثل `[[home_controller.dart]]` و `[[cart_controller.dart]]`.
  - `pages`: شاشات التطبيق الرئيسية مثل `[[home_view.dart]]` و `[[product_details_view.dart]]`.
  - `widgets`: مكونات واجهة المستخدم القابلة لإعادة الاستخدام.

- **`/routes`**: يحتوي على ملف `[[routes.dart]]` الذي يُعرّف مسارات التنقل في التطبيق باستخدام GetX.

- **`/functions`**: يحتوي على دوال مساعدة صغيرة ومستقلة يمكن استخدامها في أي مكان، مثل `[[hive_init.dart]]` لتهيئة قاعدة البيانات المحلية.

- **`/l10n`** و **`/generated`**: ملفات الترجمة والتعريب (Localization) لدعم اللغتين العربية والإنجليزية.

---

## ٣. تدفق البيانات (Data Flow)

يعتمد التطبيق على نمط واضح لتدفق البيانات، خاصة عند جلبها من الخادم وعرضها للمستخدم. كمثال، عملية جلب المنتجات وعرضها في الصفحة الرئيسية:

1.  **الواجهة (UI)**: عند فتح الشاشة الرئيسية `[[home_view.dart]]`، يقوم `[[home_controller.dart]]` بطلب المنتجات.
2.  **وحدة التحكم (Controller)**: `HomeController` يستدعي الدالة `getProducts` من `[[product_service.dart]]`.
3.  **الخدمة (Service)**: `ProductService` يتواصل مع `[[api_service.dart]]` لجلب البيانات من الـ API.
4.  **خدمة الـ API**: `ApiService` يقوم ببناء طلب HTTP GET إلى نقطة النهاية `/shop/products`، مع إضافة الترويسات اللازمة (مثل رمز المصادقة واللغة).
5.  **الخادم (Backend)**: يستجيب الخادم ببيانات المنتجات بصيغة JSON.
6.  **التحليل والتخزين**: `ProductService` يستلم الاستجابة، يحلل بيانات JSON ويحولها إلى قائمة من `[[product_model.dart]]`، ثم يقوم بتخزينها مؤقتاً (caching) في قاعدة بيانات Hive المحلية لتحسين الأداء في المرات القادمة.
7.  **تحديث الحالة**: `HomeController` يستقبل قائمة المنتجات ويقوم بتحديث متغير الحالة التفاعلي `products`.
8.  **إعادة بناء الواجهة**: بفضل `Obx` من GetX، يتم إعادة بناء واجهة `[[home_view.dart]]` تلقائياً لعرض المنتجات الجديدة.

```dart
// home_controller.dart
void fetchProductsForSection(int index, {String? categoryId}) async {
  try {
    isLoading.value = true;
    // 1. Call the service
    List<ProductModel> fetchedProducts = await _productService.getProducts(categoryId: categoryId);
    // 2. Update state
    searchController.setProducts(fetchedProducts);
  } finally {
    isLoading.value = false;
  }
}

// product_service.dart
Future<List<ProductModel>> getProducts({String? categoryId}) async {
  // 3. Make API call
  final response = await _apiService.get(ApiConfig.products, /* ... */);
  final decodedData = jsonDecode(response.body);
  List<ProductModel> products = /* ... */; // 4. Parse JSON
  // 5. Cache to Hive
  for (var p in products) {
    await _productsBox.put(p.id, p);
  }
  return products;
}
```

---

## ٤. إدارة الحالة (State Management) والتنقل (Routing)

يستخدم التطبيق حزمة **Riverpod 2.x** كحل أساسي لإدارة الحالة وحقن الاعتماديات، مع **GoRouter** للتنقل.

-   **التحكم بالحالة (State Management)**:
    -   يتم تعريف الـ Notifiers باستخدام مولد الأكواد `riverpod_generator` (`@riverpod` أو `@Riverpod(keepAlive: true)`).
    -   تُستخدم `AsyncValue` (من خلال `AsyncData`, `AsyncLoading`, `AsyncError`) للتعامل الآمن مع الحالات غير المتزامنة وتجنب الأخطاء غير المعالجة.
    -   تُستخدم `ConsumerWidget` أو `ConsumerStatefulWidget` مع `ref.watch` لإعادة بناء الأجزاء اللازمة فقط، أو `ref.select` للاستماع لحقول محددة بكفاءة.

-   **حقن الاعتماديات (Dependency Injection)**:
    -   الخدمات والمستودعات (`ApiService`, `ProductRepository`, `AddressRepository`) تُسجل وتُحقن عبر Providers نقية عديمة الحالة.
    -   يتم الوصول للخدمات عبر تمرير `ref` أو مراقبة المزودات (`ref.watch(apiServiceProvider)`).

    ```dart
    // cart_controller.dart
    @riverpod
    class CartController extends _$CartController {
      @override
      FutureOr<List<CartItemModel>> build() async {
        return _cartBox.values.toList();
      }

      Future<void> addToCart(ProductModel product) async {
        // Business logic...
        state = AsyncData(_cartBox.values.toList());
      }
    }

    // cart_view.dart
    class CartView extends ConsumerWidget {
      @override
      Widget build(BuildContext context, WidgetRef ref) {
        final cartState = ref.watch(cartControllerProvider);
        return cartState.when(
          data: (items) => buildCartContent(items),
          loading: () => const CircularProgressIndicator(),
          error: (e, st) => Text('Error: $e'),
        );
      }
    }
    ```

-   **التخزين المحلي (Local Storage)**:
    -   يستخدم التطبيق **Hive** (`hive_flutter`) لتخزين البيانات محلياً. هذا يشمل:
        -   سلة التسوق (`cart` box).
        -   قائمة الرغبات (`wishlist` box).
        -   المنتجات والأقسام (`products` & `categories` boxes) للتخزين المؤقت (Caching).
        -   إعدادات المستخدم (مثل اللغة والمظهر).
        -   رمز المصادقة (`auth_box`).
    -   يتم تهيئة جميع "الصناديق" (Boxes) عند بدء تشغيل التطبيق عبر دالة `[[hive_init.dart]]`.

---

## ٥. المكونات الرئيسية (Key Components)

-   **`[[main.dart]]`**: نقطة انطلاق التطبيق. يقوم بتهيئة Firebase، Hive، GetX، إعدادات اللغة والثيم، وتحديد المسار الأولي.

-   **`[[main_page.dart]]`**: الشاشة الرئيسية التي تحتوي على شريط التنقل السفلي (`BottomNavigationBar`) وتدير الانتقال بين الشاشات الرئيسية (Home, Wishlist, Cart, Profile).

-   **Services (`/core/services`)**:
    -   **`[[api_service.dart]]`**: المكون المركزي المسؤول عن جميع طلبات الـ HTTP إلى الخادم. يعالج إضافة الترويسات، بناء الـ URI، ومعالجة الأخطاء الشائعة (مثل أخطاء الشبكة والمصادقة).
    -   **`[[auth_service.dart]]`**: مسؤول عن منطق المصادقة، مثل تسجيل الدخول، إنشاء حساب، وتسجيل الدخول عبر Google، بالتنسيق مع `ApiService`.
    -   **`[[storage_service.dart]]`**: طبقة تجريدية (abstraction layer) فوق Hive لتسهيل عمليات حفظ وجلب البيانات المحلية مثل رمز المصادقة.
    -   **`[[product_service.dart]]`** و **`[[category_service.dart]]`**: مسؤولة عن جلب بيانات المنتجات والأقسام من الـ API وتخزينها محلياً.

-   **Controllers (`/presentation/bindings`)**:
    -   **`[[auth_controller.dart]]`**: يدير حالة المستخدم الحالي (هل سجل الدخول أم لا) ومنطق عمليات المصادغة من منظور الواجهة.
    -   **`[[home_controller.dart]]`**: يدير جلب وعرض المنتجات في الصفحة الرئيسية، بالإضافة إلى التعامل مع حالات التحميل والأخطاء.
    -   **`[[cart_controller.dart]]`**: يدير حالة سلة التسوق (الإضافة، الحذف، تعديل الكمية) ويتفاعل مباشرة مع صندوق Hive الخاص بالسلة.
    -   **`[[wishlist_controller.dart]]`**: يدير قائمة المنتجات المفضلة للمستخدم.

-   **Data Models (`/data/models`)**:
    -   ملفات مثل `[[product_model.dart]]` و `[[user_model.dart]]` تُعرّف بنية البيانات في التطبيق. استخدام `freezed` يضمن عدم تغيير هذه النماذج بعد إنشائها، مما يمنع الأخطاء الجانبية غير المتوقعة.
