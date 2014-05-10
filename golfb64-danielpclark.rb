class B;def initialize(g)@l=12;@b=(("A".."Z").to_a+("a".."z").to_a+("0".."9").to_a+["+","/"]
).each_with_index.map{|x,i|{x=>i}}.inject(:update);@g=g;@i=@b.invert;@m=@l.times.map{|i|
@i[@b.length-i-1]}.join;end;def n;c(@g)?@g:r;end;def c(s);@b[s[-1]]==@b.length-1?(return false
):s==@m?r: f(s,s[-1]) ?s[-1]=f(s,s[-1]):f(s,s[-2])?r: (s[-1]=f(s);f(s,s[-2])?s[-2]=f(s,s[-2]):r)
true;end;def h(s)v=s.split("").map{|x|@b[x]};v.index(v.compact.max)end;def r;@g==@m?@g=@l.times.map{
|j| @i[j]}.join: (v=@g[0..h(@g)-1];c(v);u=@g[h(@g)..-1].length;u.times{v+=f(v)};@g=v);end
def f(s,a=@i[0])(@b[a]..@b.length-1).each{|p|unless !!s[@i[p]];return @i[p]end};false;end;end

# Whitled down to 658 Characters

# Pass test cases
puts "      IN   *******   OUT"
["ABCDEFGHIJKL","ABCDEFGHIJK+","ABCDEFGHIJK/","ABCDEFGHIJLK","ABCD/9876542",
"ABCD/9876543","ABCD/987654+","ABCD/98765+E","ABCDEF+/9875","ABCDEF+/9876",
"ABCDEF/GHIJK","ABCDEF/GHIJL","ABCDEFG+/987","A+/987654321","/+9876543210"
	].each do |v|
	t = B.new(v.dup)
	puts " #{v}   #{t.n}"
end