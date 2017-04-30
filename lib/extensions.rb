class String
  def from_german_to_f
    self.gsub(',', '.').to_f
  end
end

class Float
  def to_german_s
    self.to_s.gsub('.', ',')
  end
end

class Hash
  def slice(keys)
    select {|key,_| keys.include? key}
  end
end
