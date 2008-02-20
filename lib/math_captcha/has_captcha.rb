module MathCaptcha
  module HasCaptcha
    def check_captcha
      self.errors.add_to_base("Captcha not answered correctly.") unless self.captcha.check(self.captcha_solution)
    end
    
    module ClassMethods
      def has_captcha
        attr_accessor :captcha, :captcha_solution
        validates_presence_of :captcha_solution, :on => :create, :message => "can't be blank"
        before_validation :check_captcha
      end
    end
  end
end

ActiveRecord::Base.send(:include, MathCaptcha::HasCaptcha)
ActiveRecord::Base.send(:extend, MathCaptcha::HasCaptcha::ClassMethods)