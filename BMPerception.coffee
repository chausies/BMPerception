Surveys = new (Mongo.Collection)('surveys')
NUM_OF_TASKS = 7
DATA_CODE = 'I Love Anh Chau'
GIF_LENGTH = 3
questions = [
	"You prefer to stay home and read a book rather than going out.",
	'You consider yourself able to "read between the lines".',
	"You are able to read someone's emotions based on their body language.",
	"You prefer to company of a large crowd as opposed to the company of a few people.",
	"You can empathize with a stranger's emotions.",
	"Some things should be communicated between friends without words.",
	"You are pessimistic."
]
NUM_OF_QUESTIONS = questions.length

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
		task_file1: ->
			task_num = Session.get 'task_num'
			if task_num == 0
				'part1/example_task.gif'
			else
				'part1/task' + task_num + ".gif"
		task_file3: ->
			task_num = Session.get 'task_num'
			if task_num == 0
				'part3/example_task.gif'
			else
				'part3/task' + task_num + ".gif"
		waiting: ->
			Session.get 'waiting'
		# Getting Question Stuff
		question_name: ->
			q_num = Session.get 'q_num'
			'Survey Question #' + q_num + " out of " + NUM_OF_QUESTIONS
		question: ->
			q_num = Session.get 'q_num'
			# 'part1/question' + q_num + ".txt"
			questions[q_num - 1]

	# Helpers functions
	wait_for_gif = ->
		Session.set 'waiting', true
		setTimeout (->
			Session.set 'waiting', false
			return
		), 1000*GIF_LENGTH
		return
	register_choice = (choice) ->
		q_num = Session.get 'q_num'
		survey = Session.get 'survey_part2'
		survey.push choice
		Session.set 'survey_part2', survey
		q_num += 1
		Session.set 'q_num', q_num
		if q_num > NUM_OF_QUESTIONS
			Session.set 'part2', false
			Session.set 'part2.5', true
		return
	save_survey = ->
		part1 = Session.get 'survey_part1'
		part2 = Session.get 'survey_part2'
		part3 = Session.get 'survey_part3'
		Surveys.insert
			age: 21
			createdAt: new Date
			part1: part1
			part2: part2
			part3: part3
		return

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
			Session.set 'survey_part1', []
			wait_for_gif()
			return
		'click .walking1': ->
			task_num = Session.get 'task_num'
			if task_num != 0
				survey = Session.get 'survey_part1'
				survey.push 'walking'
				Session.set 'survey_part1', survey
			task_num += 1
			Session.set 'task_num', task_num
			if task_num > NUM_OF_TASKS
				Session.set 'part1', false
				Session.set 'part1.5', true
			else
				wait_for_gif()
			return
		'click .running1': ->
			task_num = Session.get 'task_num'
			if task_num != 0
				survey = Session.get 'survey_part1'
				survey.push 'running'
				Session.set 'survey_part1', survey
			task_num += 1
			Session.set 'task_num', task_num
			if task_num > NUM_OF_TASKS
				Session.set 'part1', false
				Session.set 'part1.5', true
			else
				wait_for_gif()
			return
		'click .go-to-part2': ->
			Session.set 'part1.5', false
			Session.set 'part2', true
			Session.set 'q_num', 1
			Session.set 'survey_part2', []
			return
		# Register choices
		'click .choice1': ->
			register_choice 1
			return
		'click .choice2': ->
			register_choice 2
			return
		'click .choice3': ->
			register_choice 3
			return
		'click .choice4': ->
			register_choice 4
			return
		'click .go-to-part3': ->
			Session.set 'part2.5', false
			Session.set 'part3', true
			Session.set 'task_num', 0
			Session.set 'survey_part3', []
			wait_for_gif()
			return
		'click .walking3': ->
			task_num = Session.get 'task_num'
			if task_num != 0
				survey = Session.get 'survey_part3'
				survey.push 'walking'
				Session.set 'survey_part3', survey
			task_num += 1
			Session.set 'task_num', task_num
			if task_num > NUM_OF_TASKS
				Session.set 'part3', false
				save_survey()
				Session.set 'part3.5', true
			else
				wait_for_gif()
			return
		'click .running3': ->
			task_num = Session.get 'task_num'
			if task_num != 0
				survey = Session.get 'survey_part3'
				survey.push 'running'
				Session.set 'survey_part3', survey
			task_num += 1
			Session.set 'task_num', task_num
			if task_num > NUM_OF_TASKS
				Session.set 'part3', false
				save_survey()
				Session.set 'part3.5', true
			else
				wait_for_gif()
			return
