import 'package:flutter/material.dart';
void main() {
  runApp(const MarvelApp());
}
class MarvelApp extends StatelessWidget {
  const MarvelApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Marvel Heroes',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: const Color(0xFF101010),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
        ),
      ),
      home: const HomePage(),
    );
  }
}
class HeroModel {
  final String name;
  final String realName;
  final String image;
  final String description;
  final int power;
  bool favorite;
  HeroModel({
    required this.name,
    required this.realName,
    required this.image,
    required this.description,
    required this.power,
    this.favorite = false,
  });
}
class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  String searchText = '';
  final TextEditingController searchController = TextEditingController();
  final List<HeroModel> heroes = [
    HeroModel(
      name: 'Spider-Man',
      realName: 'Peter Parker',
      image:
          'https://th.bing.com/th/id/OIP.91PIVt9JQJZB2dYffMfkWgHaHa?r=0&o=7rm=3&rs=1&pid=ImgDetMain&o=7&rm=3',
      description:
          'Peter Parker is a superhero with spider-like abilities. He uses his powers to protect New York City.',
      power: 88,
    ),
    HeroModel(
      name: 'Iron Man',
      realName: 'Tony Stark',
      image:
          'https://tse2.mm.bing.net/th/id/OIP.qf39oJa6rCZDatOu7r7lrwHaNH?r=0&rs=1&pid=ImgDetMain&o=7&rm=3',
      description:
          'Tony Stark is a genius inventor who created a powerful armored suit and became Iron Man.',
      power: 92,
    ),
    HeroModel(
      name: 'Captain America',
      realName: 'Steve Rogers',
      image:
          'https://tse3.mm.bing.net/th/id/OIP.pLqU68V_LLjwFSSBQdNGLwHaLH?r=0&rs=1&pid=ImgDetMain&o=7&rm=3',
      description:
          'Steve Rogers became Captain America after receiving an experimental super-soldier serum.',
      power: 90,
    ),
    HeroModel(
      name: 'Thor',
      realName: 'Thor Odinson',
      image:
          'https://tse4.mm.bing.net/th/id/OIP.mvBQXYtkL2XDQuZSPWU5ZgHaJO?r=0&rs=1&pid=ImgDetMain&o=7&rm=3',
      description:
          'Thor is the God of Thunder and one of the strongest heroes in the Marvel universe.',
      power: 98,
    ),
    HeroModel(
      name: 'Hulk',
      realName: 'Bruce Banner',
      image:
          'https://th.bing.com/th/id/OIP.AHZGlkh5UBbLftlCvIyJZgHaJQ?r=0&o=7rm=3&rs=1&pid=ImgDetMain&o=7&rm=3',
      description:
          'Bruce Banner transforms into the Hulk when his anger becomes uncontrollable.',
      power: 99,
    ),
    HeroModel(
      name: 'Black Panther',
      realName: "T'Challa",
      image:
          'https://tse3.mm.bing.net/th/id/OIP._iWJLWepSFOBnCElu7rGSgHaNK?r=0&rs=1&pid=ImgDetMain&o=7&rm=3',
      description:
          'T’Challa is the king of Wakanda and the Black Panther, protector of his nation.',
      power: 91,
    ),
  ];
  List<HeroModel> get filteredHeroes {
    List<HeroModel> list;
    if (selectedIndex == 1) {
      list = heroes.where((hero) => hero.favorite).toList();
    } else {
      list = heroes;
    }
    if (searchText.isNotEmpty) {
      list = list
          .where(
            (hero) =>
                hero.name.toLowerCase().contains(searchText.toLowerCase()) ||
                hero.realName.toLowerCase().contains(searchText.toLowerCase()),
          )
          .toList();
    }
    return list;
  }
  void toggleFavorite(HeroModel hero) {
    setState(() {
      hero.favorite = !hero.favorite;
    });
  }
  void openHero(HeroModel hero) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HeroDetailsPage(
          hero: hero,
          onFavoriteChanged: () {
            setState(() {});
          },
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MARVEL HEROES',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search heroes...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchText.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          searchController.clear();
                          setState(() {
                            searchText = '';
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: filteredHeroes.isEmpty
                ? const Center(
                    child: Text(
                      'No heroes found',
                      style: TextStyle(fontSize: 20),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.68,
                    ),
                    itemCount: filteredHeroes.length,
                    itemBuilder: (context, index) {
                      final hero = filteredHeroes[index];

                      return HeroCard(
                        hero: hero,
                        onTap: () => openHero(hero),
                        onFavorite: () => toggleFavorite(hero),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        backgroundColor: const Color(0xFF181818),
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Heroes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
class HeroCard extends StatelessWidget {
  final HeroModel hero;
  final VoidCallback onTap;
  final VoidCallback onFavorite;
  const HeroCard({
    super.key,
    required this.hero,
    required this.onTap,
    required this.onFavorite,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: const Color(0xFF1C1C1C),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.network(
                      hero.image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(
                            Icons.person,
                            size: 70,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: CircleAvatar(
                      backgroundColor: Colors.black.withOpacity(0.7),
                      child: IconButton(
                        icon: Icon(
                          hero.favorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: hero.favorite ? Colors.red : Colors.white,
                        ),
                        onPressed: onFavorite,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hero.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    hero.realName,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.flash_on,
                        color: Colors.orange,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Power: ${hero.power}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class HeroDetailsPage extends StatelessWidget {
  final HeroModel hero;
  final VoidCallback onFavoriteChanged;

  const HeroDetailsPage({
    super.key,
    required this.hero,
    required this.onFavoriteChanged,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(hero.name),
        actions: [
          IconButton(
            icon: Icon(
              hero.favorite
                  ? Icons.favorite
                  : Icons.favorite_border,
            ),
            onPressed: () {
              hero.favorite = !hero.favorite;
              onFavoriteChanged();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    hero.favorite
                        ? '${hero.name} added to favorites'
                        : '${hero.name} removed from favorites',
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              hero.image,
              width: double.infinity,
              height: 350,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const SizedBox(
                  height: 350,
                  child: Center(
                    child: Icon(Icons.person, size: 100),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hero.name,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    hero.realName,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[400],
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    'POWER LEVEL',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: hero.power / 100,
                    minHeight: 12,
                    borderRadius: BorderRadius.circular(10),
                    backgroundColor: Colors.grey[800],
                    color: Colors.red,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${hero.power}/100',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'ABOUT',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    hero.description,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: Colors.grey[300],
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        hero.favorite = !hero.favorite;
                        onFavoriteChanged();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              hero.favorite
                                  ? 'Added to favorites!'
                                  : 'Removed from favorites!',
                            ),
                          ),
                        );
                      },
                      icon: Icon(
                        hero.favorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                      ),
                      label: Text(
                        hero.favorite
                            ? 'Remove from Favorites'
                            : 'Add to Favorites',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
