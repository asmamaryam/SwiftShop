// ignore_for_file: deprecated_member_use, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:my_shop/provider/cart.dart';
import 'package:my_shop/screens/splash_screen.dart';
import 'package:provider/provider.dart';

import './provider/product_provider.dart';
import '../provider/auth.dart';
import '../provider/order.dart';
import '../screens/order_screen.dart';
import '../screens/user_product_screen.dart';
import '../screens/edit_product_screen.dart';
import '../screens/product_overview_screen.dart';
import '../screens/product_detail_screen.dart';
import '../screens/auth_screen.dart';
import '../screens/cart_screen.dart';
import '../helpers/custom_route.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductsProvider>(
          update: (ctx, auth, previousproduct) => ProductsProvider(
            auth.token.toString(),
            auth.userId,
            previousproduct == null ? [] : previousproduct.item,
          ),
          create: (context) => ProductsProvider('', '', []),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (ctx, auth, previousproduct) => Orders(
            auth.token.toString(),
            auth.userId,
            previousproduct == null ? [] : previousproduct.orders,
          ),
          create: (ctx) => Orders('', '', []),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, authValue, _) => MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
              fontFamily: 'Lato',
              pageTransitionsTheme: PageTransitionsTheme(builders: {
                TargetPlatform.android: CustompageTransitionBuilder(),
                TargetPlatform.iOS: CustompageTransitionBuilder(),
              }),
              colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.pink)
                  .copyWith(secondary: Colors.lightBlue)),
          home: authValue.isAuth
              ? ProductOverviewScreen()
              : FutureBuilder(
                  future: authValue.tryAutologin(),
                  builder: (ctx, authResultsnapshot) =>
                      authResultsnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen()),
          routes: {
            ProductDetailScreen.rotename: (context) => ProductDetailScreen(),
            CartScreen.routname: (context) => CartScreen(),
            OrderScreen.routname: (context) => OrderScreen(),
            UserProductScreen.routename: (context) => UserProductScreen(),
            EditProductScreen.routname: (context) => EditProductScreen(),
          },
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
