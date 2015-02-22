Surveys = new (Mongo.Collection)('surveys')

if Meteor.isClient
	Template.body.helpers
		tasks: ->
			if Session.get('hideCompleted')
				# If hide completed is checked, filter tasks
				Tasks.find { checked: $ne: true }, sort: createdAt: -1
			else
				Tasks.find {}, sort: createdAt: -1
		hideCompleted: ->
			Session.get 'hideCompleted'
		incompleteCount: ->
			Tasks.find(checked: $ne: true).count()
		getData: ->
			user = Meteor.user()
			if user and user.username == 'testing@testing.com'
				my_string = "text, time\n"
				Tasks.find().forEach (task) ->
					my_string += task.text.toString() + ", (" + task.createdAt + ") \n"
					return
				return my_string
			else
				return ""

if Meteor.isServer
  Meteor.startup ->
    # code to run on server at startup
    return
