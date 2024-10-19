// class AuthWrapper extends StatelessWidget {
//   const AuthWrapper({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<User?>(
//       stream: FirebaseAuth.instance.authStateChanges(), // Listen for auth state changes
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator()); // Show a loading spinner while waiting
//         }
//         if (snapshot.hasData) {
//           return const BottomNavigation(); // User is signed in, show bottom navigation
//         } else {
//           return const LoginPage(); // User is not signed in, show login page
//         }
//       },
//     );
//   }
// }