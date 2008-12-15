## there might be a bug in Maq: the indel positions are inconsistent between SOLiD and Solexa. 

# so when we  say two indels are the same, we tolerate about 3bp apart

f1 = ARGV[0]
f2 = ARGV[1]

$var = 1
$indels = Hash.new {|h,k| h[k]=Hash.new() }

def parseIndelLine(l)
  cols = l.split(/\s+/)
  return [cols[0], cols[1].to_i, cols[4].split(':')[0].to_i]
end


File.new(f1, 'r').each do |line|
  chr, pos, nature = parseIndelLine(line)
  $indels[chr][pos] = nature
end

File.new(f2, 'r').each do |line|
  chr, pos, nature = parseIndelLine(line)
  flag = 0
  if $indels.key?(chr) #
    (pos-$var).upto(pos+$var) do |i|
      if $indels[chr].key?(i) and $indels[chr][i] == nature
       # find a match
        flag +=1
      end
    end
  end

  if flag > 0
    puts "#{flag}\t#{line}"
  end
end

