import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'feedbacklist.dart';

class FeedbackFormPage extends StatefulWidget {
  const FeedbackFormPage({super.key});

  @override
  State<FeedbackFormPage> createState() => _FeedbackFormPageState();
}

class _FeedbackFormPageState extends State<FeedbackFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController =
      TextEditingController(); // New email field
  final TextEditingController feedbackController = TextEditingController();
  bool isSubmitting = false;
  double _rating = 0.0;

  Future<void> submitFeedback() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isSubmitting = true);

      try {
        await FirebaseFirestore.instance.collection('feedbacks').add({
          'name': nameController.text.isNotEmpty
              ? nameController.text
              : 'Anonymous',
          'email': emailController.text.isNotEmpty
              ? emailController.text
              : 'Not provided',
          'feedback': feedbackController.text,
          'rating': _rating,
          'timestamp': DateTime.now(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Feedback Submitted Successfully!')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const FeedbackListPage()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to submit feedback.')),
        );
      }

      setState(() {
        isSubmitting = false;
        nameController.clear();
        emailController.clear();
        feedbackController.clear();
        _rating = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Submit Feedback")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Your Feedback",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              TextFormField(
                controller: nameController,
                decoration:
                    const InputDecoration(labelText: 'Product Name'),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                decoration:
                    const InputDecoration(labelText: 'Your Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: feedbackController,
                decoration: const InputDecoration(
                    labelText: 'Your Feedback (Required)'),
                maxLines: 5,
                validator: (value) =>
                    value!.isEmpty ? 'Please provide feedback.' : null,
              ),
              const SizedBox(height: 20),
              const Text('Rate your experience:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              RatingBar.builder(
                initialRating: _rating,
                minRating: 1,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 40.0,
                itemBuilder: (context, index) =>
                    const Icon(Icons.star, color: Colors.amber),
                onRatingUpdate: (rating) => setState(() => _rating = rating),
              ),
              const SizedBox(height: 20),
              isSubmitting
                  ? const Center(child: CircularProgressIndicator())
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: submitFeedback,
                        child: const Text('Submit Feedback'),
                      ),
                    ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FeedbackListPage()),
                    );
                  },
                  child: const Text("View All Feedback"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
