module Debug
	def info(obj)
		puts "BEGIN: #{obj.inspect}"
		puts '  ---- instance methods ----'
		puts obj.instance_methods
		puts '  ---- private instance methods ----'
		puts obj.private_instance_methods
		puts '  ---- singleton methods ----'
		puts obj.singleton_methods
		puts "END: #{obj.inspect}"
	end
end

module Logger
	def info(text)
		puts text
	end
end

module Parent
	include  Logger
	extend self

	def print
		text = init('Hello')
		info(text)
		p text.inspect
	end

	def init(msg)
		return 'Parent' + msg
	end

#	module_function :print
#	module_function :init
end

include Debug

#info(Parent)
#Parent.info('hello')
Parent.print

exit

module Child
	extend Parent

	def print
		super
	end

	def init(msg)
		return 'Child' + msg
	end

	module_function :print
	module_function :init
end

class Text
#	include Parent
#	include Child

	def print
		Parent.print
		Child.print
	end
end

t = Text.new
t.print
