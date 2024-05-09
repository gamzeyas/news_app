import 'package:flutter/material.dart';
import 'package:news_app/models/category.dart';
import 'package:news_app/viewmodel/article_list_view_model.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  List<Category> categories = [
    Category('business', 'İş'),
    Category('entertainment', 'Eğlence'),
    Category('general', 'Genel'),
    Category('health', 'Sağlık'),
    Category('science', 'Bilim'),
    Category('sports', 'Spor'),
    Category('technology', 'Teknoloji'),
  ];

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ArticleListViewModel>(context);
    getCategoriesTab(vm);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: const Text(
            'Haberler',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 60,
              width: double.infinity,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: getCategoriesTab(vm),
              ),
            ),
            getWidgetByStatus(vm)
          ],
        ));
  }
List<Widget> getCategoriesTab(ArticleListViewModel vm) {
  List<Widget> list = [];
  for (int i = 0; i < categories.length; i++) {
    list.add(GestureDetector(
      onTap: () {
        for (int j = 0; j < categories.length; j++) {
          categories[j].isSelected = (j == i); // Tıklanan kategoriye göre isSelected durumunu güncelle
        }
        vm.getNews(categories[i].key);
      },
      child: Card(
        color: categories[i].isSelected ? Colors.red : Colors.white, // isSelected durumuna göre renk değiştir
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            categories[i].tittle,
            style: const TextStyle(fontSize: 16,),
          ),
        ),
      ),
    ));
  }
  return list;
}

}

Widget getWidgetByStatus(ArticleListViewModel vm) {
  switch (vm.status.index) {
    case 2:
      return Expanded(
        child: ListView.builder(
          itemCount: vm.viewModel.articles.length,
          itemBuilder: (context, index) {
            return Card(
              child: Column(
                children: [
                  Image.network(
                    vm.viewModel.articles[index].urlToImage ??
                        'https://i.medyaradar.com/2/278/156/storage/files/images/2020/02/29/devlet-baskani-hayatini-kaybetti-l-MPzn_cover.jpg.webp',
                    fit: BoxFit.fitHeight,
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.newspaper_outlined,
                      color: Colors.red,
                    ),
                    title: Text(
                      vm.viewModel.articles[index].title ?? '',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle:
                        Text(vm.viewModel.articles[index].description ?? ''),
                  ),
                  ButtonBar(
                    children: [
                      MaterialButton(
                        onPressed: () async {
                          await launchUrl(Uri.parse(
                              vm.viewModel.articles[index].url ?? ''));
                        },
                        child: const Text('Habere Git',
                            style: TextStyle(color: Colors.blue)),
                      )
                    ],
                  )
                ],
              ),
            );
          },
        ),
      );
    default:
      return const Center(
        child: CircularProgressIndicator(),
      );
  }
}
