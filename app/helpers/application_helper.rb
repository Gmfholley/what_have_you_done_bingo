module ApplicationHelper
  
  def humanized_time(date)
    date.strftime("%B %d, %Y")
  end
end
