require 'openssl'
require 'yaml'
class Captcha
  NUMBERS   = (1..9).to_a
  OPERATORS = [:+, :-, :*]
  CryptoName = 'AES-128-CBC'

  attr_reader :x, :y, :operator

  def initialize(x=nil, y=nil, operator=nil)
    @x = x || NUMBERS.sort_by{rand}.first
    @y = y || NUMBERS.sort_by{rand}.first
    @operator = operator || OPERATORS.sort_by{rand}.first
  end

  # Only the #to_secret is shared with the client.
  # It can be reused here to create the Captcha again
  def self.from_secret(secret)
    reset_crypto
    crypto.decrypt(key)
    yml = crypto.update(secret)
    yml << crypto.final
    args = YAML.load(yml)
    new(args[:x], args[:y], args[:operator])
  end

  def self.crypto
    @@crypto ||= OpenSSL::Cipher::Cipher.new(CryptoName)
  end
  def self.reset_crypto
    @@crypto = nil
  end

  def self.key
    'ultrasecret'
  end

  
  def check(answer)
    answer == solution
  end
  
  def task
    "#{@x} #{@operator.to_s} #{@y}"
  end
  alias_method :to_s, :task

  def solution
    @x.send @operator, @y
  end

  def to_secret
    reset_crypto
    crypto.encrypt(self.class.key)
    cipher = crypto.update(to_yaml)
    cipher << crypto.final
    cipher
  end

  def to_yaml
    YAML::dump({
      :x => x,
      :y => y,
      :operator => operator
    })
  end

  private
  def crypto
    self.class.crypto
  end
  def reset_crypto
    self.class.reset_crypto
  end

end
