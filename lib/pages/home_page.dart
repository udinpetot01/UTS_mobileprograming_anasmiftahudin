import 'package:flutter/material.dart';
import 'package:news1_app/constans/theme.dart';
import 'package:news1_app/models/news_update_model.dart';
import 'package:news1_app/pages/news_detail.dart';
import 'package:news1_app/pages/widgets/build_ekonomi_news.dart';
import 'package:news1_app/pages/widgets/build_nasional_news.dart';
import 'package:news1_app/pages/widgets/build_tech_news.dart';
import 'package:news1_app/providers/news_ekonomi_provider.dart';
import 'package:news1_app/providers/news_nasional_provider.dart';
import 'package:news1_app/providers/news_techno_provider.dart';
import 'package:news1_app/providers/news_update_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final ScrollController updateNewsScrollController = ScrollController();
  int updateNewsActiveIndex = 0;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NewsUpdateProvider>(context, listen: false).fetchNewsUpdate();
      Provider.of<TechNewsProvider>(context, listen: false).fetchTechNews();
      Provider.of<NewsEkonomiProvider>(context, listen: false)
          .fetchEkonomihNews();
      Provider.of<NasionalNewsProvider>(context, listen: false)
          .fetchNasionalNews();
    });

    updateNewsScrollController.addListener(
      () {
        setState(() {
          updateNewsActiveIndex = (updateNewsScrollController.offset /
                  (MediaQuery.of(context).size.width / 1.6))
              .round();
        });
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          children: [
            buildProfile(),
            Consumer<NewsUpdateProvider>(
              builder: (context, newsUpdate, child) {
                if (newsUpdate.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (newsUpdate.newsList.isEmpty) {
                  return const Text("No news available");
                } else {
                  return buildNewsUpdate(newsUpdate.newsList.first);
                }
              },
            ),
            const SizedBox(height: 25),
            buildNewsCategory(),
          ],
        ),
      ),
    );
  }

  Widget buildProfile() {
    return Padding(
      padding: const EdgeInsets.only(right: 15, top: 15),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage('assets/ic/my.png'),
          ),
          const SizedBox(
            width: 8,
          ),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selamat Siang',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                ),
              ),
              Text(
                'Anis Miftahudin',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            height: 40,
            width: 40,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 53, 146, 81),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Stack(
                children: [
                  Image.asset(
                    'assets/ic/noti.png',
                    width: 20,
                  ),
                  Positioned(
                    child: Container(
                      height: 8,
                      width: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xff0866ff),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNewsUpdate(NewsUpdateModel news) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Terbaru',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: updateNewsScrollController,
          child: Row(
            children: (news.posts?.take(5) ?? []).map(
              (item) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            NewDetailpage(link: news.link ?? ''),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    margin: const EdgeInsets.only(right: 23),
                    height: 206,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                      image: DecorationImage(
                        image: NetworkImage(item.thumbnail ?? ''),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                image: DecorationImage(
                                  image: NetworkImage(news.image ?? ''),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Text(
                              (news.title?.split(" | ").first ?? ''),
                              style: whiteTextStyle.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.black38,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            item.title ?? '',
                            style: whiteTextStyle.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ).toList(),
          ),
        ),
        const SizedBox(height: 16),
        buildDotIndicator(
            news.posts?.take(5).toList().length ?? 0, updateNewsActiveIndex),
      ],
    );
  }

  Widget buildDotIndicator(int count, int activeIndex) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
        (index) {
          double size = (index == activeIndex) ? 12.0 : 8.0;
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            height: size,
            width: size,
            decoration: BoxDecoration(
              color: (index == activeIndex)
                  ? primaryColor
                  : const Color(0XFFD9D9D9),
              shape: BoxShape.circle,
            ),
          );
        },
      ),
    );
  }

  Widget buildNewsCategory() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(10),
          height: 30,
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: const Color.fromARGB(255, 53, 146, 81),
            ),
            indicatorColor: const Color.fromARGB(255, 53, 146, 81),
            dividerHeight: 0,
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(text: 'Tekno'),
              Tab(text: 'Ekonomi'),
              Tab(text: 'Nasional'),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: MediaQuery.of(context).size.height * 1,
          child: TabBarView(
            controller: _tabController,
            children: [
              Consumer<TechNewsProvider>(
                builder: (context, techNews, child) {
                  if (techNews.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (techNews.techList.isEmpty) {
                    return const Text('No Data');
                  } else {
                    return BuildTechNews(news: techNews.techList.first);
                  }
                },
              ),
              Consumer<NewsEkonomiProvider>(
                builder: (context, ekonomiNews, child) {
                  if (ekonomiNews.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (ekonomiNews.ekonomiList.isEmpty) {
                    return const Text('No Data');
                  } else {
                    return BuildEkonomiNews(
                        news: ekonomiNews.ekonomiList.first);
                  }
                },
              ),
              Consumer<NasionalNewsProvider>(
                builder: (context, nasionalNews, child) {
                  if (nasionalNews.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (nasionalNews.nasionalList.isEmpty) {
                    return const Text('No Data');
                  } else {
                    return BuildNasionalNews(
                        news: nasionalNews.nasionalList.first);
                  }
                },
              ),
            ],
          ),
        )
      ],
    );
  }
}

class EkonomiNewsProvider {}
