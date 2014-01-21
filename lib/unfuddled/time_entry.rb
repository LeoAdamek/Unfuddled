module Unfuddled
  class TimeEntry < Unfuddled::Base

    def person
      @client.person(id)
    end

  end
end
