import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'todo_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLogin = true; // To toggle between Login and Signup
  bool _isLoading = false;

  Future<void> _authenticate() async {
    setState(() => _isLoading = true);
    try {
      if (_isLogin) {
        // Log in
        final response = await Supabase.instance.client.auth.signInWithPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        if (response.user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const TodoScreen()),
          );
        }
      } else {
        // Sign up
        final response = await Supabase.instance.client.auth.signUp(
          email: _emailController.text,
          password: _passwordController.text,
        );
        if (response.user != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Sign-up successful! Please log in.')),
          );
          setState(() => _isLogin = true); // Switch to login after signup
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 18, 18, 19),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Welcome!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _isLogin
                          ? 'Log in to your account'
                          : 'Create a new account',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Email Text Field
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email),
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    // Password Text Field
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Authentication Button
                    _isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: _authenticate,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 30),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Text(
                              _isLogin ? 'Log In' : 'Sign Up',
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                    const SizedBox(height: 10),
                    // Toggle Login/Signup
                    TextButton(
                      onPressed: () {
                        setState(() => _isLogin = !_isLogin);
                      },
                      child: Text(
                        _isLogin
                            ? 'Don’t have an account? Sign up'
                            : 'Already have an account? Log in',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
