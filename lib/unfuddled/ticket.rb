module Unfuddled
  class Ticket < Unfuddled::Base
    
    # Get the time entries for the ticket
    #
    # @return [Array[Unfuddled::TimeEntry]]
    def time_entries
      url = "/api/v1/projects/#{project_id}/tickets/#{id}/time_entries.json"
     
      @client.process_list_response( @client.send(:get , url)[:body] , Unfuddled::TimeEntry )
    end

    # Get the project for the ticket
    #
    # @return [Unfuddled::Project]
    def project
      @client.project(:id => project_id)
    end

    # To String
    # @return [String]
    def to_s
      "Unfuddled::Ticket: ##{number} #{title}"
    end

    # Get the custom fields
    #
    # @return [Array(Unfuddled::CustomField)]
    def custom_fields
      p = project
      fields = []

      3.times do |i|
        n = i+1
        fields << Unfuddled::CustomField.new(
                                             :number => n,
                                             :title  => p.send(:"ticket_field#{n}_title"),
                                             :type   => p.send(:"ticket_field#{n}_disposition"),
                                             :value  => send(:"field#{n}_value_id")
                                             )
      end

      fields
    end

    # Get the ticket reporter
    #
    # @return [Unfuddled::Person]
    def reporter
      @client.person(reporter_id)
    end

    # Get the milestone
    #
    # @return [Unfuddled::Milestone]
    def milestone
      @client.milestone(project_id , milestone_id)
    end

  end
end
