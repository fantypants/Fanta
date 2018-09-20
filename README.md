# Fanta

## NOTES

- Users can login
- Users can add new missions
- In each mission you can create any type of question(s)
- You can answer any mission or question with any user
- The master mission creator (i.e the user who created the mission) can see all responses
- The client who answered the question can only see there responses
- You can use the search function to search all answers within a mission for the answer & question id
- You can answer either one question or the entire mission in one swoop

## Things I'd have done differently
- Written tests for both inside out and outside in for the models and the controllers, due to time I couldn't write tests, but usually for production environment I'd start with tests first and then make the controller functions pass.
- Example test methods I'd have introduced exist under the controller tests
- Created guards for only being able to answer the question once (as it stands users can answer multiple times)

## How-To
- I created a short 3 min video to demonstrate:
https://www.useloom.com/share/60317f13123740d99efe247fc76bea37



## FINISHED
    - Open Ended - Prompts users to write in a sentence or paragraph
    - Single Choice - Provides several choices and a user may select one
    - Multiple Choice - Provides several choices and a user may select one or more
    - Rating - Allows a user to select a value between a minimum and maximum integer value
    - Users must be able to submit responses for each question in a mission
    - Users must be able to view all submitted responses in a mission


To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
# Fanta
