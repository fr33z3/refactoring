class String
  def from_german_to_f
    gsub(',', '.').to_f
  end
end

class Float
  def to_german_s
    to_s.gsub('.', ',')
  end
end
