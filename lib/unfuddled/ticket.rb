require 'memoizer'
module Unfuddled
  # Ticket Class
  # 
  # Class for a Ticket, part of a Project hosted on Unfuddle
  # Provides access to its milestone, reporter, time entries and comments
  class Ticket < Unfuddled::Base

    include Memoizer
    
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
      "Unfuddled::Ticket: ##{number} #{summary}"
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
    # @memoized
    # @return [Unfuddled::Person]
    def reporter
      @client.person(reporter_id)
    end
    memoize(:reporter)

    # Get the milestone for this ticket
    #
    # @memoized
    # @return [Unfuddled::Milestone]
    def milestone
      @client.milestone(project_id , milestone_id)
    end
    memoize(:milestone)

    # Get / Update / Set ticket comments
    #
    # @return [Array(Unfuddled::Comment)]
    def comments
      url = "/api/v1/projects/#{project_id}/tickets/#{id}/comments.json"
      
      @client.process_list_response( @client.send(:get , url)[:body] , Unfuddled::Comment )
    end

    # Add a new Comment
    #
    # @param  body [String] Body text for Comment
    # @return      [Integer] Newly created comment ID
    def add_comment(body)

      raise ArgumentError("Comment body must be a string") unless body.is_a?(String)

      url = "/api/v1/projects/#{project_id}/tickets/#{id}/comments.json"
      @client.post(url , {:body => body})
    end
    


    # Save a Ticket
    def save
      if id.nil? then
        url = "/api/v1/projects/#{project_id}/tickets.json"
        method = :post
      else
        url = "/api/v1/projects/#{project_id}/tickets/#{id}.json"
        method = :put
      end

      @client.send(method , url , send(:to_h))
    end

  end
end
