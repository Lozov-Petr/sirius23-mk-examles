  $ ./unify_run.exe
  answers1, all answers {
  q=_.11;
  }
  answers2, all answers {
  q=[_.33] ^ _.36;
  }
  answers3, all answers {
  q=[C 0 []] ^ _.40;
  }
  answers4, all answers {
  q=[C 1 []] ^ _.71;
  }
  answers5, all answers {
  q=[C 1 []; C 1 []] ^ _.135;
  }
  answers6, all answers {
  q=[_.103; _.103] ^ _.116;
  }
  answers7, all answers {
  q=[C 1 [C 2 []; _.138]; C 1 [_.245; C 3 []]; _.245; _.138] ^ _.156;
  }
  answers8, all answers {
  q=[C 1 [C 2 []; C 3 []]; C 1 [C 2 []; C 3 []]; C 2 []; C 3 []] ^ _.202;
  }
  answers9, all answers {
  q=[C 1 [C 2 []; C 3 []; C 4 []; C 5 []]; C 1 [C 2 []; C 3 []; C 4 []; C 5 []]; C 1 [C 2 []; C 3 []; C 4 []; C 5 []]; C 1 [C 2 []; C 3 []; C 4 []; C 5 []]; C 2 []; C 3 []; C 4 []; C 5 []] ^ _.983;
  }
  answers_bad, all answers {
  }
  answers, all answers {
  q=[C 4 []; C 2 [C 5 []; C 3 []]; C 2 [C 6 []; C 2 [C 7 []; C 3 []]]; _.572; C 2 [C 4 []; _.572]] ^ _.508;
  }
