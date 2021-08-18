require 'telegram/bot'
require 'json'

token = '' # токен бота
master = 0 # айди чата мастера

@txt = ''

smile =
	[
		"😀","😃","😄","😁","😆","😅","😂","🤣","😊","😇","🙂","🙃","😉","😌","😍","😘","😗","😙","😚","😋","😜","😝","😛","🤑","🤗","🤓","😎","🤡","🤠","😏","😒","😞","😔","😟","😕","🙁","😣","😖","😫","😩","😤","😠","😡","😶","😐","😑","😯","😦","😧","😮","😲","😵","😳","😱","😨","😰","😢","😥","🤤","😭","😓","😪","😴","🙄","🤔","🤥","😬","🤐","🤢","🤧","😷","🤒","🤕","😈","👿","👹","👺","💩","👻","💀","👽","👾","🤖","🎃","😺","😸","😹","😻","😼","😽","🙀","😿","😾","👐","🙌","👏","🙏","🤝","👍","👎","👊","✊","🤛","🤜","🤞","🤘","👌","👈","👉","👆","👇","✋","🤚","🖐","🖖","👋","🤙","💪","🖕","🤳","💅","💍","💄","💋","👄","👅","👂","👃","👁","👀","🗣","👤","👥","👶","👦","👧","👨","👩","👱","👴","👵","👲","👳","👳","👮","👷","💂","🕵","🤶","🎅","👸","🤴","👰","🤵","👼","🤰","🙇","💁","🙅","🙆","🙋","🤦","🤷","🙎","💇","💆","🕴","💃","🕺","👯","👯","🚶","🏃","👭","👬","💑","💏","👪","👚","👕","👖","👔","👗","👙","👘","👠","👡","👢","👞","👟","👒","🎩","🎓","👑","⛑","🎒","👝","👛","👜","💼","👓","🕶","🌂"
	]
# Проверяем наличие черного списка
if File.exist?('black_list.json') == false
	File.new('black_list.json', 'w')
	hh = Hash.new
	hash = File.open('black_list.json', 'w')
	hash.write(JSON.generate(hh))
	hash.close
end
# Проверяем наличие белого списка
if File.exist?('white_list.json') == false
	File.new('white_list.json', 'w')
	hh = Hash.new
	hash = File.open('white_list.json', 'w')
	hash.write(JSON.generate(hh))
	hash.close
end
# Создаём хеш для расчета hostname
white_list = JSON.parse(File.read('white_list.json'))
@hh = Hash.new
white_list.each do |key, value|
		@hh[key] = ''
end
# Добавляем в список
def add_2_list input
	list = JSON.parse(File.read('black_list.json'))
	list[input["id"]] = {
		"first_name" => input["first_name"],
		"last_name" => input["last_name"],
		"username" => input["username"],
	}
	add_to_list = File.open('black_list.json', 'w')
	add_to_list.write(JSON.generate(list))
	add_to_list.close
end
# Получем хостнэйм
def get_hostname get
	# Сообщение
	message = get[0]
	# Пользователь
	usr_id = get[1]
	# Если добавил юзера в список после запуска бота
	# @hh[usr_id] = '' if @hh[usr_id] == nil
	if message == '*'
		puts "звёздочка #{message}"
	elsif message == '#'
		puts "решетка #{message}"
	else
		numbers = [1,2,3,4,5,6,7,8,9,0]
		numbers.each do |c|
			if message == c.to_s
				# puts "#{message} = #{c}"
				@hh[usr_id] = @hh[usr_id] + message
				if @hh[usr_id].size == 6
					puts "Получен запрос на расчет ip для eva#{@hh[usr_id]}"
					hostname = @hh[usr_id]
					@hh[usr_id] = ''
					# Отправляем на расчет
					raschet hostname
				end
			end
		end
	end
end
# Расчёт
def raschet x
	eva = {}
	eva['S'] = x[0].to_i
	eva['AA'] = (x[1].to_s + x[2].to_s).to_i
	eva['B'] = x[3].to_i
	eva['CC'] = (x[4].to_s + x[5].to_s).to_i
	# puts "Получен запрос на расчет ip для eva#{x}"
	if eva['S'] == 0
		@txt = 'попробуй снова'
		# puts @txt
		# для ицва-1
		elsif eva['S'] == 5
			ad1 = 224
			if eva['AA'] < 4 || eva['AA'] > 43
				@txt = 'Нет такого полуряда'
				puts 'Нет такого полуряда'
			elsif eva['B'] == '' || eva['B'] > 6
				@txt = 'Нет такого шкафа'
				puts 'Нет такого шкафа'
			elsif eva['CC'] > 23
				@txt = 'Нет такого сервера'
				puts 'Нет такого сервера'
				else
					ad2 = 144 + (eva['AA'].to_f / 16).floor
					ad3 = (eva['AA'] % 16) * 16 + eva['B']
					if (eva['AA'].to_f / 2).floor == eva['AA'].to_f / 2
						ad4 = (eva['AA'] % 16) * 16
					else
						ad4 = ((eva['AA'] - 1) % 16) * 16
					end
					# Ответ
					@txt = "eva#{x}\n\taddress 10.#{ad2}.#{ad3}.#{eva['CC']}\n\tgateway 10.#{ad2}.#{ad4}.254\n\tnetmask 255.255.#{ad1}.0"
					# puts @txt
			end
		# для ицва-2, ицва-3
		elsif eva['S'] == 6
			ad1 =240
			if eva['AA'] < 4
				@txt = 'Нет такого полуряда'
				puts 'Нет такого полуряда'
			elsif eva['CC'] > 31
				@txt = 'Нет такого сервера'
				puts 'Нет такого сервера'
			elsif (eva['AA'] & 1) != 0 && eva['B'] == 0
				@txt = 'Нет такого шкафа'
				puts 'Нет такого шкафа'
				else
					ad2 = 148 + (eva['AA'].to_f / 16).floor
					ad3 = (eva['AA'] % 16) * 16 + eva['B']
					ad4 = (eva['AA'] % 16) * 16
					ad5 = 224 if eva['B'] + eva['CC'] == 0
					ad5 = eva['CC'] if eva['B'] + eva['CC'] != 0
					# Ответ
					@txt = "eva#{x}\n\taddress 10.#{ad2}.#{ad3}.#{ad5}\n\tgateway 10.#{ad2}.#{ad4}.254\n\tnetmask 255.255.#{ad1}.0"
					# puts @txt
			end
		else
			# Ответ
			@txt = 'Не попал'
			puts 'Не попал'
	end
end

Telegram::Bot::Client.run(token, logger: Logger.new($stdout)) do |bot|
	# Выводит удобную клавиатуру
	show_kd =
						Telegram::Bot::Types::ReplyKeyboardMarkup
						.new(keyboard: [%w(1 2 3), %w(4 5 6), %w(7 8 9), %w(* 0 #)], one_time_keyboard: false)
	# Выводит кнопку старт
	hide_kb =
						Telegram::Bot::Types::ReplyKeyboardMarkup
						.new(keyboard: '/start', one_time_keyboard: false)
	# Удаляет клавиатуру
	delete_kb =
						Telegram::Bot::Types::ReplyKeyboardRemove
						.new(remove_keyboard: true)
	# Пишем в лог, что бот стартанул
	bot.logger.info('Bot has been started')
	while true
		# check_updates
		# sleep 3
		# end
		begin
			bot.listen do |message|
				# Открываем белый список
				white_list = JSON.parse(File.read('white_list.json'))
				# Открываем чёрный список
				black_list = JSON.parse(File.read('black_list.json'))
				# Генерируем рандомный смаил
				hop_hey = "#{smile[rand(0..smile.size-1)]}#{smile[rand(0..smile.size-1)]}#{smile[rand(0..smile.size-1)]}"
				# Если пользователь в белом списке
				if white_list.key? message.from.id.to_s
					# Генерируем имя из списка
					first_name = white_list[message.from.id.to_s]['first_name']
					case message.text
						when '/start'
							@hh[message.from.id.to_s] = ''
							bot.api.send_message(chat_id: message.chat.id, text: "Привет, #{first_name}!", reply_markup: show_kd)
						when '/ping'
							bot.api.send_message(chat_id: message.chat.id, text: hop_hey, reply_markup: delete_kb)
						when '/stop'
							bot.api.send_message(chat_id: message.chat.id, text: "Я спать... 😴", reply_markup: delete_kb)
					end
					if message.text.size == 1
						get = [message.text, message.from.id.to_s]
						get_hostname get
					end
					# Результат расчета
					if @txt != ''
						bot.api.send_message(chat_id: message.chat.id, text: @txt, reply_markup: hide_kb)
						@txt = ''
					end
				# Если пользователь в чёрном списке
				elsif black_list.key? message.from.id.to_s
					# Посылаем пользователю рандомный смаил
					bot.api.send_message(chat_id: message.chat.id, text: hop_hey, reply_markup: delete_kb)
				# Иначе
				else
					# Собираем данные о пользователе в хеш
					hh = Hash.new
					hh["first_name"] = message.from.first_name
					hh["last_name"] = message.from.last_name
					hh["username"] = message.from.username
					hh["id"] = message.from.id
					# Добавляем в список
					add_2_list hh
					# Посылаем пользователю сообщение
					bot.api.send_message(chat_id: message.chat.id, text: "Ни чем не могу помочь\n#{hop_hey}", reply_markup: delete_kb)
					# И оповещаем хозяина о новом пользователе
					attention = "У нас новый участник 👇\n#{hh["first_name"]} #{hh["last_name"]}:\n@#{hh["username"]}\n🆔#{hh["id"]}"
					bot.api.send_message(chat_id: master, text: attention)
					bot.logger.info("неопознаный клиент: #{hh["username"]} uid=#{hh["id"]}")
				end
			end
			rescue StandardError => e
				puts e.message
				# puts e.backtrace.select{ |err| err =~ /bot/ }.join(', ')
				sleep 3
				retry
			else
				puts продолжаем
				sleep 3
		end
	end
end