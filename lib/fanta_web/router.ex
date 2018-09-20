defmodule FantaWeb.Router do
  use FantaWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Phauxth.Authenticate
  end

  scope "/", FantaWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/users", UserController
    resources "/users", UserController do
      resources "/missions", MissionController do
        get "search", MissionController, :search
        post "search", MissionController, :search
        get "answer_mission", MissionController, :answer_mission
        post "answer_all", MissionController, :answer_all
        get "new_question", MissionController, :new_question
        post "createquestion", MissionController, :createquestion
        get ":question_id/show_question", MissionController, :show_question
        post ":question_id/answer_question", MissionController, :answer_question
        get ":question_id/show_answer", MissionController, :show_answer
      end
    end
    resources "/sessions", SessionController, only: [:new, :create, :delete]
  end

end
