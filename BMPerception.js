// Generated by CoffeeScript 1.9.1
(function() {
  var BLACK_GIF_LENGTH, DATA_CODE, NUM_OF_QUESTIONS, NUM_OF_TASKS, Surveys, WHITE_GIF_LENGTH, questions, randperm, register_choice, save_survey, wait_for_black_gif, wait_for_white_gif;

  DATA_CODE = 'Psyched';

  questions = ["You prefer to stay home and read a book rather than going out.", 'You consider yourself able to "read between the lines".', "You are able to read someone's emotions based on their body language.", "You prefer the company of a large crowd as opposed to the company of a few people.", "You can empathize with a stranger's emotions.", "Some things should be communicated between friends without words.", "You are pessimistic."];

  NUM_OF_QUESTIONS = questions.length;

  NUM_OF_TASKS = 7;

  BLACK_GIF_LENGTH = 6;

  WHITE_GIF_LENGTH = 1;

  Surveys = new Mongo.Collection('surveys');

  randperm = function(n, k) {
    var a, i, j, l, ref, results, x;
    if (k == null) {
      k = n;
    }
    a = (function() {
      results = [];
      for (var l = 1; 1 <= n ? l <= n : l >= n; 1 <= n ? l++ : l--){ results.push(l); }
      return results;
    }).apply(this);
    i = n;
    while (i) {
      j = Math.floor(Math.random() * i);
      x = a[--i];
      ref = [a[j], x], a[i] = ref[0], a[j] = ref[1];
    }
    return a.slice(0, +(k - 1) + 1 || 9e9);
  };

  if (Meteor.isClient) {
    Template.body.helpers({
      get_data: function() {
        return Session.get('get_data');
      },
      survey_data: function() {
        var csv, features, l, m, o, question, ref, ref1, ref2, task;
        features = ["Age, Survey Finish Time"];
        for (task = l = 1, ref = NUM_OF_TASKS; 1 <= ref ? l <= ref : l >= ref; task = 1 <= ref ? ++l : --l) {
          features.push('Part 1: Task #' + task);
        }
        for (task = m = 1, ref1 = NUM_OF_TASKS; 1 <= ref1 ? m <= ref1 : m >= ref1; task = 1 <= ref1 ? ++m : --m) {
          features.push('Part 2: Task #' + task);
        }
        for (question = o = 1, ref2 = NUM_OF_QUESTIONS; 1 <= ref2 ? o <= ref2 : o >= ref2; question = 1 <= ref2 ? ++o : --o) {
          features.push('Part 3: QUESTION #' + question);
        }
        csv = features.join(", ") + "\n";
        Surveys.find().forEach(function(survey) {
          csv += [survey.age, survey.createdAt, survey.part1.join(','), survey.part2.join(','), survey.part3.join(',')].join(',');
          csv += "\n";
        });
        return csv;
      },
      part0: function() {
        return !((Session.get('part1')) || (Session.get('part1.5')) || (Session.get('part2')) || (Session.get('part2.5')) || (Session.get('part3')) || (Session.get('part3.5')));
      },
      part1: function() {
        return Session.get('part1');
      },
      part1_5: function() {
        return Session.get('part1.5');
      },
      part2: function() {
        return Session.get('part2');
      },
      part2_5: function() {
        return Session.get('part2.5');
      },
      part3: function() {
        return Session.get('part3');
      },
      part3_5: function() {
        return Session.get('part3.5');
      },
      task_num: function() {
        return Session.get('task_num');
      },
      task_name: function() {
        var task_num;
        task_num = Session.get('task_num');
        if (task_num === 0) {
          return 'Example Task';
        } else {
          return 'Task #' + task_num + " out of " + NUM_OF_TASKS;
        }
      },
      task_black_file_left: function() {
        var order, p, task_num;
        task_num = Session.get('task_num');
        if (task_num === 0) {
          return '';
        } else {
          p = Session.get('part1') ? 1 : 2;
          order = Session.get('order' + p);
          return 'Black/task' + order[task_num - 1] + 'Bleft.gif';
        }
      },
      task_black_file_right: function() {
        var order, p, task_num;
        task_num = Session.get('task_num');
        if (task_num === 0) {
          return 'Black/task10Bright.gif';
        } else {
          p = Session.get('part1') ? 1 : 2;
          order = Session.get('order' + p);
          return 'Black/task' + order[task_num - 1] + 'Bright.gif';
        }
      },
      task_white_file_left: function() {
        var order, p, task_num;
        task_num = Session.get('task_num');
        if (task_num === 0) {
          return 'White/task54Wleft.gif';
        } else {
          p = Session.get('part1') ? 1 : 2;
          order = Session.get('order' + p);
          return 'White/task' + order[task_num - 1] + 'Wleft.gif';
        }
      },
      task_white_file_right: function() {
        var order, p, task_num;
        task_num = Session.get('task_num');
        if (task_num === 0) {
          return '';
        } else {
          p = Session.get('part1') ? 1 : 2;
          order = Session.get('order' + p);
          return 'White/task' + order[task_num - 1] + 'Wright.gif';
        }
      },
      black_waiting: function() {
        return Session.get('black_waiting');
      },
      white_waiting: function() {
        return Session.get('white_waiting');
      },
      waiting: function() {
        return Session.get('black_waiting') || Session.get('white_waiting');
      },
      question_name: function() {
        var q_num;
        q_num = Session.get('q_num');
        return 'Survey Question #' + q_num + " out of " + NUM_OF_QUESTIONS;
      },
      question: function() {
        var order, q_num;
        q_num = Session.get('q_num');
        order = Session.get('order3');
        q_num = order[q_num - 1];
        return questions[q_num];
      }
    });
    wait_for_black_gif = function() {
      Session.set('black_waiting', true);
      setTimeout((function() {
        Session.set('black_waiting', false);
        wait_for_white_gif();
      }), 1000 * BLACK_GIF_LENGTH);
    };
    wait_for_white_gif = function() {
      Session.set('white_waiting', true);
      setTimeout((function() {
        Session.set('white_waiting', false);
      }), 1000 * WHITE_GIF_LENGTH);
    };
    register_choice = function(choice) {
      var order, q, q_num, survey;
      q_num = Session.get('q_num');
      order = Session.get('order3');
      q = order[q_num - 1];
      survey = Session.get('survey_part3');
      survey[q] = choice;
      Session.set('survey_part3', survey);
      q_num += 1;
      Session.set('q_num', q_num);
      if (q_num > NUM_OF_QUESTIONS) {
        Session.set('part3', false);
        save_survey();
        Session.set('part3.5', true);
      }
    };
    save_survey = function() {
      var part1, part2, part3;
      part1 = Session.get('survey_part1');
      part2 = Session.get('survey_part2');
      part3 = Session.get('survey_part3');
      Surveys.insert({
        age: 21,
        createdAt: new Date,
        part1: part1,
        part2: part2,
        part3: part3
      });
    };
    Template.body.events({
      'submit .get-data': function(event) {
        var text;
        text = event.target.text.value;
        if (text === DATA_CODE) {
          Session.set('get_data', true);
        } else {
          Session.set('get_data', false);
        }
        event.target.text.value = '';
        return false;
      },
      'click .go-to-part1': function() {
        Session.set('part1', true);
        Session.set('task_num', 0);
        Session.set('survey_part1', []);
        Session.set('order1', randperm(NUM_OF_TASKS));
        Session.set('order2', randperm(NUM_OF_TASKS));
        Session.set('order3', randperm(NUM_OF_QUESTIONS));
        wait_for_black_gif();
      },
      'click .walking1': function() {
        var order, survey, task_num;
        task_num = Session.get('task_num');
        if (task_num !== 0) {
          survey = Session.get('survey_part1');
          order = Session.get('order1');
          survey[order[task_num - 1]] = 'walking';
          Session.set('survey_part1', survey);
        }
        task_num += 1;
        Session.set('task_num', task_num);
        if (task_num > NUM_OF_TASKS) {
          Session.set('part1', false);
          Session.set('part1.5', true);
        } else {
          wait_for_black_gif();
        }
      },
      'click .running1': function() {
        var order, survey, task_num;
        task_num = Session.get('task_num');
        if (task_num !== 0) {
          survey = Session.get('survey_part1');
          order = Session.get('order1');
          survey[order[task_num - 1]] = 'running';
          Session.set('survey_part1', survey);
        }
        task_num += 1;
        Session.set('task_num', task_num);
        if (task_num > NUM_OF_TASKS) {
          Session.set('part1', false);
          Session.set('part1.5', true);
        } else {
          wait_for_black_gif();
        }
      },
      'click .go-to-part2': function() {
        Session.set('part1.5', false);
        Session.set('part2', true);
        Session.set('task_num', 0);
        Session.set('survey_part2', []);
        wait_for_black_gif();
      },
      'click .walking2': function() {
        var order, survey, task_num;
        task_num = Session.get('task_num');
        if (task_num !== 0) {
          survey = Session.get('survey_part2');
          order = Session.get('order2');
          survey[order[task_num - 1]] = 'walking';
          Session.set('survey_part2', survey);
        }
        task_num += 1;
        Session.set('task_num', task_num);
        if (task_num > NUM_OF_TASKS) {
          Session.set('part2', false);
          Session.set('part2.5', true);
        } else {
          wait_for_black_gif();
        }
      },
      'click .running2': function() {
        var order, survey, task_num;
        task_num = Session.get('task_num');
        if (task_num !== 0) {
          survey = Session.get('survey_part2');
          order = Session.get('order2');
          survey[order[task_num - 1]] = 'running';
          Session.set('survey_part2', survey);
        }
        task_num += 1;
        Session.set('task_num', task_num);
        if (task_num > NUM_OF_TASKS) {
          Session.set('part2', false);
          Session.set('part2.5', true);
        } else {
          wait_for_black_gif();
        }
      },
      'click .go-to-part3': function() {
        Session.set('part2.5', false);
        Session.set('part3', true);
        Session.set('q_num', 1);
        Session.set('survey_part3', []);
      },
      'click .choice1': function() {
        register_choice(1);
      },
      'click .choice2': function() {
        register_choice(2);
      },
      'click .choice3': function() {
        register_choice(3);
      },
      'click .choice4': function() {
        register_choice(4);
      }
    });
  }

}).call(this);
