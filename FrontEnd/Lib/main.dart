import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:govi_arana/screens/create_machine.dart';
import 'package:govi_arana/screens/crop_screen.dart';
import 'package:govi_arana/screens/payment_screen.dart';
import 'package:govi_arana/screens/update_growth_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:govi_arana/screens/prediction_screen.dart';

import 'firebase_options.dart';

// Core Screens
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/profile_screen.dart';

// Disease & Guide
import 'screens/disease_screen.dart';
import 'screens/add_disease_screen.dart';
import 'screens/disease_detail_screen.dart';
import 'screens/add_remedy_screen.dart';
import 'screens/guide_screen.dart';
import 'screens/guide_detail_screen.dart';

// Static Screens
import 'screens/help_screen.dart';
import 'screens/feedback_screen.dart';
import 'screens/aboutus_screen.dart';
import 'screens/location.dart';

// Rental & Crop
import 'screens/rental_screen.dart';
import 'screens/book_rental_screen.dart';


// Forum
import 'screens/forums_screen.dart';
import 'screens/create_forum_screen.dart';
import 'screens/forum_detail_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.containsKey('email');
  final userId = prefs.getString('userId') ?? '';
  final userName = prefs.getString('name') ?? '';
  final email = prefs.getString('email') ?? '';

  runApp(GoviAranaApp(
    isLoggedIn: isLoggedIn,
    userId: userId,
    userName: userName,
    email: email,
  ));
}

class GoviAranaApp extends StatelessWidget {
  final bool isLoggedIn;
  final String userId;
  final String userName;
  final String email;

  const GoviAranaApp({
    super.key,
    required this.isLoggedIn,
    required this.userId,
    required this.userName,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Govi Arana',
      theme: ThemeData(primarySwatch: Colors.green),
      initialRoute: isLoggedIn ? '/dashboard' : '/',
      routes: {
        '/': (ctx) => const WelcomeScreen(),
        '/login': (ctx) => LoginScreen(),
        '/signup': (ctx) => SignupScreen(),
        '/dashboard': (ctx) => DashboardScreen(
              userId: userId,
              userName: userName,
              email: email,
              authToken: '',
            ),
        '/diseases': (ctx) => const DiseaseListScreen(),
        '/add-disease': (ctx) => AddDiseaseScreen(),
        '/guide': (ctx) => const GuideListScreen(),
        '/help': (ctx) => const HelpScreen(),
        '/feedback': (ctx) => const FeedbackScreen(),
        '/about': (ctx) => const AboutUsScreen(),
        '/location': (ctx) => LocationScreen(),
        '/forum': (ctx) => const ForumListScreen(),
        '/create-forum': (ctx) => const CreateForumScreen(currentUser: ''),
        '/crops': (ctx) => CropsScreen(authToken: ''),
        '/predict': (context) => PredictScreen(), 
        '/list-machine': (context) => ListMachineScreen(),
     
      },
      onGenerateRoute: (settings) {
        final args = settings.arguments;

        switch (settings.name) {
      
      case '/updateCrop':
        if (args is Map<String, dynamic>) {
          return MaterialPageRoute(
            builder: (_) => UpdateProductivityScreen(crop: args),
          );
        }
        return _errorRoute();
      case '/bookings':
        return MaterialPageRoute(
          builder: (_) => BookMachineScreen(),
          settings: settings,
        );
         

       case '/list':
        return MaterialPageRoute(
          builder: (_) => MachineListScreen(),
        );


          case '/profile':
  if (args is Map<String, dynamic>) {
    return MaterialPageRoute(
      builder: (_) => ProfileScreen(
        email: args['email'] ?? '',
      ),
    );
  }
  return _errorRoute();

          case '/disease-detail':
            if (args is Map<String, dynamic> && args['id'] is String) {
              return MaterialPageRoute(
                builder: (_) =>
                    DiseaseDetailScreen(diseaseId: args['id'] as String),
              );
            }
            return _errorRoute();

          case '/add-remedy':
            if (args is Map<String, dynamic> && args['id'] is String) {
              return MaterialPageRoute(
                builder: (_) =>
                    AddRemedyScreen(diseaseId: args['id'] as String),
              );
            }
            return _errorRoute();

          case '/guideDetail':
            if (args is String) {
              return MaterialPageRoute(
                builder: (_) => GuideDetailScreen(guideId: args),
              );
            }
            return _errorRoute();

          case '/update':
  if (args is Map<String, dynamic>) {
    return MaterialPageRoute(
      builder: (_) => ProfileScreen(
        email: args['email'] ?? '',
      ),
    );
  }
  return _errorRoute();

case '/deleteUser':
  if (args is Map<String, dynamic>) {
    return MaterialPageRoute(
      builder: (_) => ProfileScreen(
        email: args['email'] ?? '',
      ),
    );
  }
  return _errorRoute();
          
          case '/forum-detail':
            if (args is String) {
              return MaterialPageRoute(
                builder: (_) => ForumDetailScreen(forumId: args),
              );
            }
            return _errorRoute();

  case '/payment':
  if (args is Map<String, dynamic> &&
      args.containsKey('bookingId') &&
      args.containsKey('amount')) {
    return MaterialPageRoute(
      builder: (_) => PaymentScreen(
        bookingId: args['bookingId'] as String,
        amount: args['amount'] as int, totalCost:(args['totalCost'] as num).toDouble(),
      ),
    );
  }
  return _errorRoute();

          default:
            return _errorRoute();
        }
      },
    );
  }

  Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text("Error")),
        body: const Center(child: Text("Page not found")),
      ),
    );
  }
}
