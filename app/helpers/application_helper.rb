module ApplicationHelper

  def flash_messages
    flash.each do |msg_type, message|
      concat(
        content_tag(:div, message,
                    role: "alert",
                    class: "alert #{bootstrap_class_for(msg_type)} alert-dismissible") do
          concat(message)
        end
      )
    end

    flash.clear
    nil
  end

  def bootstrap_class_for(flash_type)
    {
      success: "alert-success",
      error: "alert-danger",
      alert: "alert-warning",
      notice: "alert-info"
    }[flash_type.to_sym]
  end

  def humanize_duration(seconds_left)
    Time.at(seconds_left).utc.strftime("%H:%M:%S")
  end
end
