import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class FeedbackListPage extends StatelessWidget {
  const FeedbackListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Customer Feedback")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('feedbacks')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No feedback available"));
          }

          var feedbacks = snapshot.data!.docs;

          return ListView.builder(
            itemCount: feedbacks.length,
            itemBuilder: (context, index) {
              var feedback = feedbacks[index];
              Map<String, dynamic> data =
                  feedback.data() as Map<String, dynamic>;

              String name = data.containsKey('name') ? data['name'] : 'Anonymous';
              String feedbackText =
                  data.containsKey('feedback') ? data['feedback'] : 'No feedback provided';
              String email = data.containsKey('email') ? data['email'] : 'Not provided';
              double rating = data.containsKey('rating')
                  ? double.tryParse(data['rating'].toString()) ?? 0.0
                  : 0.0;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(feedbackText),
                      const SizedBox(height: 5),
                      Text("📧 Email: $email", style: const TextStyle(color: Colors.grey)),
                      const SizedBox(height: 5),
                      RatingBarIndicator(
                        rating: rating,
                        itemBuilder: (context, _) =>
                            const Icon(Icons.star, color: Colors.amber),
                        itemCount: 5,
                        itemSize: 20.0,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
