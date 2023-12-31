import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:projet_finale_mathieu/Dashboard/detailActivite.dart';
import 'package:projet_finale_mathieu/ModelD/modelActivity.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String selectedCategory = 'all';

  void _logout() async {
    await _auth.signOut();
  }

  void _filterByCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _filterByCategory('all'),
                child: Text('All'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => _filterByCategory('Activite 1'),
                child: Text('Fun'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => _filterByCategory('Activite 2'),
                child: Text('Sport'),
              ),
            ],
          ),
          SizedBox(height: 10),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('master2').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                var activities = snapshot.data!.docs
                    .map((doc) => doc.data() as Map<String, dynamic>)
                    .where((activity) {
                  var category = activity['categorie'].trim() ?? '';
                  return selectedCategory == 'all' || category == selectedCategory;
                }).toList();

                return ListView.builder(
                  itemCount: activities.length,
                  itemBuilder: (context, index) {
                    var activity = activities[index];

                    var imageUrl = activity['image'] ?? '';
                    var category = activity['categorie'] ?? '';

                    return ListTile(
                      leading: imageUrl.isNotEmpty
                          ? Image.network(
                        imageUrl,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      )
                          : Container(width: 50, height: 50),
                      title: Text(activity['titre'] ?? ''),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(activity['lieu'] ?? ''),
                          Text('Category: $category'),
                          Text('Price: \$${activity['prix'] ?? ''}'),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PageDetailsActivite(activity as listeactivite),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ListeActivite extends StatefulWidget {
  const ListeActivite({Key? key});

  @override
  State<ListeActivite> createState() => _ListeActiviteState();
}

class _ListeActiviteState extends State<ListeActivite> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  String selectedCategory = 'all';

  void _filterByCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tous les activités"),
        backgroundColor: Color.fromARGB(255, 1, 29, 52),
        titleTextStyle: TextStyle(
          color: Color.fromARGB(255, 255, 255, 255),
          fontWeight: FontWeight.bold,
          fontSize: 28.0,
        ),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _filterByCategory('all'),
                child: Text('All'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => _filterByCategory('Activite 1'),
                child: Text('Fun'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => _filterByCategory('Activite 2'),
                child: Text('Sport'),
              ),
            ],
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: db.collection("master2").snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('No activities found.'),
                  );
                }

                List<listeactivite> activities = snapshot.data!.docs.map((doc) {
                  return listeactivite.fromFirestore(doc);
                }).toList();

                activities = activities
                    .where((activity) =>
                selectedCategory == 'all' ||
                    activity.categorie == selectedCategory)
                    .toList();

                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: activities.length,
                  itemBuilder: (context, index) {
                    listeactivite activity = activities[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PageDetailsActivite(activity)),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              margin: const EdgeInsets.only(right: 8),
                              child: CachedNetworkImage(
                                imageUrl: activity.imageUrl,
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    activity.titre,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text('Location: ${activity.lieu}'),
                                  Text('Price: ${activity.prix}'),
                                  Text('Category: ${activity.categorie}'),
                                  // Ajoutez ici d'autres éléments que vous souhaitez afficher
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
