# frozen_string_literal: true

module FlashHelper
  def flash_class(level)
    case level
    when :notice, 'notice' then 'alert alert-info'
    when :success, 'success' then 'alert alert-success'
    when :error, 'error' then 'alert alert-danger'
    when :alert, 'alert' then 'alert alert-danger'
    end
  end

  def with_each_flash_message(flash)
    flash.each do |k, v|
      alert_class = flash_class(k)
      case v
      when Hash
        v.each_value do |vv|
          yield(alert_class, vv)
        end
      when Array
        v.each { |vv| yield(alert_class, vv) }
      else
        yield(alert_class, v)
      end
    end
  end
end
