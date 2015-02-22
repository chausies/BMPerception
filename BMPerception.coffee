Surveys = new (Mongo.Collection)('surveys')
NUM_OF_TASKS = 96

if Meteor.isClient
	Template.body.helpers
		part0: ->
			!(
				(Session.get('part1'))   ||
				(Session.get('part1.5')) ||
				(Session.get('part2'))   ||
				(Session.get('part2.5')) ||
				(Session.get('part3'))   ||
				(Session.get('part3.5'))
			)
