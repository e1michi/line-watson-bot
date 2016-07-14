module Parent
	def print
		text = init('Hello')
		p text.inspect
	end

	def init(msg)
		return 'Parent' + msg
	end

	module_function :print
	module_function :init
end

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
