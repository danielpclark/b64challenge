class B64
	def initialize(string)
		@b64 = (
			("A".."Z").to_a + ("a".."z").to_a + ("0".."9").to_a + ["+","/"]
		).each_with_index.map {|x,i| {x=>i} }.inject(:update)
		@string = string
	end

	def next
		# this is where everything moves forward
		unless inc(@string)
			@string = swapper
		end
		@string
	end

	def inc(s)
		# increment last item in string or false
		unless @b64[s[-1]] == @b64.length-1
			s.length.times do |c|
				if c+@b64[s[-1]]+1 > @b64.length-1
					break
				end
				val = @b64.invert[@b64[s[-1]]+1+c]
				if not !!s[val]
					s[-1] = val
					break
				else
					return false
				end
			end	 
		else
			return false
		end
		return true
	end

	def seek_high(s)
		# select with index highest number
		val = s.split("").map { |x| @b64[x] }
		return val.index(val.compact.max)
	end

	def swapper
		# save loop cycles by substituting with next unique charcter set
		val = @string[0..seek_high(@string[0..-2])-1]
		inc(val)
		count = @string[seek_high(@string[0..-2])..-1].length
		count.times do |pos|
			val += first_non(val)
		end
		val
	end

	def first_non(s)
		# find the lowest not used character in base
		(0..@b64.length-1).each do |p|
			unless !!s[@b64.invert[p]]
				return @b64.invert[p]
			end
		end
	end

end

# Pass 5 test cases with rollovers
["ABCDEFGHIJK9","ABCD/9876542","ABCDEF+/9875","ABCDEFG+/985","A+/987654310"].each do |val|
	test = B64.new(val)
	puts " ******** TEST FOR ROLLOVER SEQUENCE #{val} ******** "
	5.times do
		print test.next + " - "
	end
	puts
	puts
end