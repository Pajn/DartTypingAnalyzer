// Copyright (c) 2015, Rasmus Eneman. All rights reserved.
// This software is made available under the terms of *either* of the licenses
// found in LICENSE.APACHE or LICENSE.BSD.

library finder;

import 'dart:async';
import 'dart:io';
import 'package:git/git.dart';
import 'package:github/server.dart';

class Project {
  final String name;
  final String path;
  final String url;

  Project(this.name, this.path, this.url);
}

Stream<Project> findProjects(String clonePath) async* {
  var github = createGitHubClient();
  var repos = new Directory(clonePath);
  if (!repos.existsSync()) {
    repos.createSync();
  }

  await for (var repository in github.search.repositories('language:Dart', sort: 'stars', pages: 10)) {
    var directory = new Directory(repos.path + '/' + repository.name);
    if (!directory.existsSync()) {
      print('Cloning ${repository.name} from ${repository.cloneUrls.https}');

      directory.createSync();
      await runGit(['clone', repository.cloneUrls.https], processWorkingDir: directory.path);

      yield new Project(repository.name, directory.path, repository.htmlUrl);
    } else {
      // Wait for a bit if we do not clone to not send to many requests
      await new Future.delayed(const Duration(milliseconds: 500));
    }
  }
}
