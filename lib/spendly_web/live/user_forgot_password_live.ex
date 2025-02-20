defmodule SpendlyWeb.UserForgotPasswordLive do
  use SpendlyWeb, :live_view

  alias Spendly.Accounts

  def render(assigns) do
    ~H"""
    <div class="auth-container">
      <div class="auth-card">
        <.header class="text-center">
          <h3>Forgot your password?</h3>
          <:subtitle>We'll send a password reset link to your inbox</:subtitle>
        </.header>

        <.simple_form for={@form} id="reset_password_form" phx-submit="send_email">
          <.input field={@form[:email]} type="email" placeholder="Email" required />
          <:actions>
            <.button phx-disable-with="Sending..." class="w-full btn-sub">
              Send password reset instructions
            </.button>
          </:actions>
        </.simple_form>
        <p class="font-medium text-center text-amber-800">
          <.link href={~p"/users/register"} class="hover:underline">Register</.link>
          | <.link href={~p"/users/log_in"} class="hover:underline">Log in</.link>
        </p>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, form: to_form(%{}, as: "user"))}
  end

  def handle_event("send_email", %{"user" => %{"email" => email}}, socket) do
    if user = Accounts.get_user_by_email(email) do
      Accounts.deliver_user_reset_password_instructions(
        user,
        &url(~p"/users/reset_password/#{&1}")
      )
    end

    info =
      "If your email is in our system, you will receive instructions to reset your password shortly."

    {:noreply,
     socket
     |> put_flash(:info, info)
     |> redirect(to: ~p"/")}
  end
end
