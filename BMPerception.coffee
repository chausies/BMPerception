Surveys = new (Mongo.Collection)('surveys')
NUM_OF_TASKS = 7
DATA_CODE = 'I Love Anh Chau'
NUM_OF_QUESTIONS = 7
GIF_LENGTH = 9

if Meteor.isClient
	Template.body.helpers
		get_data: ->
			Session.get('get_data')
		survey_data: ->
			features = ["Age, Survey Finish Time"]
			for task in [1..NUM_OF_TASKS]
				features.push 'Part 1: Task #' + task
			for question in [1..NUM_OF_QUESTIONS]
				features.push 'Part 2: QUESTION #' + question
			for task in [1..NUM_OF_TASKS]
				features.push 'Part 3: Task #' + task
			csv = features.join(", ") + "\n"
			Surveys.find().forEach (survey) ->
				csv += [
					survey.age,
					survey.createdAt,
					survey.part1.join(','),
					survey.part2.join(','),
					survey.part3.join(',')
				].join ','
				csv += "\n"
				return
			return csv
		# Getting Parts
		part0: ->
			!(
				(Session.get('part1'))   ||
				(Session.get('part1.5')) ||
				(Session.get('part2'))   ||
				(Session.get('part2.5')) ||
				(Session.get('part3'))   ||
				(Session.get('part3.5'))
			)
		part1: ->
			Session.get('part1')
		part1_5: ->
			Session.get('part1.5')
		part2: ->
			Session.get('part2')
		part2_5: ->
			Session.get('part2.5')
		part3: ->
			Session.get('part3')
		part3_5: ->
			Session.get('part3.5')
		# Getting Task Stuff
		task_num: ->
			Session.get 'task_num'
		task_name: ->
			task_num = Session.get 'task_num'
			if task_num == 0
				'Example Task'
			else
				'Task #' + task_num + " out of " + NUM_OF_TASKS
		task_file: ->
			task_num = Session.get 'task_num'
			if task_num == 0
				'part1/example_task.gif'
			else
				'part1/task' + task_num + ".gif"
		waiting: ->
			Session.get 'waiting'

	Template.body.events
		'submit .get-data': (event) ->
			text = event.target.text.value
			if text == DATA_CODE
				Session.set 'get_data', true
			else
				Session.set 'get_data', false
			# Clear form
			event.target.text.value = ''
			# Prevent default form submit
			false
		'click .go-to-part1': ->
			Session.set 'part1', true
			Session.set 'task_num', 0
			Session.set 'waiting', true
			setTimeout (->
				Session.set 'waiting', false
				return
			), 1000*GIF_LENGTH
			return
