// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:news_app/models/articles.dart';

class ArticleViewModel {
  String category;
  List<Articles> articles;
  ArticleViewModel(
    this.category,
    this.articles,
  );
}
