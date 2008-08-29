module MathCaptcha
  module HasCaptcha
    module InstanceMethods
      def validate_on_create
        self.errors.add(:captcha_solution, "wrong answer.") unless self.captcha.check(self.captcha_solution.to_i)
      end
    end
    
    module ClassMethods
      def has_captcha
        include InstanceMethods
        attr_accessor :captcha, :captcha_solution
        validates_presence_of :captcha_solution, :on => :create, :message => "can't be blank"
      end
    end
  end
end

ActiveRecord::Base.send(:extend, MathCaptcha::HasCaptcha::ClassMethods)