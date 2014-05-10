class B;def initialize(g)
@g=g;@l=12;@b=(["A".."Z","a".."z","0".."9",["+","/"]].map{|z|Array z
}.inject(:+)).each_with_index.map{|x,i|{x=>i}}.inject(:update)
@i=@b.invert;@m=@l.times.map{|j|@i[@b.length-j-1]}.join;end
def n;unless c(@g);r;end;@g;end;def c(s)
unless @b[s[-1]]==@b.length-1;unless s==@m;if f(s,s[-1]);s[-1]=f(s,s[-1])
elsif not f(s,s[-2]);s[-1]=f(s);if f(s,s[-2]);s[-2]=f(s,s[-2])
else r end;else r end;else r end;else false end; true end
def h(s);v=s.split("").map{|x|@b[x]};v.index(v.compact.max)end
def r;if @g==@m;@g=@l.times.map{|j|@i[j]}.join;else
v=@g[0..h(@g)-1];c(v);u=@g[h(@g)..-1].length;u.times{v+=f(v)}
@g=v;end;end;def f(s,a = @i[0]);(@b[a]..@b.length-1).each { |p|
unless !!s[@i[p]];return @i[p];end};false;end;end

# Whitled down to 744 Characters

# Pass test cases
puts "      IN   *******   OUT"
["ABCDEFGHIJKL","ABCDEFGHIJK+","ABCDEFGHIJK/","ABCDEFGHIJLK","ABCD/9876542",
"ABCD/9876543","ABCD/987654+","ABCD/98765+E","ABCDEF+/9875","ABCDEF+/9876",
"ABCDEF/GHIJK","ABCDEF/GHIJL","ABCDEFG+/987","A+/987654321","/+9876543210"
	].each do |v|
	t = B.new(v)
	puts " #{v}   #{t.n}"
end