DATA_CODE = 'Psyched'
questions = [
	"You prefer to stay home and read a book rather than going out.",
	'You consider yourself able to "read between the lines".',
	"You are able to read someone's emotions based on their body language.",
	"You prefer the company of a large crowd as opposed to the company of a few people.",
	"You can empathize with a stranger's emotions.",
	"Some things should be communicated between friends without words.",
	"You are pessimistic."
]
LEFT = 0
RIGHT = 1
WALK = 0
RUN = 1
NUM_OF_QUESTIONS = questions.length
NUM_OF_TASKS = 2
BLACK_GIF_LENGTH = 1
WHITE_GIF_LENGTH = 1
Surveys = new (Mongo.Collection)('surveys')

randperm = (n, k=n) ->
	a = [1..n]
	i = n
	while i
		j = Math.floor(Math.random() * i)
		x = a[--i]
		[a[i], a[j]] = [a[j], x]
	return a[..(k-1)]

if Meteor.isClient
	Template.body.helpers
		get_data: ->
			Session.get('get_data')
		survey_data: ->
			features = ["Age, Survey Finish Time"]
			for task in [1..NUM_OF_TASKS]
				features.push 'Part 1: Black Task #' + task
				features.push 'Part 1: White Task #' + task
			for task in [1..NUM_OF_TASKS]
				features.push 'Part 2: Black Task #' + task
				features.push 'Part 2: White Task #' + task
			for question in [1..NUM_OF_QUESTIONS]
				features.push 'Part 3: QUESTION #' + question
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
		task_black_file_left: ->
			task_num = Session.get 'task_num'
			if task_num == 0
				''
			else
				p = if (Session.get 'part1') then 1 else 2
				order = Session.get 'order' + p
				'Black/task' + order[task_num-1] + 'Bleft.gif'
		task_black_file_right: ->
			task_num = Session.get 'task_num'
			if task_num == 0
				'Black/task10Bright.gif'
			else
				p = if (Session.get 'part1') then 1 else 2
				order = Session.get 'order' + p
				'Black/task' + order[task_num-1] + 'Bright.gif'
		task_white_file_left: ->
			task_num = Session.get 'task_num'
			if task_num == 0
				'White/task54Wleft.gif'
			else
				p = if (Session.get 'part1') then 1 else 2
				order = Session.get 'order' + p
				'White/task' + order[task_num-1] + 'Wleft.gif'
		task_white_file_right: ->
			task_num = Session.get 'task_num'
			if task_num == 0
				''
			else
				p = if (Session.get 'part1') then 1 else 2
				order = Session.get 'order' + p
				'White/task' + order[task_num-1] + 'Wright.gif'
    # Waiting stuff
		black_waiting: ->
			Session.get 'black_waiting'
		white_waiting: ->
			Session.get 'white_waiting'
		black_question: ->
			Session.get 'black_question'
		white_question: ->
			Session.get 'white_question'
		waiting: ->
			Session.get('black_waiting') || Session.get('white_waiting')
		# Getting Question Stuff
		question_name: ->
			q_num = Session.get 'q_num'
			'Survey Question #' + q_num + " out of " + NUM_OF_QUESTIONS
		question: ->
			q_num = Session.get 'q_num'
			order = Session.get 'order3'
			q = order[q_num-1] - 1
			# 'part1/question' + q + ".txt"
			questions[q]

	# Helpers functions
	wait_for_black_gif = ->
		Session.set 'black_waiting', true
		setTimeout (->
			Session.set 'black_waiting', false
			Session.set 'black_question', true
			return
		), 1000*BLACK_GIF_LENGTH
		return
	wait_for_white_gif = ->
		Session.set 'white_waiting', true
		setTimeout (->
			Session.set 'white_waiting', false
			Session.set 'white_question', true
			return
		), 1000*WHITE_GIF_LENGTH
		return
	register_choice = (choice) ->
		q_num = Session.get 'q_num'
		order = Session.get 'order3'
		q = order[q_num-1] - 1
		survey = Session.get 'survey_part3'
		survey[q] = choice
		Session.set 'survey_part3', survey
		q_num += 1
		Session.set 'q_num', q_num
		if q_num > NUM_OF_QUESTIONS
			Session.set 'part3', false
			save_survey()
			Session.set 'part3.5', true
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
			Session.set 'order1', randperm(NUM_OF_TASKS)
			Session.set 'order2', randperm(NUM_OF_TASKS)
			Session.set 'order3', randperm(NUM_OF_QUESTIONS)
			wait_for_black_gif()
			return
		'click .going_left1': ->
			task_num = Session.get 'task_num'
			if task_num != 0
				survey = Session.get 'survey_part1'
				order = Session.get 'order1'
				survey[2*(order[task_num-1]-1)] = LEFT
				Session.set 'survey_part1', survey
			Session.set 'black_question', false
			wait_for_white_gif()
			return
		'click .going_right1': ->
			task_num = Session.get 'task_num'
			if task_num != 0
				survey = Session.get 'survey_part1'
				order = Session.get 'order1'
				survey[2*(order[task_num-1]-1)] = RIGHT
				Session.set 'survey_part1', survey
			Session.set 'black_question', false
			wait_for_white_gif()
			return
		'click .walking1': ->
			task_num = Session.get 'task_num'
			if task_num != 0
				survey = Session.get 'survey_part1'
				order = Session.get 'order1'
				survey[2*order[task_num-1]-1] = WALK
				Session.set 'survey_part1', survey
			task_num += 1
			Session.set 'task_num', task_num
			Session.set 'white_question', false
			if task_num > NUM_OF_TASKS
				Session.set 'part1', false
				Session.set 'part1.5', true
			else
				wait_for_black_gif()
			return
		'click .running1': ->
			task_num = Session.get 'task_num'
			if task_num != 0
				survey = Session.get 'survey_part1'
				order = Session.get 'order1'
				survey[2*order[task_num-1]-1] = RUN
				Session.set 'survey_part1', survey
			task_num += 1
			Session.set 'task_num', task_num
			Session.set 'white_question', false
			if task_num > NUM_OF_TASKS
				Session.set 'part1', false
				Session.set 'part1.5', true
			else
				wait_for_black_gif()
			return
		'click .go-to-part2': ->
			Session.set 'part1.5', false
			Session.set 'part2', true
			Session.set 'task_num', 0
			Session.set 'survey_part2', []
			wait_for_black_gif()
			return
		'click .going_left2': ->
			task_num = Session.get 'task_num'
			if task_num != 0
				survey = Session.get 'survey_part2'
				order = Session.get 'order2'
				survey[2*(order[task_num-1]-1)] = LEFT
				Session.set 'survey_part2', survey
			Session.set 'black_question', false
			wait_for_white_gif()
			return
		'click .going_right2': ->
			task_num = Session.get 'task_num'
			if task_num != 0
				survey = Session.get 'survey_part2'
				order = Session.get 'order2'
				survey[2*(order[task_num-1]-1)] = RIGHT
				Session.set 'survey_part2', survey
			Session.set 'black_question', false
			wait_for_white_gif()
			return
		'click .walking2': ->
			task_num = Session.get 'task_num'
			if task_num != 0
				survey = Session.get 'survey_part2'
				order = Session.get 'order2'
				survey[2*order[task_num-1]-1] = WALK
				Session.set 'survey_part2', survey
			task_num += 1
			Session.set 'task_num', task_num
			Session.set 'white_question', false
			if task_num > NUM_OF_TASKS
				Session.set 'part2', false
				Session.set 'part2.5', true
			else
				wait_for_black_gif()
			return
		'click .running2': ->
			task_num = Session.get 'task_num'
			if task_num != 0
				survey = Session.get 'survey_part2'
				order = Session.get 'order2'
				survey[2*order[task_num-1]-1] = RUN
				Session.set 'survey_part2', survey
			task_num += 1
			Session.set 'task_num', task_num
			Session.set 'white_question', false
			if task_num > NUM_OF_TASKS
				Session.set 'part2', false
				Session.set 'part2.5', true
			else
				wait_for_black_gif()
			return
		'click .go-to-part3': ->
			Session.set 'part2.5', false
			Session.set 'part3', true
			Session.set 'q_num', 1
			Session.set 'survey_part3', []
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
