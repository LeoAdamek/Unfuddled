module Unfuddled
  class Person < Unfuddled::Base

    # To String
    # @return [String]
    def to_s
      "Unfuddled::Person: #{first_name} #{last_name}"
    end

  end
end
