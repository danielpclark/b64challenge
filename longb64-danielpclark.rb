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
			swapper
		end
		@string
	end

	def inc(s)
		# increment last item in string or false
		unless @b64[s[-1]] == @b64.length-1
			if first_non(s,s[-1])
				s[-1] = first_non(s,s[-1])
			elsif not first_non(s,s[-2])
				s[-1] = first_non(s)
				if first_non(s,s[-2])
					s[-2] = first_non(s,s[-2])
				else
					swapper
				end
			else
				swapper
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
		val = @string[0..seek_high(@string)-1]
		inc(val)
		count = @string[seek_high(@string)..-1].length
		count.times do |pos|
			val += first_non(val)
		end
		@string = val
	end

	def first_non(s,start = @b64.invert[0])
		# find the lowest not used character in base
		(@b64[start]..@b64.length-1).each do |p|
			unless !!s[@b64.invert[p]]
				return @b64.invert[p]
			end
		end
		return false
	end

end

# Pass 5 test cases with rollovers
["ABCDEFGHIJK9","ABCD/9876542","ABCDEF+/9875","ABCDEFG+/985","A+/987654320"].each do |val|
	test = B64.new(val)
	puts " ******** TEST FOR ROLLOVER SEQUENCE #{val} ******** "
	5.times do
		print test.next + ", "
	end
	puts
	puts
end
