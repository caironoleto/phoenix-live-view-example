defmodule PhoenixLiveViewExampleWeb.StepFormLive do
  alias PhoenixLiveViewExample.StepForm
  alias PhoenixLiveViewExampleWeb.StepFormView

  use PhoenixLiveViewExampleWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(current_step: 1)
      |> assign(changeset: StepForm.changeset(%StepForm{}, %{}))

    {:ok, socket}
  end

  def render(assigns) do
    StepFormView.render("form.html", assigns)
  end

  def handle_event("prev-step", _params, socket) do
    new_step = max(socket.assigns.current_step - 1, 1)

    {:noreply, assign(socket, current_step: new_step)}
  end

  def handle_event("next-step", _params, socket) do
    current_step = socket.assigns.current_step
    changeset = socket.assigns.changeset

    step_invalid =
      case current_step do
        1 -> Enum.any?(Keyword.keys(changeset.errors), fn k -> k in [:title, :description] end)
        2 -> Enum.any?(Keyword.keys(changeset.errors), fn k -> k in [:type] end)
        _ -> true
      end

    new_step = if step_invalid, do: current_step, else: current_step + 1

    {:noreply, assign(socket, :current_step, new_step)}
  end

  def handle_event("validate", %{"step_form" => params}, socket) do
    changeset = StepForm.changeset(%StepForm{}, params) |> Map.put(:action, :insert)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"step_form" => params}, socket) do
    # Pretending to insert stuff if changeset is valid
    changeset = StepForm.changeset(%StepForm{}, params)

    case changeset.valid? do
      true ->
        {:noreply,
          socket
          |> put_flash(:info, "StepForm inserted => #{inspect(changeset.changes)}")
          |> redirect(to: "/")}

      false ->
        {:noreply, assign(socket, :changeset, %{changeset | action: :insert})}
    end
  end
end
