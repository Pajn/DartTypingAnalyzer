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

  Project(this.name, this.path);
}

Stream<Project> findProjects(String clonePath) async* {
  var github = createGitHubClient();
  var repos = new Directory(clonePath);
  if (!repos.existsSync()) {
    repos.createSync();
  }
  var cloned = 0;

  await for (Repository repository in github.search.repositories('language:Dart', sort: 'stars', pages: 1)) {
    var directory = new Directory(repos.path + '/' + repository.name);
    if (!directory.existsSync() && cloned < 2) {
      print('Cloning ${repository.name} from ${repository.cloneUrls.https}');
      directory.createSync();
      cloned++;
      await runGit(['clone', repository.cloneUrls.https], processWorkingDir: directory.path);
      yield new Project(repository.name, directory.path);
    }
  }
}
