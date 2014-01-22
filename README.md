Unfuddled
==================

_A client for the Unfuddle API_

[![Coverage Status](https://coveralls.io/repos/LeoAdamek/Unfuddled/badge.png?branch=master)](https://coveralls.io/r/LeoAdamek/Unfuddled?branch=master)
[![Code Climate](https://codeclimate.com/github/LeoAdamek/Unfuddled.png)](https://codeclimate.com/github/LeoAdamek/Unfuddled)
[![Build Status](https://travis-ci.org/LeoAdamek/Unfuddled.png?branch=master)](https://travis-ci.org/LeoAdamek/Unfuddled)


About
--------

This gem aims to provide a simple, powerful, semantic API client for Unfuddle.


Features
-------------

This gem features:

* Simple DSL for querying data
* Built-in memoization to reduce repeated API calls and improved performance
* Simple ActiveModel-like CRUD operations

Quick Start
-----------

Here's a quick interactive tutorial.

```ruby
require 'unfuddled'

# Connect to Unfuddle
unfuddle = Unfuddled::REST::Client.new(
                                     :subdomain => "your_unfuddle_subdomain",
                                     :username  => "your_unfuddle_username",
                                     :password  => "your_unfuddle_password"
                                     )


# Get All Tickets
all_tickets = unfuddle.tickets

# Get Ticket with ID = 99
ticket = unfuddle.ticket :id => 99

# Get All Ticket Summaries
summaries = unfuddle.tickets.collect(&:summary)

# Get All Reporters (and nil for those who have been deleted)
reporters = unfuddle.tickets.collect(&:reporter_id).uniq.each do |reporter|
  begin
    unfuddle.person reporter
  rescue Unfuddled::HTTPErrorResponse
    nil
  end
end

# Get All Completed Milestones for each project
completed_milestones = unfuddle.projects.each do |project|
  project.milestones :completed
end

# Get A Month of Time Tracking Entries
time_tracking = unfuddle.time_invested(:start_date => "2014-01-01" , :end_date => "2014-01-31")

```

Contributing
------------
Contribute with a fork, some code and a pull request.
