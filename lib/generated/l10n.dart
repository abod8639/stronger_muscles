// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Stronger Muscles`
  String get appTitle {
    return Intl.message(
      'Stronger Muscles',
      name: 'appTitle',
      desc: '',
      args: [],
    );
  }

  /// `Welcome Back!`
  String get welcomeBack {
    return Intl.message(
      'Welcome Back!',
      name: 'welcomeBack',
      desc: '',
      args: [],
    );
  }

  /// `Sign in to continue`
  String get signInToContinue {
    return Intl.message(
      'Sign in to continue',
      name: 'signInToContinue',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your email`
  String get enterEmail {
    return Intl.message(
      'Please enter your email',
      name: 'enterEmail',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email`
  String get validEmail {
    return Intl.message(
      'Please enter a valid email',
      name: 'validEmail',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your password`
  String get enterPassword {
    return Intl.message(
      'Please enter your password',
      name: 'enterPassword',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 6 characters`
  String get passwordLength {
    return Intl.message(
      'Password must be at least 6 characters',
      name: 'passwordLength',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password?`
  String get forgotPassword {
    return Intl.message(
      'Forgot Password?',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Forgot password not implemented yet`
  String get forgotPasswordNotImplemented {
    return Intl.message(
      'Forgot password not implemented yet',
      name: 'forgotPasswordNotImplemented',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `OR`
  String get or {
    return Intl.message(
      'OR',
      name: 'or',
      desc: '',
      args: [],
    );
  }

  /// `Sign in with Google`
  String get signInWithGoogle {
    return Intl.message(
      'Sign in with Google',
      name: 'signInWithGoogle',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account? `
  String get dontHaveAccount {
    return Intl.message(
      'Don\'t have an account? ',
      name: 'dontHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get signUp {
    return Intl.message(
      'Sign Up',
      name: 'signUp',
      desc: '',
      args: [],
    );
  }

  /// `Create Account`
  String get createAccount {
    return Intl.message(
      'Create Account',
      name: 'createAccount',
      desc: '',
      args: [],
    );
  }

  /// `Sign up to get started`
  String get signUpToGetStarted {
    return Intl.message(
      'Sign up to get started',
      name: 'signUpToGetStarted',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Please confirm your password`
  String get confirmYourPassword {
    return Intl.message(
      'Please confirm your password',
      name: 'confirmYourPassword',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get passwordsDoNotMatch {
    return Intl.message(
      'Passwords do not match',
      name: 'passwordsDoNotMatch',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account? `
  String get alreadyHaveAccount {
    return Intl.message(
      'Already have an account? ',
      name: 'alreadyHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Search products...`
  String get searchProducts {
    return Intl.message(
      'Search products...',
      name: 'searchProducts',
      desc: '',
      args: [],
    );
  }

  /// `Filter products`
  String get filterProducts {
    return Intl.message(
      'Filter products',
      name: 'filterProducts',
      desc: '',
      args: [],
    );
  }

  /// `Filter`
  String get filter {
    return Intl.message(
      'Filter',
      name: 'filter',
      desc: '',
      args: [],
    );
  }

  /// `Most Popular Offers`
  String get mostPopularOffers {
    return Intl.message(
      'Most Popular Offers',
      name: 'mostPopularOffers',
      desc: '',
      args: [],
    );
  }

  /// `See all`
  String get seeAll {
    return Intl.message(
      'See all',
      name: 'seeAll',
      desc: '',
      args: [],
    );
  }

  /// `Special Offer!`
  String get specialOffer {
    return Intl.message(
      'Special Offer!',
      name: 'specialOffer',
      desc: '',
      args: [],
    );
  }

  /// `Get 20% off on all products`
  String get getDiscount {
    return Intl.message(
      'Get 20% off on all products',
      name: 'getDiscount',
      desc: '',
      args: [],
    );
  }

  /// `Shop Now`
  String get shopNow {
    return Intl.message(
      'Shop Now',
      name: 'shopNow',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get categoryHome {
    return Intl.message(
      'Home',
      name: 'categoryHome',
      desc: '',
      args: [],
    );
  }

  /// `Protein`
  String get categoryProtein {
    return Intl.message(
      'Protein',
      name: 'categoryProtein',
      desc: '',
      args: [],
    );
  }

  /// `Creatine`
  String get categoryCreatine {
    return Intl.message(
      'Creatine',
      name: 'categoryCreatine',
      desc: '',
      args: [],
    );
  }

  /// `Amino`
  String get categoryAmino {
    return Intl.message(
      'Amino',
      name: 'categoryAmino',
      desc: '',
      args: [],
    );
  }

  /// `BCAA`
  String get categoryBCAA {
    return Intl.message(
      'BCAA',
      name: 'categoryBCAA',
      desc: '',
      args: [],
    );
  }

  /// `Pre-workout`
  String get categoryPreWorkout {
    return Intl.message(
      'Pre-workout',
      name: 'categoryPreWorkout',
      desc: '',
      args: [],
    );
  }

  /// `Mass Gainer`
  String get categoryMassGainer {
    return Intl.message(
      'Mass Gainer',
      name: 'categoryMassGainer',
      desc: '',
      args: [],
    );
  }

  /// `Vitamins`
  String get categoryVitamins {
    return Intl.message(
      'Vitamins',
      name: 'categoryVitamins',
      desc: '',
      args: [],
    );
  }

  /// `Recovery`
  String get categoryRecovery {
    return Intl.message(
      'Recovery',
      name: 'categoryRecovery',
      desc: '',
      args: [],
    );
  }

  /// `Fat Burner`
  String get categoryFatBurner {
    return Intl.message(
      'Fat Burner',
      name: 'categoryFatBurner',
      desc: '',
      args: [],
    );
  }

  /// `Health`
  String get categoryHealth {
    return Intl.message(
      'Health',
      name: 'categoryHealth',
      desc: '',
      args: [],
    );
  }

  /// `My Account`
  String get myAccount {
    return Intl.message(
      'My Account',
      name: 'myAccount',
      desc: '',
      args: [],
    );
  }

  /// `Sign Out`
  String get signOut {
    return Intl.message(
      'Sign Out',
      name: 'signOut',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get accountSettings {
    return Intl.message(
      'Settings',
      name: 'accountSettings',
      desc: '',
      args: [],
    );
  }

  /// `Edit Profile`
  String get editProfile {
    return Intl.message(
      'Edit Profile',
      name: 'editProfile',
      desc: '',
      args: [],
    );
  }

  /// `Theme`
  String get theme {
    return Intl.message(
      'Theme',
      name: 'theme',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Help & Support`
  String get helpSupport {
    return Intl.message(
      'Help & Support',
      name: 'helpSupport',
      desc: '',
      args: [],
    );
  }

  /// `About`
  String get about {
    return Intl.message(
      'About',
      name: 'about',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get english {
    return Intl.message(
      'English',
      name: 'english',
      desc: '',
      args: [],
    );
  }

  /// `Arabic`
  String get arabic {
    return Intl.message(
      'Arabic',
      name: 'arabic',
      desc: '',
      args: [],
    );
  }

  /// `Cart`
  String get cart {
    return Intl.message(
      'Cart',
      name: 'cart',
      desc: '',
      args: [],
    );
  }

  /// `Your cart is empty`
  String get yourCartIsEmpty {
    return Intl.message(
      'Your cart is empty',
      name: 'yourCartIsEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Add products to get started`
  String get addProductsToGetStarted {
    return Intl.message(
      'Add products to get started',
      name: 'addProductsToGetStarted',
      desc: '',
      args: [],
    );
  }

  /// `Start Shopping`
  String get startShopping {
    return Intl.message(
      'Start Shopping',
      name: 'startShopping',
      desc: '',
      args: [],
    );
  }

  /// `Total`
  String get total {
    return Intl.message(
      'Total',
      name: 'total',
      desc: '',
      args: [],
    );
  }

  /// `item`
  String get item {
    return Intl.message(
      'item',
      name: 'item',
      desc: '',
      args: [],
    );
  }

  /// `items`
  String get items {
    return Intl.message(
      'items',
      name: 'items',
      desc: '',
      args: [],
    );
  }

  /// `Checkout`
  String get checkout {
    return Intl.message(
      'Checkout',
      name: 'checkout',
      desc: '',
      args: [],
    );
  }

  /// `Proceed to checkout`
  String get proceedToCheckout {
    return Intl.message(
      'Proceed to checkout',
      name: 'proceedToCheckout',
      desc: '',
      args: [],
    );
  }

  /// `Wishlist`
  String get wishlist {
    return Intl.message(
      'Wishlist',
      name: 'wishlist',
      desc: '',
      args: [],
    );
  }

  /// `Your wishlist is empty.`
  String get yourWishlistIsEmpty {
    return Intl.message(
      'Your wishlist is empty.',
      name: 'yourWishlistIsEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Start adding your favorite products!`
  String get startAddingFavorites {
    return Intl.message(
      'Start adding your favorite products!',
      name: 'startAddingFavorites',
      desc: '',
      args: [],
    );
  }

  /// `Continue Shopping`
  String get continueShopping {
    return Intl.message(
      'Continue Shopping',
      name: 'continueShopping',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get address {
    return Intl.message(
      'Address',
      name: 'address',
      desc: '',
      args: [],
    );
  }

  /// `No addresses found. Please add one in your profile.`
  String get noAddressesFound {
    return Intl.message(
      'No addresses found. Please add one in your profile.',
      name: 'noAddressesFound',
      desc: '',
      args: [],
    );
  }

  /// `Add New Address`
  String get addNewAddress {
    return Intl.message(
      'Add New Address',
      name: 'addNewAddress',
      desc: '',
      args: [],
    );
  }

  /// `Payment`
  String get payment {
    return Intl.message(
      'Payment',
      name: 'payment',
      desc: '',
      args: [],
    );
  }

  /// `Review`
  String get review {
    return Intl.message(
      'Review',
      name: 'review',
      desc: '',
      args: [],
    );
  }

  /// `Order Summary`
  String get orderSummary {
    return Intl.message(
      'Order Summary',
      name: 'orderSummary',
      desc: '',
      args: [],
    );
  }

  /// `Total Amount`
  String get totalAmount {
    return Intl.message(
      'Total Amount',
      name: 'totalAmount',
      desc: '',
      args: [],
    );
  }

  /// `Shipping To:`
  String get shippingTo {
    return Intl.message(
      'Shipping To:',
      name: 'shippingTo',
      desc: '',
      args: [],
    );
  }

  /// `Payment Method:`
  String get paymentMethod {
    return Intl.message(
      'Payment Method:',
      name: 'paymentMethod',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get back {
    return Intl.message(
      'Back',
      name: 'back',
      desc: '',
      args: [],
    );
  }

  /// `No products found.`
  String get noProductsFound {
    return Intl.message(
      'No products found.',
      name: 'noProductsFound',
      desc: '',
      args: [],
    );
  }

  /// `Add to Cart`
  String get addToCart {
    return Intl.message(
      'Add to Cart',
      name: 'addToCart',
      desc: '',
      args: [],
    );
  }

  /// `Add New`
  String get addNew {
    return Intl.message(
      'Add New',
      name: 'addNew',
      desc: '',
      args: [],
    );
  }

  /// `View All`
  String get viewAll {
    return Intl.message(
      'View All',
      name: 'viewAll',
      desc: '',
      args: [],
    );
  }

  /// `Product Description`
  String get productDescription {
    return Intl.message(
      'Product Description',
      name: 'productDescription',
      desc: '',
      args: [],
    );
  }

  /// `Full Name`
  String get fullName {
    return Intl.message(
      'Full Name',
      name: 'fullName',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your full name`
  String get enterName {
    return Intl.message(
      'Please enter your full name',
      name: 'enterName',
      desc: '',
      args: [],
    );
  }

  /// `Select Flavor`
  String get selectFlavor {
    return Intl.message(
      'Select Flavor',
      name: 'selectFlavor',
      desc: '',
      args: [],
    );
  }

  /// `Customer Reviews`
  String get customerReviews {
    return Intl.message(
      'Customer Reviews',
      name: 'customerReviews',
      desc: '',
      args: [],
    );
  }

  /// `Be the first to review this product`
  String get beTheFirstToReviewThisProduct {
    return Intl.message(
      'Be the first to review this product',
      name: 'beTheFirstToReviewThisProduct',
      desc: '',
      args: [],
    );
  }

  /// `No images available`
  String get noImagesAvailable {
    return Intl.message(
      'No images available',
      name: 'noImagesAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Product Image`
  String get productImage {
    return Intl.message(
      'Product Image',
      name: 'productImage',
      desc: '',
      args: [],
    );
  }

  /// `Warnings`
  String get warnings {
    return Intl.message(
      'Warnings',
      name: 'warnings',
      desc: '',
      args: [],
    );
  }

  /// `Usage Instructions`
  String get usageInstructions {
    return Intl.message(
      'Usage Instructions',
      name: 'usageInstructions',
      desc: '',
      args: [],
    );
  }

  /// `Product Info`
  String get productInfo {
    return Intl.message(
      'Product Info',
      name: 'productInfo',
      desc: '',
      args: [],
    );
  }

  /// `Brand`
  String get brand {
    return Intl.message(
      'Brand',
      name: 'brand',
      desc: '',
      args: [],
    );
  }

  /// `SKU`
  String get sku {
    return Intl.message(
      'SKU',
      name: 'sku',
      desc: '',
      args: [],
    );
  }

  /// `Serving Size`
  String get servingSize {
    return Intl.message(
      'Serving Size',
      name: 'servingSize',
      desc: '',
      args: [],
    );
  }

  /// `Servings Per Container`
  String get servingsPerContainer {
    return Intl.message(
      'Servings Per Container',
      name: 'servingsPerContainer',
      desc: '',
      args: [],
    );
  }

  /// `Weight`
  String get weight {
    return Intl.message(
      'Weight',
      name: 'weight',
      desc: '',
      args: [],
    );
  }

  /// `Size`
  String get size {
    return Intl.message(
      'Size',
      name: 'size',
      desc: '',
      args: [],
    );
  }

  /// `Manufacturer`
  String get manufacturer {
    return Intl.message(
      'Manufacturer',
      name: 'manufacturer',
      desc: '',
      args: [],
    );
  }

  /// `Country of Origin`
  String get countryOfOrigin {
    return Intl.message(
      'Country of Origin',
      name: 'countryOfOrigin',
      desc: '',
      args: [],
    );
  }

  /// `New Arrival`
  String get newArrival {
    return Intl.message(
      'New Arrival',
      name: 'newArrival',
      desc: '',
      args: [],
    );
  }

  /// `Best Seller`
  String get bestSeller {
    return Intl.message(
      'Best Seller',
      name: 'bestSeller',
      desc: '',
      args: [],
    );
  }

  /// `Featured`
  String get featured {
    return Intl.message(
      'Featured',
      name: 'featured',
      desc: '',
      args: [],
    );
  }

  /// `Ingredients`
  String get ingredients {
    return Intl.message(
      'Ingredients',
      name: 'ingredients',
      desc: '',
      args: [],
    );
  }

  /// `Added to Cart`
  String get addedToCart {
    return Intl.message(
      'Added to Cart',
      name: 'addedToCart',
      desc: '',
      args: [],
    );
  }

  /// `Decrease Quantity`
  String get decreaseQuantity {
    return Intl.message(
      'Decrease Quantity',
      name: 'decreaseQuantity',
      desc: '',
      args: [],
    );
  }

  /// `Remove from Cart`
  String get removeFromCart {
    return Intl.message(
      'Remove from Cart',
      name: 'removeFromCart',
      desc: '',
      args: [],
    );
  }

  /// `Flavor`
  String get flavor {
    return Intl.message(
      'Flavor',
      name: 'flavor',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
