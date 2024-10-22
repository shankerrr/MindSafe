// ignore_for_file: library_private_types_in_public_api, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MentalHealthApp());
}

// MentalHealthApp Class - App Entry Point
class MentalHealthApp extends StatelessWidget {
  const MentalHealthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChatProvider(),
      child: MaterialApp(
        title: 'Mental Health App',
        theme: ThemeData(
          primaryColor: const Color(0xFF00796B), // Dark teal
          secondaryHeaderColor: const Color(0xFF004D40), // Teal
          visualDensity: VisualDensity.adaptivePlatformDensity,
          scaffoldBackgroundColor: Colors.white,
          textTheme: const TextTheme(
            bodyLarge: TextStyle(fontFamily: 'Arial', color: Colors.black87),
          ),
        ),
        home: const LoginPage(), // Start with login page
      ),
    );
  }
}

// Chat Provider for managing chat messages
class ChatProvider with ChangeNotifier {
  final List<Message> _messages = [];

  var message;

  List<Message> get messages => _messages;

  void sendMessage(String text) {
    _messages.add(Message(text: text, isUser: true, date: DateTime.now()));
    notifyListeners();
    receiveResponse(text);
  }

  void receiveResponse(String userInput) {
    String response;

    if (userInput.toLowerCase().contains('sad') ||
        userInput.toLowerCase().contains('anxiety') ||
        userInput.toLowerCase().contains('fear')) {
      response = [
        "It's okay to feel sad. Want to share what's on your mind?",
        "Sadness is tough. I'm here if you'd like to talk.",
        "Sadness can feel heavy. Feel free to express your feelings."
      ][DateTime.now().second % 3];
    } else if (userInput.toLowerCase().contains('anxiety')) {
      response = [
        "Anxiety is overwhelming sometimes. Have you tried deep breathing?",
        "It's normal to feel anxious. What's on your mind?",
        "Take a deep breath. Want to talk about what's causing anxiety?"
      ][DateTime.now().second % 3];
    } else if (userInput.toLowerCase().contains('thank you') ||
        userInput.toLowerCase().contains('bye')) {
      response = "You're welcome! Let me know if you need more help.";
      _messages
          .add(Message(text: response, isUser: false, date: DateTime.now()));
      _messages.add(
          Message(text: "Take care!", isUser: false, date: DateTime.now()));
      notifyListeners();
    } else if (userInput.toLowerCase().contains('safety') ||
        userInput.toLowerCase().contains('danger')) {
      response =
          "Your safety is the priority. Ensure you're following evacuation orders and staying in contact with emergency services. You can also find shelter information through local     disaster response teams.";
    } else if (userInput.toLowerCase().contains('sad') ||
        userInput.toLowerCase().contains('overwhelmed')) {
      response =
          "This is an incredibly tough time, and it's okay to feel sad or overwhelmed. Try to reach out to loved ones or a crisis support line for emotional assistance.";
    } else if (userInput.toLowerCase().contains('evacuation')) {
      response =
          "Evacuation procedures can be overwhelming. Ensure you're prepared with an emergency kit, and follow instructions from local authorities. Would you like a list of emergency contacts?";
    } else if (userInput.toLowerCase().contains('help') ||
        userInput.toLowerCase().contains('support')) {
      response =
          "You are not alone in this. If you're in immediate danger, contact your local emergency services. Otherwise, you can also talk to mental health professionals who specialize in crisis situations.";
    } else if (userInput.toLowerCase().contains('aftershock') ||
        userInput.toLowerCase().contains('earthquake')) {
      response =
          "Aftershocks can be frightening. Try to stay in a safe area, and remember that aftershocks are usually smaller than the initial quake. It's important to stay informed through official channels.";
    } else if (userInput.toLowerCase().contains('flood') ||
        userInput.toLowerCase().contains('storm')) {
      response =
          "Flooding can be dangerous. Move to higher ground if you're in a flood-prone area. Stay indoors during storms and avoid any contact with floodwaters as they may be contaminated.";
    } else if (userInput.toLowerCase().contains('relief') ||
        userInput.toLowerCase().contains('resources')) {
      response =
          "There are many disaster relief resources available. I can provide you with information on shelters, food assistance, or emotional support services in your area.";
      return;
    } else {
      response = [
        "Tell me more about how you're feeling.",
        "I'm here to listen. What's been on your mind?",
        "Feel free to share anything that's bothering you."
      ][DateTime.now().second % 3];
    }

    _messages.add(Message(text: response, isUser: false, date: DateTime.now()));
    notifyListeners();
  }
}

// Message Class to model the chat messages
class Message {
  final String text;
  final bool isUser;
  final DateTime date;

  Message({required this.text, required this.isUser, required this.date});
}

// Mock database for user credentials
class UserDatabase {
  static final Map<String, String> _users = {};

  static bool register(String username, String password) {
    if (_users.containsKey(username)) {
      return false; // User already exists
    }
    _users[username] = password; // Register new user
    return true;
  }

  static bool login(String username, String password) {
    return _users[username] == password; // Validate user
  }
}

// Login Page Class
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true; // To toggle password visibility

  void _login() {
    if (UserDatabase.login(
        _usernameController.text, _passwordController.text)) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } else {
      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid username or password')),
      );
    }
  }

  void _navigateToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: const Color(0xFF004D40), // Teal
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              obscureText: _obscurePassword,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00796B), // Dark teal
                padding: const EdgeInsets.symmetric(vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Login',
                  style: TextStyle(color: Colors.white)), // Changed to white
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: _navigateToRegister,
              child: const Text('Create an Account',
                  style: TextStyle(color: Color(0xFF00796B))),
            ),
          ],
        ),
      ),
    );
  }
}

// Registration Page Class
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true; // To toggle password visibility

  void _register() {
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (UserDatabase.register(username, password)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created successfully!')),
      );
      Navigator.pop(context); // Go back to login
    } else {
      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username already exists')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        backgroundColor: const Color(0xFF004D40), // Teal
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              obscureText: _obscurePassword,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _register,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00796B), // Dark teal
                padding: const EdgeInsets.symmetric(vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Register',
                  style: TextStyle(color: Colors.white)), // Changed to white
            ),
          ],
        ),
      ),
    );
  }
}

// Main Screen after login, with Chat, Calming Music, and SOS Button
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mental Health App'),
        backgroundColor: const Color(0xFF004D40), // Teal
      ),
      body: Column(
        children: [
          // Centered buttons for music and SOS
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          // Placeholder for calming music functionality
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(20),
                          textStyle: const TextStyle(fontSize: 18),
                          backgroundColor: const Color(0xFF00796B), // Dark teal
                        ),
                        icon: const Icon(Icons.music_note),
                        label: const Text('Calming Music',
                            style: TextStyle(
                                color: Colors.white)), // Changed to white
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          // Call the SOS function directly
                          _makePhoneCall('+91 99996 66555');
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(20),
                          textStyle: const TextStyle(fontSize: 18),
                          backgroundColor: const Color(0xFF00796B), // Dark teal
                        ),
                        icon: const Icon(Icons.local_phone),
                        label: const Text('SOS Emergency',
                            style: TextStyle(
                                color: Colors.white)), // Changed to white
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Expanded(child: ChatScreen()), // Place ChatScreen below buttons
        ],
      ),
    );
  }

  // This function initiates the phone call
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

// Chat Screen for Mental Health Conversations
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _userInput = TextEditingController();
  bool _isLoading = false; // Flag to track loading state

  Future<void> sendMessage() async {
    final message = _userInput.text.trim();
    if (message.isEmpty) return; // Prevent sending empty messages

    setState(() {
      _isLoading = true; // Set loading to true
    });

    // Send the message to the ChatProvider
    Provider.of<ChatProvider>(context, listen: false).sendMessage(message);
    _userInput.clear(); // Clear input field after sending

    // Simulate loading for a moment before finishing (you can adjust the timing)
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false; // Set loading to false after the response is received
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.7),
              BlendMode.dstATop,
            ),
            image: const AssetImage('assets/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Consumer<ChatProvider>(
                builder: (context, chatProvider, child) {
                  return ListView.builder(
                    itemCount: chatProvider.messages.length,
                    itemBuilder: (context, index) {
                      final message = chatProvider.messages[index];
                      return ListTile(
                        title: Text(message.text),
                        subtitle: Text(DateFormat.jm().format(message.date)),
                        tileColor: message.isUser
                            ? Colors.lightBlue[100]
                            : Colors.green[100],
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _userInput,
                      decoration: const InputDecoration(
                        hintText: 'Type your message...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: sendMessage, // Call sendMessage when pressed
                  ),
                ],
              ),
            ),
            if (_isLoading)
              const CircularProgressIndicator(), // Show loading indicator
          ],
        ),
      ),
    );
  }
}
