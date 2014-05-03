# Golf Challenge Unique Base 64 Incrementor

**The goal is to write a script that will use your (Base 64) numbering system and never repeat any character within the string while incrementing.**

When you rollover a big number that jumps to the next place value you need to substitute it with the next unique in place... example (in Base 10) 0985,0986,0987 jumps to 1023, 1024, 1025 to avoid repetition. Note: Rollovers are when you hit the top place value like 0999 and roll over to the next place value 1000

So increment all 12 character unique strings without wasting CPU cycles on skip loops.

# **Rules**
 
 * No like characters within the 12 character string.
 * No skip/next command in loop from "0985","0986","0987" to "1023" (Base 10 example), use substitution.  This is a rollover.  Rollovers are no skip zones.
 * All down counts of any length (starting from the highest value character towards the next +11 characters) get substituted on rollover  Example: if Z was highest value character in the base and Y was next then YXWVUTSRQPON will roll over to Z0123456789a

# **Criterion**

Pass 5 test cases with different position rollover cases (when the next place position increments).

># **About Number Bases**
>
>Our numbering system is (Base 10).  That includes 0-9.  Binary is (Base 2), that's only >1's and 0's.  Hex is (Base 16) (0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F).  A hexadecimal "F" has a >(Base 10) value of 15.
>
>In Binary, a string of two binary characters can have only two unique states.  Like '10' >and '01'.  In this challenge Binary is not a possible choice since you can't have any more >unique amount of characters then two since you only have 1 and 0.
>
>(Base 64) has 64 individual characters which would translate in value in (Base 10) from >between 0 to 63.  See here for more on (Base 64) http://en.wikipedia.org/wiki/Base_64

# **Logic Insights**

Your incrementor function will increment to the next 'not in string' character on the right end until it gets to the highest character.  Once it get's to the last character then it passes on to the swap task.

The swap task then looks for the chunk to jump to eg: in (Base 10) to go from 00987 to the next level would be 01234. So seeing 00987 is the set to replace we have the 0 which "can" be incremented, and then the 987 which is a counting down sequence 9, 8, 7.  So we then increment the first number to the left so 0 turns to 1, and then substitute the 987 with the smallest unused numbers from left to right, which is 234.

# Here is a working long answer written in Ruby:

*The order of the (base 64) used in this code and output is as is defined on [Wikipedia][1]*

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
				if first_non(s,s[-1]) # and not @b64[s[-2]] == @b64[s[-1]]+1
					s[-1] = first_non(s,s[-1])
				elsif not first_non(s,s[-2]) # and not @b64[s[-2]] == @b64[s[-1]]+1
					s[-1] = first_non(s)
					if first_non(s,s[-2])
						s[-2] = first_non(s,s[-2])
					else
						s = swapper
					end
				else
					s = swapper
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

And here is it's output.

	 ******** TEST FOR ROLLOVER SEQUENCE ABCDEFGHIJK9 ******** 
	ABCDEFGHIJK+, ABCDEFGHIJK/, ABCDEFGHIJLK, ABCDEFGHIJLM, ABCDEFGHIJLN, 

	 ******** TEST FOR ROLLOVER SEQUENCE ABCD/9876542 ******** 
	ABCD/9876543, ABCD/987654+, ABCD/98765+E, ABCD/98765+F, ABCD/98765+G, 

	 ******** TEST FOR ROLLOVER SEQUENCE ABCDEF+/9875 ******** 
	ABCDEF+/9876, ABCDEF/GHIJK, ABCDEF/GHIJL, ABCDEF/GHIJM, ABCDEF/GHIJN, 

	 ******** TEST FOR ROLLOVER SEQUENCE ABCDEFG+/985 ******** 
	ABCDEFG+/986, ABCDEFG+/987, ABCDEFG/HIJK, ABCDEFG/HIJL, ABCDEFG/HIJM, 

	 ******** TEST FOR ROLLOVER SEQUENCE A+/987654320 ******** 
	A+/987654321, A/BCDEFGHIJK, A/BCDEFGHIJL, A/BCDEFGHIJM, A/BCDEFGHIJN, 


# Submission

Please send a pull request and name your file as follows `golfb64-<yourname>.xxx` for your golf answers and `longb64-<yourname>.xxx` for your long answer versions.  Use any promming language you'd like.  I've included my long version [`longb64-danielpclark.rb`][3]  To see other people's submissions you can check [here][2] as well.


  [1]: http://en.wikipedia.org/wiki/Base_64
  [2]: http://codegolf.stackexchange.com/questions/26503/base-64-all-unique-12-character-incrementor-without-skip-next-on-rollovers-in
  [3]: https://github.com/danielpclark/b64challenge/blob/master/longb64-danielpclark.rb
