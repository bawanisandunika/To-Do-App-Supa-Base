import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  bool _passwordVisible = false; // For toggling password visibility

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
            const SnackBar(content: Text('Sign-up successful! Please log in.')),
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
      resizeToAvoidBottomInset:
          false, // Prevent layout adjustment on keyboard open
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Centered SVG Image
                  SvgPicture.asset(
                    'assets/images/login_img.svg',
                    height: 180,
                    width: 180,
                  ),
                  const SizedBox(height: 20),
                  // Welcome Text
                  Text(
                    _isLogin ? 'Welcome Back!' : 'Create Account',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _isLogin
                        ? 'Log in to continue'
                        : 'Sign up and join us today!',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            // Input fields and buttons in a scrollable section
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // Email Input Field
                    TextField(
                      controller: _emailController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        prefixIcon:
                            const Icon(Icons.email, color: Colors.white),
                        labelText: 'Email',
                        labelStyle: const TextStyle(color: Colors.white),
                        filled: true,
                        fillColor: Colors.grey[900],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    // Password Input Field
                    TextField(
                      controller: _passwordController,
                      obscureText: !_passwordVisible,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock, color: Colors.white),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(
                                () => _passwordVisible = !_passwordVisible);
                          },
                        ),
                        labelText: 'Password',
                        labelStyle: const TextStyle(color: Colors.white),
                        filled: true,
                        fillColor: Colors.grey[900],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Authentication Button
                    _isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: _authenticate,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 92, 7, 100),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Text(
                              _isLogin ? 'Log In' : 'Sign Up',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white, // Button text color
                              ),
                            ),
                          ),
                    const SizedBox(height: 20),
                    // Social Media Sign-In Options
                    if (!_isLogin)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.g_mobiledata, size: 40),
                            color: Colors.white,
                            onPressed: () {},
                            tooltip: 'Sign in with Google',
                          ),
                          const SizedBox(width: 20),
                          IconButton(
                            icon: const Icon(Icons.facebook, size: 40),
                            color: const Color.fromARGB(255, 142, 33, 243),
                            onPressed: () {},
                            tooltip: 'Sign in with Facebook',
                          ),
                          const SizedBox(width: 20),
                          IconButton(
                            icon: const Icon(Icons.apple, size: 40),
                            color: Colors.white,
                            onPressed: () {},
                            tooltip: 'Sign in with Apple',
                          ),
                        ],
                      ),
                    const SizedBox(height: 20),
                    // Toggle Between Login and Signup
                    TextButton(
                      onPressed: () {
                        setState(() => _isLogin = !_isLogin);
                      },
                      child: Text(
                        _isLogin
                            ? 'Don’t have an account? Sign up'
                            : 'Already have an account? Log in',
                        style: const TextStyle(
                          color: const Color.fromARGB(255, 92, 7, 100),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
          ],
        ),
      ),
    );
  }
}
