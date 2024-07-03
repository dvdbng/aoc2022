import 'dart:convert';
import 'dart:io';

void main1() {
  print("Hello");
  String? line = null;
  var score = 0;
  while ((line = stdin.readLineSync(encoding: utf8)) != null) {
    final plays = line!.split(" ");
    final theirplay = plays[0].codeUnits[0] - 'A'.codeUnits[0];
    final ourplay = plays[1].codeUnits[0] - 'X'.codeUnits[0];
    assert(ourplay >= 0 && ourplay <= 2);
    assert(theirplay >= 0 && theirplay <= 2);
    score += ourplay + 1;
    print("$ourplay, $theirplay, ${(theirplay + 1) % 3}");
    if (((theirplay + 1) % 3) == ourplay) { // Won
      score += 6;
    } else if (theirplay == ourplay) { // Tie
      score += 3;
    }

  }
  print(score);
}


void main() {
  print("Hello");
  String? line = null;
  var score = 0;
  while ((line = stdin.readLineSync(encoding: utf8)) != null) {
    final plays = line!.split(" ");
    final theirplay = plays[0].codeUnits[0] - 'A'.codeUnits[0];
    final ouroutcome = plays[1];
    var ourplay = 0;
    assert(ourplay >= 0 && ourplay <= 2);
    assert(theirplay >= 0 && theirplay <= 2);
    if (ouroutcome == 'X') { // Lose
      ourplay = ((theirplay + 2) % 3);
    } else if (ouroutcome == 'Y') { // Draw
      ourplay = theirplay;
    } else if (ouroutcome == 'Z') { // Win
      ourplay = ((theirplay + 1) % 3);
    }
    score += ourplay + 1;
    if (((theirplay + 1) % 3) == ourplay) { // Won
      score += 6;
    } else if (theirplay == ourplay) { // Tie
      score += 3;
    }
  }
  print(score);
}
