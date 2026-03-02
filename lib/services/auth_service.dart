// Firebase Authentication Service
// Handles user registration, login, logout, and session management

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// AuthService - Manages all authentication operations
/// Provides methods for sign-up, sign-in, sign-out, and user state monitoring
class AuthService {
  // Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Get current user
  User? get currentUser => _auth.currentUser;

  /// Stream of authentication state changes
  /// Use this to listen for login/logout events
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Check if user is logged in
  bool get isLoggedIn => _auth.currentUser != null;

  /// Sign up with email and password
  /// Returns User object on success, null on failure
  Future<User?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Send email verification (optional)
      await result.user?.sendEmailVerification();
      
      print('✅ User created: ${result.user?.email}');
      return result.user;
    } on FirebaseAuthException catch (e) {
      print('❌ Sign up error: ${e.message}');
      _handleAuthException(e);
      return null;
    }
  }

  /// Sign in with email and password
  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      print('✅ User logged in: ${result.user?.email}');
      return result.user;
    } on FirebaseAuthException catch (e) {
      print('❌ Sign in error: ${e.message}');
      _handleAuthException(e);
      return null;
    }
  }

  /// Sign out current user
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      print('✅ User signed out');
    } catch (e) {
      print('❌ Sign out error: $e');
    }
  }

  /// Send password reset email
  Future<bool> resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      print('✅ Password reset email sent to $email');
      return true;
    } on FirebaseAuthException catch (e) {
      print('❌ Password reset error: ${e.message}');
      _handleAuthException(e);
      return false;
    }
  }

  /// Update user display name
  Future<void> updateDisplayName(String displayName) async {
    try {
      await _auth.currentUser?.updateDisplayName(displayName);
      print('✅ Display name updated to $displayName');
    } catch (e) {
      print('❌ Update display name error: $e');
    }
  }

  /// Delete current user account
  Future<bool> deleteAccount() async {
    try {
      await _auth.currentUser?.delete();
      print('✅ User account deleted');
      return true;
    } on FirebaseAuthException catch (e) {
      print('❌ Delete account error: ${e.message}');
      _handleAuthException(e);
      return false;
    }
  }

  /// Handle Firebase Auth exceptions with user-friendly messages
  void _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        throw Exception('The password is too weak.');
      case 'email-already-in-use':
        throw Exception('An account already exists with this email.');
      case 'user-not-found':
        throw Exception('No user found with this email.');
      case 'wrong-password':
        throw Exception('Incorrect password.');
      case 'invalid-email':
        throw Exception('The email address is invalid.');
      case 'user-disabled':
        throw Exception('This account has been disabled.');
      case 'too-many-requests':
        throw Exception('Too many attempts. Please try again later.');
      case 'operation-not-allowed':
        throw Exception('This operation is not allowed.');
      default:
        throw Exception('Authentication failed: ${e.message}');
    }
  }
}

// ============================================================================
// EXAMPLE USAGE IN A FLUTTER SCREEN
// ============================================================================

/// Login Screen - Example implementation using AuthService
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Handle login logic
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final user = await _authService.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (user != null && mounted) {
        // Navigate to home screen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login successful!')),
        );
        // Navigator.pushReplacement(context, MaterialPageRoute(...));
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// Handle sign up logic
  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final user = await _authService.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (user != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account created! Please verify your email.')),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Authentication'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Email field
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Password field
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              
              // Error message
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    _errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              
              // Login button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Login'),
                ),
              ),
              const SizedBox(height: 12),
              
              // Sign up button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _isLoading ? null : _handleSignUp,
                  child: const Text('Create Account'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// AUTH STATE LISTENER - Automatically navigate based on auth state
// ============================================================================

/// AuthGate - Listens to auth state and routes accordingly
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        // Show loading while checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // User is logged in
        if (snapshot.hasData) {
          return const HomeScreenPlaceholder();
        }

        // User is not logged in
        return const LoginScreen();
      },
    );
  }
}

/// Placeholder for home screen
class HomeScreenPlaceholder extends StatelessWidget {
  const HomeScreenPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final user = authService.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => authService.signOut(),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome!', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 16),
            Text('Email: ${user?.email ?? "Unknown"}'),
            Text('UID: ${user?.uid ?? "Unknown"}'),
          ],
        ),
      ),
    );
  }
}
