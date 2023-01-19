defmodule CommonUI.Form do
  use Phoenix.Component
  import Phoenix.Component, except: [link: 1]

  import CommonUI.Gettext, warn: false
  import Phoenix.HTML.Form, only: [input_name: 2, input_id: 2, input_value: 2, humanize: 1]

  @doc """
  Renders a simple form with a css grid based 2 column layout.

  ## Examples

      <.simple_form :let={f} for={:user} phx-change="validate" phx-submit="save">
        <.input field={{f, :email}} label="Email"/>
        <.input field={{f, :username}} label="Username" />
        <:actions>
          <.button>Save</.button>
        <:actions>
      </.simple_form>
  """
  attr(:for, :any, default: nil, doc: "the datastructure for the form")
  attr(:as, :any, default: nil, doc: "the server side parameter to collect all input under")
  attr(:rest, :global, doc: "the arbitraty HTML attributes to apply to the form tag")

  slot(:inner_block, required: true)
  slot(:actions, doc: "the slot for form actions, such as a submit button")

  def simple_form(assigns) do
    ~H"""
    <.form :let={f} for={@for} as={@as} {@rest}>
      <div class="space-y-8 mt-10">
        <div class="grid grid-cols-1 mt-6 gap-y-6 gap-x-4 sm:grid-cols-2">
          <%= render_slot(@inner_block, f) %>
        </div>
        <div :for={action <- @actions} class="mt-2 flex items-center justify-between gap-6">
          <%= render_slot(action, f) %>
        </div>
      </div>
    </.form>
    """
  end

  @doc """
  Renders an input with label and error messages.

  A `%Phoenix.HTML.Form{}` and field name may be passed to the input
  to build input names and error messages, or all the attributes and
  errors may be passed explicitly.

  ## Examples

      <.input field={{f, :email}} type="email" />
      <.input name="my-input" errors={["oh no!"]} />
  """
  attr(:id, :any)
  attr(:name, :any)
  attr(:label, :string)

  attr(:type, :string,
    default: "text",
    doc:
      ~s|one of "text", "textarea", "number" "email", "date", "time", "datetime", "select", "range|
  )

  attr(:value, :any)
  attr(:field, :any, doc: "a %Phoenix.HTML.Form{}/field name tuple, for example: {f, :email}")
  attr(:errors, :list)
  attr(:wrapper_class, :string, default: "form-control")

  attr(:prompt, :string, default: nil, doc: "the prompt for select inputs")
  attr(:options, :list, doc: "the options to pass to Phoenix.HTML.Form.options_for_select/2")
  attr(:multiple, :boolean, default: false, doc: "the multiple flag for select inputs")

  attr(:rest, :global,
    doc: "the arbitrary HTML attributes for the input tag",
    include:
      ~w(autocomplete checked disabled form max maxlength min minlength pattern placeholder readonly required size step)
  )

  slot(:inner_block)

  def input(%{field: {f, field}} = assigns) do
    assigns
    |> assign(field: nil)
    |> assign_new(:name, fn ->
      name = input_name(f, field)
      if assigns.multiple, do: name <> "[]", else: name
    end)
    |> assign_new(:id, fn -> input_id(f, field) end)
    |> assign_new(:value, fn -> input_value(f, field) end)
    |> assign_new(:errors, fn -> translate_errors(f.errors || [], field) end)
    |> assign_new(:label, fn -> humanize(field) end)
    |> input()
  end

  def input(%{type: "checkbox"} = assigns) do
    ~H"""
    <label phx-feedback-for={@name} class="flex items-center gap-4 text-base leading-6 pt-10">
      <input type="hidden" id={@id} name={@name} value="false" />
      <input
        type="checkbox"
        id={@id}
        name={@name}
        class="toggle toggle-primary"
        value="true"
        checked={input_checked(@rest, @value)}
      />
      <%= @label %>
    </label>
    """
  end

  def input(%{type: "select"} = assigns) do
    ~H"""
    <div phx-feedback-for={@name}>
      <.label for={@id}><%= @label %></.label>
      <select
        id={@id}
        name={@name}
        class={[border("select", @errors), "select select-md w-full max-w-x"]}
        multiple={@multiple}
        {@rest}
      >
        <option :if={@prompt}><%= @prompt %></option>
        <%= Phoenix.HTML.Form.options_for_select(@options, @value) %>
      </select>
      <.error :for={msg <- @errors} message={msg} />
    </div>
    """
  end

  def input(%{type: "textarea"} = assigns) do
    ~H"""
    <div phx-feedback-for={@name} class={@wrapper_class}>
      <.label for={@id}><%= @label %></.label>
      <textarea
        id={@id || @name}
        name={@name}
        class={[border("textarea", @errors), "textarea"]}
        {@rest}
      ><%= @value %></textarea>
      <.error :for={msg <- @errors} message={msg} />
    </div>
    """
  end

  def input(%{type: "range"} = assigns) do
    ~H"""
    <div phx-feedback-for={@name} class={@wrapper_class}>
      <.label for={@id}><%= @label %></.label>
      <input
        id={@id || @name}
        name={@name}
        value={@value}
        type="range"
        class={["range range-md range-primary w-full"]}
        {@rest}
      />
      <.error :for={msg <- @errors} message={msg} />
    </div>
    """
  end

  def input(assigns) do
    ~H"""
    <div phx-feedback-for={@name} class={@wrapper_class}>
      <.label for={@id}><%= @label %></.label>
      <input
        type={@type}
        name={@name}
        id={@id || @name}
        value={@value}
        class={[border("input", @errors), "input input-md inptut-bordered"]}
        {@rest}
      />
      <.error :for={msg <- @errors} message={msg} />
    </div>
    """
  end

  defp input_checked(%{checked: checked}, _value) when not is_nil(checked), do: checked
  defp input_checked(_rest, value) when is_boolean(value), do: value
  defp input_checked(_rest, value), do: to_string(value) == "true"

  defp border(type, [] = _errors), do: "#{type}-bordered"

  defp border(type, [_ | _] = _errors),
    do: "#{type}-bordered #{type}-error"

  @doc """
  Renders a label.
  """
  attr(:for, :string, default: nil)
  slot(:inner_block, required: true)

  def label(assigns) do
    ~H"""
    <label for={@for} class="label">
      <%= render_slot(@inner_block) %>
    </label>
    """
  end

  @doc """
  Generates a generic error message.
  """
  attr(:message, :string, default: "")

  def error(assigns) do
    ~H"""
    <p class="phx-no-feedback:hidden mt-3 flex gap-3 text-sm leading-6 text-sea-buckthorn-600 input-error">
      <Heroicons.exclamation_circle mini class="mt-0.5 h-5 w-5 flex-none fill-sea-buckthorn-500" />
      <%= @message %>
    </p>
    """
  end

  @doc """
  Translates an error message using gettext.
  """
  def translate_error({msg, opts}) do
    # When using gettext, we typically pass the strings we want
    # to translate as a static argument:
    #
    #     # Translate "is invalid" in the "errors" domain
    #     dgettext("errors", "is invalid")
    #
    #     # Translate the number of files with plural rules
    #     dngettext("errors", "1 file", "%{count} files", count)
    #
    # Because the error messages we show in our forms and APIs
    # are defined inside Ecto, we need to translate them dynamically.
    # This requires us to call the Gettext module passing our gettext
    # backend as first argument.
    #
    # Note we use the "errors" domain, which means translations
    # should be written to the errors.po file. The :count option is
    # set by Ecto and indicates we should also apply plural rules.
    if count = opts[:count] do
      Gettext.dngettext(CommonUI.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(CommonUI.Gettext, "errors", msg, opts)
    end
  end

  @doc """
  Translates the errors for a field from a keyword list of errors.
  """
  def translate_errors(errors, field) when is_list(errors) do
    for {^field, {msg, opts}} <- errors, do: translate_error({msg, opts})
  end
end
