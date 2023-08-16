import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;

class Course {
  final String title;
  final String provider;
  final String duration;

  Course({required this.title, required this.provider, required this.duration});
}

Future<List<Course>> scrapeClassCentral(String searchTerm) async {
  var url = Uri.parse('https://www.classcentral.com/search?q=$searchTerm');

  var response = await http.get(url);
  var document = parser.parse(response.body);

  var courseListings = document.querySelectorAll('li.course-name');

  var courses = <Course>[];

  for (var course in courseListings) {
    var titleElement = course.querySelector('h3');
    var providerElement = course.querySelector('span.provider');
    var durationElement = course.querySelector('span.length');

    var title = titleElement != null ? titleElement.text : '';
    var provider = providerElement != null ? providerElement.text : '';
    var duration = durationElement != null ? durationElement.text : '';

    var newCourse = Course(title: title, provider: provider, duration: duration);
    courses.add(newCourse);
  }


  return courses;
}
