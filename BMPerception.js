// Generated by CoffeeScript 1.9.1
(function() {
  var DATA_CODE, GIF_LENGTH, NUM_OF_QUESTIONS, NUM_OF_TASKS, Surveys, questions, register_choice, save_survey, wait_for_gif;

  Surveys = new Mongo.Collection('surveys');

  NUM_OF_TASKS = 7;

  DATA_CODE = 'I Love Anh Chau';

  GIF_LENGTH = 3;

  questions = ["You prefer to stay home and read a book rather than going out.", 'You consider yourself able to "read between the lines".', "You are able to read someone's emotions based on their body language.", "You prefer the company of a large crowd as opposed to the company of a few people.", "You can empathize with a stranger's emotions.", "Some things should be communicated between friends without words.", "You are pessimistic."];

  NUM_OF_QUESTIONS = questions.length;

  if (Meteor.isClient) {
    Template.body.helpers({
      get_data: function() {
        return Session.get('get_data');
      },
      survey_data: function() {
        var csv, features, i, j, k, question, ref, ref1, ref2, task;
        features = ["Age, Survey Finish Time"];
        for (task = i = 1, ref = NUM_OF_TASKS; 1 <= ref ? i <= ref : i >= ref; task = 1 <= ref ? ++i : --i) {
          features.push('Part 1: Task #' + task);
        }
        for (question = j = 1, ref1 = NUM_OF_QUESTIONS; 1 <= ref1 ? j <= ref1 : j >= ref1; question = 1 <= ref1 ? ++j : --j) {
          features.push('Part 2: QUESTION #' + question);
        }
        for (task = k = 1, ref2 = NUM_OF_TASKS; 1 <= ref2 ? k <= ref2 : k >= ref2; task = 1 <= ref2 ? ++k : --k) {
          features.push('Part 3: Task #' + task);
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
      task_file1: function() {
        var task_num;
        task_num = Session.get('task_num');
        if (task_num === 0) {
          return 'part1/example_task.gif';
        } else {
          return 'part1/task' + task_num + ".gif";
        }
      },
      task_file3: function() {
        var task_num;
        task_num = Session.get('task_num');
        if (task_num === 0) {
          return 'part3/example_task.gif';
        } else {
          return 'part3/task' + task_num + ".gif";
        }
      },
      waiting: function() {
        return Session.get('waiting');
      },
      question_name: function() {
        var q_num;
        q_num = Session.get('q_num');
        return 'Survey Question #' + q_num + " out of " + NUM_OF_QUESTIONS;
      },
      question: function() {
        var q_num;
        q_num = Session.get('q_num');
        return questions[q_num - 1];
      }
    });
    wait_for_gif = function() {
      Session.set('waiting', true);
      setTimeout((function() {
        Session.set('waiting', false);
      }), 1000 * GIF_LENGTH);
    };
    register_choice = function(choice) {
      var q_num, survey;
      q_num = Session.get('q_num');
      survey = Session.get('survey_part2');
      survey.push(choice);
      Session.set('survey_part2', survey);
      q_num += 1;
      Session.set('q_num', q_num);
      if (q_num > NUM_OF_QUESTIONS) {
        Session.set('part2', false);
        Session.set('part2.5', true);
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
        wait_for_gif();
      },
      'click .walking1': function() {
        var survey, task_num;
        task_num = Session.get('task_num');
        if (task_num !== 0) {
          survey = Session.get('survey_part1');
          survey.push('walking');
          Session.set('survey_part1', survey);
        }
        task_num += 1;
        Session.set('task_num', task_num);
        if (task_num > NUM_OF_TASKS) {
          Session.set('part1', false);
          Session.set('part1.5', true);
        } else {
          wait_for_gif();
        }
      },
      'click .running1': function() {
        var survey, task_num;
        task_num = Session.get('task_num');
        if (task_num !== 0) {
          survey = Session.get('survey_part1');
          survey.push('running');
          Session.set('survey_part1', survey);
        }
        task_num += 1;
        Session.set('task_num', task_num);
        if (task_num > NUM_OF_TASKS) {
          Session.set('part1', false);
          Session.set('part1.5', true);
        } else {
          wait_for_gif();
        }
      },
      'click .go-to-part2': function() {
        Session.set('part1.5', false);
        Session.set('part2', true);
        Session.set('q_num', 1);
        Session.set('survey_part2', []);
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
      },
      'click .go-to-part3': function() {
        Session.set('part2.5', false);
        Session.set('part3', true);
        Session.set('task_num', 0);
        Session.set('survey_part3', []);
        wait_for_gif();
      },
      'click .walking3': function() {
        var survey, task_num;
        task_num = Session.get('task_num');
        if (task_num !== 0) {
          survey = Session.get('survey_part3');
          survey.push('walking');
          Session.set('survey_part3', survey);
        }
        task_num += 1;
        Session.set('task_num', task_num);
        if (task_num > NUM_OF_TASKS) {
          Session.set('part3', false);
          save_survey();
          Session.set('part3.5', true);
        } else {
          wait_for_gif();
        }
      },
      'click .running3': function() {
        var survey, task_num;
        task_num = Session.get('task_num');
        if (task_num !== 0) {
          survey = Session.get('survey_part3');
          survey.push('running');
          Session.set('survey_part3', survey);
        }
        task_num += 1;
        Session.set('task_num', task_num);
        if (task_num > NUM_OF_TASKS) {
          Session.set('part3', false);
          save_survey();
          Session.set('part3.5', true);
        } else {
          wait_for_gif();
        }
      }
    });
  }

}).call(this);
