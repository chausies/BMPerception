// Generated by CoffeeScript 1.9.1
(function() {
  var NUM_OF_TASKS, Surveys;

  Surveys = new Mongo.Collection('surveys');

  NUM_OF_TASKS = 96;

  if (Meteor.isClient) {
    Template.body.helpers({
      part0: function() {
        return !((Session.get('part1')) || (Session.get('part1.5')) || (Session.get('part2')) || (Session.get('part2.5')) || (Session.get('part3')) || (Session.get('part3.5')));
      }
    });
  }

}).call(this);
