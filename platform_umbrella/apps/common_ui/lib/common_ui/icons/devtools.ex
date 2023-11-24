defmodule CommonUI.Icons.Devtools do
  @moduledoc false
  use CommonUI.Component

  attr :class, :any, default: nil

  def devtools_icon(assigns) do
    ~H"""
    <svg
      xmlns="http://www.w3.org/2000/svg"
      fill="none"
      stroke="currentColor"
      class={["h-6 w-6 ", @class]}
      viewBox="0 0 16 16"
    >
      <path d="M1 0 0 1l2.2 3.081a1 1 0 0 0 .815.419h.07a1 1 0 0 1 .708.293l2.675 2.675-2.617 2.654A3.003 3.003 0 0 0 0 13a3 3 0 1 0 5.878-.851l2.654-2.617.968.968-.305.914a1 1 0 0 0 .242 1.023l3.356 3.356a1 1 0 0 0 1.414 0l1.586-1.586a1 1 0 0 0 0-1.414l-3.356-3.356a1 1 0 0 0-1.023-.242L10.5 9.5l-.96-.96 2.68-2.643A3.005 3.005 0 0 0 16 3c0-.269-.035-.53-.102-.777l-2.14 2.141L12 4l-.364-1.757L13.777.102a3 3 0 0 0-3.675 3.68L7.462 6.46 4.793 3.793a1 1 0 0 1-.293-.707v-.071a1 1 0 0 0-.419-.814L1 0zm9.646 10.646a.5.5 0 0 1 .708 0l3 3a.5.5 0 0 1-.708.708l-3-3a.5.5 0 0 1 0-.708zM3 11l.471.242.529.026.287.445.445.287.026.529L5 13l-.242.471-.026.529-.445.287-.287.445-.529.026L3 15l-.471-.242L2 14.732l-.287-.445L1.268 14l-.026-.529L1 13l.242-.471.026-.529.445-.287.287-.445.529-.026L3 11z" />
    </svg>
    """
  end

  attr :class, :any, default: nil

  def gitea_icon(assigns) do
    ~H"""
    <svg
      xmlns="http://www.w3.org/2000/svg"
      viewBox="0 0 32 32"
      fill="currentColor"
      stroke="currentColor"
      class={["h-6 w-6 ", @class]}
    >
      <path d="M5.583 7.229c-2.464-0.005-5.755 1.557-5.573 5.479 0.281 6.125 6.557 6.693 9.068 6.745 0.271 1.146 3.224 5.109 5.411 5.318h9.573c5.74-0.38 10.036-17.365 6.854-17.427-5.271 0.25-8.396 0.375-11.073 0.396v5.297l-0.839-0.365-0.005-4.932c-3.073 0-5.781-0.141-10.917-0.396-0.646-0.005-1.542-0.115-2.5-0.115zM5.927 9.396h0.297c0.349 3.141 0.917 4.974 2.068 7.781-2.938-0.349-5.432-1.198-5.891-4.38-0.24-1.646 0.563-3.365 3.526-3.401zM17.339 12.479c0.198 0.005 0.406 0.042 0.594 0.13l1 0.432-0.714 1.302c-0.109 0-0.219 0.016-0.323 0.052-0.464 0.151-0.708 0.604-0.542 1.021 0.036 0.083 0.089 0.161 0.151 0.229l-1.234 2.25c-0.099 0-0.203 0.016-0.297 0.052-0.464 0.146-0.708 0.604-0.542 1.016 0.172 0.417 0.682 0.63 1.151 0.479 0.464-0.146 0.703-0.604 0.536-1.021-0.047-0.109-0.115-0.208-0.208-0.292l1.203-2.188c0.13 0.010 0.26 0 0.391-0.042 0.104-0.031 0.198-0.083 0.281-0.151 0.464 0.198 0.844 0.354 1.12 0.49 0.406 0.203 0.552 0.339 0.599 0.49 0.042 0.146-0.005 0.427-0.24 0.922-0.172 0.37-0.458 0.896-0.797 1.51-0.115 0-0.229 0.016-0.333 0.052-0.469 0.151-0.708 0.604-0.542 1.021 0.167 0.411 0.682 0.625 1.146 0.479 0.469-0.151 0.708-0.604 0.542-1.021-0.042-0.099-0.104-0.193-0.182-0.271 0.333-0.609 0.62-1.135 0.807-1.526 0.25-0.536 0.38-0.938 0.266-1.323s-0.469-0.635-0.932-0.865c-0.307-0.151-0.693-0.313-1.146-0.505 0.005-0.109-0.010-0.214-0.052-0.318s-0.109-0.198-0.193-0.281l0.703-1.281 3.901 1.682c0.703 0.307 0.995 1.057 0.651 1.682l-2.682 4.906c-0.339 0.625-1.182 0.885-1.885 0.578l-5.516-2.38c-0.703-0.307-0.995-1.057-0.656-1.682l2.682-4.906c0.234-0.432 0.708-0.688 1.208-0.708h0.083z" />
    </svg>
    """
  end

  attr :class, :any, default: nil

  def tekton_icon(assigns) do
    ~H"""
    <svg
      xmlns="http://www.w3.org/2000/svg"
      viewBox="14.90 -7.60 688.70 733.20"
      fill="currentColor"
      stroke="currentColor"
      class={["h-6 w-6 ", @class]}
    >
      <path
        fill-rule="evenodd"
        d="M297.486 319.777v6.908m182.388 217.198l6.011-1.615.718 4.665c3.409 21.442 1.884 40.012-6.819 58.942 13.458 1.884 25.21 8.343 31.4 22.07 4.396 9.689 8.613 20.993 8.703 31.758 0 7.985-2.512 15.97-8.792 21.173a20.86 20.86 0 0 1-13.188 4.755H427.66c-4.037 11.035-12.022 21.172-23.685 24.223a54.199 54.199 0 0 1-9.958 1.345c-3.589.18-7.087.27-10.586.27-9.061.089-18.122 0-27.184 0q-21.262-.27-42.524-.808a22.658 22.658 0 0 1-20.006-13.009 22.58 22.58 0 0 1-19.917 13.009c-14.264.359-28.439.628-42.614.807-9.06.09-18.122.18-27.183 0-3.499 0-6.998-.09-10.586-.269a47.501 47.501 0 0 1-10.048-1.345c-11.663-3.05-19.558-13.278-23.685-24.223H90.067a20.86 20.86 0 0 1-13.188-4.755c-6.28-5.203-8.792-13.188-8.792-21.173 0-10.765 4.307-22.07 8.613-31.758a36.138 36.138 0 0 1 10.407-13.457 42.391 42.391 0 0 1 20.365-8.613c-8.703-18.93-10.228-37.5-6.819-58.942l.718-4.665 6.729 1.794a95.2 95.2 0 0 1 3.23-12.022 78.076 78.076 0 0 1 24.85-36.154 64.905 64.905 0 0 1 13.547-8.344 239.918 239.918 0 0 1 5.114-38.218 174.147 174.147 0 0 1 14.892-49.163 68.053 68.053 0 0 1-9.15-14.444c-.36-.807-.718-1.615-.987-2.422a209.478 209.478 0 0 1-59.48-50.42c-9.87-12.11-24.313-30.95-25.57-46.83-.627-5.562-.807-11.125-.896-16.597a296.926 296.926 0 0 1 2.153-39.923c.897-7.715 2.153-15.43 3.678-23.056a214.155 214.155 0 0 1-26.645-38.398 194.37 194.37 0 0 1-22.249-69.528 189.93 189.93 0 0 1 5.473-72.13A27.186 27.186 0 0 1 62.256 6.496c45.933 0 85.587 18.75 122.46 42.973a216.023 216.023 0 0 1 225.72 0c36.782-24.222 76.436-42.973 122.37-42.973a26.901 26.901 0 0 1 26.106 20.007 191.986 191.986 0 0 1 5.383 72.13 194.37 194.37 0 0 1-22.249 69.528 213.693 213.693 0 0 1-26.555 38.397c1.435 7.267 2.601 14.534 3.588 21.98a293.14 293.14 0 0 1 2.243 40.64c-.09 5.653-.27 11.305-.897 16.777-1.435 16.328-15.43 34.63-25.569 47.01a210.939 210.939 0 0 1-59.48 50.42l-1.076 2.422a124.22 124.22 0 0 1-6.37 11.752 55.538 55.538 0 0 1-7.357 9.6 140.82 140.82 0 0 1 5.024 13.367 183.229 183.229 0 0 1 6.908 29.516c1.077 5.114 2.064 10.317 2.781 15.43 20.366-34.09 47.46-64.862 81.55-83.792 20.007-11.124 42.704-18.212 65.76-17.584 24.493.628 48.536 12.022 67.107 27.632 20.365 17.135 36.962 41.627 39.743 68.631a39.08 39.08 0 0 1-.897 13.278c-3.499 14.444-14.623 25.748-27.811 31.938-16.867 7.895-37.95 7.626-52.124-5.742-7.985-7.625-10.497-15.969-14.534-25.748-2.422-5.741-4.934-10.137-10.048-13.995a35.138 35.138 0 0 0-23.684-7.087c-12.112.807-22.877 7.715-31.4 15.969a162.575 162.575 0 0 0-13.457 14.892 253.303 253.303 0 0 0-21.8 31.58 203.902 203.902 0 0 0-13.278 26.106 11.685 11.685 0 0 1-.718 1.525 3.328 3.328 0 0 0 .18.808zm18.571-76.437a7.69 7.69 0 0 1 3.23.628c4.126-4.844 8.433-9.599 12.918-13.995 1.436-1.346 2.871-2.691 4.217-3.858a43.425 43.425 0 0 1-13.457-14.802 47.293 47.293 0 0 1-5.831-16.328 209.518 209.518 0 0 0-25.3 26.376c-.448 6.19 5.652 13.367 9.869 16.686 3.947 3.14 9.15 5.563 14.354 5.293zm-6.37 12.83a38.158 38.158 0 0 1-16.148-7.536 43.887 43.887 0 0 1-11.753-13.996 291.104 291.104 0 0 0-21.531 35.975 61.626 61.626 0 0 1 6.549 4.576 69.173 69.173 0 0 1 17.943 21.531 279.836 279.836 0 0 1 24.94-40.55zm109.63-34.81a5.235 5.235 0 0 1-.538 2.333c13.637 13.368 13.009 28.978 21.532 37.052 14.982 14.265 48.266-1.794 46.202-22.339-1.884-17.853-12.2-35.616-26.555-49.612-.09-.09-.18-.179-.269-.179a10.782 10.782 0 0 0-7.626-2.87c-18.122-.808-32.117 18.211-32.745 35.616zm-12.739-6.549a53.817 53.817 0 0 1 3.858-13.098c5.831-13.277 16.776-24.133 30.144-27.99-12.919-7.895-27.183-12.74-40.91-13.099a76.402 76.402 0 0 0-11.932.539c-1.256.897-2.422 1.794-3.05 2.332a21.45 21.45 0 0 0-2.063 1.974c-9.061 10.227-7.985 29.964-.18 40.55a7.382 7.382 0 0 1 1.077 2.243 55.758 55.758 0 0 1 23.056 6.55zm-37.949-5.472a51.291 51.291 0 0 1-5.831-22.967 48.481 48.481 0 0 1 3.947-20.724 129.972 129.972 0 0 0-22.249 9.869c-4.216 2.332-8.433 5.024-12.65 7.895 0 .09-.089.09-.089.179-3.858 5.652-.18 15.7 2.87 20.993 2.782 4.755 7.088 9.69 12.112 11.842a4.883 4.883 0 0 1 1.615.987 66.064 66.064 0 0 1 20.275-8.074zM277.838 64.72a6.37 6.37 0 1 1-6.37 6.37 6.281 6.281 0 0 1 6.37-6.37zm0 28.08a6.37 6.37 0 1 1-6.37 6.37 6.394 6.394 0 0 1 6.37-6.37zm39.385-28.08a6.37 6.37 0 1 1-6.37 6.37 6.394 6.394 0 0 1 6.37-6.37zm0 28.08a6.37 6.37 0 1 1-6.37 6.37 6.394 6.394 0 0 1 6.37-6.37zm-14.354-48.984v76.167c40.73.898 80.742 12.202 105.324 33.823 28.35 25.03 47.279 68.362 45.216 91.149-1.795 20.455-34.45 34.27-77.962 41.448a39.576 39.576 0 0 1 4.486 12.56 57.159 57.159 0 0 1-.09 18.75c16.418-1.884 31.22-4.396 44.409-7.177a434.354 434.354 0 0 0 68.63-20.634 24.585 24.585 0 0 0 1.526-6.28s9.42-85.767-39.205-156.013c-37.59-54.277-94.738-82.178-152.334-83.793zm-10.676 76.167V43.817c-58.584 1.705-116.628 30.503-153.95 86.305-46.65 69.798-37.5 153.59-37.5 153.59a27.511 27.511 0 0 0 1.794 6.46 440.227 440.227 0 0 0 68.273 20.455 482.746 482.746 0 0 0 44.498 7.177 57.156 57.156 0 0 1-.09-18.75 39.576 39.576 0 0 1 4.486-12.56c-43.511-7.178-76.167-21.083-77.962-41.448-2.063-22.788 16.867-66.12 45.216-91.15 24.492-21.71 64.505-33.014 105.235-33.912zm-73.386 208.944a481.49 481.49 0 0 1-50.15-7.895 440.168 440.168 0 0 1-58.673-16.776 152.258 152.258 0 0 0 9.6 13.098c23.594 28.888 53.29 48.535 88.906 60.826a278.375 278.375 0 0 0 34.719 9.33c0-.09-.09-.269-.09-.358a19.205 19.205 0 0 1-.987-9.78c1.436-8.253 7.626-13.456 15.61-16.776-15.071-5.114-28.618-13.636-36.513-27.183a24.626 24.626 0 0 1-2.422-4.486zm38.218 52.931c1.704 4.396 7.356 7.806 14.444 10.138 8.612.987 17.314 1.794 26.017 2.333 8.792-.539 17.584-1.256 26.196-2.333 6.639-2.153 12.022-5.203 14.085-9.24 8.972-17.405-86.843-16.956-80.742-.898zm227.963-77.512a446.47 446.47 0 0 1-58.494 16.686 485.352 485.352 0 0 1-50.15 7.895 67.28 67.28 0 0 1-2.243 4.396c-7.894 13.457-21.351 22.07-36.423 27.184 7.805 3.319 13.816 8.433 15.34 16.417a18.989 18.989 0 0 1-.986 10.497c28.977-5.832 56.25-15.61 80.473-31.4 17.494-11.394 31.759-26.286 45.126-42.345 2.602-2.96 5.024-6.19 7.357-9.33zm-191.36 27.9c-4.037 7.088-12.38 17.674-29.964 14.086-21.621-6.998-37.142-21.532-33.284-44.768 3.499-20.993 38.397-34.09 67.016-33.822h.27c28.618-.269 63.517 12.83 66.926 33.822 3.32 20.096-7.805 33.733-24.94 41.538-25.39 9.42-34.271-2.87-38.219-10.676-1.884-3.768-2.691-5.742-3.678-5.831h-.27c-.807.358-1.794 2.153-3.857 5.652zm3.858-54.725c-17.315 0-38.308 5.024-40.372 15.79-3.409 17.853 23.057 26.465 40.372 26.465h.359c17.314-.09 43.51-8.702 40.102-26.465-2.064-10.766-23.057-15.79-40.372-15.79zm-48.266-34.988a6.46 6.46 0 0 1-12.92 0 28.944 28.944 0 0 0-6.817-19.02 20.771 20.771 0 0 0-15.52-7.446 19.479 19.479 0 0 0-11.125 3.499 24.702 24.702 0 0 0-8.434 10.138 6.4 6.4 0 0 1-11.573-5.473 39.066 39.066 0 0 1 12.83-15.341 32.36 32.36 0 0 1 18.39-5.742 33.086 33.086 0 0 1 25.12 11.843 42.306 42.306 0 0 1 10.049 27.542zm96.622 0a6.46 6.46 0 0 0 12.918 0 28.944 28.944 0 0 1 6.819-19.02 20.626 20.626 0 0 1 15.52-7.446 19.479 19.479 0 0 1 11.125 3.499 24.702 24.702 0 0 1 8.433 10.138 6.442 6.442 0 0 0 11.663-5.473 39.066 39.066 0 0 0-12.83-15.341 32.36 32.36 0 0 0-18.39-5.742 33.086 33.086 0 0 0-25.12 11.843 41.904 41.904 0 0 0-10.138 27.542zm5.203 171.712a175.606 175.606 0 0 1-42.345 7.985 178.655 178.655 0 0 1-95.366-21.083c-5.652-1.615-11.124-3.499-16.597-5.473a109.984 109.984 0 0 0 53.56 38.757c-21.801-3.679-43.87-10.407-60.916-22.25-11.035 23.865-17.764 57.059-12.381 102.364q1.884 15.476 4.845 29.337c28.708-13.009 48.804-7.805 73.744 8.792 2.871-39.385 11.125-68.99 15.072-81.102 1.705-5.113 3.948-7.625 6.998-7.894 3.23-.27 8.702-.09 8.523 9.42-.987 3.857-1.794 8.433-2.422 11.752-1.705 8.792-3.05 17.763-4.396 26.645-1.256 8.792-2.512 17.584-3.589 26.466-.718 5.652-1.435 11.483-1.884 17.225-.18 3.23-.359 6.46-.449 9.689a162.17 162.17 0 0 0 40.64-.27c-.089-3.14-.268-6.369-.448-9.509-.987-14.175-3.14-29.067-5.203-43.152-1.256-8.433-2.602-16.956-4.217-25.3-.987-4.755-2.063-10.765-3.768-15.34.27-9.42 12.56-11.484 15.97-1.077 3.767 11.304 12.739 41.896 15.61 83.434 22.518-12.92 52.303-22.519 73.834-10.497 1.884-9.061 3.41-18.57 4.665-28.619 5.024-41.896-.359-73.475-9.958-96.801-17.225 10.138-39.115 15.52-60.198 18.212a109.925 109.925 0 0 0 58.224-40.282c-5.472 1.974-11.034 3.858-16.597 5.473a168.987 168.987 0 0 1-30.951 13.098zM100.564 38.793c22.697 6.101 44.05 17.136 64.325 29.965a210.95 210.95 0 0 0-23.236 21.71c-3.858-6.37-8.075-12.56-12.47-18.66a220.172 220.172 0 0 0-28.62-33.015zM62.794 33.5h2.153c25.48 13.996 48.266 42.435 65.043 70.695-3.41 4.396-6.729 8.971-9.958 13.636a235.587 235.587 0 0 0-28.62 60.109c-20.544-27.632-46.65-78.41-29.336-143.901.27-.09.449-.36.718-.539zm469.473 0h-2.153c-25.479 13.996-48.266 42.435-65.043 70.695a162.788 162.788 0 0 1 7.985 10.945 234.567 234.567 0 0 1 30.503 62.89c20.544-27.632 46.65-78.41 29.336-143.902l-.628-.628zm-37.77 5.293c-22.697 6.1-44.139 17.136-64.324 29.965a211.875 211.875 0 0 1 23.236 21.8c3.947-6.37 8.074-12.65 12.47-18.75a220.17 220.17 0 0 1 28.619-33.015zM186.33 563.44a318.167 318.167 0 0 0 25.928 67.106c1.525 2.871 2.601 3.679 5.472 5.383 8.882 5.383 21.352 11.214 23.505 33.374-10.137-12.919-19.827-22.16-34.72-25.39-7.266-.089-15.52 1.347-21.261 7.268-12.291 12.739-3.41 34.719 4.037 36.693s83.882 0 83.882 0 3.14-14.265-2.78-22.16c-5.832-7.984-14.893-48.625-15.521-91.867-17.943-15.7-45.665-26.286-68.542-10.407zm214.686 0a324.012 324.012 0 0 1-25.838 67.106c-1.615 2.871-2.691 3.679-5.472 5.383-8.882 5.383-21.352 11.214-23.506 33.374 10.138-12.919 19.827-22.16 34.72-25.39 7.267-.089 15.61 1.347 21.262 7.268 12.29 12.739 3.41 34.719-4.037 36.693s-83.883 0-83.883 0-3.14-14.265 2.781-22.16c5.832-7.984 14.983-48.625 15.61-91.867 17.764-15.7 45.486-26.286 68.363-10.407zm-100.39 96.084c-2.243 0-4.576.09-6.908.09h-5.473a49.187 49.187 0 0 0-2.78-4.665 54.156 54.156 0 0 1-2.872-8.075 212.85 212.85 0 0 1-5.203-23.325 300.085 300.085 0 0 1-4.127-44.05 143.787 143.787 0 0 0 42.076-.359 286.457 286.457 0 0 1-5.293 51.048c-1.167 5.92-4.127 20.275-7.177 25.568a41.592 41.592 0 0 0-2.243 3.768zm167.047-92.495c.628 41.358-25.479 57.686-40.73 69.887 69.439-31.58 77.423 22.16 70.246 28.08h-71.86a38.873 38.873 0 0 0-29.876-36.603 275.23 275.23 0 0 0 13.996-35.706c20.275-10.855 44.139-21.98 58.224-25.658zm-37.949-60.736c17.405 8.074 28.35 26.465 30.772 47.1-14.085 4.126-29.516 11.483-42.524 17.942a391.87 391.87 0 0 0 10.676-54.636c.448-3.319.807-6.818 1.076-10.406zm-272.102.358c-17.136 8.254-27.812 26.556-30.144 47.01 13.906 4.217 28.977 11.394 41.807 17.764a391.874 391.874 0 0 1-10.676-54.636c-.36-3.32-.718-6.728-.987-10.138zm-38.039 60.378c-.628 41.358 25.479 57.686 40.82 69.887-69.528-31.58-77.423 22.16-70.336 28.08h70.605a40.687 40.687 0 0 1 11.125-26.644 41.422 41.422 0 0 1 18.212-10.856 273.167 273.167 0 0 1-4.127-8.971q-5.787-13.323-10.497-27.184c-19.647-10.317-42.165-20.723-55.802-24.312z"
      />
    </svg>
    """
  end
end
