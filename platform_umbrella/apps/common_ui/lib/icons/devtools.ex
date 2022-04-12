defmodule CommonUI.Icons.Devtools do
  use Phoenix.Component

  def devtools_icon(assigns) do
    ~H"""
    <svg
      xmlns="http://www.w3.org/2000/svg"
      fill="currentColor"
      stroke="currentColor"
      class={"h-6 w-6" <> @class}
      viewBox="0 0 16 16"
    >
      <path d="M1 0 0 1l2.2 3.081a1 1 0 0 0 .815.419h.07a1 1 0 0 1 .708.293l2.675 2.675-2.617 2.654A3.003 3.003 0 0 0 0 13a3 3 0 1 0 5.878-.851l2.654-2.617.968.968-.305.914a1 1 0 0 0 .242 1.023l3.356 3.356a1 1 0 0 0 1.414 0l1.586-1.586a1 1 0 0 0 0-1.414l-3.356-3.356a1 1 0 0 0-1.023-.242L10.5 9.5l-.96-.96 2.68-2.643A3.005 3.005 0 0 0 16 3c0-.269-.035-.53-.102-.777l-2.14 2.141L12 4l-.364-1.757L13.777.102a3 3 0 0 0-3.675 3.68L7.462 6.46 4.793 3.793a1 1 0 0 1-.293-.707v-.071a1 1 0 0 0-.419-.814L1 0zm9.646 10.646a.5.5 0 0 1 .708 0l3 3a.5.5 0 0 1-.708.708l-3-3a.5.5 0 0 1 0-.708zM3 11l.471.242.529.026.287.445.445.287.026.529L5 13l-.242.471-.026.529-.445.287-.287.445-.529.026L3 15l-.471-.242L2 14.732l-.287-.445L1.268 14l-.026-.529L1 13l.242-.471.026-.529.445-.287.287-.445.529-.026L3 11z" />
    </svg>
    """
  end

  def gitea_icon(assigns) do
    ~H"""
    <svg
      xmlns="http://www.w3.org/2000/svg"
      viewBox="0 0 32 32"
      fill="currentColor"
      stroke="currentColor"
      class={"h-6 w-6" <> @class}
    >
      <path d="M5.583 7.229c-2.464-0.005-5.755 1.557-5.573 5.479 0.281 6.125 6.557 6.693 9.068 6.745 0.271 1.146 3.224 5.109 5.411 5.318h9.573c5.74-0.38 10.036-17.365 6.854-17.427-5.271 0.25-8.396 0.375-11.073 0.396v5.297l-0.839-0.365-0.005-4.932c-3.073 0-5.781-0.141-10.917-0.396-0.646-0.005-1.542-0.115-2.5-0.115zM5.927 9.396h0.297c0.349 3.141 0.917 4.974 2.068 7.781-2.938-0.349-5.432-1.198-5.891-4.38-0.24-1.646 0.563-3.365 3.526-3.401zM17.339 12.479c0.198 0.005 0.406 0.042 0.594 0.13l1 0.432-0.714 1.302c-0.109 0-0.219 0.016-0.323 0.052-0.464 0.151-0.708 0.604-0.542 1.021 0.036 0.083 0.089 0.161 0.151 0.229l-1.234 2.25c-0.099 0-0.203 0.016-0.297 0.052-0.464 0.146-0.708 0.604-0.542 1.016 0.172 0.417 0.682 0.63 1.151 0.479 0.464-0.146 0.703-0.604 0.536-1.021-0.047-0.109-0.115-0.208-0.208-0.292l1.203-2.188c0.13 0.010 0.26 0 0.391-0.042 0.104-0.031 0.198-0.083 0.281-0.151 0.464 0.198 0.844 0.354 1.12 0.49 0.406 0.203 0.552 0.339 0.599 0.49 0.042 0.146-0.005 0.427-0.24 0.922-0.172 0.37-0.458 0.896-0.797 1.51-0.115 0-0.229 0.016-0.333 0.052-0.469 0.151-0.708 0.604-0.542 1.021 0.167 0.411 0.682 0.625 1.146 0.479 0.469-0.151 0.708-0.604 0.542-1.021-0.042-0.099-0.104-0.193-0.182-0.271 0.333-0.609 0.62-1.135 0.807-1.526 0.25-0.536 0.38-0.938 0.266-1.323s-0.469-0.635-0.932-0.865c-0.307-0.151-0.693-0.313-1.146-0.505 0.005-0.109-0.010-0.214-0.052-0.318s-0.109-0.198-0.193-0.281l0.703-1.281 3.901 1.682c0.703 0.307 0.995 1.057 0.651 1.682l-2.682 4.906c-0.339 0.625-1.182 0.885-1.885 0.578l-5.516-2.38c-0.703-0.307-0.995-1.057-0.656-1.682l2.682-4.906c0.234-0.432 0.708-0.688 1.208-0.708h0.083z" />
    </svg>
    """
  end
end
