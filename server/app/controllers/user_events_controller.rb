class UserEventsController < EventsController
  nested_in :user
end