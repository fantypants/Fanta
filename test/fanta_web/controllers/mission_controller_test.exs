defmodule FantaWeb.MissionControllerTest do
  use FantaWeb.ConnCase

  alias FantaWeb..Models.Mission
  @valid_attrs %{name: "some name"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, mission_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing missions"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, mission_path(conn, :new)
    assert html_response(conn, 200) =~ "New mission"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, mission_path(conn, :create), mission: @valid_attrs
    mission = Repo.get_by!(Mission, @valid_attrs)
    assert redirected_to(conn) == mission_path(conn, :show, mission.id)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, mission_path(conn, :create), mission: @invalid_attrs
    assert html_response(conn, 200) =~ "New mission"
  end

  test "shows chosen resource", %{conn: conn} do
    mission = Repo.insert! %Mission{}
    conn = get conn, mission_path(conn, :show, mission)
    assert html_response(conn, 200) =~ "Show mission"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, mission_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    mission = Repo.insert! %Mission{}
    conn = get conn, mission_path(conn, :edit, mission)
    assert html_response(conn, 200) =~ "Edit mission"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    mission = Repo.insert! %Mission{}
    conn = put conn, mission_path(conn, :update, mission), mission: @valid_attrs
    assert redirected_to(conn) == mission_path(conn, :show, mission)
    assert Repo.get_by(Mission, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    mission = Repo.insert! %Mission{}
    conn = put conn, mission_path(conn, :update, mission), mission: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit mission"
  end

  test "deletes chosen resource", %{conn: conn} do
    mission = Repo.insert! %Mission{}
    conn = delete conn, mission_path(conn, :delete, mission)
    assert redirected_to(conn) == mission_path(conn, :index)
    refute Repo.get(Mission, mission.id)
  end

  test "Users can create missions" do
  end
  test "Users can create questions in missions" do
  end
  test "Users can add all types of questions" do
  end
  test "Only author can see all reponses" do
  end
  test "User can see there own response" do
  end
  test "Users can answer a question" do
  end
  test "Users can answer multiple questions" do
  end
end
