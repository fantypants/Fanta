defmodule FantaWeb.MissionController do
  use FantaWeb, :controller
  alias Fanta.Repo
  import Ecto.Query
  alias FantaWeb.Models.Mission
  alias FantaWeb.Models.Question
  alias FantaWeb.Models.Answer

  def index(%Plug.Conn{assigns: %{current_user: user}} = conn, _params) do
    missions = Repo.all(Mission)
    render(conn, "index.html", missions: missions, user_id: user.id)
  end

  def new(%Plug.Conn{assigns: %{current_user: user}} = conn, _params) do
    changeset = Mission.changeset(%Mission{})
    render(conn, "new.html", changeset: changeset, user_id: user.id)
  end

  def new_question(%Plug.Conn{assigns: %{current_user: user}} = conn, %{"mission_id" => mission_id}) do
    changeset = Question.changeset(%Question{})
    render(conn, "new_question.html", changeset: changeset, mission: mission_id)
  end

  def show_question(%Plug.Conn{assigns: %{current_user: user}} = conn, %{"question_id" => question_id, "mission_id" => mission_id}) do
    question = Repo.get!(Question, question_id)
    changeset = Answer.changeset(%Answer{})
    render(conn, "show_question.html", user_id: user.id, question: question, changeset: changeset, mission: mission_id)
  end

  def show_answer(%Plug.Conn{assigns: %{current_user: user}} = conn, %{"question_id" => question_id, "mission_id" => mission_id}) do
    answers_query = from a in Answer, where: a.user_id == ^user.id
    question = Repo.get!(Question, question_id) |> Repo.preload(answers: answers_query)
    render(conn, "show_answer.html", user_id: user.id, question: question, mission: mission_id)
  end

  def answer_question(%Plug.Conn{assigns: %{current_user: user}} = conn, %{"answer" => answer, "mission_id" => mission_id, "question_id" => question_id}) do
    body = [answer["body"]] |> Enum.map(&(&1)) |> List.flatten |> IO.inspect
    params = %{"body" => body, "question_id" => question_id, "user_id" => user.id}
    changeset = Answer.changeset(%Answer{}, params)
    case Repo.insert(changeset) do
      {:ok, answer} ->
        conn
        |> put_flash(:info, "Answer created successfully.")
        |> redirect(to: user_mission_mission_path(conn, :show_question, user.id, mission_id, question_id))
      {:error, changeset} ->
        IO.inspect changeset
        conn
        |> put_flash(:info, "Answer Didnt work.")
        |> redirect(to: user_mission_mission_path(conn, :show_question, user.id, mission_id, question_id))
    end
  end

  def check_answer(user_id, question_id) do
    answers_query = from a in Answer, where: a.user_id == ^user_id and a.question_id == ^question_id
    answers = Repo.all(answers_query) |> Enum.count |> IO.inspect
    case answers do
      0 ->
        "Not Answered"
      _->
        "Answered"
    end
  end

  def createquestion(%Plug.Conn{assigns: %{current_user: user}} = conn, %{"question" => question, "mission_id" => mission_id}) do
    options = question["options"] |> IO.inspect
    title = question["title"] |> IO.inspect
    type = question["type"] |> IO.inspect
    params = %{"options" => options, "title" => title, "type" => type, "mission_id" => mission_id}
    changeset = Question.changeset(%Question{}, params)
    case Repo.insert(changeset) do
      {:ok, question} ->
        conn
        |> put_flash(:info, "Question created successfully.")
        |> redirect(to: user_mission_mission_path(conn, :new_question, user.id, mission_id))
      {:error, changeset} ->
        IO.inspect changeset
        render(conn, "new_question.html", user_id: user.id, mission: mission_id, changeset: changeset)
    end
  end

  def create(%Plug.Conn{assigns: %{current_user: user}} = conn, %{"mission" => mission_params}) do
    params = Map.put(mission_params, "user_id", user.id)
    changeset = Mission.changeset(%Mission{}, params)

    case Repo.insert(changeset) do
      {:ok, mission} ->
        conn
        |> put_flash(:info, "Mission created successfully.")
        |> redirect(to: user_mission_path(conn, :show, user.id, mission))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset, user_id: user.id)
    end
  end

  def show(%Plug.Conn{assigns: %{current_user: user}} = conn, %{"id" => id}) do
    mission = Repo.get!(Mission, id) |> Repo.preload(:questions)
    render(conn, "show.html", user_id: user.id, mission: mission)
  end

  def edit(%Plug.Conn{assigns: %{current_user: user}} = conn, %{"id" => id}) do
    mission = Repo.get!(Mission, id)
    changeset = Mission.changeset(mission)
    render(conn, "edit.html", mission: mission, user_id: user.id, changeset: changeset)
  end

  def update(%Plug.Conn{assigns: %{current_user: user}} = conn, %{"id" => id, "mission" => mission_params}) do
    mission = Repo.get!(Mission, id)
    changeset = Mission.changeset(mission, mission_params)

    case Repo.update(changeset) do
      {:ok, mission} ->
        conn
        |> put_flash(:info, "Mission updated successfully.")
        |> redirect(to: user_mission_path(conn, :show, user.id, mission))
      {:error, changeset} ->
        render(conn, "edit.html", mission: mission, user_id: user.id, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    mission = Repo.get!(Mission, id)
    user_id = conn.user_id

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(mission)

    conn
    |> put_flash(:info, "Mission deleted successfully.")
    |> redirect(to: user_mission_path(conn, :index, user_id))
  end
end
