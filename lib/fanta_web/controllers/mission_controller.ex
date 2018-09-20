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

  defp check_parent_user(mission_id, user_id) do
    parent_id = Repo.get!(Mission, mission_id).user_id
    if parent_id == user_id do
      true
    else
      false
    end
  end

  def show_answer(%Plug.Conn{assigns: %{current_user: user}} = conn, %{"question_id" => question_id, "mission_id" => mission_id}) do
    case check_parent_user(mission_id, user.id) do
      true ->
      question = Repo.get!(Question, question_id) |> Repo.preload(:answers)
      false ->
        answers_query = from a in Answer, where: a.user_id == ^user.id
        question = Repo.get!(Question, question_id) |> Repo.preload(answers: answers_query)
    end
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

  def answer_mission(%Plug.Conn{assigns: %{current_user: user}} = conn, %{"mission_id" => mission_id}) do
    mission = Repo.get!(Mission, mission_id) |> Repo.preload(:questions)
    render(conn, "answer_mission.html", user_id: user.id, mission_id: mission_id, mission: mission)
  end

  def answer_all(%Plug.Conn{assigns: %{current_user: user}} = conn, params) do
    mission_id = params["mission_id"]
    answers = Map.keys(params)
      |> Enum.reject(fn(a) -> String.starts_with?(a, "b") !== true end)
      |> Enum.map(fn(a) -> get_atom_and_value(a, params, params["mission_id"], params["user_id"]) end)
      Enum.map(answers, fn(a) -> answer_question_single(a) end)
    conn |> redirect(to: user_mission_path(conn, :show, user.id, mission_id))
  end

  defp get_atom_and_value(atom, list, mission_id, user_id) do
    question_id = String.split(atom, "_") |> List.last |> IO.inspect
      body = [list[atom]] |> List.flatten
    %{"question_id" => question_id, "body" => body, "mission_id" => mission_id, "user_id" => user_id}
  end

  def answer_question_single(params) do
    changeset = Answer.changeset(%Answer{}, params)
    case Repo.insert(changeset) do
      {:ok, answer} ->
        IO.puts "Inserted"
        IO.inspect answer
      {:error, changeset} ->
        IO.inspect changeset
    end
  end

  def show(%Plug.Conn{assigns: %{current_user: user}} = conn, %{"id" => id}) do
    mission = Repo.get!(Mission, id) |> Repo.preload(:questions)
    render(conn, "show.html", user_id: user.id, mission: mission)
  end

  defp get_questions_from_mission(mission_id, search) do
    query = from q in Question, where: q.mission_id == ^mission_id, select: q.id
    question_ids = Repo.all(query)
    |> Enum.map(fn(ans) -> Repo.all(from a in Answer, where: a.question_id == ^ans, select: %{question_id: a.question_id, body: a.body, user_id: a.user_id}) end)
    |> List.flatten
    |> IO.inspect
    |> Enum.reject(fn(a) -> Enum.any?(a.body, fn(b) -> b == search end) !== true end)
  end

  def search(%Plug.Conn{assigns: %{current_user: user}} = conn, params) do
    query = params["query"]
    mission_id = params["mission_id"]

    case query do
      "" ->
        results = []
      _->
        results = get_questions_from_mission(mission_id, query)
      end
    render(conn, "search_answers.html", user_id: user.id, mission_id: mission_id, results: results)
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
