module MathCaptcha
  module BeforeFilters
    def set_captcha
      session[:captcha] = Captcha.new
    end
  end
end

ActionController::Base.send(:include, MathCaptcha::BeforeFilters)