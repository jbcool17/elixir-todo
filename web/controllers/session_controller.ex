defmodule Todo.SessionController do
	use Todo.Web, :controller

	def new(conn, _) do
		render conn, "new.html"
	end

	def create(conn, %{"session" => %{"email" => user, "password" => pass}}) do
		case Todo.Auth.login_by_email_and_pass(conn, user, pass, repo: Repo) do
			{:ok, conn} ->
				logged_in_user = Guardian.Plug.current_resource(conn)
				conn
				|> put_flash(:info, "Logged In Mate")
				|> redirect(to: user_path(conn, :show, logged_in_user))
			{:error, _reason, conn} ->
				conn
				|> put_flash(:error, "F / Password")
				|> render("new.html")
		end
	end
end