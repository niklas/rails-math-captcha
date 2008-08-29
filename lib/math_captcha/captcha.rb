class Captcha
  NUMBERS   = (1..9).to_a
  OPERATORS = [:+, :-, :*]

  def initialize(x=nil, y=nil, operator=nil)
    @x = x || NUMBERS.sort_by{rand}.first
    @y = y || NUMBERS.sort_by{rand}.first
    @operator = operator || OPERATORS.sort_by{rand}.first
  end
  
  def check(answer)
    answer == solution
  end
  
  def to_s
    "#{@x} #{@operator.to_s} #{@y}"
  end

  def solution
    @x.send @operator, @y
  end
end