import 'package:flutter/material.dart';

class TermsOfServiceDialog extends StatelessWidget {
  const TermsOfServiceDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Terms of Service'),
      backgroundColor: Colors.white,
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
                '1. Good Conduct:\n\n'
                    'You agree to behave respectfully towards other users and not engage in any abusive, discriminatory, or harmful behavior.\n\n'
                    '2. Privacy & Safety:\n\n'
                    'We take user privacy seriously. Your personal information will be kept safe and only shared when necessary for your account functionality or legal compliance.\n\n'
                    '3. Information Sharing:\n\n'
                    'By using the app, you acknowledge that your messages, notes, and group posts are stored and can be accessed as per the app’s data retention policy.\n\n'
                    '4. User Responsibility:\n\n'
                    'You are responsible for the content you post and share on the platform. We encourage you to share content that is respectful and appropriate.\n\n'
                    '5. Prohibited Content:\n\n'
                    'Any content that violates our community guidelines, including hate speech, illegal activity, or explicit content, is strictly prohibited and may result in account suspension or banning.\n\n'
                    '6. Account Security:\n\n'
                    'You are responsible for maintaining the security of your account and should take appropriate measures to protect your login credentials.'
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog after accepting
            // Navigate to the next screen or perform any other action after agreeing
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black, backgroundColor: Colors.white, // Black text color
            side: BorderSide(color: Colors.grey.shade400, width: 2), // Grey border
            elevation: 5, // Shadow effect
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // Rounded corners
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20), // Button padding
          ),
          child: const Text('Done'),
        )
      ],
    );
  }
}

void showTermsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const TermsOfServiceDialog();
    },
  );
}
