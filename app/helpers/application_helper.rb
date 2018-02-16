module ApplicationHelper
  def normalized_provider(provider)
    case provider
      when :google_oauth2 then :google
      else provider
    end
  end
end
