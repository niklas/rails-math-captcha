module MathCaptcha
  module HasCaptcha
    module InstanceMethods
      def validate_captcha
        unless skip_captcha?
          self.errors.add(:captcha_solution, "wrong answer.") unless self.captcha.check(self.captcha_solution.to_i)
        end
      end
      def skip_captcha!
        self.class.skip_captcha!
      end
      def skip_captcha?
        self.class.skip_captcha?
      end
      def captcha
        @captcha ||= Captcha.new
      end
      def captcha_secret=(secret)
        @captcha = Captcha.from_secret(secret)
      end
      def captcha_secret
        captcha.to_secret
      end
    end
    
    module ClassMethods
      def has_captcha
        include InstanceMethods
        attr_accessor :captcha_solution
        dont_skip_captcha!
        validates_presence_of :captcha_solution, 
          :on => :create, :message => "can't be blank", 
          :unless => Proc.new {|record| record.skip_captcha? }
      end
      def skip_captcha!
        @@skip_captcha = true
      end
      def dont_skip_captcha!
        @@skip_captcha = false
      end
      def skip_captcha?
        @@skip_captcha
      end
    end
  end
end

ActiveRecord::Base.send(:extend, MathCaptcha::HasCaptcha::ClassMethods)
